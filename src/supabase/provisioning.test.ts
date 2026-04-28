import {
  ensureNipDomainLink,
  extractIdentityForProvisioning,
  getNipFromMetadata,
  isIgnorableProvisioningSchemaError,
} from './provisioning'
import type { SupabaseClient } from '@supabase/supabase-js'
import { vi } from 'vitest'

interface SelectResult {
  data: unknown[] | null
  error: unknown | null
}

interface UpdateResult {
  error: unknown | null
}

const ENV_KEYS = [
  'SUPABASE_NIP_LINK_TABLE',
  'SUPABASE_NIP_COLUMN',
  'SUPABASE_NIP_LINK_USER_ID_COLUMNS',
] as const

const ENV_SNAPSHOT: Record<(typeof ENV_KEYS)[number], string | undefined> = {
  SUPABASE_NIP_LINK_TABLE: process.env.SUPABASE_NIP_LINK_TABLE,
  SUPABASE_NIP_COLUMN: process.env.SUPABASE_NIP_COLUMN,
  SUPABASE_NIP_LINK_USER_ID_COLUMNS:
    process.env.SUPABASE_NIP_LINK_USER_ID_COLUMNS,
}

function createSupabaseMock({
  selectResults,
  updateResults,
}: {
  selectResults: SelectResult[]
  updateResults?: UpdateResult[]
}) {
  let selectIndex = 0
  let updateIndex = 0

  const selectLimit = vi.fn(async () => {
    const nextResult = selectResults[selectIndex]
    selectIndex += 1

    return nextResult ?? { data: [], error: null }
  })

  const selectEq = vi.fn(() => ({ limit: selectLimit }))
  const select = vi.fn(() => ({ eq: selectEq }))

  const updateIs = vi.fn(async () => {
    const nextResult = updateResults?.[updateIndex]
    updateIndex += 1

    return nextResult ?? { error: null }
  })

  const updateEq = vi.fn(() => ({ is: updateIs }))
  const update = vi.fn(() => ({ eq: updateEq }))

  const from = vi.fn(() => ({ select, update }))

  return {
    supabase: { from } as unknown as SupabaseClient,
    mocks: {
      from,
      select,
      selectEq,
      selectLimit,
      update,
      updateEq,
      updateIs,
    },
  }
}

beforeEach(() => {
  for (const key of ENV_KEYS) {
    delete process.env[key]
  }
})

afterEach(() => {
  vi.restoreAllMocks()
})

afterAll(() => {
  for (const key of ENV_KEYS) {
    const value = ENV_SNAPSHOT[key]

    if (typeof value === 'string') {
      process.env[key] = value
      continue
    }

    delete process.env[key]
  }
})

describe('provisioning helpers', () => {
  it('uses trusted app metadata nip over user metadata nip', () => {
    const identity = extractIdentityForProvisioning({
      id: 'user-1',
      email: 'user@example.com',
      user_metadata: { nip: 'USER-NIP' },
      app_metadata: { nip: 'APP-NIP' },
    })

    expect(identity).not.toBeNull()
    expect(getNipFromMetadata(identity!)).toBe('APP-NIP')
  })

  it('uses app metadata nip when user metadata nip is missing', () => {
    const identity = extractIdentityForProvisioning({
      sub: 'user-2',
      app_metadata: { nip: 'APP-NIP' },
    })

    expect(identity).not.toBeNull()
    expect(getNipFromMetadata(identity!)).toBe('APP-NIP')
  })

  it('returns null nip when both metadata sources are missing', () => {
    const identity = extractIdentityForProvisioning({
      id: 'user-3',
      user_metadata: {},
      app_metadata: {},
    })

    expect(identity).not.toBeNull()
    expect(getNipFromMetadata(identity!)).toBeNull()
  })

  it('returns null nip when only user metadata nip exists', () => {
    const identity = extractIdentityForProvisioning({
      id: 'user-4',
      user_metadata: { nip: 'USER-NIP' },
    })

    expect(identity).not.toBeNull()
    expect(getNipFromMetadata(identity!)).toBeNull()
  })

  it('marks missing relation or missing column errors as ignorable', () => {
    expect(
      isIgnorableProvisioningSchemaError({
        code: '42P01',
        message: 'relation "pegawai" does not exist',
      }),
    ).toBe(true)

    expect(
      isIgnorableProvisioningSchemaError({
        code: '42703',
        message: 'column "auth_user_id" does not exist',
      }),
    ).toBe(true)
  })

  it('does not ignore unrelated errors', () => {
    expect(
      isIgnorableProvisioningSchemaError({
        code: '23505',
        message: 'duplicate key value violates unique constraint',
      }),
    ).toBe(false)
  })
})

describe('ensureNipDomainLink', () => {
  it('skips provisioning when only user metadata contains nip', async () => {
    const { supabase, mocks } = createSupabaseMock({
      selectResults: [{ data: [], error: null }],
    })

    await ensureNipDomainLink({
      supabase,
      identity: {
        id: 'user-1',
        user_metadata: { nip: 'USER-NIP' },
      },
    })

    expect(mocks.from).not.toHaveBeenCalled()
  })

  it('does not overwrite an existing linkage for a different user', async () => {
    const { supabase, mocks } = createSupabaseMock({
      selectResults: [{ data: [{ auth_user_id: 'other-user' }], error: null }],
    })
    const warnSpy = vi.spyOn(console, 'warn').mockImplementation(() => {})

    await ensureNipDomainLink({
      supabase,
      identity: {
        id: 'user-1',
        app_metadata: { nip: 'EMP-001' },
      },
    })

    expect(mocks.update).not.toHaveBeenCalled()
    expect(warnSpy).toHaveBeenCalledWith(
      '[supabase] NIP provisioning skipped due to existing linkage mismatch',
      expect.objectContaining({
        identityId: 'user-1',
        linkedUserId: 'other-user',
      }),
    )
  })

  it('falls back to next user id column when first column is missing', async () => {
    const { supabase, mocks } = createSupabaseMock({
      selectResults: [
        {
          data: null,
          error: {
            code: '42703',
            message: 'column "auth_user_id" does not exist',
          },
        },
        { data: [{ user_id: null }], error: null },
      ],
      updateResults: [{ error: null }],
    })

    await ensureNipDomainLink({
      supabase,
      identity: {
        id: 'user-1',
        app_metadata: { nip: 'EMP-001' },
      },
    })

    expect(mocks.update).toHaveBeenCalledTimes(1)
    expect(mocks.update).toHaveBeenCalledWith({ user_id: 'user-1' })
  })

  it('logs unexpected errors instead of silently swallowing them', async () => {
    const from = vi.fn(() => {
      throw new Error('unexpected failure')
    })
    const warnSpy = vi.spyOn(console, 'warn').mockImplementation(() => {})

    await ensureNipDomainLink({
      supabase: { from } as unknown as SupabaseClient,
      identity: {
        id: 'user-1',
        app_metadata: { nip: 'EMP-001' },
      },
    })

    expect(warnSpy).toHaveBeenCalledWith(
      '[supabase] NIP provisioning skipped due to unexpected error',
      expect.objectContaining({
        error: expect.any(Object),
      }),
    )
  })
})
