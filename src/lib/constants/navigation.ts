// ─── Navigation Types ────────────────────────────────────────────
// Tipe-tipe ini digunakan oleh sidebar dan header components.
// Data navigasi sekarang diambil dari database via
// src/lib/services/navigation.ts (getMenuForUser).
//
// File ini hanya berisi type definitions — tidak ada data hardcode.
// Lihat: supabase/migrations/20260428000015_dynamic_navigation.sql

import type { LucideIcon } from 'lucide-react'

export type NavItem = {
  menuItemId: string
  title: string
  href: string
  icon: LucideIcon
  iconName: string | null
}

export type NavGroup = {
  menuItemId: string
  label: string
  items: NavItem[]
}
