import { createClient } from '@/supabase/server'
import { ensureNipDomainLink } from '@/supabase/provisioning'
import { provisionPublicUser } from '@/lib/auth/provision-user'
import { type EmailOtpType } from '@supabase/supabase-js'
import { redirect } from 'next/navigation'
import { type NextRequest } from 'next/server'

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url)
  const token_hash = searchParams.get('token_hash')
  const type = searchParams.get('type') as EmailOtpType | null
  const next = searchParams.get('next') ?? '/dashboard'

  if (token_hash && type) {
    const supabase = await createClient()

    const { error } = await supabase.auth.verifyOtp({
      type,
      token_hash,
    })
    if (!error) {
      const { data } = await supabase.auth.getUser()

      // Provisioning: pastikan public.users row ada
      if (data.user) {
        await provisionPublicUser(
          supabase,
          data.user.id,
          data.user.email ?? null,
        )
      }

      await ensureNipDomainLink({
        supabase,
        identity: data.user,
      })

      redirect(next)
    } else {
      redirect(`/auth/error?error=${error?.message}`)
    }
  }

  redirect(`/auth/error?error=No token hash or type`)
}
