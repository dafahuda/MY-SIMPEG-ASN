import { FolderOpen } from 'lucide-react'

import { DashboardPagePlaceholder } from '@/components/layout/dashboard-page-placeholder'

export default function DokumenPage() {
  return (
    <DashboardPagePlaceholder
      title="Dokumen"
      description="Arsip dokumen kepegawaian dan lampiran pendukung."
      icon={FolderOpen}
    />
  )
}
