import { ArrowRight, LucideIcon } from 'lucide-react'

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'

type DashboardPagePlaceholderProps = {
  title: string
  description: string
  icon: LucideIcon
}

export function DashboardPagePlaceholder({
  title,
  description,
  icon: Icon,
}: DashboardPagePlaceholderProps) {
  return (
    <div className="space-y-4">
      <div>
        <h2 className="text-2xl font-bold tracking-tight">{title}</h2>
        <p className="text-muted-foreground">{description}</p>
      </div>

      <Card>
        <CardHeader>
          <div className="flex items-center gap-3">
            <div className="bg-primary/10 text-primary flex size-10 items-center justify-center rounded-lg">
              <Icon className="size-5" />
            </div>
            <div>
              <CardTitle>Modul sedang disiapkan</CardTitle>
              <CardDescription>
                Fondasi halaman sudah tersedia dan siap dihubungkan ke data
                nyata.
              </CardDescription>
            </div>
          </div>
        </CardHeader>
        <CardContent className="grid gap-4 md:grid-cols-2">
          <div className="bg-muted/50 rounded-lg border p-4">
            <h3 className="mb-2 font-medium">Yang akan diisi berikutnya</h3>
            <ul className="text-muted-foreground space-y-2 text-sm">
              <li className="flex items-start gap-2">
                <ArrowRight className="mt-0.5 size-4 shrink-0" />
                Tabel data, filter, dan pencarian khusus modul ini.
              </li>
              <li className="flex items-start gap-2">
                <ArrowRight className="mt-0.5 size-4 shrink-0" />
                Integrasi Supabase query dan validasi formulir.
              </li>
              <li className="flex items-start gap-2">
                <ArrowRight className="mt-0.5 size-4 shrink-0" />
                Aksi tambah, ubah, dan detail sesuai kebutuhan SIMPEG.
              </li>
            </ul>
          </div>

          <div className="bg-muted/50 rounded-lg border p-4">
            <h3 className="mb-2 font-medium">Status implementasi</h3>
            <p className="text-muted-foreground text-sm leading-6">
              Route, layout dashboard, breadcrumb, sidebar, dan navigasi sudah
              aktif. Halaman ini sengaja dipasang sebagai placeholder agar
              struktur modul sesuai rencana fondasi tetap lengkap sebelum fitur
              CRUD dibangun.
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
