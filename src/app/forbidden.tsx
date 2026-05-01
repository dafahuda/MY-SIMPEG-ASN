import Link from 'next/link'
import { ShieldX } from 'lucide-react'

import { Button } from '@/components/ui/button'

export default function ForbiddenPage() {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="text-center space-y-4">
        <div className="flex justify-center">
          <ShieldX className="h-16 w-16 text-destructive" />
        </div>
        <h1 className="text-4xl font-bold text-destructive">403</h1>
        <h2 className="text-xl font-semibold">Akses Ditolak</h2>
        <p className="text-muted-foreground max-w-md">
          Anda tidak memiliki izin untuk mengakses halaman ini.
          Hubungi administrator jika Anda merasa ini adalah kesalahan.
        </p>
        <Button asChild variant="outline" className="mt-4">
          <Link href="/dashboard">Kembali ke Dashboard</Link>
        </Button>
      </div>
    </div>
  )
}
