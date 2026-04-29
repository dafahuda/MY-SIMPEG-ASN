import { Suspense } from 'react'
import { Users, UserCheck, CalendarClock, FileText } from 'lucide-react'

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { Skeleton } from '@/components/ui/skeleton'

// ---------------------------------------------------------------------------
// Stat card data — placeholder values until real queries are wired
// ---------------------------------------------------------------------------

const STAT_CARDS = [
  {
    title: 'Total Pegawai',
    value: '—',
    description: 'Seluruh ASN terdaftar',
    icon: Users,
  },
  {
    title: 'Aktif',
    value: '—',
    description: 'Pegawai berstatus aktif',
    icon: UserCheck,
  },
  {
    title: 'Pensiun Tahun Ini',
    value: '—',
    description: 'Memasuki BUP tahun berjalan',
    icon: CalendarClock,
  },
  {
    title: 'Usulan Pending',
    value: '—',
    description: 'Menunggu verifikasi',
    icon: FileText,
  },
] as const

// ---------------------------------------------------------------------------
// Stat cards section
// ---------------------------------------------------------------------------

function StatCards() {
  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {STAT_CARDS.map((stat) => {
        const Icon = stat.icon
        return (
          <Card key={stat.title}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">
                {stat.title}
              </CardTitle>
              <Icon className="text-muted-foreground h-4 w-4" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{stat.value}</div>
              <p className="text-muted-foreground text-xs">
                {stat.description}
              </p>
            </CardContent>
          </Card>
        )
      })}
    </div>
  )
}

// ---------------------------------------------------------------------------
// Placeholder chart area
// ---------------------------------------------------------------------------

function ChartPlaceholder() {
  return (
    <div className="grid gap-4 md:grid-cols-2">
      <Card>
        <CardHeader>
          <CardTitle>Distribusi Golongan</CardTitle>
          <CardDescription>
            Sebaran pegawai berdasarkan golongan ruang
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="bg-muted/50 flex h-[200px] items-center justify-center rounded-md">
            <p className="text-muted-foreground text-sm">
              Chart akan ditampilkan di sini
            </p>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Tren Kepegawaian</CardTitle>
          <CardDescription>Pergerakan jumlah pegawai per bulan</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="bg-muted/50 flex h-[200px] items-center justify-center rounded-md">
            <p className="text-muted-foreground text-sm">
              Chart akan ditampilkan di sini
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

// ---------------------------------------------------------------------------
// Recent activity placeholder
// ---------------------------------------------------------------------------

function RecentActivity() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Aktivitas Terbaru</CardTitle>
        <CardDescription>Perubahan data dan usulan terakhir</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="flex items-center gap-4">
              <Skeleton className="h-10 w-10 rounded-full" />
              <div className="flex-1 space-y-1">
                <Skeleton className="h-4 w-3/4" />
                <Skeleton className="h-3 w-1/2" />
              </div>
              <Skeleton className="h-4 w-16" />
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  )
}

// ---------------------------------------------------------------------------
// Loading fallback for Suspense
// ---------------------------------------------------------------------------

function DashboardSkeleton() {
  return (
    <div className="space-y-4">
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <Card key={i}>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <Skeleton className="h-4 w-24" />
              <Skeleton className="h-4 w-4" />
            </CardHeader>
            <CardContent>
              <Skeleton className="mb-1 h-7 w-16" />
              <Skeleton className="h-3 w-32" />
            </CardContent>
          </Card>
        ))}
      </div>
      <div className="grid gap-4 md:grid-cols-2">
        <Skeleton className="h-[300px] rounded-xl" />
        <Skeleton className="h-[300px] rounded-xl" />
      </div>
      <Skeleton className="h-[300px] rounded-xl" />
    </div>
  )
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

export default function DashboardPage() {
  return (
    <Suspense fallback={<DashboardSkeleton />}>
      <div className="space-y-4">
        <div>
          <h2 className="text-2xl font-bold tracking-tight">Dashboard</h2>
          <p className="text-muted-foreground">
            Ringkasan data kepegawaian ASN
          </p>
        </div>

        <StatCards />
        <ChartPlaceholder />
        <RecentActivity />
      </div>
    </Suspense>
  )
}
