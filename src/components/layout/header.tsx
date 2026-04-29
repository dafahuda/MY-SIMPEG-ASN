'use client'

import { usePathname } from 'next/navigation'
import { Separator } from '@/components/ui/separator'
import { SidebarTrigger } from '@/components/ui/sidebar'
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from '@/components/ui/breadcrumb'
import { ThemeSwitcher } from '@/components/theme-switcher'

/** Map URL segments to human-readable labels */
const SEGMENT_LABELS: Record<string, string> = {
  dashboard: 'Dashboard',
  pegawai: 'Data Pegawai',
  jabatan: 'Jabatan',
  kepangkatan: 'Kepangkatan',
  pendidikan: 'Pendidikan',
  diklat: 'Diklat',
  keluarga: 'Keluarga',
  kinerja: 'SKP & PAK',
  disiplin: 'Disiplin',
  kgb: 'KGB',
  usulan: 'Usulan',
  dokumen: 'Dokumen',
  master: 'Master Data',
  laporan: 'Laporan',
  pengaturan: 'Pengaturan',
}

function getLabel(segment: string): string {
  return (
    SEGMENT_LABELS[segment] ??
    segment.charAt(0).toUpperCase() + segment.slice(1)
  )
}

export function Header() {
  const pathname = usePathname()

  // Build breadcrumb segments from pathname, e.g. /pegawai/123 → ['pegawai', '123']
  const segments = pathname.split('/').filter(Boolean)

  return (
    <header className="flex h-16 shrink-0 items-center gap-2 border-b px-4 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-12">
      <div className="flex items-center gap-2">
        <SidebarTrigger className="-ml-1" />
        <Separator orientation="vertical" className="mr-2 h-4" />
        <Breadcrumb>
          <BreadcrumbList>
            {segments.map((segment, index) => {
              const href = '/' + segments.slice(0, index + 1).join('/')
              const isLast = index === segments.length - 1

              return isLast ? (
                <BreadcrumbItem key={href}>
                  <BreadcrumbPage>{getLabel(segment)}</BreadcrumbPage>
                </BreadcrumbItem>
              ) : (
                <BreadcrumbItem key={href}>
                  <BreadcrumbLink href={href}>
                    {getLabel(segment)}
                  </BreadcrumbLink>
                  <BreadcrumbSeparator />
                </BreadcrumbItem>
              )
            })}
          </BreadcrumbList>
        </Breadcrumb>
      </div>
      <div className="ml-auto flex items-center gap-2">
        <ThemeSwitcher />
      </div>
    </header>
  )
}
