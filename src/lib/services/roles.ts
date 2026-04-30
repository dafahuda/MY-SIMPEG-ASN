import { unstable_cache } from 'next/cache'

import { createClient } from '@/supabase/server'

// ─── Type definitions ────────────────────────────────────────────

export type RoleInfo = {
  roleId: string
  kodeRole: string
  namaRole: string
  deskripsi: string | null
  level: number
  isSystem: boolean
  isActive: boolean
}

// ─── Constants ───────────────────────────────────────────────────
// Satu-satunya constant yang boleh hardcode (untuk auto-assign logic)

export const ROLE_PEGAWAI_CODE = 'PEGAWAI'
export const SUPERADMIN_LEVEL = 99

// ─── Cached fetch: semua roles aktif ─────────────────────────────
// Cache selama 1 jam, revalidate via tag 'roles'.

export const fetchRoles = unstable_cache(
  async (): Promise<RoleInfo[]> => {
    const supabase = await createClient()
    const { data, error } = await supabase
      .from('roles')
      .select('role_id, kode_role, nama_role, deskripsi, level, is_system, is_active')
      .eq('is_active', true)
      .order('level', { ascending: true })

    if (error) {
      console.error('[roles] Failed to fetch:', error.message)
      return []
    }

    return (data ?? []).map(r => ({
      roleId: r.role_id,
      kodeRole: r.kode_role,
      namaRole: r.nama_role,
      deskripsi: r.deskripsi,
      level: r.level,
      isSystem: r.is_system,
      isActive: r.is_active,
    }))
  },
  ['roles'],
  { tags: ['roles'], revalidate: 3600 },
)

// ─── Utility: get role by kode ───────────────────────────────────

export async function getRoleByCode(code: string): Promise<RoleInfo | null> {
  const roles = await fetchRoles()
  return roles.find(r => r.kodeRole === code) ?? null
}

// ─── Utility: get all roles as label map ─────────────────────────
// Pengganti ROLE_LABELS dari constants/roles.ts

export async function getRoleLabels(): Promise<Record<string, string>> {
  const roles = await fetchRoles()
  const labels: Record<string, string> = {}
  for (const r of roles) {
    labels[r.kodeRole] = r.namaRole
  }
  return labels
}

// ─── Utility: get all roles as level map ─────────────────────────
// Pengganti ROLE_LEVEL dari constants/roles.ts

export async function getRoleLevels(): Promise<Record<string, number>> {
  const roles = await fetchRoles()
  const levels: Record<string, number> = {}
  for (const r of roles) {
    levels[r.kodeRole] = r.level
  }
  return levels
}

// ─── Utility: check if role is superadmin ────────────────────────

export function isSuperAdmin(role: RoleInfo): boolean {
  return role.level >= SUPERADMIN_LEVEL
}
