import { TrendingUp } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function KgbPage() {
  return (
    <DashboardPagePlaceholder
      title="KGB"
      description="Kenaikan gaji berkala dan jadwal tindak lanjutnya."
      icon={TrendingUp}
    />
  )
}
