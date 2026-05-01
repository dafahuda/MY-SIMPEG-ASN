import { createClient } from '@/supabase/server'

// ─── Type definitions ────────────────────────────────────────────

export type UserActiveRole = {
  userRoleId: string
  roleId: string
  kodeRole: string
  namaRole: string
  level: number
  assignedAt: string
}

export type ScopeType = 'GLOBAL' | 'OPD' | 'UNIT_KERJA' | 'SELF' | 'BAWAHAN_LANGSUNG'

export type AssignRoleResult = {
  allowed: boolean
  reason?: string
}

// ─── Scope priority (higher = wider access) ──────────────────────

const SCOPE_PRIORITY: Record<ScopeType, number> = {
  GLOBAL: 5,
  OPD: 4,
  UNIT_KERJA: 3,
  BAWAHAN_LANGSUNG: 2,
  SELF: 1,
}

// ─── Forbidden role combinations (separation of duties) ──────────

const FORBIDDEN_COMBINATIONS: [string, string][] = [
  ['VERIFIKATOR_BKD', 'APPROVER_BKD'],
]

const MAX_ACTIVE_ROLES = 3

// ─── getUserActiveRoles ──────────────────────────────────────────
// Ambil semua role aktif user, sorted by level descending.

export async function getUserActiveRoles(userId: string): Promise<UserActiveRole[]> {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase
      .from('user_roles')
      .select(`
        user_role_id,
        role_id,
        assigned_at,
        roles!inner (
          kode_role,
          nama_role,
          level
        )
      `)
      .eq('user_id', userId)
      .eq('is_active', true)

    if (error) {
      console.error('[multi-role] Failed to fetch user roles:', error.message)
      return []
    }

    return (data ?? []).map((row: any) => ({
      userRoleId: row.user_role_id,
      roleId: row.role_id,
      kodeRole: row.roles.kode_role,
      namaRole: row.roles.nama_role,
      level: row.roles.level,
      assignedAt: row.assigned_at,
    })).sort((a: UserActiveRole, b: UserActiveRole) => b.level - a.level)
  } catch {
    return []
  }
}

// ─── getActingRole ───────────────────────────────────────────────
// Return role dengan level tertinggi (untuk audit trail).
// Jika level sama, pilih yang assigned_at paling awal.

export function getActingRole(roles: UserActiveRole[]): UserActiveRole | null {
  if (roles.length === 0) return null

  return roles.reduce((highest, current) => {
    if (current.level > highest.level) return current
    if (current.level === highest.level) {
      return current.assignedAt < highest.assignedAt ? current : highest
    }
    return highest
  })
}

// ─── getEffectiveScope ───────────────────────────────────────────
// Gabungkan scope dari semua role user.
// Return scope terluas (GLOBAL > OPD > UNIT_KERJA > BAWAHAN_LANGSUNG > SELF).

export async function getEffectiveScope(userId: string): Promise<ScopeType> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('access_scope')
    .select('scope_type, user_role_id')
    .eq('is_active', true)

  if (error || !data || data.length === 0) return 'SELF'

  // Filter by user's active roles
  const userRoles = await getUserActiveRoles(userId)
  const userRoleIds = new Set(userRoles.map(r => r.userRoleId))

  let widest: ScopeType = 'SELF'
  for (const scope of data) {
    if (!userRoleIds.has(scope.user_role_id)) continue
    const scopeType = scope.scope_type as ScopeType
    if (SCOPE_PRIORITY[scopeType] > SCOPE_PRIORITY[widest]) {
      widest = scopeType
    }
  }
  return widest
}

// ─── canAssignRole ───────────────────────────────────────────────
// Validasi apakah user boleh diberi role baru.
// Cek: max 3 role aktif + larangan kombinasi.

export async function canAssignRole(
  userId: string,
  newRoleCode: string,
): Promise<AssignRoleResult> {
  const currentRoles = await getUserActiveRoles(userId)

  // Cek max active roles
  if (currentRoles.length >= MAX_ACTIVE_ROLES) {
    return {
      allowed: false,
      reason: `User sudah memiliki ${MAX_ACTIVE_ROLES} role aktif. Nonaktifkan salah satu sebelum menambah role baru.`,
    }
  }

  // Cek duplikat
  if (currentRoles.some(r => r.kodeRole === newRoleCode)) {
    return {
      allowed: false,
      reason: `User sudah memiliki role ${newRoleCode} yang aktif.`,
    }
  }

  // Cek forbidden combinations
  for (const [roleA, roleB] of FORBIDDEN_COMBINATIONS) {
    if (newRoleCode === roleA && currentRoles.some(r => r.kodeRole === roleB)) {
      return {
        allowed: false,
        reason: `${roleA} dan ${roleB} tidak boleh aktif bersamaan (separation of duties).`,
      }
    }
    if (newRoleCode === roleB && currentRoles.some(r => r.kodeRole === roleA)) {
      return {
        allowed: false,
        reason: `${roleA} dan ${roleB} tidak boleh aktif bersamaan (separation of duties).`,
      }
    }
  }

  return { allowed: true }
}
