import type { SupabaseClient } from '@supabase/supabase-js'

type UnknownRecord = Record<string, unknown>

interface LinkTarget {
  table: string
  nipColumn: string
  userIdColumn: string
}

export interface ProvisioningIdentity {
  id: string
  email: string | null
  userMetadata: UnknownRecord | null
  appMetadata: UnknownRecord | null
}

interface ProvisioningParams {
  supabase: SupabaseClient
  identity: unknown
}

function asRecord(value: unknown): UnknownRecord | null {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    return null
  }

  return value as UnknownRecord
}

function asString(value: unknown): string | null {
  if (typeof value !== 'string') {
    return null
  }

  const trimmed = value.trim()
  return trimmed.length > 0 ? trimmed : null
}

function parseCsv(rawValue: string | undefined): string[] {
  if (!rawValue) {
    return []
  }

  return rawValue
    .split(',')
    .map((item) => item.trim())
    .filter((item) => item.length > 0)
}

function getLinkTargets(): LinkTarget[] {
  const table = process.env.SUPABASE_NIP_LINK_TABLE?.trim() || 'pegawai'
  const nipColumn = process.env.SUPABASE_NIP_COLUMN?.trim() || 'nip'
  const userIdColumns = parseCsv(process.env.SUPABASE_NIP_LINK_USER_ID_COLUMNS)

  const resolvedUserIdColumns =
    userIdColumns.length > 0 ? userIdColumns : ['auth_user_id', 'user_id']

  return resolvedUserIdColumns.map((userIdColumn) => ({
    table,
    nipColumn,
    userIdColumn,
  }))
}

export function extractIdentityForProvisioning(
  identity: unknown,
): ProvisioningIdentity | null {
  const source = asRecord(identity)
  if (!source) {
    return null
  }

  const id = asString(source.id) ?? asString(source.sub)
  if (!id) {
    return null
  }

  return {
    id,
    email: asString(source.email),
    userMetadata:
      asRecord(source.user_metadata) ?? asRecord(source.userMetadata),
    appMetadata: asRecord(source.app_metadata) ?? asRecord(source.appMetadata),
  }
}

export function getNipFromMetadata(
  identity: ProvisioningIdentity,
): string | null {
  return asString(identity.appMetadata?.nip)
}

function extractErrorText(errorRecord: UnknownRecord): string {
  const message = asString(errorRecord.message)
  const details = asString(errorRecord.details)
  const hint = asString(errorRecord.hint)

  return [message, details, hint].filter(Boolean).join(' ')
}

function toProvisioningErrorDetails(error: unknown): UnknownRecord {
  const errorRecord = asRecord(error)
  if (!errorRecord) {
    return { error }
  }

  return {
    code: asString(errorRecord.code),
    message: asString(errorRecord.message),
    details: asString(errorRecord.details),
    hint: asString(errorRecord.hint),
  }
}

function getLinkedUserId(row: unknown, userIdColumn: string): string | null {
  const rowRecord = asRecord(row)
  if (!rowRecord) {
    return null
  }

  return asString(rowRecord[userIdColumn])
}

export function isIgnorableProvisioningSchemaError(error: unknown): boolean {
  const errorRecord = asRecord(error)
  if (!errorRecord) {
    return false
  }

  const code = asString(errorRecord.code)
  if (code === '42P01' || code === '42703') {
    return true
  }

  if (code && /^PGRST20\d$/.test(code)) {
    return true
  }

  const text = extractErrorText(errorRecord)
  return (
    /relation .* does not exist/i.test(text) ||
    /column .* does not exist/i.test(text) ||
    /could not find .* in the schema cache/i.test(text)
  )
}

export async function ensureNipDomainLink({
  supabase,
  identity,
}: ProvisioningParams): Promise<void> {
  try {
    const normalizedIdentity = extractIdentityForProvisioning(identity)
    if (!normalizedIdentity) {
      return
    }

    const nip = getNipFromMetadata(normalizedIdentity)
    if (!nip) {
      return
    }

    const linkTargets = getLinkTargets()

    for (const target of linkTargets) {
      const { data: existingRows, error: selectError } = await supabase
        .from(target.table)
        .select(target.userIdColumn)
        .eq(target.nipColumn, nip)
        .limit(1)

      if (selectError) {
        if (isIgnorableProvisioningSchemaError(selectError)) {
          continue
        }

        console.warn(
          '[supabase] NIP provisioning skipped due to non-critical error',
          {
            operation: 'select',
            table: target.table,
            nipColumn: target.nipColumn,
            userIdColumn: target.userIdColumn,
            nip,
            identityId: normalizedIdentity.id,
            error: toProvisioningErrorDetails(selectError),
          },
        )
        return
      }

      const linkedUserId = getLinkedUserId(
        Array.isArray(existingRows) ? existingRows[0] : null,
        target.userIdColumn,
      )

      if (linkedUserId && linkedUserId !== normalizedIdentity.id) {
        console.warn(
          '[supabase] NIP provisioning skipped due to existing linkage mismatch',
          {
            table: target.table,
            nipColumn: target.nipColumn,
            userIdColumn: target.userIdColumn,
            nip,
            identityId: normalizedIdentity.id,
            linkedUserId,
          },
        )
        return
      }

      if (linkedUserId === normalizedIdentity.id) {
        return
      }

      const payload: Record<string, string> = {
        [target.userIdColumn]: normalizedIdentity.id,
      }

      const { error: updateError } = await supabase
        .from(target.table)
        .update(payload)
        .eq(target.nipColumn, nip)
        .is(target.userIdColumn, null)

      if (!updateError) {
        return
      }

      if (isIgnorableProvisioningSchemaError(updateError)) {
        continue
      }

      console.warn(
        '[supabase] NIP provisioning skipped due to non-critical error',
        {
          operation: 'update',
          table: target.table,
          nipColumn: target.nipColumn,
          userIdColumn: target.userIdColumn,
          nip,
          identityId: normalizedIdentity.id,
          error: toProvisioningErrorDetails(updateError),
        },
      )
      return
    }
  } catch (error) {
    // Provisioning is fail-open so auth/session flow is never blocked.
    console.warn(
      '[supabase] NIP provisioning skipped due to unexpected error',
      {
        error: toProvisioningErrorDetails(error),
      },
    )
  }
}
