import { Settings } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function PengaturanPage() {
  return (
    <DashboardPagePlaceholder
      title="Pengaturan"
      description="Konfigurasi aplikasi, preferensi pengguna, dan administrasi."
      icon={Settings}
    />
  )
}
