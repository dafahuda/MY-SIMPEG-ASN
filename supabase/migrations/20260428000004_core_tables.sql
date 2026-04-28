-- ============================================================
-- Migration 004: Core Tables (Chapter A-B)
-- pegawai (master employee) + pegawai_pribadi (1:1 biodata)
-- ============================================================

-- -------------------------------------------------------
-- A. pegawai
-- -------------------------------------------------------
create table if not exists public.pegawai (
  pegawai_id         text        not null,
  nip                text        not null,
  nama_lengkap       text        not null,
  status_pegawai_id  text        not null,
  kedudukan_hukum_id text,
  status_kerja_id    text,
  unit_kerja_id      text,
  opd_id             text,
  tmt_cpns           date,
  tmt_pns            date,
  tmt_pensiun        date,
  tmt_pensiun_source text,
  no_karpeg          text,
  no_taspen          text,
  no_karis_karsu     text,
  is_active          boolean     not null default true,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_pegawai                    primary key (pegawai_id),
  constraint uq_pegawai_nip               unique (nip),
  constraint fk_pegawai_status_pegawai     foreign key (status_pegawai_id) references public.master_status_pegawai(status_pegawai_id) on delete restrict,
  constraint fk_pegawai_kedudukan_hukum    foreign key (kedudukan_hukum_id) references public.master_kedudukan_hukum(kedudukan_hukum_id) on delete restrict,
  constraint fk_pegawai_status_kerja       foreign key (status_kerja_id) references public.master_status_kerja(status_kerja_id) on delete restrict,
  constraint fk_pegawai_unit_kerja         foreign key (unit_kerja_id) references public.master_unit_kerja(unit_kerja_id) on delete restrict,
  constraint fk_pegawai_opd                foreign key (opd_id) references public.master_opd(opd_id) on delete restrict,
  constraint ck_pegawai_id                 check (trim(pegawai_id) <> ''),
  constraint ck_pegawai_nip                check (trim(nip) <> ''),
  constraint ck_pegawai_nama               check (trim(nama_lengkap) <> ''),
  constraint ck_pegawai_tmt_pns_after_cpns check (tmt_pns is null or tmt_cpns is null or tmt_pns >= tmt_cpns)
);

create index if not exists idx_pegawai_status_pegawai_id on public.pegawai(status_pegawai_id);
create index if not exists idx_pegawai_opd_unit          on public.pegawai(opd_id, unit_kerja_id);
create index if not exists idx_pegawai_is_active         on public.pegawai(is_active);

create trigger trg_pegawai_updated_at
  before update on public.pegawai
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- B. pegawai_pribadi (1:1 extension)
-- -------------------------------------------------------
create table if not exists public.pegawai_pribadi (
  pribadi_id           text        not null,
  pegawai_id           text        not null,
  foto_url             text,
  tempat_lahir         text,
  tanggal_lahir        date,
  jenis_kelamin        text,
  agama_id             text,
  status_perkawinan_id text,
  alamat_domisili      text,
  alamat_ktp           text,
  no_hp                text,
  email_pribadi        text,
  nik                  text,
  npwp                 text,
  no_bpjs              text,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  created_by           text,
  updated_by           text,

  constraint pk_pegawai_pribadi                    primary key (pribadi_id),
  constraint uq_pegawai_pribadi_pegawai_id         unique (pegawai_id),
  constraint fk_pegawai_pribadi_pegawai             foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_pegawai_pribadi_agama               foreign key (agama_id) references public.master_agama(agama_id) on delete restrict,
  constraint fk_pegawai_pribadi_status_perkawinan   foreign key (status_perkawinan_id) references public.master_status_perkawinan(status_perkawinan_id) on delete restrict,
  constraint ck_pegawai_pribadi_id                  check (trim(pribadi_id) <> ''),
  constraint ck_pegawai_pribadi_pegawai_id          check (trim(pegawai_id) <> ''),
  constraint ck_pegawai_pribadi_jenis_kelamin       check (jenis_kelamin is null or jenis_kelamin in ('L', 'P'))
);

create index if not exists idx_pegawai_pribadi_agama_id             on public.pegawai_pribadi(agama_id);
create index if not exists idx_pegawai_pribadi_status_perkawinan_id on public.pegawai_pribadi(status_perkawinan_id);

create trigger trg_pegawai_pribadi_updated_at
  before update on public.pegawai_pribadi
  for each row execute function public.tg_set_updated_at();
