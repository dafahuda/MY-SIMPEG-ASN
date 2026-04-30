-- ============================================================
-- Migration 011: Role Hierarchy (Fase 10)
-- ALTER roles + level column, seed 5 default roles
-- ============================================================

-- -------------------------------------------------------
-- Task 10.1: ALTER roles — tambah kolom level
-- -------------------------------------------------------
alter table public.roles
  add column if not exists level integer not null default 0;

alter table public.roles
  add constraint ck_roles_level check (level >= 0);

comment on column public.roles.level is
  'Hierarki role: semakin tinggi semakin banyak akses. Level 2 reserved untuk future roles (OPERATOR_DIVISI, KEPALA_DIVISI, dll). Level 99 = SUPERADMIN bypass.';

-- -------------------------------------------------------
-- Task 10.2: Seed 5 role default dengan level
-- -------------------------------------------------------
-- Level assignment:
--   1  = PEGAWAI (akses minimal, data diri)
--   2  = (reserved untuk future roles)
--   3  = VERIFIKATOR_BKD (verifikasi usulan)
--   4  = APPROVER_BKD (approve usulan — separation of duties)
--   5  = ADMIN_OPD (kelola data pegawai di OPD sendiri)
--   99 = SUPERADMIN (akses penuh, bypass semua permission check)

insert into public.roles (role_id, kode_role, nama_role, deskripsi, level, is_system) values
  ('ROL-001', 'SUPERADMIN',      'Super Administrator',  'Akses penuh ke seluruh sistem',                    99, true),
  ('ROL-002', 'ADMIN_OPD',       'Admin OPD',            'Mengelola data pegawai di OPD/divisi sendiri',      5,  false),
  ('ROL-003', 'VERIFIKATOR_BKD', 'Verifikator BKD',      'Memverifikasi usulan kepegawaian',                  3,  false),
  ('ROL-004', 'APPROVER_BKD',    'Approver BKD',         'Menyetujui usulan kepegawaian',                     4,  false),
  ('ROL-005', 'PEGAWAI',         'Pegawai',              'Akses data diri dan pengajuan usulan',              1,  false)
on conflict (role_id) do update set
  level = excluded.level,
  deskripsi = excluded.deskripsi,
  nama_role = excluded.nama_role;
