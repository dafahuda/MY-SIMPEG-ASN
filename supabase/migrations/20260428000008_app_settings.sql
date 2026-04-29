-- ============================================================
-- Migration 008: App Settings (Fase 8 — Dynamic Architecture)
-- Tabel key-value untuk branding, konfigurasi instansi, dan
-- pengaturan aplikasi lainnya.
-- ============================================================
-- Akses:
--   BACA  → semua user (termasuk halaman login / anon)
--   TULIS → hanya SUPERADMIN (via service_role / server action)
-- ============================================================

-- -------------------------------------------------------
-- A. Tabel app_settings
-- -------------------------------------------------------

create table if not exists public.app_settings (
  setting_id    text        not null,
  setting_key   text        not null,
  setting_value text,
  setting_type  text        not null default 'STRING',
  kategori      text        not null default 'GENERAL',
  label         text        not null,
  deskripsi     text,
  urutan        integer     not null default 0,
  is_public     boolean     not null default false,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  created_by    text,
  updated_by    text,

  constraint pk_app_settings        primary key (setting_id),
  constraint uq_app_settings_key    unique (setting_key),
  constraint ck_app_settings_id     check (trim(setting_id) <> ''),
  constraint ck_app_settings_key    check (trim(setting_key) <> ''),
  constraint ck_app_settings_label  check (trim(label) <> ''),
  constraint ck_app_settings_urutan check (urutan >= 0),
  constraint ck_app_settings_type   check (setting_type in (
    'STRING', 'TEXT', 'NUMBER', 'BOOLEAN', 'JSON', 'IMAGE_URL', 'COLOR'
  ))
);

-- -------------------------------------------------------
-- B. Trigger auto-update updated_at
-- -------------------------------------------------------

create trigger trg_app_settings_updated_at
  before update on public.app_settings
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- C. Index untuk query by kategori
-- -------------------------------------------------------

create index if not exists idx_app_settings_kategori
  on public.app_settings(kategori);

-- -------------------------------------------------------
-- D. Row Level Security
-- -------------------------------------------------------

alter table public.app_settings enable row level security;

-- Setting publik (is_public = true) bisa dibaca semua orang
-- termasuk halaman login (anon) — untuk branding, logo, nama app
create policy "Public settings readable by everyone"
  on public.app_settings
  for select
  to anon, authenticated
  using (is_public = true);

-- Setting non-publik (is_public = false) hanya bisa dibaca user yang login
-- contoh: NIP kepala, kode satker
create policy "Private settings readable by authenticated users"
  on public.app_settings
  for select
  to authenticated
  using (is_public = false);

-- INSERT/UPDATE/DELETE hanya via service_role (backend/admin).
-- Tidak ada policy untuk anon/authenticated write.
-- Semua write dilakukan via server action yang menggunakan
-- service_role client atau via Supabase Dashboard.

-- -------------------------------------------------------
-- E. Seed data default
-- -------------------------------------------------------

insert into public.app_settings
  (setting_id, setting_key, setting_value, setting_type, kategori, label, deskripsi, urutan, is_public)
values
  -- BRANDING (tampil di UI untuk semua user)
  ('SET-001', 'app.name',          'SIMPEG ASN',                                'STRING',    'BRANDING', 'Nama Aplikasi',      'Judul yang tampil di header, sidebar, dan title bar',  1, true),
  ('SET-002', 'app.description',   'Sistem Informasi Manajemen Pegawai ASN',    'STRING',    'BRANDING', 'Deskripsi Aplikasi', 'Subtitle atau tagline aplikasi',                       2, true),
  ('SET-003', 'app.logo_url',      '/images/logo.png',                          'IMAGE_URL', 'BRANDING', 'Logo Instansi',      'URL logo yang tampil di sidebar dan halaman login',    3, true),
  ('SET-004', 'app.favicon_url',   '/favicon.ico',                              'IMAGE_URL', 'BRANDING', 'Favicon',            'Icon yang tampil di tab browser',                      4, true),
  ('SET-005', 'app.primary_color', '#1e40af',                                   'COLOR',     'BRANDING', 'Warna Utama',        'Warna tema utama aplikasi',                            5, true),
  ('SET-006', 'app.footer_text',   '© 2025 Pusdaya. Hak cipta dilindungi.',     'STRING',    'BRANDING', 'Teks Footer',        'Teks copyright yang tampil di footer halaman',         6, true),
  ('SET-007', 'app.login_banner',  '',                                          'TEXT',      'BRANDING', 'Banner Login',       'Pesan atau pengumuman yang tampil di halaman login',   7, true),

  -- INSTANSI (identitas organisasi)
  ('SET-008', 'inst.nama',         'Pusat Pemberdayaan Bahasa dan Sastra',       'STRING',    'INSTANSI', 'Nama Instansi',      'Nama lengkap instansi/organisasi',                     1, true),
  ('SET-009', 'inst.alamat',       '',                                           'TEXT',      'INSTANSI', 'Alamat Instansi',    'Alamat lengkap kantor',                                2, true),
  ('SET-010', 'inst.telepon',      '',                                           'STRING',    'INSTANSI', 'Telepon',            'Nomor telepon kantor',                                 3, true),
  ('SET-011', 'inst.email',        '',                                           'STRING',    'INSTANSI', 'Email',              'Email resmi instansi',                                 4, true),
  ('SET-012', 'inst.website',      '',                                           'STRING',    'INSTANSI', 'Website',            'URL website resmi instansi',                           5, true),
  ('SET-013', 'inst.kode_satker',  '',                                           'STRING',    'INSTANSI', 'Kode Satuan Kerja',  'Kode satker untuk keperluan laporan ASN',              6, false),
  ('SET-014', 'inst.kode_bkn',     '',                                           'STRING',    'INSTANSI', 'Kode Instansi BKN',  'Kode instansi di sistem BKN (untuk integrasi)',        7, false),
  ('SET-015', 'inst.kepala_nama',  '',                                           'STRING',    'INSTANSI', 'Nama Kepala',        'Nama pimpinan instansi',                               8, false),
  ('SET-016', 'inst.kepala_nip',   '',                                           'STRING',    'INSTANSI', 'NIP Kepala',         'NIP pimpinan instansi',                                9, false);
