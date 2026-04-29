import { BarChart3 } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function LaporanPage() {
  return (
    <DashboardPagePlaceholder
      title="Laporan"
      description="Ringkasan, statistik, dan keluaran pelaporan kepegawaian."
      icon={BarChart3}
    />
  )
}
