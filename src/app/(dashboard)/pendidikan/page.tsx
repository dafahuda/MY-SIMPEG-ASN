import { GraduationCap } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function PendidikanPage() {
  return (
    <DashboardPagePlaceholder
      title="Pendidikan"
      description="Riwayat pendidikan formal dan jenjang akademik pegawai."
      icon={GraduationCap}
    />
  )
}
