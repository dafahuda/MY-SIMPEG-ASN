import { AuthButton } from '@/components/auth-button'
import { ThemeSwitcher } from '@/components/theme-switcher'
import Link from 'next/link'
import { Suspense } from 'react'

type ProtectedLayoutProps = {
  children: React.ReactNode
}

// Temporary layout — will be replaced by dashboard layout
export default function ProtectedLayout({ children }: ProtectedLayoutProps) {
  return (
    <main className="flex min-h-screen flex-col items-center">
      <div className="flex w-full flex-1 flex-col items-center gap-20">
        <nav className="border-b-foreground/10 flex h-16 w-full justify-center border-b">
          <div className="flex w-full max-w-5xl items-center justify-between p-3 px-5 text-sm">
            <div className="flex items-center gap-5 font-semibold">
              <Link href={'/'}>SIMPEG ASN</Link>
            </div>
            <div className="flex items-center gap-2">
              <Suspense>
                <AuthButton />
              </Suspense>
              <ThemeSwitcher />
            </div>
          </div>
        </nav>
        <div className="flex max-w-5xl flex-1 flex-col gap-20 p-5">
          {children}
        </div>
      </div>
    </main>
  )
}
