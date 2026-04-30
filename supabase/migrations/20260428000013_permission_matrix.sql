-- ============================================================
-- Migration 013: Permission Matrix (Fase 10B)
-- Tabel modules, permissions, role_permissions — fondasi akses
-- berbasis database (RBAC dynamic).
-- ============================================================
-- Catatan desain:
--   - Menggunakan TEXT (bukan ENUM) untuk kolom `aksi` agar bisa
--     menambah aksi baru tanpa ALTER TYPE (prinsip dinamis).
--   - role_permissions punya `is_active` untuk soft-disable tanpa
--     kehilangan audit trail (bisa re-enable tanpa re-INSERT).
-- ============================================================

-- -------------------------------------------------------
-- A. Tabel modules
-- -------------------------------------------------------

create table if not exists public.modules (
  module_id    text        not null,
  kode_module  text        not null,
  nama_module  text        not null,
  deskripsi    text,
  icon_name    text,
  urutan       integer     not null default 0,
  is_active    boolean     not null default true,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  created_by   text,
  updated_by   text,

  constraint pk_modules        primary key (module_id),
  constraint uq_modules_kode   unique (kode_module),
  constraint ck_modules_id     check (trim(module_id) <> ''),
  constraint ck_modules_kode   check (trim(kode_module) <> ''),
  constraint ck_modules_nama   check (trim(nama_module) <> ''),
  constraint ck_modules_urutan check (urutan >= 0)
);

create trigger trg_modules_updated_at
  before update on public.modules
  for each row execute function public.tg_set_updated_at();

-- RLS: semua authenticated bisa baca, hanya superadmin bisa manage
alter table public.modules enable row level security;

create policy "modules_select_authenticated"
  on public.modules for select to authenticated using (true);

create policy "modules_manage_superadmin"
  on public.modules for all to authenticated
  using ((select (auth.jwt()->>'user_role_level')::int) >= 99)
  with check ((select (auth.jwt()->>'user_role_level')::int) >= 99);

-- -------------------------------------------------------
-- B. Seed modules (15 modul sesuai navigasi SIMPEG)
-- -------------------------------------------------------

insert into public.modules (module_id, kode_module, nama_module, deskripsi, icon_name, urutan) values
  ('MOD-001', 'DASHBOARD',    'Dashboard',        'Halaman utama dashboard',            'LayoutDashboard', 1),
  ('MOD-002', 'PEGAWAI',      'Data Pegawai',     'Manajemen data pegawai',             'Users',           2),
  ('MOD-003', 'KEPANGKATAN',  'Kepangkatan',      'Riwayat pangkat dan golongan',       'Award',           3),
  ('MOD-004', 'JABATAN',      'Jabatan',          'Riwayat jabatan',                    'Briefcase',       4),
  ('MOD-005', 'PENDIDIKAN',   'Pendidikan',       'Riwayat pendidikan',                 'GraduationCap',   5),
  ('MOD-006', 'DIKLAT',       'Diklat',           'Riwayat diklat dan pelatihan',       'BookOpen',        6),
  ('MOD-007', 'KELUARGA',     'Keluarga',         'Data keluarga pegawai',              'Heart',           7),
  ('MOD-008', 'KINERJA',      'SKP & PAK',        'Penilaian kinerja dan angka kredit', 'Target',          8),
  ('MOD-009', 'DISIPLIN',     'Disiplin',         'Riwayat hukuman disiplin',           'Scale',           9),
  ('MOD-010', 'KGB',          'KGB',              'Kenaikan gaji berkala',              'TrendingUp',      10),
  ('MOD-011', 'USULAN',       'Usulan',           'Workflow usulan kepegawaian',        'FileText',        11),
  ('MOD-012', 'DOKUMEN',      'Dokumen',          'Manajemen dokumen pegawai',          'FolderOpen',      12),
  ('MOD-013', 'MASTER',       'Master Data',      'Pengelolaan data referensi',         'Database',        13),
  ('MOD-014', 'LAPORAN',      'Laporan',          'Laporan dan statistik',              'BarChart3',       14),
  ('MOD-015', 'PENGATURAN',   'Pengaturan',       'Konfigurasi sistem',                 'Settings',        15)
on conflict (module_id) do update set
  nama_module = excluded.nama_module,
  deskripsi = excluded.deskripsi,
  icon_name = excluded.icon_name,
  urutan = excluded.urutan;

-- -------------------------------------------------------
-- C. Tabel permissions
-- -------------------------------------------------------

create table if not exists public.permissions (
  permission_id    text        not null,
  module_id        text        not null,
  kode_permission  text        not null,
  nama_permission  text        not null,
  aksi             text        not null,
  deskripsi        text,
  is_active        boolean     not null default true,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  created_by       text,
  updated_by       text,

  constraint pk_permissions           primary key (permission_id),
  constraint uq_permissions_kode      unique (kode_permission),
  constraint fk_permissions_module    foreign key (module_id) references public.modules(module_id) on delete cascade,
  constraint ck_permissions_id        check (trim(permission_id) <> ''),
  constraint ck_permissions_kode      check (trim(kode_permission) <> ''),
  constraint ck_permissions_aksi      check (aksi in ('VIEW', 'CREATE', 'EDIT', 'DELETE', 'APPROVE', 'REJECT', 'EXPORT', 'PRINT', 'MANAGE'))
);

create index if not exists idx_permissions_module_id on public.permissions(module_id);

create trigger trg_permissions_updated_at
  before update on public.permissions
  for each row execute function public.tg_set_updated_at();

-- RLS
alter table public.permissions enable row level security;

create policy "permissions_select_authenticated"
  on public.permissions for select to authenticated using (true);

create policy "permissions_manage_superadmin"
  on public.permissions for all to authenticated
  using ((select (auth.jwt()->>'user_role_level')::int) >= 99)
  with check ((select (auth.jwt()->>'user_role_level')::int) >= 99);

-- -------------------------------------------------------
-- D. Seed permissions (55 permissions untuk 15 modul)
-- -------------------------------------------------------
-- Pattern: MODULE.AKSI
-- Setiap modul punya set aksi standar (VIEW, CREATE, EDIT, DELETE)
-- Modul tertentu punya aksi tambahan (APPROVE, REJECT, EXPORT, PRINT, MANAGE)

insert into public.permissions (permission_id, module_id, kode_permission, nama_permission, aksi) values
  -- Dashboard (hanya VIEW)
  ('PRM-001', 'MOD-001', 'DASHBOARD.VIEW',       'Lihat Dashboard',         'VIEW'),
  -- Pegawai (CRUD + EXPORT)
  ('PRM-002', 'MOD-002', 'PEGAWAI.VIEW',         'Lihat Data Pegawai',      'VIEW'),
  ('PRM-003', 'MOD-002', 'PEGAWAI.CREATE',       'Tambah Pegawai',          'CREATE'),
  ('PRM-004', 'MOD-002', 'PEGAWAI.EDIT',         'Edit Data Pegawai',       'EDIT'),
  ('PRM-005', 'MOD-002', 'PEGAWAI.DELETE',       'Hapus Pegawai',           'DELETE'),
  ('PRM-006', 'MOD-002', 'PEGAWAI.EXPORT',       'Export Data Pegawai',     'EXPORT'),
  -- Kepangkatan (CRUD)
  ('PRM-007', 'MOD-003', 'KEPANGKATAN.VIEW',     'Lihat Kepangkatan',       'VIEW'),
  ('PRM-008', 'MOD-003', 'KEPANGKATAN.CREATE',   'Tambah Kepangkatan',      'CREATE'),
  ('PRM-009', 'MOD-003', 'KEPANGKATAN.EDIT',     'Edit Kepangkatan',        'EDIT'),
  ('PRM-010', 'MOD-003', 'KEPANGKATAN.DELETE',   'Hapus Kepangkatan',       'DELETE'),
  -- Jabatan (CRUD)
  ('PRM-011', 'MOD-004', 'JABATAN.VIEW',         'Lihat Jabatan',           'VIEW'),
  ('PRM-012', 'MOD-004', 'JABATAN.CREATE',       'Tambah Jabatan',          'CREATE'),
  ('PRM-013', 'MOD-004', 'JABATAN.EDIT',         'Edit Jabatan',            'EDIT'),
  ('PRM-014', 'MOD-004', 'JABATAN.DELETE',       'Hapus Jabatan',           'DELETE'),
  -- Pendidikan (CRUD)
  ('PRM-015', 'MOD-005', 'PENDIDIKAN.VIEW',      'Lihat Pendidikan',        'VIEW'),
  ('PRM-016', 'MOD-005', 'PENDIDIKAN.CREATE',    'Tambah Pendidikan',       'CREATE'),
  ('PRM-017', 'MOD-005', 'PENDIDIKAN.EDIT',      'Edit Pendidikan',         'EDIT'),
  ('PRM-018', 'MOD-005', 'PENDIDIKAN.DELETE',    'Hapus Pendidikan',        'DELETE'),
  -- Diklat (CRUD)
  ('PRM-019', 'MOD-006', 'DIKLAT.VIEW',          'Lihat Diklat',            'VIEW'),
  ('PRM-020', 'MOD-006', 'DIKLAT.CREATE',        'Tambah Diklat',           'CREATE'),
  ('PRM-021', 'MOD-006', 'DIKLAT.EDIT',          'Edit Diklat',             'EDIT'),
  ('PRM-022', 'MOD-006', 'DIKLAT.DELETE',        'Hapus Diklat',            'DELETE'),
  -- Keluarga (CRUD)
  ('PRM-023', 'MOD-007', 'KELUARGA.VIEW',        'Lihat Keluarga',          'VIEW'),
  ('PRM-024', 'MOD-007', 'KELUARGA.CREATE',      'Tambah Keluarga',         'CREATE'),
  ('PRM-025', 'MOD-007', 'KELUARGA.EDIT',        'Edit Keluarga',           'EDIT'),
  ('PRM-026', 'MOD-007', 'KELUARGA.DELETE',      'Hapus Keluarga',          'DELETE'),
  -- Kinerja (CRUD)
  ('PRM-027', 'MOD-008', 'KINERJA.VIEW',         'Lihat SKP & PAK',        'VIEW'),
  ('PRM-028', 'MOD-008', 'KINERJA.CREATE',       'Tambah SKP/PAK',         'CREATE'),
  ('PRM-029', 'MOD-008', 'KINERJA.EDIT',         'Edit SKP/PAK',           'EDIT'),
  ('PRM-030', 'MOD-008', 'KINERJA.DELETE',       'Hapus SKP/PAK',          'DELETE'),
  -- Disiplin (CRUD)
  ('PRM-031', 'MOD-009', 'DISIPLIN.VIEW',        'Lihat Disiplin',          'VIEW'),
  ('PRM-032', 'MOD-009', 'DISIPLIN.CREATE',      'Tambah Disiplin',         'CREATE'),
  ('PRM-033', 'MOD-009', 'DISIPLIN.EDIT',        'Edit Disiplin',           'EDIT'),
  ('PRM-034', 'MOD-009', 'DISIPLIN.DELETE',      'Hapus Disiplin',          'DELETE'),
  -- KGB (CRUD)
  ('PRM-035', 'MOD-010', 'KGB.VIEW',             'Lihat KGB',              'VIEW'),
  ('PRM-036', 'MOD-010', 'KGB.CREATE',           'Tambah KGB',             'CREATE'),
  ('PRM-037', 'MOD-010', 'KGB.EDIT',             'Edit KGB',               'EDIT'),
  ('PRM-038', 'MOD-010', 'KGB.DELETE',           'Hapus KGB',              'DELETE'),
  -- Usulan (CRUD + APPROVE + REJECT)
  ('PRM-039', 'MOD-011', 'USULAN.VIEW',          'Lihat Usulan',            'VIEW'),
  ('PRM-040', 'MOD-011', 'USULAN.CREATE',        'Buat Usulan',             'CREATE'),
  ('PRM-041', 'MOD-011', 'USULAN.EDIT',          'Edit Usulan',             'EDIT'),
  ('PRM-042', 'MOD-011', 'USULAN.DELETE',        'Hapus Usulan',            'DELETE'),
  ('PRM-043', 'MOD-011', 'USULAN.APPROVE',       'Approve Usulan',          'APPROVE'),
  ('PRM-044', 'MOD-011', 'USULAN.REJECT',        'Reject Usulan',           'REJECT'),
  -- Dokumen (CRUD)
  ('PRM-045', 'MOD-012', 'DOKUMEN.VIEW',         'Lihat Dokumen',           'VIEW'),
  ('PRM-046', 'MOD-012', 'DOKUMEN.CREATE',       'Upload Dokumen',          'CREATE'),
  ('PRM-047', 'MOD-012', 'DOKUMEN.EDIT',         'Edit Dokumen',            'EDIT'),
  ('PRM-048', 'MOD-012', 'DOKUMEN.DELETE',       'Hapus Dokumen',           'DELETE'),
  -- Master Data (VIEW + MANAGE)
  ('PRM-049', 'MOD-013', 'MASTER.VIEW',          'Lihat Master Data',       'VIEW'),
  ('PRM-050', 'MOD-013', 'MASTER.MANAGE',        'Kelola Master Data',      'MANAGE'),
  -- Laporan (VIEW + EXPORT + PRINT)
  ('PRM-051', 'MOD-014', 'LAPORAN.VIEW',         'Lihat Laporan',           'VIEW'),
  ('PRM-052', 'MOD-014', 'LAPORAN.EXPORT',       'Export Laporan',          'EXPORT'),
  ('PRM-053', 'MOD-014', 'LAPORAN.PRINT',        'Print Laporan',           'PRINT'),
  -- Pengaturan (VIEW + MANAGE)
  ('PRM-054', 'MOD-015', 'PENGATURAN.VIEW',      'Lihat Pengaturan',        'VIEW'),
  ('PRM-055', 'MOD-015', 'PENGATURAN.MANAGE',    'Kelola Pengaturan',       'MANAGE')
on conflict (permission_id) do update set
  kode_permission = excluded.kode_permission,
  nama_permission = excluded.nama_permission,
  aksi = excluded.aksi;

-- -------------------------------------------------------
-- E. Tabel role_permissions
-- -------------------------------------------------------
-- Tambahan vs blueprint: kolom `is_active` untuk soft-disable
-- tanpa kehilangan audit trail.

create table if not exists public.role_permissions (
  role_permission_id text        not null,
  role_id            text        not null,
  permission_id      text        not null,
  is_active          boolean     not null default true,
  granted_at         timestamptz not null default now(),
  granted_by         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),

  constraint pk_role_permissions             primary key (role_permission_id),
  constraint uq_role_permissions_role_perm   unique (role_id, permission_id),
  constraint fk_role_permissions_role        foreign key (role_id) references public.roles(role_id) on delete cascade,
  constraint fk_role_permissions_permission  foreign key (permission_id) references public.permissions(permission_id) on delete cascade,
  constraint ck_role_permissions_id          check (trim(role_permission_id) <> '')
);

create index if not exists idx_role_permissions_role_id       on public.role_permissions(role_id);
create index if not exists idx_role_permissions_permission_id on public.role_permissions(permission_id);

create trigger trg_role_permissions_updated_at
  before update on public.role_permissions
  for each row execute function public.tg_set_updated_at();

-- RLS
alter table public.role_permissions enable row level security;

create policy "role_permissions_select_authenticated"
  on public.role_permissions for select to authenticated using (true);

create policy "role_permissions_manage_superadmin"
  on public.role_permissions for all to authenticated
  using ((select (auth.jwt()->>'user_role_level')::int) >= 99)
  with check ((select (auth.jwt()->>'user_role_level')::int) >= 99);
