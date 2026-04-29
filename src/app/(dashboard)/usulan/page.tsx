import { FileText } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function UsulanPage() {
  return (
    <DashboardPagePlaceholder
      title="Usulan"
      description="Workflow usulan kepegawaian yang menunggu proses lanjutan."
      icon={FileText}
    />
  )
}
