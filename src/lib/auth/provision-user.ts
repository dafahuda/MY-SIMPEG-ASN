import type { SupabaseClient } from '@supabase/supabase-js'

// ─── Types ───────────────────────────────────────────────────────

type ProvisionResult = {
  userId: string
  isNew: boolean
}

// ─── provisionPublicUser ─────────────────────────────────────────
// Memastikan setiap auth.users punya row di public.users.
// Dipanggil setelah verifyOtp (confirm) dan sebagai fallback di
// dashboard layout jika user login tanpa melalui confirm route.
//
// Idempotent: jika row sudah ada, return existing user_id.
// Auto-assign PEGAWAI role ditangani oleh trigger
// tg_auto_assign_pegawai_role di migration 012.

export async function provisionPublicUser(
  supabase: SupabaseClient,
  authUserId: string,
  email: string | null,
): Promise<ProvisionResult> {
  // Cek apakah sudah ada
  const { data: existing } = await supabase
    .from('users')
    .select('user_id')
    .eq('auth_user_id', authUserId)
    .single()

  if (existing) {
    return { userId: existing.user_id, isNew: false }
  }

  // Generate user_id format: USR-<8 char random>
  const randomPart = crypto.randomUUID().replace(/-/g, '').slice(0, 8).toUpperCase()
  const userId = `USR-${randomPart}`

  // Username dari email (sebelum @)
  const username = email?.split('@')[0] ?? `user-${randomPart.toLowerCase()}`

  const { error } = await supabase.from('users').insert({
    user_id: userId,
    auth_user_id: authUserId,
    email_login: email,
    username,
    is_active: true,
    created_by: 'SYSTEM',
  })

  if (error) {
    // Jika race condition (concurrent insert), coba fetch lagi
    if (error.code === '23505') {
      const { data: raceResult } = await supabase
        .from('users')
        .select('user_id')
        .eq('auth_user_id', authUserId)
        .single()

      if (raceResult) {
        return { userId: raceResult.user_id, isNew: false }
      }
    }

    throw new Error(`[provision-user] Failed to create user: ${error.message}`)
  }

  return { userId, isNew: true }
}
