import {
  LayoutDashboard,
  Users,
  Award,
  Briefcase,
  GraduationCap,
  BookOpen,
  Heart,
  Target,
  Scale,
  TrendingUp,
  FileText,
  FolderOpen,
  Database,
  BarChart3,
  Settings,
  HelpCircle,
  type LucideIcon,
} from 'lucide-react'

// ─── Static Icon Map ─────────────────────────────────────────────
// Maps icon_name strings from database (PascalCase) to LucideIcon
// components. This pattern is used by Next.js SaaS Starter, LobeHub,
// Microsoft AutoGen, and other production codebases.
//
// Advantages over dynamic imports:
// - Instant render (no loading flash in sidebar)
// - Tree-shakeable (only used icons in bundle)
// - Server component compatible
// - Type-safe with fallback
//
// To add a new icon: import it from lucide-react and add to ICON_MAP.

const ICON_MAP: Record<string, LucideIcon> = {
  LayoutDashboard,
  Users,
  Award,
  Briefcase,
  GraduationCap,
  BookOpen,
  Heart,
  Target,
  Scale,
  TrendingUp,
  FileText,
  FolderOpen,
  Database,
  BarChart3,
  Settings,
}

const FALLBACK_ICON: LucideIcon = HelpCircle

/**
 * Resolve icon name string from database to LucideIcon component.
 * Returns fallback icon (HelpCircle) if name is null or not found.
 */
export function resolveIcon(name: string | null): LucideIcon {
  if (!name) return FALLBACK_ICON
  return ICON_MAP[name] ?? FALLBACK_ICON
}

export { FALLBACK_ICON }
export type { LucideIcon }
