import { Users } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function PegawaiPage() {
  return (
    <DashboardPagePlaceholder
      title="Data Pegawai"
      description="Pusat pengelolaan data induk pegawai ASN."
      icon={Users}
    />
  )
}
