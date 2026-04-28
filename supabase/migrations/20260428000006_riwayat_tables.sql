-- ============================================================
-- Migration 006: Riwayat / History Tables (Chapter C-L)
-- 10 tabel riwayat pegawai
-- ============================================================

-- -------------------------------------------------------
-- C. riwayat_jabatan
-- -------------------------------------------------------
create table if not exists public.riwayat_jabatan (
  riwayat_jabatan_id text        not null,
  pegawai_id         text        not null,
  jenis_jabatan_id   text,
  jabatan_id         text        not null,
  eselon_id          text,
  kelas_jabatan      integer,
  unit_kerja_id      text,
  opd_id             text,
  tmt_jabatan        date        not null,
  tmt_akhir_jabatan  date,
  no_sk              text,
  tanggal_sk         date,
  pejabat_penetap    text,
  is_plt             boolean,
  is_plh             boolean,
  is_definitif       boolean,
  is_current         boolean     not null,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_riwayat_jabatan             primary key (riwayat_jabatan_id),
  constraint fk_riwayat_jabatan_pegawai     foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_jabatan_jenis       foreign key (jenis_jabatan_id) references public.master_jenis_jabatan(jenis_jabatan_id) on delete restrict,
  constraint fk_riwayat_jabatan_jabatan     foreign key (jabatan_id) references public.master_jabatan(jabatan_id) on delete restrict,
  constraint fk_riwayat_jabatan_eselon      foreign key (eselon_id) references public.master_eselon(eselon_id) on delete restrict,
  constraint fk_riwayat_jabatan_unit_kerja  foreign key (unit_kerja_id) references public.master_unit_kerja(unit_kerja_id) on delete restrict,
  constraint fk_riwayat_jabatan_opd         foreign key (opd_id) references public.master_opd(opd_id) on delete restrict,
  constraint ck_riwayat_jabatan_id          check (trim(riwayat_jabatan_id) <> ''),
  constraint ck_riwayat_jabatan_pegawai     check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_jabatan_jabatan     check (trim(jabatan_id) <> ''),
  constraint ck_riwayat_jabatan_tmt_akhir   check (tmt_akhir_jabatan is null or tmt_akhir_jabatan >= tmt_jabatan)
);

-- Satu jabatan aktif per pegawai
create unique index if not exists uq_riwayat_jabatan_current_per_pegawai
  on public.riwayat_jabatan(pegawai_id) where is_current;

create index if not exists idx_riwayat_jabatan_pegawai_id       on public.riwayat_jabatan(pegawai_id);
create index if not exists idx_riwayat_jabatan_jenis_jabatan_id on public.riwayat_jabatan(jenis_jabatan_id);
create index if not exists idx_riwayat_jabatan_jabatan_id       on public.riwayat_jabatan(jabatan_id);
create index if not exists idx_riwayat_jabatan_eselon_id        on public.riwayat_jabatan(eselon_id);
create index if not exists idx_riwayat_jabatan_unit_kerja_id    on public.riwayat_jabatan(unit_kerja_id);
create index if not exists idx_riwayat_jabatan_opd_id           on public.riwayat_jabatan(opd_id);

create trigger trg_riwayat_jabatan_updated_at
  before update on public.riwayat_jabatan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- D. riwayat_pangkat_golongan
-- -------------------------------------------------------
create table if not exists public.riwayat_pangkat_golongan (
  riwayat_pangkat_id text        not null,
  pegawai_id         text        not null,
  pangkat_id         text        not null,
  golongan_id        text        not null,
  tmt_pangkat        date        not null,
  masa_kerja_tahun   integer,
  masa_kerja_bulan   integer,
  masa_kerja_source  text,
  no_sk              text,
  tanggal_sk         date,
  pejabat_penetap    text,
  jenis_kenaikan_id  text,
  gaji_pokok         numeric,
  is_current         boolean     not null,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_riwayat_pangkat_golongan              primary key (riwayat_pangkat_id),
  constraint fk_riwayat_pangkat_pegawai               foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_pangkat_pangkat               foreign key (pangkat_id) references public.master_pangkat(pangkat_id) on delete restrict,
  constraint fk_riwayat_pangkat_golongan              foreign key (golongan_id) references public.master_golongan(golongan_id) on delete restrict,
  constraint fk_riwayat_pangkat_jenis_kenaikan        foreign key (jenis_kenaikan_id) references public.master_jenis_kenaikan_pangkat(jenis_kenaikan_id) on delete restrict,
  constraint ck_riwayat_pangkat_id                    check (trim(riwayat_pangkat_id) <> ''),
  constraint ck_riwayat_pangkat_pegawai               check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_pangkat_pangkat               check (trim(pangkat_id) <> ''),
  constraint ck_riwayat_pangkat_golongan              check (trim(golongan_id) <> ''),
  constraint ck_riwayat_pangkat_masa_kerja_tahun      check (masa_kerja_tahun is null or masa_kerja_tahun >= 0),
  constraint ck_riwayat_pangkat_masa_kerja_bulan      check (masa_kerja_bulan is null or (masa_kerja_bulan >= 0 and masa_kerja_bulan <= 11))
);

create unique index if not exists uq_riwayat_pangkat_golongan_current_per_pegawai
  on public.riwayat_pangkat_golongan(pegawai_id) where is_current;

create index if not exists idx_riwayat_pangkat_pegawai_id       on public.riwayat_pangkat_golongan(pegawai_id);
create index if not exists idx_riwayat_pangkat_pangkat_id       on public.riwayat_pangkat_golongan(pangkat_id);
create index if not exists idx_riwayat_pangkat_golongan_id      on public.riwayat_pangkat_golongan(golongan_id);
create index if not exists idx_riwayat_pangkat_jenis_kenaikan   on public.riwayat_pangkat_golongan(jenis_kenaikan_id);

create trigger trg_riwayat_pangkat_golongan_updated_at
  before update on public.riwayat_pangkat_golongan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- E. riwayat_keluarga
-- -------------------------------------------------------
create table if not exists public.riwayat_keluarga (
  keluarga_id        text        not null,
  pegawai_id         text        not null,
  status_keluarga_id text        not null,
  nama_keluarga      text        not null,
  gelar_depan        text,
  gelar_belakang     text,
  jenis_kelamin      text,
  tempat_lahir       text,
  tanggal_lahir      date,
  agama_id           text,
  pendidikan_id      text,
  pekerjaan          text,
  nik                text,
  status_hidup       text,
  status_tanggungan  boolean,
  no_akta            text,
  tanggal_menikah    date,
  tanggal_cerai      date,
  tanggal_meninggal  date,
  urutan_anak        integer,
  is_current         boolean,
  keterangan         text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_riwayat_keluarga                primary key (keluarga_id),
  constraint fk_riwayat_keluarga_pegawai        foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_keluarga_status         foreign key (status_keluarga_id) references public.master_status_keluarga(status_keluarga_id) on delete restrict,
  constraint fk_riwayat_keluarga_agama          foreign key (agama_id) references public.master_agama(agama_id) on delete restrict,
  constraint fk_riwayat_keluarga_pendidikan     foreign key (pendidikan_id) references public.master_tingkat_pendidikan(tingkat_pendidikan_id) on delete restrict,
  constraint ck_riwayat_keluarga_id             check (trim(keluarga_id) <> ''),
  constraint ck_riwayat_keluarga_pegawai        check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_keluarga_status         check (trim(status_keluarga_id) <> ''),
  constraint ck_riwayat_keluarga_nama           check (trim(nama_keluarga) <> ''),
  constraint ck_riwayat_keluarga_urutan_anak    check (urutan_anak is null or urutan_anak >= 1),
  constraint ck_riwayat_keluarga_cerai          check (tanggal_cerai is null or tanggal_menikah is null or tanggal_cerai >= tanggal_menikah),
  constraint ck_riwayat_keluarga_meninggal      check (tanggal_meninggal is null or tanggal_lahir is null or tanggal_meninggal >= tanggal_lahir)
);

-- Satu pasangan aktif per pegawai (MSK-001=SUAMI, MSK-002=ISTRI)
create unique index if not exists uq_riwayat_keluarga_pasangan_aktif
  on public.riwayat_keluarga(pegawai_id)
  where is_current = true and status_keluarga_id in ('MSK-001', 'MSK-002');

create index if not exists idx_riwayat_keluarga_pegawai_id       on public.riwayat_keluarga(pegawai_id);
create index if not exists idx_riwayat_keluarga_status           on public.riwayat_keluarga(status_keluarga_id);
create index if not exists idx_riwayat_keluarga_agama            on public.riwayat_keluarga(agama_id);
create index if not exists idx_riwayat_keluarga_pendidikan       on public.riwayat_keluarga(pendidikan_id);
create index if not exists idx_riwayat_keluarga_pegawai_current  on public.riwayat_keluarga(pegawai_id, is_current);

create trigger trg_riwayat_keluarga_updated_at
  before update on public.riwayat_keluarga
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- F. riwayat_pendidikan
-- -------------------------------------------------------
create table if not exists public.riwayat_pendidikan (
  riwayat_pendidikan_id    text        not null,
  pegawai_id               text        not null,
  tingkat_pendidikan_id    text        not null,
  jurusan_nama             text,
  institusi_pendidikan     text,
  no_ijazah                text,
  tanggal_ijazah           date,
  gelar_depan              text,
  gelar_belakang           text,
  no_sk_pencantuman_gelar  text,
  status_studi_id          text,
  no_sk_tubel              text,
  tanggal_sk_tubel         date,
  tmt_tubel_awal           date,
  tmt_tubel_akhir          date,
  no_sk_pemberhentian      text,
  keterangan_perjanjian    text,
  is_terakhir              boolean     not null,
  keterangan               text,
  created_at               timestamptz not null default now(),
  updated_at               timestamptz not null default now(),
  created_by               text,
  updated_by               text,

  constraint pk_riwayat_pendidikan              primary key (riwayat_pendidikan_id),
  constraint fk_riwayat_pendidikan_pegawai      foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_pendidikan_tingkat      foreign key (tingkat_pendidikan_id) references public.master_tingkat_pendidikan(tingkat_pendidikan_id) on delete restrict,
  constraint fk_riwayat_pendidikan_studi        foreign key (status_studi_id) references public.master_status_studi(status_studi_id) on delete restrict,
  constraint ck_riwayat_pendidikan_id           check (trim(riwayat_pendidikan_id) <> ''),
  constraint ck_riwayat_pendidikan_pegawai      check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_pendidikan_tingkat      check (trim(tingkat_pendidikan_id) <> ''),
  constraint ck_riwayat_pendidikan_tubel        check (tmt_tubel_akhir is null or tmt_tubel_awal is null or tmt_tubel_akhir >= tmt_tubel_awal)
);

create unique index if not exists uq_riwayat_pendidikan_terakhir
  on public.riwayat_pendidikan(pegawai_id) where is_terakhir = true;

create index if not exists idx_riwayat_pendidikan_pegawai_id  on public.riwayat_pendidikan(pegawai_id);
create index if not exists idx_riwayat_pendidikan_tingkat     on public.riwayat_pendidikan(tingkat_pendidikan_id);
create index if not exists idx_riwayat_pendidikan_studi       on public.riwayat_pendidikan(status_studi_id);
create index if not exists idx_riwayat_pendidikan_terakhir    on public.riwayat_pendidikan(pegawai_id, is_terakhir);

create trigger trg_riwayat_pendidikan_updated_at
  before update on public.riwayat_pendidikan
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- G. riwayat_kgb
-- -------------------------------------------------------
create table if not exists public.riwayat_kgb (
  riwayat_kgb_id   text           not null,
  pegawai_id       text           not null,
  no_sk_kgb        text,
  tmt_kgb          date           not null,
  gaji_pokok_lama  numeric(14,2),
  gaji_pokok_baru  numeric(14,2)  not null,
  masa_kerja_tahun integer,
  masa_kerja_bulan integer,
  is_terakhir      boolean        not null,
  keterangan       text,
  created_at       timestamptz    not null default now(),
  updated_at       timestamptz    not null default now(),
  created_by       text,
  updated_by       text,

  constraint pk_riwayat_kgb                    primary key (riwayat_kgb_id),
  constraint fk_riwayat_kgb_pegawai            foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint ck_riwayat_kgb_id                 check (trim(riwayat_kgb_id) <> ''),
  constraint ck_riwayat_kgb_pegawai            check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_kgb_gaji_baru          check (gaji_pokok_baru >= 0),
  constraint ck_riwayat_kgb_gaji_lama          check (gaji_pokok_lama is null or gaji_pokok_lama >= 0),
  constraint ck_riwayat_kgb_gaji_order         check (gaji_pokok_lama is null or gaji_pokok_baru >= gaji_pokok_lama),
  constraint ck_riwayat_kgb_mk_tahun           check (masa_kerja_tahun is null or masa_kerja_tahun >= 0),
  constraint ck_riwayat_kgb_mk_bulan           check (masa_kerja_bulan is null or (masa_kerja_bulan >= 0 and masa_kerja_bulan <= 11))
);

create unique index if not exists uq_riwayat_kgb_terakhir_per_pegawai
  on public.riwayat_kgb(pegawai_id) where is_terakhir = true;

create index if not exists idx_riwayat_kgb_pegawai_id  on public.riwayat_kgb(pegawai_id);
create index if not exists idx_riwayat_kgb_tmt         on public.riwayat_kgb(tmt_kgb);
create index if not exists idx_riwayat_kgb_terakhir    on public.riwayat_kgb(pegawai_id, is_terakhir);

create trigger trg_riwayat_kgb_updated_at
  before update on public.riwayat_kgb
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- H. riwayat_skp
-- -------------------------------------------------------
create table if not exists public.riwayat_skp (
  riwayat_skp_id         text           not null,
  pegawai_id             text           not null,
  periode_awal           date,
  periode_akhir          date,
  tahun                  integer        not null,
  jumlah_bulan_penilaian integer,
  jenjang_id             text,
  predikat_id            text,
  koefisien_dasar        numeric(8,4),
  nilai_kinerja          numeric(6,2)   not null,
  angka_kredit           numeric(8,2),
  is_terakhir            boolean        not null,
  keterangan             text,
  created_at             timestamptz    not null default now(),
  updated_at             timestamptz    not null default now(),
  created_by             text,
  updated_by             text,

  constraint pk_riwayat_skp                    primary key (riwayat_skp_id),
  constraint fk_riwayat_skp_pegawai            foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_skp_jenjang            foreign key (jenjang_id) references public.master_jenjang_skp(jenjang_id) on delete restrict,
  constraint fk_riwayat_skp_predikat           foreign key (predikat_id) references public.master_predikat_skp(predikat_id) on delete restrict,
  constraint ck_riwayat_skp_id                 check (trim(riwayat_skp_id) <> ''),
  constraint ck_riwayat_skp_pegawai            check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_skp_tahun              check (tahun >= 1900),
  constraint ck_riwayat_skp_bulan              check (jumlah_bulan_penilaian is null or (jumlah_bulan_penilaian >= 1 and jumlah_bulan_penilaian <= 12)),
  constraint ck_riwayat_skp_periode            check (periode_akhir is null or periode_awal is null or periode_akhir >= periode_awal),
  constraint ck_riwayat_skp_nilai              check (nilai_kinerja >= 0),
  constraint ck_riwayat_skp_ak                 check (angka_kredit is null or angka_kredit >= 0)
);

create unique index if not exists uq_riwayat_skp_terakhir_per_pegawai
  on public.riwayat_skp(pegawai_id) where is_terakhir = true;

create index if not exists idx_riwayat_skp_pegawai_id  on public.riwayat_skp(pegawai_id);
create index if not exists idx_riwayat_skp_tahun       on public.riwayat_skp(tahun);
create index if not exists idx_riwayat_skp_predikat    on public.riwayat_skp(predikat_id);
create index if not exists idx_riwayat_skp_jenjang     on public.riwayat_skp(jenjang_id);
create index if not exists idx_riwayat_skp_terakhir    on public.riwayat_skp(pegawai_id, is_terakhir);

create trigger trg_riwayat_skp_updated_at
  before update on public.riwayat_skp
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- I. riwayat_pak
-- -------------------------------------------------------
create table if not exists public.riwayat_pak (
  riwayat_pak_id       text        not null,
  pegawai_id           text        not null,
  periode_awal         date,
  periode_akhir        date,
  jenis_pak_id         text,
  ak_dasar_lama        numeric,
  ak_dasar_baru        numeric,
  ak_dasar_total       numeric,
  ak_jf_lama           numeric,
  ak_jf_baru           numeric,
  ak_jf_total          numeric,
  ak_penyesuaian_lama  numeric,
  ak_penyesuaian_baru  numeric,
  ak_penyesuaian_total numeric,
  ak_konversi_lama     numeric,
  ak_konversi_baru     numeric,
  ak_konversi_total    numeric,
  ak_peningkatan_lama  numeric,
  ak_peningkatan_baru  numeric,
  ak_peningkatan_total numeric,
  ak_kumulatif_total   numeric     not null,
  target_pangkat_id    text,
  target_jenjang_id    text,
  selisih_pangkat      numeric,
  selisih_jenjang      numeric,
  no_sk_pak            text,
  tanggal_sk_pak       date,
  pejabat_penetap      text,
  status_dokumen_id    text,
  keterangan           text,
  is_terakhir          boolean     not null,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  created_by           text,
  updated_by           text,

  constraint pk_riwayat_pak                    primary key (riwayat_pak_id),
  constraint fk_riwayat_pak_pegawai            foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_pak_jenis              foreign key (jenis_pak_id) references public.master_jenis_pak(jenis_pak_id) on delete restrict,
  constraint fk_riwayat_pak_target_pangkat     foreign key (target_pangkat_id) references public.master_pangkat(pangkat_id) on delete restrict,
  constraint fk_riwayat_pak_target_jenjang     foreign key (target_jenjang_id) references public.master_jenis_jabatan(jenis_jabatan_id) on delete restrict,
  constraint fk_riwayat_pak_status_dokumen     foreign key (status_dokumen_id) references public.master_status_dokumen(status_dokumen_id) on delete restrict,
  constraint ck_riwayat_pak_id                 check (trim(riwayat_pak_id) <> ''),
  constraint ck_riwayat_pak_pegawai            check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_pak_kumulatif          check (ak_kumulatif_total >= 0),
  constraint ck_riwayat_pak_periode            check (periode_akhir is null or periode_awal is null or periode_akhir >= periode_awal)
);

create unique index if not exists uq_riwayat_pak_terakhir
  on public.riwayat_pak(pegawai_id) where is_terakhir = true;

create index if not exists idx_riwayat_pak_pegawai_id       on public.riwayat_pak(pegawai_id);
create index if not exists idx_riwayat_pak_jenis            on public.riwayat_pak(jenis_pak_id);
create index if not exists idx_riwayat_pak_target_pangkat   on public.riwayat_pak(target_pangkat_id);
create index if not exists idx_riwayat_pak_status_dokumen   on public.riwayat_pak(status_dokumen_id);
create index if not exists idx_riwayat_pak_terakhir         on public.riwayat_pak(pegawai_id, is_terakhir);
create index if not exists idx_riwayat_pak_periode          on public.riwayat_pak(periode_awal, periode_akhir);

create trigger trg_riwayat_pak_updated_at
  before update on public.riwayat_pak
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- J. riwayat_disiplin
-- -------------------------------------------------------
create table if not exists public.riwayat_disiplin (
  riwayat_disiplin_id text        not null,
  pegawai_id          text        not null,
  tingkat_hukuman_id  text,
  jenis_hukuman_id    text,
  no_surat_panggilan  text,
  tanggal_panggilan   date,
  no_bap              text,
  tanggal_bap         date,
  no_sk_hukuman       text,
  tanggal_sk_hukuman  date,
  tmt_hukuman         date,
  tmt_akhir_hukuman   date,
  status_proses_id    text,
  alasan_hukuman      text,
  keterangan          text,
  is_aktif            boolean     not null,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_riwayat_disiplin                primary key (riwayat_disiplin_id),
  constraint fk_riwayat_disiplin_pegawai        foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_disiplin_tingkat        foreign key (tingkat_hukuman_id) references public.master_tingkat_hukuman(tingkat_hukuman_id) on delete restrict,
  constraint fk_riwayat_disiplin_jenis          foreign key (jenis_hukuman_id) references public.master_jenis_hukuman(jenis_hukuman_id) on delete restrict,
  constraint fk_riwayat_disiplin_status_proses  foreign key (status_proses_id) references public.master_status_proses_disiplin(status_proses_id) on delete restrict,
  constraint ck_riwayat_disiplin_id             check (trim(riwayat_disiplin_id) <> ''),
  constraint ck_riwayat_disiplin_pegawai        check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_disiplin_tmt_akhir      check (tmt_akhir_hukuman is null or tmt_hukuman is null or tmt_akhir_hukuman >= tmt_hukuman)
);

create index if not exists idx_riwayat_disiplin_pegawai_id       on public.riwayat_disiplin(pegawai_id);
create index if not exists idx_riwayat_disiplin_tingkat          on public.riwayat_disiplin(tingkat_hukuman_id);
create index if not exists idx_riwayat_disiplin_jenis            on public.riwayat_disiplin(jenis_hukuman_id);
create index if not exists idx_riwayat_disiplin_status_proses    on public.riwayat_disiplin(status_proses_id);
create index if not exists idx_riwayat_disiplin_pegawai_aktif    on public.riwayat_disiplin(pegawai_id, is_aktif);
create index if not exists idx_riwayat_disiplin_tanggal_sk       on public.riwayat_disiplin(tanggal_sk_hukuman);

create trigger trg_riwayat_disiplin_updated_at
  before update on public.riwayat_disiplin
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- K. riwayat_diklat
-- -------------------------------------------------------
create table if not exists public.riwayat_diklat (
  riwayat_diklat_id  text        not null,
  pegawai_id         text        not null,
  nama_diklat        text        not null,
  jenis_diklat       text,
  penyelenggara      text,
  tempat             text,
  tahun              integer,
  tanggal_mulai      date,
  tanggal_selesai    date,
  jumlah_jam         integer,
  no_sertifikat      text,
  tanggal_sertifikat date,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_riwayat_diklat              primary key (riwayat_diklat_id),
  constraint fk_riwayat_diklat_pegawai      foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint ck_riwayat_diklat_id           check (trim(riwayat_diklat_id) <> ''),
  constraint ck_riwayat_diklat_pegawai      check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_diklat_nama         check (trim(nama_diklat) <> ''),
  constraint ck_riwayat_diklat_selesai      check (tanggal_selesai is null or tanggal_mulai is null or tanggal_selesai >= tanggal_mulai),
  constraint ck_riwayat_diklat_sertifikat   check (tanggal_sertifikat is null or tanggal_mulai is null or tanggal_sertifikat >= tanggal_mulai),
  constraint ck_riwayat_diklat_jam          check (jumlah_jam is null or jumlah_jam >= 0)
);

create index if not exists idx_riwayat_diklat_pegawai_id    on public.riwayat_diklat(pegawai_id);
create index if not exists idx_riwayat_diklat_pegawai_tahun on public.riwayat_diklat(pegawai_id, tahun);
create index if not exists idx_riwayat_diklat_tanggal_mulai on public.riwayat_diklat(tanggal_mulai);

create trigger trg_riwayat_diklat_updated_at
  before update on public.riwayat_diklat
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- L. riwayat_usulan
-- -------------------------------------------------------
create table if not exists public.riwayat_usulan (
  riwayat_usulan_id   text        not null,
  pegawai_id          text        not null,
  jenis_usulan_id     text        not null,
  modul_sumber        text        not null,
  referensi_record_id text        not null,
  periode_bulan       integer,
  periode_tahun       integer,
  tanggal_usulan      date        not null,
  status_usulan_id    text        not null,
  tanggal_status      date,
  keterangan          text,
  catatan_verifikator text,
  is_aktif            boolean     not null,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_riwayat_usulan                  primary key (riwayat_usulan_id),
  constraint fk_riwayat_usulan_pegawai          foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_riwayat_usulan_jenis            foreign key (jenis_usulan_id) references public.master_jenis_usulan(jenis_usulan_id) on delete restrict,
  constraint fk_riwayat_usulan_status           foreign key (status_usulan_id) references public.master_status_usulan(status_usulan_id) on delete restrict,
  constraint ck_riwayat_usulan_id               check (trim(riwayat_usulan_id) <> ''),
  constraint ck_riwayat_usulan_pegawai          check (trim(pegawai_id) <> ''),
  constraint ck_riwayat_usulan_jenis            check (trim(jenis_usulan_id) <> ''),
  constraint ck_riwayat_usulan_modul            check (trim(modul_sumber) <> ''),
  constraint ck_riwayat_usulan_referensi        check (trim(referensi_record_id) <> ''),
  constraint ck_riwayat_usulan_status           check (trim(status_usulan_id) <> ''),
  constraint ck_riwayat_usulan_periode_bulan    check (periode_bulan is null or (periode_bulan >= 1 and periode_bulan <= 12)),
  constraint ck_riwayat_usulan_periode_tahun    check (periode_tahun is null or (periode_tahun >= 1900 and periode_tahun <= 2100))
);

create index if not exists idx_riwayat_usulan_pegawai_id     on public.riwayat_usulan(pegawai_id);
create index if not exists idx_riwayat_usulan_jenis          on public.riwayat_usulan(jenis_usulan_id);
create index if not exists idx_riwayat_usulan_status         on public.riwayat_usulan(status_usulan_id);
create index if not exists idx_riwayat_usulan_modul_ref      on public.riwayat_usulan(modul_sumber, referensi_record_id);
create index if not exists idx_riwayat_usulan_queue          on public.riwayat_usulan(status_usulan_id, is_aktif, tanggal_status);

create trigger trg_riwayat_usulan_updated_at
  before update on public.riwayat_usulan
  for each row execute function public.tg_set_updated_at();
