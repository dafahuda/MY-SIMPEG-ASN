import { BookOpen } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function DiklatPage() {
  return (
    <DashboardPagePlaceholder
      title="Diklat"
      description="Pencatatan pendidikan dan pelatihan pegawai."
      icon={BookOpen}
    />
  )
}
