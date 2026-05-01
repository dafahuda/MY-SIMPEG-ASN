'use client'

import { useState, useTransition } from 'react'
import { UserPlus } from 'lucide-react'

import { Button } from '@/components/ui/button'
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'

import { assignRole } from './actions'

// ─── Types ───────────────────────────────────────────────────────

type RoleAssignmentFormProps = {
  users: { user_id: string; username: string }[]
  roles: { role_id: string; kode_role: string; nama_role: string; level: number }[]
}

// ─── Component ───────────────────────────────────────────────────

export function RoleAssignmentForm({ users, roles }: RoleAssignmentFormProps) {
  const [selectedUser, setSelectedUser] = useState('')
  const [selectedRole, setSelectedRole] = useState('')
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null)
  const [isPending, startTransition] = useTransition()

  const handleSubmit = () => {
    if (!selectedUser || !selectedRole) {
      setMessage({ type: 'error', text: 'Pilih pengguna dan role terlebih dahulu' })
      return
    }

    startTransition(async () => {
      const result = await assignRole(selectedUser, selectedRole)
      setMessage({
        type: result.success ? 'success' : 'error',
        text: result.message,
      })
      if (result.success) {
        setSelectedUser('')
        setSelectedRole('')
      }
    })
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2 text-base">
          <UserPlus className="size-4" />
          Tambah Role
        </CardTitle>
        <CardDescription>
          Tetapkan role baru ke pengguna. Trigger database akan memvalidasi
          batasan (maks 3 role, kombinasi terlarang).
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="flex flex-col gap-4 sm:flex-row sm:items-end">
          <div className="flex-1 space-y-1.5">
            <label className="text-sm font-medium">Pengguna</label>
            <Select value={selectedUser} onValueChange={setSelectedUser}>
              <SelectTrigger>
                <SelectValue placeholder="Pilih pengguna..." />
              </SelectTrigger>
              <SelectContent>
                {users.map((user) => (
                  <SelectItem key={user.user_id} value={user.user_id}>
                    {user.username}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div className="flex-1 space-y-1.5">
            <label className="text-sm font-medium">Role</label>
            <Select value={selectedRole} onValueChange={setSelectedRole}>
              <SelectTrigger>
                <SelectValue placeholder="Pilih role..." />
              </SelectTrigger>
              <SelectContent>
                {roles.map((role) => (
                  <SelectItem key={role.role_id} value={role.role_id}>
                    {role.nama_role} (Level {role.level})
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <Button
            onClick={handleSubmit}
            disabled={isPending || !selectedUser || !selectedRole}
            className="shrink-0"
          >
            {isPending ? 'Memproses...' : 'Tambah'}
          </Button>
        </div>

        {message && (
          <p
            className={`mt-3 text-sm ${
              message.type === 'success' ? 'text-green-600' : 'text-red-500'
            }`}
          >
            {message.text}
          </p>
        )}
      </CardContent>
    </Card>
  )
}
