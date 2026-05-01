import Link from 'next/link'
import { LogIn } from 'lucide-react'

import { Button } from '@/components/ui/button'

export default function UnauthorizedPage() {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="text-center space-y-4">
        <div className="flex justify-center">
          <LogIn className="h-16 w-16 text-muted-foreground" />
        </div>
        <h1 className="text-4xl font-bold text-destructive">401</h1>
        <h2 className="text-xl font-semibold">Sesi Berakhir</h2>
        <p className="text-muted-foreground max-w-md">
          Silakan login kembali untuk melanjutkan.
        </p>
        <Button asChild className="mt-4">
          <Link href="/auth/login">Login</Link>
        </Button>
      </div>
    </div>
  )
}
