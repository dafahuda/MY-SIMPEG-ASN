import { unstable_cache } from 'next/cache'

import { createClient } from '@/supabase/server'
import { SUPERADMIN_LEVEL } from './roles'

// ─── Type definitions ────────────────────────────────────────────

export type PermissionInfo = {
  permissionId: string
  kodePermission: string
  namaPermission: string
  aksi: string
  moduleId: string
  kodeModule: string
}

export type ModuleInfo = {
  moduleId: string
  kodeModule: string
  namaModule: string
  deskripsi: string | null
  iconName: string | null
  urutan: number
  isActive: boolean
}

// ─── Constants ───────────────────────────────────────────────────

/** Wildcard permission — SUPERADMIN memiliki semua akses */
export const PERMISSION_ALL = '*'

// ─── Cached fetch: semua modules aktif ───────────────────────────

export const fetchModules = unstable_cache(
  async (): Promise<ModuleInfo[]> => {
    const supabase = await createClient()
    const { data, error } = await supabase
      .from('modules')
      .select('module_id, kode_module, nama_module, deskripsi, icon_name, urutan, is_active')
      .eq('is_active', true)
      .order('urutan')

    if (error) {
      console.error('[permissions] Failed to fetch modules:', error.message)
      return []
    }

    return (data ?? []).map(m => ({
      moduleId: m.module_id,
      kodeModule: m.kode_module,
      namaModule: m.nama_module,
      deskripsi: m.deskripsi,
      iconName: m.icon_name,
      urutan: m.urutan,
      isActive: m.is_active,
    }))
  },
  ['modules'],
  { tags: ['modules'], revalidate: 3600 },
)

// ─── getUserPermissions ──────────────────────────────────────────
// Ambil semua permission codes untuk user berdasarkan active roles.
// Multi-role: UNION semua permissions dari semua role aktif user.
// SUPERADMIN bypass: return ['*'] (wildcard).
// Cached per userId selama 5 menit.

export function getUserPermissions(userId: string, userRoleLevel: number) {
  return unstable_cache(
    async (): Promise<string[]> => {
      // SUPERADMIN bypass — tidak perlu query permission matrix
      if (userRoleLevel >= SUPERADMIN_LEVEL) {
        return [PERMISSION_ALL]
      }

      const supabase = await createClient()

      // Query: ambil semua permission codes dari role_permissions
      // untuk semua role aktif user (multi-role UNION)
      const { data, error } = await supabase
        .from('role_permissions')
        .select(`
          permission_id,
          permissions!inner (
            kode_permission,
            is_active
          ),
          roles!inner (
            role_id,
            is_active
          )
        `)
        .eq('is_active', true)
        .eq('permissions.is_active', true)
        .eq('roles.is_active', true)
        .in('role_id', await getUserRoleIds(userId))

      if (error) {
        console.error('[permissions] Failed to fetch user permissions:', error.message)
        return []
      }

      // Deduplicate permission codes
      const codes = new Set<string>()
      for (const row of data ?? []) {
        const perm = row.permissions as unknown as { kode_permission: string; is_active: boolean }
        if (perm.is_active) {
          codes.add(perm.kode_permission)
        }
      }

      return Array.from(codes).sort()
    },
    [`user-permissions-${userId}`],
    { tags: [`user-permissions-${userId}`, 'permissions'], revalidate: 300 },
  )()
}

// ─── Helper: get role_ids for user ───────────────────────────────

async function getUserRoleIds(userId: string): Promise<string[]> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from('user_roles')
    .select('role_id')
    .eq('user_id', userId)
    .eq('is_active', true)

  if (error || !data) return []
  return data.map(r => r.role_id)
}

// ─── Permission check utilities ──────────────────────────────────

/**
 * Cek apakah user memiliki permission tertentu.
 * Jika userPermissions berisi '*' (SUPERADMIN), selalu return true.
 */
export function hasPermission(
  userPermissions: string[],
  code: string,
): boolean {
  if (userPermissions.includes(PERMISSION_ALL)) return true
  return userPermissions.includes(code)
}

/**
 * Cek apakah user memiliki salah satu dari permission yang diminta.
 */
export function hasAnyPermission(
  userPermissions: string[],
  codes: string[],
): boolean {
  if (userPermissions.includes(PERMISSION_ALL)) return true
  return codes.some(code => userPermissions.includes(code))
}

/**
 * Cek apakah user memiliki SEMUA permission yang diminta.
 */
export function hasAllPermissions(
  userPermissions: string[],
  codes: string[],
): boolean {
  if (userPermissions.includes(PERMISSION_ALL)) return true
  return codes.every(code => userPermissions.includes(code))
}

// ─── Module-level permission check ──────────────────────────────

/**
 * Cek apakah user bisa mengakses modul tertentu (minimal VIEW).
 */
export function canAccessModule(
  userPermissions: string[],
  moduleCode: string,
): boolean {
  if (userPermissions.includes(PERMISSION_ALL)) return true
  return userPermissions.some(p => p.startsWith(`${moduleCode}.`))
}

/**
 * Filter list of module codes berdasarkan permission user.
 * Berguna untuk dynamic navigation.
 */
export function getAccessibleModules(
  userPermissions: string[],
  allModuleCodes: string[],
): string[] {
  if (userPermissions.includes(PERMISSION_ALL)) return allModuleCodes
  return allModuleCodes.filter(code => canAccessModule(userPermissions, code))
}
