import { Target } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function KinerjaPage() {
  return (
    <DashboardPagePlaceholder
      title="SKP & PAK"
      description="Pemantauan target kinerja dan penilaian angka kredit."
      icon={Target}
    />
  )
}
