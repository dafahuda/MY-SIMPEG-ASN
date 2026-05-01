'use client'

import { useCallback, useMemo, useState } from 'react'
import { RefreshCw } from 'lucide-react'

import { Badge } from '@/components/ui/badge'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'

// ─── Types ───────────────────────────────────────────────────────

type RoleSwitcherProps = {
  roles: string[]
}

// ─── Cookie helpers ──────────────────────────────────────────────
// Acting role disimpan di cookie agar bisa dibaca server-side.
// Cookie ini BUKAN untuk security — hanya untuk UI preference.
// Permission tetap dihitung dari SEMUA active roles (union).

const COOKIE_NAME = 'simpeg-acting-role'

function getActingRoleFromCookie(): string | null {
  if (typeof document === 'undefined') return null
  const match = document.cookie.match(
    new RegExp(`(?:^|; )${COOKIE_NAME}=([^;]*)`),
  )
  return match ? decodeURIComponent(match[1]) : null
}

function setActingRoleCookie(role: string) {
  document.cookie = `${COOKIE_NAME}=${encodeURIComponent(role)}; path=/; max-age=${60 * 60 * 24 * 30}; samesite=lax`
}

// ─── Component ───────────────────────────────────────────────────
// Hanya tampil jika user punya > 1 role aktif.

export function RoleSwitcher({ roles }: RoleSwitcherProps) {
  // Inisialisasi state langsung dari cookie (tanpa useEffect)
  const initialRole = useMemo(() => {
    const saved = getActingRoleFromCookie()
    if (saved && roles.includes(saved)) return saved
    if (roles.length > 0) {
      setActingRoleCookie(roles[0])
      return roles[0]
    }
    return ''
  }, [roles])

  const [actingRole, setActingRole] = useState<string>(initialRole)

  const handleChange = useCallback(
    (value: string) => {
      setActingRole(value)
      setActingRoleCookie(value)
    },
    [],
  )

  // Jangan render jika hanya 1 role atau tidak ada role
  if (roles.length <= 1) return null

  return (
    <div className="flex items-center gap-2">
      <RefreshCw className="text-muted-foreground size-3.5" />
      <Select value={actingRole} onValueChange={handleChange}>
        <SelectTrigger className="h-7 w-auto gap-1 border-none bg-transparent px-1 text-xs shadow-none focus:ring-0">
          <SelectValue placeholder="Pilih role" />
        </SelectTrigger>
        <SelectContent align="start">
          {roles.map((role) => (
            <SelectItem key={role} value={role} className="text-xs">
              <Badge variant="outline" className="text-xs font-normal">
                {role}
              </Badge>
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  )
}
