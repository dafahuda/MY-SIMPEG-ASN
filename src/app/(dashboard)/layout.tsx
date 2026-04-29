import { Suspense } from 'react'
import { connection } from 'next/server'

import { createClient } from '@/supabase/server'
import { getBranding } from '@/lib/services/app-settings'
import { SidebarInset, SidebarProvider } from '@/components/ui/sidebar'
import { AppSidebar } from '@/components/layout/app-sidebar'
import { Header } from '@/components/layout/header'

type DashboardLayoutProps = {
  children: React.ReactNode
}

export default async function DashboardLayout({
  children,
}: DashboardLayoutProps) {
  await connection()
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  const userInfo = {
    name:
      user?.user_metadata?.full_name ??
      user?.user_metadata?.name ??
      user?.email?.split('@')[0] ??
      'Pengguna',
    email: user?.email ?? '',
    avatar: user?.user_metadata?.avatar_url as string | undefined,
    role: user?.app_metadata?.role as string | undefined,
  }

  const branding = await getBranding()

  return (
    <SidebarProvider>
      <AppSidebar user={userInfo} branding={branding} />
      <SidebarInset>
        <Header branding={branding} />
        <main className="flex-1 overflow-auto p-4 md:p-6">
          <Suspense>{children}</Suspense>
        </main>
      </SidebarInset>
    </SidebarProvider>
  )
}
