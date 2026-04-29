export const ROLES = {
  SUPERADMIN: 'SUPERADMIN',
  ADMIN_OPD: 'ADMIN_OPD',
  VERIFIKATOR_BKD: 'VERIFIKATOR_BKD',
  APPROVER_BKD: 'APPROVER_BKD',
  PEGAWAI: 'PEGAWAI',
} as const

export type RoleCode = (typeof ROLES)[keyof typeof ROLES]

export const ROLE_LABELS: Record<RoleCode, string> = {
  SUPERADMIN: 'Super Administrator',
  ADMIN_OPD: 'Admin OPD',
  VERIFIKATOR_BKD: 'Verifikator BKD',
  APPROVER_BKD: 'Approver BKD',
  PEGAWAI: 'Pegawai',
}

export const ROLE_LEVEL: Record<RoleCode, number> = {
  PEGAWAI: 1,
  ADMIN_OPD: 2,
  VERIFIKATOR_BKD: 3,
  APPROVER_BKD: 4,
  SUPERADMIN: 5,
}
