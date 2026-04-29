import { Database } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function MasterPage() {
  return (
    <DashboardPagePlaceholder
      title="Master Data"
      description="Referensi data dasar yang dipakai seluruh modul SIMPEG."
      icon={Database}
    />
  )
}
