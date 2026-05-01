import { createClient } from '@/supabase/server'
import { SUPERADMIN_LEVEL } from './roles'
import { resolveIcon, type LucideIcon } from '@/lib/utils/icon-resolver'

// ─── Types ───────────────────────────────────────────────────────

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

type MenuRow = {
  menu_item_id: string
  parent_id: string | null
  module_id: string | null
  label: string
  href: string | null
  icon_name: string | null
  grup_label: string | null
  urutan: number
  is_active: boolean
  is_visible: boolean
}

// ─── getMenuForUser ──────────────────────────────────────────────
// Fetch menu items from database, filtered by user's role access.
// SUPERADMIN bypass: return all active+visible menu items.
// Multi-role: UNION menu access from all active roles.
// Returns NavGroup[] compatible with AppSidebar component.

export async function getMenuForUser(
  userRoles: string[],
  userRoleLevel: number,
): Promise<NavGroup[]> {
  try {
    const supabase = await createClient()
    const isSuperAdmin = userRoleLevel >= SUPERADMIN_LEVEL

    let menuRows: MenuRow[]

    if (isSuperAdmin) {
      // SUPERADMIN sees all active+visible menu items
      const { data, error } = await supabase
        .from('menu_items')
        .select('menu_item_id, parent_id, module_id, label, href, icon_name, grup_label, urutan, is_active, is_visible')
        .eq('is_active', true)
        .eq('is_visible', true)
        .order('urutan')

      if (error) {
        console.error('[navigation] Failed to fetch menu items:', error.message)
        return []
      }

      menuRows = data ?? []
    } else {
      // Non-SUPERADMIN: fetch via role_menu_access JOIN
      // First get role_ids for user's active roles
      const { data: roleData, error: roleError } = await supabase
        .from('roles')
        .select('role_id')
        .in('kode_role', userRoles)
        .eq('is_active', true)

      if (roleError || !roleData?.length) {
        return []
      }

      const roleIds = roleData.map(r => r.role_id)

      // Fetch accessible menu_item_ids via role_menu_access
      const { data: accessData, error: accessError } = await supabase
        .from('role_menu_access')
        .select('menu_item_id')
        .in('role_id', roleIds)
        .eq('is_visible', true)

      if (accessError || !accessData?.length) {
        return []
      }

      // Deduplicate menu_item_ids (multi-role UNION)
      const accessibleIds = [...new Set(accessData.map(a => a.menu_item_id))]

      // Fetch the actual menu items + their parent groups
      const { data: menuData, error: menuError } = await supabase
        .from('menu_items')
        .select('menu_item_id, parent_id, module_id, label, href, icon_name, grup_label, urutan, is_active, is_visible')
        .eq('is_active', true)
        .eq('is_visible', true)
        .order('urutan')

      if (menuError) {
        console.error('[navigation] Failed to fetch menu items:', menuError.message)
        return []
      }

      // Filter: keep items that are accessible + their parent groups
      const accessibleSet = new Set(accessibleIds)
      menuRows = (menuData ?? []).filter(row => {
        // Keep if directly accessible (leaf item)
        if (accessibleSet.has(row.menu_item_id)) return true
        // Keep if it's a parent group that has at least one accessible child
        if (!row.parent_id && !row.href) {
          return (menuData ?? []).some(
            child => child.parent_id === row.menu_item_id && accessibleSet.has(child.menu_item_id),
          )
        }
        return false
      })
    }

    return buildHierarchy(menuRows)
  } catch {
    console.error('[navigation] Unexpected error fetching menu')
    return []
  }
}

// ─── buildHierarchy ──────────────────────────────────────────────
// Transform flat menu rows into NavGroup[] (parent → children).
// Parents: rows where parent_id is null and href is null (group headers).
// Children: rows where parent_id points to a parent.

function buildHierarchy(rows: MenuRow[]): NavGroup[] {
  // Separate parents (groups) and children (items)
  const parents = rows.filter(r => !r.parent_id && !r.href)
  const children = rows.filter(r => r.parent_id && r.href)

  // Build groups with their children
  const groups: NavGroup[] = []

  for (const parent of parents) {
    const items = children
      .filter(c => c.parent_id === parent.menu_item_id)
      .sort((a, b) => a.urutan - b.urutan)
      .map(c => ({
        menuItemId: c.menu_item_id,
        title: c.label,
        href: c.href!,
        icon: resolveIcon(c.icon_name),
        iconName: c.icon_name,
      }))

    // Only include groups that have visible children
    if (items.length > 0) {
      groups.push({
        menuItemId: parent.menu_item_id,
        label: parent.grup_label ?? parent.label,
        items,
      })
    }
  }

  return groups.sort((a, b) => {
    const aParent = rows.find(r => r.menu_item_id === a.menuItemId)
    const bParent = rows.find(r => r.menu_item_id === b.menuItemId)
    return (aParent?.urutan ?? 0) - (bParent?.urutan ?? 0)
  })
}
