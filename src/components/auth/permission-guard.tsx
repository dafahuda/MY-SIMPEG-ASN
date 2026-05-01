'use client'

import { type ReactNode } from 'react'

import { usePermissions } from './permission-context'

const WILDCARD = '*'

// ─── Props ───────────────────────────────────────────────────────

type PermissionGuardProps = {
  /** Single permission code to check */
  permission?: string
  /** Check if user has ANY of these permissions */
  any?: string[]
  /** Check if user has ALL of these permissions */
  all?: string[]
  /** Content to render if user has permission */
  children: ReactNode
  /** Optional fallback if user does NOT have permission */
  fallback?: ReactNode
}

// ─── Component ───────────────────────────────────────────────────
// Render children hanya jika user punya permission yang diminta.
// SUPERADMIN (wildcard '*') bypass semua check.

export function PermissionGuard({
  permission,
  any: anyPerms,
  all: allPerms,
  children,
  fallback = null,
}: PermissionGuardProps) {
  const { permissions } = usePermissions()

  // SUPERADMIN bypass
  if (permissions.includes(WILDCARD)) {
    return <>{children}</>
  }

  let hasAccess = false

  if (permission) {
    hasAccess = permissions.includes(permission)
  } else if (anyPerms && anyPerms.length > 0) {
    hasAccess = anyPerms.some(p => permissions.includes(p))
  } else if (allPerms && allPerms.length > 0) {
    hasAccess = allPerms.every(p => permissions.includes(p))
  } else {
    // No permission specified = always render
    hasAccess = true
  }

  return hasAccess ? <>{children}</> : <>{fallback}</>
}
