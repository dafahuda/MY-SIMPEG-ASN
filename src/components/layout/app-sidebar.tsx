'use client'

import { useMemo } from 'react'
import Image from 'next/image'
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { ChevronRight, ShieldCheck } from 'lucide-react'

import type { BrandingData } from '@/lib/services/app-settings'
import { SIDEBAR_NAV } from '@/lib/constants/navigation'
import { ROUTE_PERMISSIONS } from '@/lib/constants/route-permissions'
import { usePermissions } from '@/components/auth/permission-context'
import {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarRail,
} from '@/components/ui/sidebar'
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from '@/components/ui/collapsible'
import { UserNav } from '@/components/layout/user-nav'

type AppSidebarProps = {
  user: {
    name: string
    email: string
    avatar?: string
    roles: string[]
  }
  branding: BrandingData
}

export function AppSidebar({ user, branding }: AppSidebarProps) {
  const pathname = usePathname()
  const { permissions, userRoleLevel } = usePermissions()

  // Filter nav items berdasarkan permission user
  const filteredNav = useMemo(() => {
    const isSuperAdmin = userRoleLevel >= 99 || permissions.includes('*')

    if (isSuperAdmin) return SIDEBAR_NAV

    return SIDEBAR_NAV
      .map((group) => ({
        ...group,
        items: group.items.filter((item) => {
          const requiredPermission = ROUTE_PERMISSIONS[item.href]
          if (!requiredPermission) return true
          return permissions.includes(requiredPermission)
        }),
      }))
      .filter((group) => group.items.length > 0)
  }, [permissions, userRoleLevel])

  const hasLogo =
    branding.logoUrl &&
    branding.logoUrl !== '/images/logo.png'

  return (
    <Sidebar collapsible="icon">
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton size="lg" asChild>
              <Link href="/dashboard">
                {hasLogo ? (
                  <Image
                    src={branding.logoUrl}
                    alt={branding.appName}
                    width={32}
                    height={32}
                    className="aspect-square size-8 rounded-lg object-contain"
                  />
                ) : (
                  <div className="bg-primary text-primary-foreground flex aspect-square size-8 items-center justify-center rounded-lg">
                    <ShieldCheck className="size-4" />
                  </div>
                )}
                <div className="grid flex-1 text-left text-sm leading-tight">
                  <span className="truncate font-semibold">
                    {branding.appName}
                  </span>
                  <span className="text-muted-foreground truncate text-xs">
                    {branding.instansiNama || branding.appDescription}
                  </span>
                </div>
              </Link>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>

      <SidebarContent>
        {filteredNav.map((group) => (
          <Collapsible
            key={group.label}
            defaultOpen
            className="group/collapsible"
          >
            <SidebarGroup>
              <SidebarGroupLabel asChild>
                <CollapsibleTrigger>
                  {group.label}
                  <ChevronRight className="ml-auto transition-transform duration-200 group-data-[state=open]/collapsible:rotate-90" />
                </CollapsibleTrigger>
              </SidebarGroupLabel>
              <CollapsibleContent>
                <SidebarGroupContent>
                  <SidebarMenu>
                    {group.items.map((item) => (
                      <SidebarMenuItem key={item.href}>
                        <SidebarMenuButton
                          asChild
                          isActive={pathname === item.href}
                          tooltip={item.title}
                        >
                          <Link href={item.href}>
                            <item.icon />
                            <span>{item.title}</span>
                          </Link>
                        </SidebarMenuButton>
                      </SidebarMenuItem>
                    ))}
                  </SidebarMenu>
                </SidebarGroupContent>
              </CollapsibleContent>
            </SidebarGroup>
          </Collapsible>
        ))}
      </SidebarContent>

      <SidebarFooter>
        <UserNav user={user} />
      </SidebarFooter>
      <SidebarRail />
    </Sidebar>
  )
}
