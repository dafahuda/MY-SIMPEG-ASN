import { Heart } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function KeluargaPage() {
  return (
    <DashboardPagePlaceholder
      title="Keluarga"
      description="Informasi keluarga dan tanggungan pegawai ASN."
      icon={Heart}
    />
  )
}
