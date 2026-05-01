import { Shield } from 'lucide-react'

import { createClient } from '@/supabase/server'
import { requirePermission } from '@/lib/auth/session'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'

import { RoleAssignmentForm } from './role-assignment-form'

// ─── Types ───────────────────────────────────────────────────────

type UserWithRoles = {
  user_id: string
  username: string
  email_login: string | null
  is_active: boolean
  roles: {
    user_role_id: string
    role_id: string
    kode_role: string
    nama_role: string
    is_active: boolean
  }[]
}

// ─── Page ────────────────────────────────────────────────────────

export default async function RoleManagementPage() {
  // Guard: hanya SUPERADMIN
  await requirePermission('PENGATURAN.VIEW')

  const supabase = await createClient()

  // Fetch semua users dengan roles mereka
  const { data: users } = await supabase
    .from('users')
    .select('user_id, username, email_login, is_active')
    .order('username')

  // Fetch semua user_roles aktif dengan join ke roles
  const { data: userRoles } = await supabase
    .from('user_roles')
    .select('user_role_id, user_id, role_id, is_active, roles(kode_role, nama_role)')
    .eq('is_active', true)

  // Fetch semua roles untuk dropdown
  const { data: allRoles } = await supabase
    .from('roles')
    .select('role_id, kode_role, nama_role, level')
    .order('level', { ascending: false })

  // Gabungkan data
  const usersWithRoles: UserWithRoles[] = (users ?? []).map((user) => ({
    ...user,
    roles: (userRoles ?? [])
      .filter((ur) => ur.user_id === user.user_id)
      .map((ur) => {
        const role = ur.roles as unknown as { kode_role: string; nama_role: string } | null
        return {
          user_role_id: ur.user_role_id,
          role_id: ur.role_id,
          kode_role: role?.kode_role ?? '',
          nama_role: role?.nama_role ?? '',
          is_active: ur.is_active,
        }
      }),
  }))

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold tracking-tight">Manajemen Role</h2>
        <p className="text-muted-foreground">
          Kelola role pengguna sistem. Setiap pengguna dapat memiliki maksimal 3
          role aktif.
        </p>
      </div>

      {/* Form assign role baru */}
      <RoleAssignmentForm
        users={usersWithRoles.map((u) => ({
          user_id: u.user_id,
          username: u.username,
        }))}
        roles={allRoles ?? []}
      />

      {/* Daftar users dan roles mereka */}
      <div className="grid gap-4">
        {usersWithRoles.map((user) => (
          <Card key={user.user_id}>
            <CardHeader className="pb-3">
              <div className="flex items-center justify-between">
                <div>
                  <CardTitle className="text-base">{user.username}</CardTitle>
                  <CardDescription>
                    {user.email_login ?? 'Tidak ada email'}
                  </CardDescription>
                </div>
                <div className="flex items-center gap-1">
                  <Shield className="text-muted-foreground size-4" />
                  <span className="text-muted-foreground text-xs">
                    {user.roles.length}/3 role
                  </span>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              {user.roles.length === 0 ? (
                <p className="text-muted-foreground text-sm italic">
                  Belum ada role yang ditetapkan
                </p>
              ) : (
                <div className="flex flex-wrap gap-2">
                  {user.roles.map((role) => (
                    <Badge key={role.user_role_id} variant="secondary">
                      {role.nama_role}
                    </Badge>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        ))}

        {usersWithRoles.length === 0 && (
          <Card>
            <CardContent className="py-8 text-center">
              <p className="text-muted-foreground">
                Belum ada pengguna terdaftar di sistem.
              </p>
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  )
}
