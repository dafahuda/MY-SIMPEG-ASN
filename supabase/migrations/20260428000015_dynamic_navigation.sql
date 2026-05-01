-- =========================================================
-- Migration 015: Dynamic Navigation (Fase 11)
-- Tabel menu_items + role_menu_access + RLS + seed
-- =========================================================

-- -------------------------------------------------------
-- A. Tabel menu_items (self-referencing hierarchy)
-- -------------------------------------------------------

create table if not exists public.menu_items (
  menu_item_id   text        not null,
  parent_id      text,
  module_id      text,
  kode_menu      text        not null,
  label          text        not null,
  href           text,
  icon_name      text,
  grup_label     text,
  urutan         integer     not null default 0,
  is_active      boolean     not null default true,
  is_visible     boolean     not null default true,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  created_by     text,
  updated_by     text,

  constraint pk_menu_items          primary key (menu_item_id),
  constraint uq_menu_items_kode     unique (kode_menu),
  constraint fk_menu_items_parent   foreign key (parent_id) references public.menu_items(menu_item_id) on delete cascade,
  constraint fk_menu_items_module   foreign key (module_id) references public.modules(module_id) on delete set null,
  constraint ck_menu_items_id       check (trim(menu_item_id) <> ''),
  constraint ck_menu_items_kode     check (trim(kode_menu) <> ''),
  constraint ck_menu_items_label    check (trim(label) <> ''),
  constraint ck_menu_items_urutan   check (urutan >= 0)
);

create index if not exists idx_menu_items_parent_id on public.menu_items(parent_id);
create index if not exists idx_menu_items_module_id on public.menu_items(module_id);
create index if not exists idx_menu_items_urutan    on public.menu_items(urutan);

create trigger trg_menu_items_updated_at
  before update on public.menu_items
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- B. Tabel role_menu_access (role × menu_item)
-- -------------------------------------------------------

create table if not exists public.role_menu_access (
  role_menu_id  text        not null,
  role_id       text        not null,
  menu_item_id  text        not null,
  is_visible    boolean     not null default true,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  created_by    text,
  updated_by    text,

  constraint pk_role_menu_access           primary key (role_menu_id),
  constraint uq_role_menu_access_role_menu unique (role_id, menu_item_id),
  constraint fk_role_menu_access_role      foreign key (role_id) references public.roles(role_id) on delete cascade,
  constraint fk_role_menu_access_menu      foreign key (menu_item_id) references public.menu_items(menu_item_id) on delete cascade,
  constraint ck_role_menu_access_id        check (trim(role_menu_id) <> '')
);

create index if not exists idx_role_menu_access_role_id on public.role_menu_access(role_id);
create index if not exists idx_role_menu_access_menu_id on public.role_menu_access(menu_item_id);

create trigger trg_role_menu_access_updated_at
  before update on public.role_menu_access
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- C. RLS policies
-- -------------------------------------------------------

-- menu_items: semua authenticated bisa baca, SUPERADMIN manage
alter table public.menu_items enable row level security;

create policy "menu_items_select_authenticated"
  on public.menu_items for select
  to authenticated
  using (true);

create policy "menu_items_manage_superadmin"
  on public.menu_items for all
  to authenticated
  using (
    coalesce(
      ((current_setting('request.jwt.claims', true)::jsonb) ->> 'user_role_level')::int,
      0
    ) >= 99
  )
  with check (
    coalesce(
      ((current_setting('request.jwt.claims', true)::jsonb) ->> 'user_role_level')::int,
      0
    ) >= 99
  );

-- role_menu_access: semua authenticated bisa baca, SUPERADMIN manage
alter table public.role_menu_access enable row level security;

create policy "role_menu_access_select_authenticated"
  on public.role_menu_access for select
  to authenticated
  using (true);

create policy "role_menu_access_manage_superadmin"
  on public.role_menu_access for all
  to authenticated
  using (
    coalesce(
      ((current_setting('request.jwt.claims', true)::jsonb) ->> 'user_role_level')::int,
      0
    ) >= 99
  )
  with check (
    coalesce(
      ((current_setting('request.jwt.claims', true)::jsonb) ->> 'user_role_level')::int,
      0
    ) >= 99
  );

-- -------------------------------------------------------
-- D. Seed menu items (migrasi dari hardcode navigation.ts)
-- -------------------------------------------------------

-- Grup headers (parent items tanpa href)
insert into public.menu_items (menu_item_id, parent_id, module_id, kode_menu, label, href, icon_name, grup_label, urutan) values
  ('MNU-G01', null, null, 'GRP_UTAMA',     'Utama',              null, null, 'Utama',              1),
  ('MNU-G02', null, null, 'GRP_RIWAYAT',   'Riwayat',            null, null, 'Riwayat',            2),
  ('MNU-G03', null, null, 'GRP_KINERJA',   'Kinerja & Disiplin', null, null, 'Kinerja & Disiplin', 3),
  ('MNU-G04', null, null, 'GRP_WORKFLOW',  'Workflow',            null, null, 'Workflow',            4),
  ('MNU-G05', null, null, 'GRP_ADMIN',     'Administrasi',        null, null, 'Administrasi',        5),
  -- Menu items (children)
  ('MNU-001', 'MNU-G01', 'MOD-001', 'MENU_DASHBOARD',   'Dashboard',     '/dashboard',     'LayoutDashboard', null, 1),
  ('MNU-002', 'MNU-G01', 'MOD-002', 'MENU_PEGAWAI',     'Data Pegawai',  '/pegawai',       'Users',           null, 2),
  ('MNU-003', 'MNU-G02', 'MOD-003', 'MENU_KEPANGKATAN', 'Kepangkatan',   '/kepangkatan',   'Award',           null, 1),
  ('MNU-004', 'MNU-G02', 'MOD-004', 'MENU_JABATAN',     'Jabatan',       '/jabatan',       'Briefcase',       null, 2),
  ('MNU-005', 'MNU-G02', 'MOD-005', 'MENU_PENDIDIKAN',  'Pendidikan',    '/pendidikan',    'GraduationCap',   null, 3),
  ('MNU-006', 'MNU-G02', 'MOD-006', 'MENU_DIKLAT',      'Diklat',        '/diklat',        'BookOpen',        null, 4),
  ('MNU-007', 'MNU-G02', 'MOD-007', 'MENU_KELUARGA',    'Keluarga',      '/keluarga',      'Heart',           null, 5),
  ('MNU-008', 'MNU-G03', 'MOD-008', 'MENU_KINERJA',     'SKP & PAK',     '/kinerja',       'Target',          null, 1),
  ('MNU-009', 'MNU-G03', 'MOD-009', 'MENU_DISIPLIN',    'Disiplin',      '/disiplin',      'Scale',           null, 2),
  ('MNU-010', 'MNU-G03', 'MOD-010', 'MENU_KGB',         'KGB',           '/kgb',           'TrendingUp',      null, 3),
  ('MNU-011', 'MNU-G04', 'MOD-011', 'MENU_USULAN',      'Usulan',        '/usulan',        'FileText',        null, 1),
  ('MNU-012', 'MNU-G04', 'MOD-012', 'MENU_DOKUMEN',     'Dokumen',       '/dokumen',       'FolderOpen',      null, 2),
  ('MNU-013', 'MNU-G05', 'MOD-013', 'MENU_MASTER',      'Master Data',   '/master',        'Database',        null, 1),
  ('MNU-014', 'MNU-G05', 'MOD-014', 'MENU_LAPORAN',     'Laporan',       '/laporan',       'BarChart3',       null, 2),
  ('MNU-015', 'MNU-G05', 'MOD-015', 'MENU_PENGATURAN',  'Pengaturan',    '/pengaturan',    'Settings',        null, 3)
on conflict (menu_item_id) do update set
  label = excluded.label,
  href = excluded.href,
  icon_name = excluded.icon_name,
  grup_label = excluded.grup_label,
  urutan = excluded.urutan,
  module_id = excluded.module_id,
  parent_id = excluded.parent_id;

-- -------------------------------------------------------
-- E. Seed role_menu_access
-- Setiap role mendapat akses ke menu yang relevan.
-- SUPERADMIN tidak perlu entry (bypass di service layer),
-- tapi kita seed untuk konsistensi admin panel.
-- -------------------------------------------------------

-- Helper: generate role_menu_id sebagai 'RMA-<role_code>-<menu_code>'
-- SUPERADMIN (ROL-001) → semua 15 menu items
insert into public.role_menu_access (role_menu_id, role_id, menu_item_id, is_visible) values
  ('RMA-001-001', 'ROL-001', 'MNU-001', true),
  ('RMA-001-002', 'ROL-001', 'MNU-002', true),
  ('RMA-001-003', 'ROL-001', 'MNU-003', true),
  ('RMA-001-004', 'ROL-001', 'MNU-004', true),
  ('RMA-001-005', 'ROL-001', 'MNU-005', true),
  ('RMA-001-006', 'ROL-001', 'MNU-006', true),
  ('RMA-001-007', 'ROL-001', 'MNU-007', true),
  ('RMA-001-008', 'ROL-001', 'MNU-008', true),
  ('RMA-001-009', 'ROL-001', 'MNU-009', true),
  ('RMA-001-010', 'ROL-001', 'MNU-010', true),
  ('RMA-001-011', 'ROL-001', 'MNU-011', true),
  ('RMA-001-012', 'ROL-001', 'MNU-012', true),
  ('RMA-001-013', 'ROL-001', 'MNU-013', true),
  ('RMA-001-014', 'ROL-001', 'MNU-014', true),
  ('RMA-001-015', 'ROL-001', 'MNU-015', true),
  -- ADMIN_OPD (ROL-002) → semua kecuali Master Data dan Pengaturan
  ('RMA-002-001', 'ROL-002', 'MNU-001', true),
  ('RMA-002-002', 'ROL-002', 'MNU-002', true),
  ('RMA-002-003', 'ROL-002', 'MNU-003', true),
  ('RMA-002-004', 'ROL-002', 'MNU-004', true),
  ('RMA-002-005', 'ROL-002', 'MNU-005', true),
  ('RMA-002-006', 'ROL-002', 'MNU-006', true),
  ('RMA-002-007', 'ROL-002', 'MNU-007', true),
  ('RMA-002-008', 'ROL-002', 'MNU-008', true),
  ('RMA-002-009', 'ROL-002', 'MNU-009', true),
  ('RMA-002-010', 'ROL-002', 'MNU-010', true),
  ('RMA-002-011', 'ROL-002', 'MNU-011', true),
  ('RMA-002-012', 'ROL-002', 'MNU-012', true),
  ('RMA-002-014', 'ROL-002', 'MNU-014', true),
  -- VERIFIKATOR_BKD (ROL-003) → Dashboard, Pegawai, Usulan, Dokumen, Laporan
  ('RMA-003-001', 'ROL-003', 'MNU-001', true),
  ('RMA-003-002', 'ROL-003', 'MNU-002', true),
  ('RMA-003-011', 'ROL-003', 'MNU-011', true),
  ('RMA-003-012', 'ROL-003', 'MNU-012', true),
  ('RMA-003-014', 'ROL-003', 'MNU-014', true),
  -- APPROVER_BKD (ROL-004) → Dashboard, Pegawai, Usulan, Laporan
  ('RMA-004-001', 'ROL-004', 'MNU-001', true),
  ('RMA-004-002', 'ROL-004', 'MNU-002', true),
  ('RMA-004-011', 'ROL-004', 'MNU-011', true),
  ('RMA-004-014', 'ROL-004', 'MNU-014', true),
  -- PEGAWAI (ROL-005) → Dashboard + semua riwayat + kinerja + usulan + dokumen
  ('RMA-005-001', 'ROL-005', 'MNU-001', true),
  ('RMA-005-003', 'ROL-005', 'MNU-003', true),
  ('RMA-005-004', 'ROL-005', 'MNU-004', true),
  ('RMA-005-005', 'ROL-005', 'MNU-005', true),
  ('RMA-005-006', 'ROL-005', 'MNU-006', true),
  ('RMA-005-007', 'ROL-005', 'MNU-007', true),
  ('RMA-005-008', 'ROL-005', 'MNU-008', true),
  ('RMA-005-009', 'ROL-005', 'MNU-009', true),
  ('RMA-005-010', 'ROL-005', 'MNU-010', true),
  ('RMA-005-011', 'ROL-005', 'MNU-011', true),
  ('RMA-005-012', 'ROL-005', 'MNU-012', true)
on conflict (role_id, menu_item_id) do update set
  is_visible = excluded.is_visible;
