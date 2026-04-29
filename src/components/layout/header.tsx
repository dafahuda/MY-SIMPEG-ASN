'use client'

import { useEffect, useMemo, useState } from 'react'
import { useRouter } from 'next/navigation'
import { usePathname } from 'next/navigation'
import { Search, type LucideIcon } from 'lucide-react'

import type { BrandingData } from '@/lib/services/app-settings'
import { SIDEBAR_NAV } from '@/lib/constants/navigation'
import { Separator } from '@/components/ui/separator'
import { Button } from '@/components/ui/button'
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
import {
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandShortcut,
} from '@/components/ui/command'

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

type SearchItem = {
  title: string
  href: string
  group: string
  icon: LucideIcon
}

type HeaderProps = {
  branding: BrandingData
}

export function Header({ branding }: HeaderProps) {
  const pathname = usePathname()
  const router = useRouter()
  const [open, setOpen] = useState(false)

  const searchItems = useMemo<SearchItem[]>(
    () =>
      SIDEBAR_NAV.flatMap((group) =>
        group.items.map((item) => ({
          title: item.title,
          href: item.href,
          group: group.label,
          icon: item.icon,
        })),
      ),
    [],
  )

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key.toLowerCase() !== 'k') return

      if (event.ctrlKey || event.metaKey) {
        event.preventDefault()
        setOpen((current) => !current)
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [])

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
        <Button
          type="button"
          variant="ghost"
          size="sm"
          className="text-muted-foreground min-w-40 justify-between"
          onClick={() => setOpen(true)}
        >
          <span className="flex items-center gap-2">
            <Search className="size-4" />
            Cari menu...
          </span>
          <span className="bg-muted rounded px-1.5 py-0.5 text-[10px] font-medium tracking-wider">
            Ctrl+K
          </span>
        </Button>
        <ThemeSwitcher />
      </div>

      <CommandDialog
        open={open}
        onOpenChange={setOpen}
        title={`Cari menu ${branding.appName}`}
        description="Pilih modul dashboard yang ingin dibuka."
        className="sm:max-w-xl"
      >
        <CommandInput placeholder="Cari dashboard, pegawai, jabatan, laporan..." />
        <CommandList>
          <CommandEmpty>Menu tidak ditemukan.</CommandEmpty>
          {SIDEBAR_NAV.map((group) => (
            <CommandGroup key={group.label} heading={group.label}>
              {searchItems
                .filter((item) => item.group === group.label)
                .map((item) => {
                  const Icon = item.icon

                  return (
                    <CommandItem
                      key={item.href}
                      value={`${item.title} ${item.group} ${item.href}`}
                      onSelect={() => {
                        router.push(item.href)
                        setOpen(false)
                      }}
                    >
                      <Icon className="size-4" />
                      <span>{item.title}</span>
                      <CommandShortcut>
                        {item.href.replace('/', '') || 'home'}
                      </CommandShortcut>
                    </CommandItem>
                  )
                })}
            </CommandGroup>
          ))}
        </CommandList>
      </CommandDialog>
    </header>
  )
}
