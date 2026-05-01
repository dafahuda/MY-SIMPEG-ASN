import { Suspense } from 'react'
import type { Metadata } from 'next'
import { connection } from 'next/server'

import { createClient } from '@/supabase/server'
import { getBranding } from '@/lib/services/app-settings'
import { getSessionWithPermissions } from '@/lib/auth/session'
import { getMenuForUser } from '@/lib/services/navigation'
import { provisionPublicUser } from '@/lib/auth/provision-user'
import { SidebarInset, SidebarProvider } from '@/components/ui/sidebar'
import { AppSidebar } from '@/components/layout/app-sidebar'
import { Header } from '@/components/layout/header'
import { PermissionProvider } from '@/components/auth/permission-context'

export async function generateMetadata(): Promise<Metadata> {
  const branding = await getBranding()

  return {
    title: {
      default: branding.appName,
      template: `%s | ${branding.appName}`,
    },
    description: branding.appDescription,
  }
}

type DashboardLayoutProps = {
  children: React.ReactNode
}

export default async function DashboardLayout({
  children,
}: DashboardLayoutProps) {
  await connection()

  // Fetch session + permissions (redirect ke login jika tidak authenticated)
  const { user: sessionUser, permissions } = await getSessionWithPermissions()

  // Fetch user metadata untuk sidebar display (nama, avatar)
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  // Fallback provisioning: jika user login tanpa melalui confirm route
  // (misalnya signInWithPassword langsung), pastikan public.users ada
  if (user && !sessionUser.userId) {
    try {
      await provisionPublicUser(supabase, user.id, user.email ?? null)
    } catch {
      // Fail-open: jangan block dashboard jika provisioning gagal
      console.warn('[dashboard] Fallback provisioning failed')
    }
  }

  const userInfo = {
    name:
      user?.user_metadata?.full_name ??
      user?.user_metadata?.name ??
      user?.email?.split('@')[0] ??
      'Pengguna',
    email: user?.email ?? '',
    avatar: user?.user_metadata?.avatar_url as string | undefined,
    roles: sessionUser.userRoles,
  }

  // Fetch data in parallel: branding + dynamic navigation
  const [branding, navGroups] = await Promise.all([
    getBranding(),
    getMenuForUser(sessionUser.userRoles, sessionUser.userRoleLevel),
  ])

  return (
    <PermissionProvider
      permissions={permissions}
      userRoleLevel={sessionUser.userRoleLevel}
    >
      <SidebarProvider>
        <AppSidebar user={userInfo} branding={branding} navGroups={navGroups} />
        <SidebarInset>
          <Header branding={branding} navGroups={navGroups} />
          <main className="flex-1 overflow-auto p-4 md:p-6">
            <Suspense>{children}</Suspense>
          </main>
        </SidebarInset>
      </SidebarProvider>
    </PermissionProvider>
  )
}
