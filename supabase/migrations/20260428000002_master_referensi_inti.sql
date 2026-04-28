-- ============================================================
-- Migration 002: Master Referensi Inti (Chapter S)
-- 25 tabel master referensi baku lintas domain SIMPEG
-- ============================================================

-- -------------------------------------------------------
-- A. master_status_pegawai
-- -------------------------------------------------------
create table if not exists public.master_status_pegawai (
  status_pegawai_id   text        not null,
  kode_status_pegawai text        not null,
  nama_status_pegawai text        not null,
  urutan              integer     not null default 0,
  is_active           boolean     not null default true,
  keterangan          text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_master_status_pegawai        primary key (status_pegawai_id),
  constraint uq_master_status_pegawai_kode   unique (kode_status_pegawai),
  constraint ck_master_status_pegawai_id     check (trim(status_pegawai_id) <> ''),
  constraint ck_master_status_pegawai_kode   check (trim(kode_status_pegawai) <> ''),
  constraint ck_master_status_pegawai_nama   check (trim(nama_status_pegawai) <> ''),
  constraint ck_master_status_pegawai_urutan check (urutan >= 0)
);

create trigger trg_master_status_pegawai_updated_at
  before update on public.master_status_pegawai
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- B. master_kedudukan_hukum
-- -------------------------------------------------------
create table if not exists public.master_kedudukan_hukum (
  kedudukan_hukum_id   text        not null,
  kode_kedudukan_hukum text        not null,
  nama_kedudukan_hukum text        not null,
  urutan               integer     not null default 0,
  is_active            boolean     not null default true,
  keterangan           text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  created_by           text,
  updated_by           text,

  constraint pk_master_kedudukan_hukum        primary key (kedudukan_hukum_id),
  constraint uq_master_kedudukan_hukum_kode   unique (kode_kedudukan_hukum),
  constraint ck_master_kedudukan_hukum_id     check (trim(kedudukan_hukum_id) <> ''),
  constraint ck_master_kedudukan_hukum_kode   check (trim(kode_kedudukan_hukum) <> ''),
  constraint ck_master_kedudukan_hukum_nama   check (trim(nama_kedudukan_hukum) <> ''),
  constraint ck_master_kedudukan_hukum_urutan check (urutan >= 0)
);

create trigger trg_master_kedudukan_hukum_updated_at
  before update on public.master_kedudukan_hukum
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- C. master_status_kerja
-- -------------------------------------------------------
create table if not exists public.master_status_kerja (
  status_kerja_id   text        not null,
  kode_status_kerja text        not null,
  nama_status_kerja text        not null,
  urutan            integer     not null default 0,
  is_active         boolean     not null default true,
  keterangan        text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  created_by        text,
  updated_by        text,

  constraint pk_master_status_kerja        primary key (status_kerja_id),
  constraint uq_master_status_kerja_kode   unique (kode_status_kerja),
  constraint ck_master_status_kerja_id     check (trim(status_kerja_id) <> ''),
  constraint ck_master_status_kerja_kode   check (trim(kode_status_kerja) <> ''),
  constraint ck_master_status_kerja_nama   check (trim(nama_status_kerja) <> ''),
  constraint ck_master_status_kerja_urutan check (urutan >= 0)
);

create trigger trg_master_status_kerja_updated_at
  before update on public.master_status_kerja
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- D. master_opd
-- -------------------------------------------------------
create table if not exists public.master_opd (
  opd_id     text        not null,
  kode_opd   text        not null,
  nama_opd   text        not null,
  urutan     integer     not null default 0,
  is_active  boolean     not null default true,
  keterangan text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by text,
  updated_by text,

  constraint pk_master_opd        primary key (opd_id),
  constraint uq_master_opd_kode   unique (kode_opd),
  constraint ck_master_opd_id     check (trim(opd_id) <> ''),
  constraint ck_master_opd_kode   check (trim(kode_opd) <> ''),
  constraint ck_master_opd_nama   check (trim(nama_opd) <> ''),
  constraint ck_master_opd_urutan check (urutan >= 0)
);

create trigger trg_master_opd_updated_at
  before update on public.master_opd
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- E. master_unit_kerja (FK -> master_opd)
-- -------------------------------------------------------
create table if not exists public.master_unit_kerja (
  unit_kerja_id   text        not null,
  kode_unit_kerja text        not null,
  nama_unit_kerja text        not null,
  opd_id          text,
  urutan          integer     not null default 0,
  is_active       boolean     not null default true,
  keterangan      text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  created_by      text,
  updated_by      text,

  constraint pk_master_unit_kerja        primary key (unit_kerja_id),
  constraint uq_master_unit_kerja_kode   unique (kode_unit_kerja),
  constraint fk_master_unit_kerja_opd    foreign key (opd_id) references public.master_opd(opd_id) on delete restrict,
  constraint ck_master_unit_kerja_id     check (trim(unit_kerja_id) <> ''),
  constraint ck_master_unit_kerja_kode   check (trim(kode_unit_kerja) <> ''),
  constraint ck_master_unit_kerja_nama   check (trim(nama_unit_kerja) <> ''),
  constraint ck_master_unit_kerja_urutan check (urutan >= 0)
);

create index if not exists idx_master_unit_kerja_opd_id on public.master_unit_kerja(opd_id);

create trigger trg_master_unit_kerja_updated_at
  before update on public.master_unit_kerja
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- F. master_agama
-- -------------------------------------------------------
create table if not exists public.master_agama (
  agama_id   text        not null,
  kode_agama text        not null,
  nama_agama text        not null,
  urutan     integer     not null default 0,
  is_active  boolean     not null default true,
  keterangan text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by text,
  updated_by text,

  constraint pk_master_agama        primary key (agama_id),
  constraint uq_master_agama_kode   unique (kode_agama),
  constraint ck_master_agama_id     check (trim(agama_id) <> ''),
  constraint ck_master_agama_kode   check (trim(kode_agama) <> ''),
  constraint ck_master_agama_nama   check (trim(nama_agama) <> ''),
  constraint ck_master_agama_urutan check (urutan >= 0)
);

create trigger trg_master_agama_updated_at
  before update on public.master_agama
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- G. master_status_perkawinan
-- -------------------------------------------------------
create table if not exists public.master_status_perkawinan (
  status_perkawinan_id   text        not null,
  kode_status_perkawinan text        not null,
  nama_status_perkawinan text        not null,
  urutan                 integer     not null default 0,
  is_active              boolean     not null default true,
  keterangan             text,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now(),
  created_by             text,
  updated_by             text,

  constraint pk_master_status_perkawinan        primary key (status_perkawinan_id),
  constraint uq_master_status_perkawinan_kode   unique (kode_status_perkawinan),
  constraint ck_master_status_perkawinan_id     check (trim(status_perkawinan_id) <> ''),
  constraint ck_master_status_perkawinan_kode   check (trim(kode_status_perkawinan) <> ''),
  constraint ck_master_status_perkawinan_nama   check (trim(nama_status_perkawinan) <> ''),
  constraint ck_master_status_perkawinan_urutan check (urutan >= 0)
);

create trigger trg_master_status_perkawinan_updated_at
  before update on public.master_status_perkawinan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- H. master_status_keluarga
-- -------------------------------------------------------
create table if not exists public.master_status_keluarga (
  status_keluarga_id   text        not null,
  kode_status_keluarga text        not null,
  nama_status_keluarga text        not null,
  urutan               integer     not null default 0,
  is_active            boolean     not null default true,
  keterangan           text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  created_by           text,
  updated_by           text,

  constraint pk_master_status_keluarga        primary key (status_keluarga_id),
  constraint uq_master_status_keluarga_kode   unique (kode_status_keluarga),
  constraint ck_master_status_keluarga_id     check (trim(status_keluarga_id) <> ''),
  constraint ck_master_status_keluarga_kode   check (trim(kode_status_keluarga) <> ''),
  constraint ck_master_status_keluarga_nama   check (trim(nama_status_keluarga) <> ''),
  constraint ck_master_status_keluarga_urutan check (urutan >= 0)
);

create trigger trg_master_status_keluarga_updated_at
  before update on public.master_status_keluarga
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- I. master_tingkat_pendidikan
-- -------------------------------------------------------
create table if not exists public.master_tingkat_pendidikan (
  tingkat_pendidikan_id   text        not null,
  kode_tingkat_pendidikan text        not null,
  nama_tingkat_pendidikan text        not null,
  urutan                  integer     not null default 0,
  is_active               boolean     not null default true,
  keterangan              text,
  created_at              timestamptz not null default now(),
  updated_at              timestamptz not null default now(),
  created_by              text,
  updated_by              text,

  constraint pk_master_tingkat_pendidikan        primary key (tingkat_pendidikan_id),
  constraint uq_master_tingkat_pendidikan_kode   unique (kode_tingkat_pendidikan),
  constraint ck_master_tingkat_pendidikan_id     check (trim(tingkat_pendidikan_id) <> ''),
  constraint ck_master_tingkat_pendidikan_kode   check (trim(kode_tingkat_pendidikan) <> ''),
  constraint ck_master_tingkat_pendidikan_nama   check (trim(nama_tingkat_pendidikan) <> ''),
  constraint ck_master_tingkat_pendidikan_urutan check (urutan >= 0)
);

create trigger trg_master_tingkat_pendidikan_updated_at
  before update on public.master_tingkat_pendidikan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- K. master_status_studi
-- -------------------------------------------------------
create table if not exists public.master_status_studi (
  status_studi_id   text        not null,
  kode_status_studi text        not null,
  nama_status_studi text        not null,
  urutan            integer     not null default 0,
  is_active         boolean     not null default true,
  keterangan        text,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  created_by        text,
  updated_by        text,

  constraint pk_master_status_studi        primary key (status_studi_id),
  constraint uq_master_status_studi_kode   unique (kode_status_studi),
  constraint ck_master_status_studi_id     check (trim(status_studi_id) <> ''),
  constraint ck_master_status_studi_kode   check (trim(kode_status_studi) <> ''),
  constraint ck_master_status_studi_nama   check (trim(nama_status_studi) <> ''),
  constraint ck_master_status_studi_urutan check (urutan >= 0)
);

create trigger trg_master_status_studi_updated_at
  before update on public.master_status_studi
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- L. master_jenis_jabatan
-- -------------------------------------------------------
create table if not exists public.master_jenis_jabatan (
  jenis_jabatan_id   text        not null,
  kode_jenis_jabatan text        not null,
  nama_jenis_jabatan text        not null,
  urutan             integer     not null default 0,
  is_active          boolean     not null default true,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_master_jenis_jabatan        primary key (jenis_jabatan_id),
  constraint uq_master_jenis_jabatan_kode   unique (kode_jenis_jabatan),
  constraint ck_master_jenis_jabatan_id     check (trim(jenis_jabatan_id) <> ''),
  constraint ck_master_jenis_jabatan_kode   check (trim(kode_jenis_jabatan) <> ''),
  constraint ck_master_jenis_jabatan_nama   check (trim(nama_jenis_jabatan) <> ''),
  constraint ck_master_jenis_jabatan_urutan check (urutan >= 0)
);

create trigger trg_master_jenis_jabatan_updated_at
  before update on public.master_jenis_jabatan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- N. master_eselon
-- -------------------------------------------------------
create table if not exists public.master_eselon (
  eselon_id   text        not null,
  kode_eselon text        not null,
  nama_eselon text        not null,
  urutan      integer     not null default 0,
  is_active   boolean     not null default true,
  keterangan  text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  created_by  text,
  updated_by  text,

  constraint pk_master_eselon        primary key (eselon_id),
  constraint uq_master_eselon_kode   unique (kode_eselon),
  constraint ck_master_eselon_id     check (trim(eselon_id) <> ''),
  constraint ck_master_eselon_kode   check (trim(kode_eselon) <> ''),
  constraint ck_master_eselon_nama   check (trim(nama_eselon) <> ''),
  constraint ck_master_eselon_urutan check (urutan >= 0)
);

create trigger trg_master_eselon_updated_at
  before update on public.master_eselon
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- M. master_jabatan (FK -> master_jenis_jabatan, master_eselon)
-- -------------------------------------------------------
create table if not exists public.master_jabatan (
  jabatan_id       text        not null,
  kode_jabatan     text        not null,
  nama_jabatan     text        not null,
  jenis_jabatan_id text,
  eselon_id        text,
  urutan           integer     not null default 0,
  is_active        boolean     not null default true,
  keterangan       text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  created_by       text,
  updated_by       text,

  constraint pk_master_jabatan              primary key (jabatan_id),
  constraint uq_master_jabatan_kode         unique (kode_jabatan),
  constraint fk_master_jabatan_jenis        foreign key (jenis_jabatan_id) references public.master_jenis_jabatan(jenis_jabatan_id) on delete restrict,
  constraint fk_master_jabatan_eselon       foreign key (eselon_id) references public.master_eselon(eselon_id) on delete restrict,
  constraint ck_master_jabatan_id           check (trim(jabatan_id) <> ''),
  constraint ck_master_jabatan_kode         check (trim(kode_jabatan) <> ''),
  constraint ck_master_jabatan_nama         check (trim(nama_jabatan) <> ''),
  constraint ck_master_jabatan_urutan       check (urutan >= 0)
);

create index if not exists idx_master_jabatan_jenis on public.master_jabatan(jenis_jabatan_id);
create index if not exists idx_master_jabatan_eselon on public.master_jabatan(eselon_id);

create trigger trg_master_jabatan_updated_at
  before update on public.master_jabatan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- O. master_pangkat
-- -------------------------------------------------------
create table if not exists public.master_pangkat (
  pangkat_id   text        not null,
  kode_pangkat text        not null,
  nama_pangkat text        not null,
  urutan       integer     not null default 0,
  is_active    boolean     not null default true,
  keterangan   text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  created_by   text,
  updated_by   text,

  constraint pk_master_pangkat        primary key (pangkat_id),
  constraint uq_master_pangkat_kode   unique (kode_pangkat),
  constraint ck_master_pangkat_id     check (trim(pangkat_id) <> ''),
  constraint ck_master_pangkat_kode   check (trim(kode_pangkat) <> ''),
  constraint ck_master_pangkat_nama   check (trim(nama_pangkat) <> ''),
  constraint ck_master_pangkat_urutan check (urutan >= 0)
);

create trigger trg_master_pangkat_updated_at
  before update on public.master_pangkat
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- P. master_golongan
-- -------------------------------------------------------
create table if not exists public.master_golongan (
  golongan_id   text        not null,
  kode_golongan text        not null,
  nama_golongan text        not null,
  urutan        integer     not null default 0,
  is_active     boolean     not null default true,
  keterangan    text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  created_by    text,
  updated_by    text,

  constraint pk_master_golongan        primary key (golongan_id),
  constraint uq_master_golongan_kode   unique (kode_golongan),
  constraint ck_master_golongan_id     check (trim(golongan_id) <> ''),
  constraint ck_master_golongan_kode   check (trim(kode_golongan) <> ''),
  constraint ck_master_golongan_nama   check (trim(nama_golongan) <> ''),
  constraint ck_master_golongan_urutan check (urutan >= 0)
);

create trigger trg_master_golongan_updated_at
  before update on public.master_golongan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- Q. master_jenis_kenaikan_pangkat
-- -------------------------------------------------------
create table if not exists public.master_jenis_kenaikan_pangkat (
  jenis_kenaikan_id   text        not null,
  kode_jenis_kenaikan text        not null,
  nama_jenis_kenaikan text        not null,
  urutan              integer     not null default 0,
  is_active           boolean     not null default true,
  keterangan          text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_master_jenis_kenaikan_pangkat        primary key (jenis_kenaikan_id),
  constraint uq_master_jenis_kenaikan_pangkat_kode   unique (kode_jenis_kenaikan),
  constraint ck_master_jenis_kenaikan_pangkat_id     check (trim(jenis_kenaikan_id) <> ''),
  constraint ck_master_jenis_kenaikan_pangkat_kode   check (trim(kode_jenis_kenaikan) <> ''),
  constraint ck_master_jenis_kenaikan_pangkat_nama   check (trim(nama_jenis_kenaikan) <> ''),
  constraint ck_master_jenis_kenaikan_pangkat_urutan check (urutan >= 0)
);

create trigger trg_master_jenis_kenaikan_pangkat_updated_at
  before update on public.master_jenis_kenaikan_pangkat
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- R. master_jenis_pak
-- -------------------------------------------------------
create table if not exists public.master_jenis_pak (
  jenis_pak_id   text        not null,
  kode_jenis_pak text        not null,
  nama_jenis_pak text        not null,
  urutan         integer     not null default 0,
  is_active      boolean     not null default true,
  keterangan     text,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  created_by     text,
  updated_by     text,

  constraint pk_master_jenis_pak        primary key (jenis_pak_id),
  constraint uq_master_jenis_pak_kode   unique (kode_jenis_pak),
  constraint ck_master_jenis_pak_id     check (trim(jenis_pak_id) <> ''),
  constraint ck_master_jenis_pak_kode   check (trim(kode_jenis_pak) <> ''),
  constraint ck_master_jenis_pak_nama   check (trim(nama_jenis_pak) <> ''),
  constraint ck_master_jenis_pak_urutan check (urutan >= 0)
);

create trigger trg_master_jenis_pak_updated_at
  before update on public.master_jenis_pak
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- S. master_status_dokumen
-- -------------------------------------------------------
create table if not exists public.master_status_dokumen (
  status_dokumen_id   text        not null,
  kode_status_dokumen text        not null,
  nama_status_dokumen text        not null,
  is_final            boolean     not null default false,
  urutan              integer     not null default 0,
  is_active           boolean     not null default true,
  keterangan          text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_master_status_dokumen        primary key (status_dokumen_id),
  constraint uq_master_status_dokumen_kode   unique (kode_status_dokumen),
  constraint ck_master_status_dokumen_id     check (trim(status_dokumen_id) <> ''),
  constraint ck_master_status_dokumen_kode   check (trim(kode_status_dokumen) <> ''),
  constraint ck_master_status_dokumen_nama   check (trim(nama_status_dokumen) <> ''),
  constraint ck_master_status_dokumen_urutan check (urutan >= 0)
);

create trigger trg_master_status_dokumen_updated_at
  before update on public.master_status_dokumen
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- T. master_tingkat_hukuman
-- -------------------------------------------------------
create table if not exists public.master_tingkat_hukuman (
  tingkat_hukuman_id   text        not null,
  kode_tingkat_hukuman text        not null,
  nama_tingkat_hukuman text        not null,
  urutan               integer     not null default 0,
  is_active            boolean     not null default true,
  keterangan           text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  created_by           text,
  updated_by           text,

  constraint pk_master_tingkat_hukuman        primary key (tingkat_hukuman_id),
  constraint uq_master_tingkat_hukuman_kode   unique (kode_tingkat_hukuman),
  constraint ck_master_tingkat_hukuman_id     check (trim(tingkat_hukuman_id) <> ''),
  constraint ck_master_tingkat_hukuman_kode   check (trim(kode_tingkat_hukuman) <> ''),
  constraint ck_master_tingkat_hukuman_nama   check (trim(nama_tingkat_hukuman) <> ''),
  constraint ck_master_tingkat_hukuman_urutan check (urutan >= 0)
);

create trigger trg_master_tingkat_hukuman_updated_at
  before update on public.master_tingkat_hukuman
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- U. master_jenis_hukuman (FK -> master_tingkat_hukuman)
-- -------------------------------------------------------
create table if not exists public.master_jenis_hukuman (
  jenis_hukuman_id   text        not null,
  kode_jenis_hukuman text        not null,
  nama_jenis_hukuman text        not null,
  tingkat_hukuman_id text,
  urutan             integer     not null default 0,
  is_active          boolean     not null default true,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_master_jenis_hukuman        primary key (jenis_hukuman_id),
  constraint uq_master_jenis_hukuman_kode   unique (kode_jenis_hukuman),
  constraint fk_master_jenis_hukuman_tingkat foreign key (tingkat_hukuman_id) references public.master_tingkat_hukuman(tingkat_hukuman_id) on delete restrict,
  constraint ck_master_jenis_hukuman_id     check (trim(jenis_hukuman_id) <> ''),
  constraint ck_master_jenis_hukuman_kode   check (trim(kode_jenis_hukuman) <> ''),
  constraint ck_master_jenis_hukuman_nama   check (trim(nama_jenis_hukuman) <> ''),
  constraint ck_master_jenis_hukuman_urutan check (urutan >= 0)
);

create index if not exists idx_master_jenis_hukuman_tingkat on public.master_jenis_hukuman(tingkat_hukuman_id);

create trigger trg_master_jenis_hukuman_updated_at
  before update on public.master_jenis_hukuman
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- V. master_status_proses_disiplin
-- -------------------------------------------------------
create table if not exists public.master_status_proses_disiplin (
  status_proses_id   text        not null,
  kode_status_proses text        not null,
  nama_status_proses text        not null,
  urutan             integer     not null default 0,
  is_active          boolean     not null default true,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_master_status_proses_disiplin        primary key (status_proses_id),
  constraint uq_master_status_proses_disiplin_kode   unique (kode_status_proses),
  constraint ck_master_status_proses_disiplin_id     check (trim(status_proses_id) <> ''),
  constraint ck_master_status_proses_disiplin_kode   check (trim(kode_status_proses) <> ''),
  constraint ck_master_status_proses_disiplin_nama   check (trim(nama_status_proses) <> ''),
  constraint ck_master_status_proses_disiplin_urutan check (urutan >= 0)
);

create trigger trg_master_status_proses_disiplin_updated_at
  before update on public.master_status_proses_disiplin
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- W. master_predikat_skp
-- -------------------------------------------------------
create table if not exists public.master_predikat_skp (
  predikat_id    text           not null,
  kode_predikat  text           not null,
  nama_predikat  text           not null,
  nilai_minimum  numeric(6,2),
  nilai_maksimum numeric(6,2),
  urutan         integer        not null default 0,
  is_active      boolean        not null default true,
  keterangan     text,
  created_at     timestamptz    not null default now(),
  updated_at     timestamptz    not null default now(),
  created_by     text,
  updated_by     text,

  constraint pk_master_predikat_skp        primary key (predikat_id),
  constraint uq_master_predikat_skp_kode   unique (kode_predikat),
  constraint ck_master_predikat_skp_id     check (trim(predikat_id) <> ''),
  constraint ck_master_predikat_skp_kode   check (trim(kode_predikat) <> ''),
  constraint ck_master_predikat_skp_nama   check (trim(nama_predikat) <> ''),
  constraint ck_master_predikat_skp_urutan check (urutan >= 0)
);

create trigger trg_master_predikat_skp_updated_at
  before update on public.master_predikat_skp
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- X. master_jenjang_skp
-- -------------------------------------------------------
create table if not exists public.master_jenjang_skp (
  jenjang_id   text        not null,
  kode_jenjang text        not null,
  nama_jenjang text        not null,
  urutan       integer     not null default 0,
  is_active    boolean     not null default true,
  keterangan   text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  created_by   text,
  updated_by   text,

  constraint pk_master_jenjang_skp        primary key (jenjang_id),
  constraint uq_master_jenjang_skp_kode   unique (kode_jenjang),
  constraint ck_master_jenjang_skp_id     check (trim(jenjang_id) <> ''),
  constraint ck_master_jenjang_skp_kode   check (trim(kode_jenjang) <> ''),
  constraint ck_master_jenjang_skp_nama   check (trim(nama_jenjang) <> ''),
  constraint ck_master_jenjang_skp_urutan check (urutan >= 0)
);

create trigger trg_master_jenjang_skp_updated_at
  before update on public.master_jenjang_skp
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- Y. master_jenis_dokumen
-- -------------------------------------------------------
create table if not exists public.master_jenis_dokumen (
  jenis_dokumen_id      text        not null,
  kode_jenis_dokumen    text        not null,
  nama_jenis_dokumen    text        not null,
  modul_sumber_default  text,
  is_wajib              boolean     not null default false,
  urutan                integer     not null default 0,
  is_active             boolean     not null default true,
  keterangan            text,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),
  created_by            text,
  updated_by            text,

  constraint pk_master_jenis_dokumen        primary key (jenis_dokumen_id),
  constraint uq_master_jenis_dokumen_kode   unique (kode_jenis_dokumen),
  constraint ck_master_jenis_dokumen_id     check (trim(jenis_dokumen_id) <> ''),
  constraint ck_master_jenis_dokumen_kode   check (trim(kode_jenis_dokumen) <> ''),
  constraint ck_master_jenis_dokumen_nama   check (trim(nama_jenis_dokumen) <> ''),
  constraint ck_master_jenis_dokumen_urutan check (urutan >= 0)
);

create trigger trg_master_jenis_dokumen_updated_at
  before update on public.master_jenis_dokumen
  for each row execute function public.tg_set_updated_at();
