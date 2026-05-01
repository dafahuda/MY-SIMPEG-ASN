'use client'

import { createContext, useContext, type ReactNode } from 'react'

// ─── Types ───────────────────────────────────────────────────────

type PermissionContextValue = {
  permissions: string[]
  userRoleLevel: number
}

// ─── Context ─────────────────────────────────────────────────────

const PermissionContext = createContext<PermissionContextValue>({
  permissions: [],
  userRoleLevel: 0,
})

// ─── Provider ────────────────────────────────────────────────────
// Render di (dashboard)/layout.tsx — server component passes data.

type PermissionProviderProps = {
  permissions: string[]
  userRoleLevel: number
  children: ReactNode
}

export function PermissionProvider({
  permissions,
  userRoleLevel,
  children,
}: PermissionProviderProps) {
  return (
    <PermissionContext.Provider value={{ permissions, userRoleLevel }}>
      {children}
    </PermissionContext.Provider>
  )
}

// ─── Hook ────────────────────────────────────────────────────────

export function usePermissions() {
  return useContext(PermissionContext)
}
