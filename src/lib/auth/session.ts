import { redirect } from 'next/navigation'
import { forbidden } from 'next/navigation'

import { createClient } from '@/supabase/server'
import { getUserPermissions, PERMISSION_ALL } from '@/lib/services/permissions'

// ─── Types ───────────────────────────────────────────────────────

export type SessionUser = {
  /** auth.users.id (UUID) — dari JWT claim 'sub' */
  id: string
  email: string | null
  /** public.users.user_id (custom ID) — null jika belum ada di public.users */
  userId: string | null
  /** Level tertinggi dari semua role aktif (dari JWT custom claim) */
  userRoleLevel: number
  /** Array kode_role dari JWT custom claim */
  userRoles: string[]
}

export type SessionWithPermissions = {
  user: SessionUser
  permissions: string[]
}

// ─── Route-to-Permission mapping ─────────────────────────────────
// Mapping route path ke permission code yang dibutuhkan.
// Digunakan oleh requireRoutePermission() untuk layout-level guard.

const ROUTE_PERMISSIONS: Record<string, string> = {
  '/dashboard': 'DASHBOARD.VIEW',
  '/pegawai': 'PEGAWAI.VIEW',
  '/kepangkatan': 'KEPANGKATAN.VIEW',
  '/jabatan': 'JABATAN.VIEW',
  '/pendidikan': 'PENDIDIKAN.VIEW',
  '/diklat': 'DIKLAT.VIEW',
  '/keluarga': 'KELUARGA.VIEW',
  '/kinerja': 'KINERJA.VIEW',
  '/disiplin': 'DISIPLIN.VIEW',
  '/kgb': 'KGB.VIEW',
  '/usulan': 'USULAN.VIEW',
  '/dokumen': 'DOKUMEN.VIEW',
  '/master': 'MASTER.VIEW',
  '/laporan': 'LAPORAN.VIEW',
  '/pengaturan': 'PENGATURAN.VIEW',
}

export { ROUTE_PERMISSIONS }

// ─── getSession ──────────────────────────────────────────────────
// Ambil session user dari Supabase Auth JWT claims.
// Menggunakan getClaims() karena custom_access_token_hook inject
// user_roles dan user_role_level ke JWT claims (bukan app_metadata).
// Return null jika tidak authenticated.

export async function getSession(): Promise<SessionUser | null> {
  const supabase = await createClient()
  const { data, error } = await supabase.auth.getClaims()

  if (error || !data?.claims) return null

  const claims = data.claims as Record<string, unknown>

  return {
    id: (claims.sub as string) ?? '',
    email: (claims.email as string) ?? null,
    userId: (claims.user_id as string) ?? null,
    userRoleLevel: (claims.user_role_level as number) ?? 0,
    userRoles: (claims.user_roles as string[]) ?? [],
  }
}

// ─── getSessionWithPermissions ───────────────────────────────────
// Ambil session + resolve permissions dari DB.
// Redirect ke login jika tidak authenticated.

export async function getSessionWithPermissions(): Promise<SessionWithPermissions> {
  const user = await getSession()

  if (!user) {
    redirect('/auth/login')
  }

  // Resolve permissions (cached 5 menit di getUserPermissions)
  const permissions = user.userId
    ? await getUserPermissions(user.userId, user.userRoleLevel)
    : user.userRoleLevel >= 99
      ? [PERMISSION_ALL]
      : []

  return { user, permissions }
}

// ─── requirePermission ───────────────────────────────────────────
// Guard function untuk Server Components.
// Panggil di awal page component untuk enforce permission.
// Jika user tidak punya permission → render 403 forbidden page.

export async function requirePermission(
  permission: string,
): Promise<SessionWithPermissions> {
  const session = await getSessionWithPermissions()

  const hasAccess =
    session.permissions.includes(PERMISSION_ALL) ||
    session.permissions.includes(permission)

  if (!hasAccess) {
    forbidden()
  }

  return session
}

// ─── requireRoutePermission ──────────────────────────────────────
// Guard berdasarkan pathname. Cocok untuk layout-level guard.
// Jika route tidak ada di mapping, cukup cek authenticated.

export async function requireRoutePermission(
  pathname: string,
): Promise<SessionWithPermissions> {
  const requiredPermission = ROUTE_PERMISSIONS[pathname]

  if (!requiredPermission) {
    return getSessionWithPermissions()
  }

  return requirePermission(requiredPermission)
}
