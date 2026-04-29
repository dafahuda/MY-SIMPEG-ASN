import { Award } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function KepangkatanPage() {
  return (
    <DashboardPagePlaceholder
      title="Kepangkatan"
      description="Riwayat pangkat dan golongan pegawai ASN."
      icon={Award}
    />
  )
}
