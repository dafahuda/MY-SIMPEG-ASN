'use server'

import { revalidatePath } from 'next/cache'

import { createClient } from '@/supabase/server'
import { getSession } from '@/lib/auth/session'

// ─── Types ───────────────────────────────────────────────────────

type ActionResult = {
  success: boolean
  message: string
}

// ─── assignRole ──────────────────────────────────────────────────
// Assign role ke user. Hanya SUPERADMIN (level >= 99) yang boleh.
// Trigger di DB akan enforce max 3 dan forbidden combinations.

export async function assignRole(
  targetUserId: string,
  roleId: string,
): Promise<ActionResult> {
  const session = await getSession()
  if (!session || session.userRoleLevel < 99) {
    return { success: false, message: 'Akses ditolak' }
  }

  const supabase = await createClient()

  // Generate user_role_id
  const randomPart = crypto.randomUUID().replace(/-/g, '').slice(0, 8).toUpperCase()
  const userRoleId = `UR-${randomPart}`

  const { error } = await supabase.from('user_roles').insert({
    user_role_id: userRoleId,
    user_id: targetUserId,
    role_id: roleId,
    is_active: true,
    created_by: session.userId ?? 'SYSTEM',
  })

  if (error) {
    return { success: false, message: error.message }
  }

  revalidatePath('/pengaturan/roles')
  return { success: true, message: 'Role berhasil ditambahkan' }
}

// ─── revokeRole ──────────────────────────────────────────────────
// Soft-revoke: set is_active = false.

export async function revokeRole(
  userRoleId: string,
): Promise<ActionResult> {
  const session = await getSession()
  if (!session || session.userRoleLevel < 99) {
    return { success: false, message: 'Akses ditolak' }
  }

  const supabase = await createClient()

  const { error } = await supabase
    .from('user_roles')
    .update({ is_active: false })
    .eq('user_role_id', userRoleId)

  if (error) {
    return { success: false, message: error.message }
  }

  revalidatePath('/pengaturan/roles')
  return { success: true, message: 'Role berhasil dicabut' }
}
