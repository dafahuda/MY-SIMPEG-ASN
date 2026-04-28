-- ============================================================
-- Migration 003: Master Workflow (Chapter T)
-- 4 tabel master workflow untuk usulan, approval, dan audit
-- ============================================================

-- -------------------------------------------------------
-- A. master_jenis_usulan
-- -------------------------------------------------------
create table if not exists public.master_jenis_usulan (
  jenis_usulan_id      text        not null,
  kode_jenis_usulan    text        not null,
  nama_jenis_usulan    text        not null,
  modul_sumber_default text,
  requires_approval    boolean     not null default true,
  urutan               integer     not null default 0,
  is_active            boolean     not null default true,
  keterangan           text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  created_by           text,
  updated_by           text,

  constraint pk_master_jenis_usulan        primary key (jenis_usulan_id),
  constraint uq_master_jenis_usulan_kode   unique (kode_jenis_usulan),
  constraint ck_master_jenis_usulan_id     check (trim(jenis_usulan_id) <> ''),
  constraint ck_master_jenis_usulan_kode   check (trim(kode_jenis_usulan) <> ''),
  constraint ck_master_jenis_usulan_nama   check (trim(nama_jenis_usulan) <> ''),
  constraint ck_master_jenis_usulan_urutan check (urutan >= 0)
);

create trigger trg_master_jenis_usulan_updated_at
  before update on public.master_jenis_usulan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- B. master_status_usulan
-- -------------------------------------------------------
create table if not exists public.master_status_usulan (
  status_usulan_id   text        not null,
  kode_status_usulan text        not null,
  nama_status_usulan text        not null,
  is_final           boolean     not null default false,
  urutan             integer     not null default 0,
  is_active          boolean     not null default true,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_master_status_usulan        primary key (status_usulan_id),
  constraint uq_master_status_usulan_kode   unique (kode_status_usulan),
  constraint ck_master_status_usulan_id     check (trim(status_usulan_id) <> ''),
  constraint ck_master_status_usulan_kode   check (trim(kode_status_usulan) <> ''),
  constraint ck_master_status_usulan_nama   check (trim(nama_status_usulan) <> ''),
  constraint ck_master_status_usulan_urutan check (urutan >= 0)
);

create trigger trg_master_status_usulan_updated_at
  before update on public.master_status_usulan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- C. master_aksi_approval
-- -------------------------------------------------------
create table if not exists public.master_aksi_approval (
  aksi_approval_id   text        not null,
  kode_aksi_approval text        not null,
  nama_aksi_approval text        not null,
  urutan             integer     not null default 0,
  is_active          boolean     not null default true,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_master_aksi_approval        primary key (aksi_approval_id),
  constraint uq_master_aksi_approval_kode   unique (kode_aksi_approval),
  constraint ck_master_aksi_approval_id     check (trim(aksi_approval_id) <> ''),
  constraint ck_master_aksi_approval_kode   check (trim(kode_aksi_approval) <> ''),
  constraint ck_master_aksi_approval_nama   check (trim(nama_aksi_approval) <> ''),
  constraint ck_master_aksi_approval_urutan check (urutan >= 0)
);

create trigger trg_master_aksi_approval_updated_at
  before update on public.master_aksi_approval
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- D. master_aksi_audit
-- -------------------------------------------------------
create table if not exists public.master_aksi_audit (
  aksi_audit_id  text        not null,
  kode_aksi_audit text       not null,
  nama_aksi_audit text       not null,
  kategori_aksi  text,
  urutan         integer     not null default 0,
  is_active      boolean     not null default true,
  keterangan     text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  created_by     text,
  updated_by     text,

  constraint pk_master_aksi_audit        primary key (aksi_audit_id),
  constraint uq_master_aksi_audit_kode   unique (kode_aksi_audit),
  constraint ck_master_aksi_audit_id     check (trim(aksi_audit_id) <> ''),
  constraint ck_master_aksi_audit_kode   check (trim(kode_aksi_audit) <> ''),
  constraint ck_master_aksi_audit_nama   check (trim(nama_aksi_audit) <> ''),
  constraint ck_master_aksi_audit_urutan check (urutan >= 0)
);

create trigger trg_master_aksi_audit_updated_at
  before update on public.master_aksi_audit
  for each row execute function public.tg_set_updated_at();
