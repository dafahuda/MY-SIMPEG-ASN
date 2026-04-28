-- ============================================================
-- Migration 007: Workflow, Audit, & Dokumen (Chapter Q-R, U)
-- approval_log, audit_log, dokumen_pegawai
-- ============================================================

-- -------------------------------------------------------
-- Q. approval_log (append-only workflow log)
-- -------------------------------------------------------
create table if not exists public.approval_log (
  approval_log_id    text        not null,
  riwayat_usulan_id  text        not null,
  actor_user_id      text        not null,
  aksi_approval_id   text        not null,
  status_sebelum_id  text,
  status_sesudah_id  text,
  tanggal_aksi       timestamptz not null,
  catatan            text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_approval_log                   primary key (approval_log_id),
  constraint fk_approval_log_usulan            foreign key (riwayat_usulan_id) references public.riwayat_usulan(riwayat_usulan_id) on delete restrict,
  constraint fk_approval_log_actor             foreign key (actor_user_id) references public.users(user_id) on delete restrict,
  constraint fk_approval_log_aksi              foreign key (aksi_approval_id) references public.master_aksi_approval(aksi_approval_id) on delete restrict,
  constraint fk_approval_log_status_sebelum    foreign key (status_sebelum_id) references public.master_status_usulan(status_usulan_id) on delete restrict,
  constraint fk_approval_log_status_sesudah    foreign key (status_sesudah_id) references public.master_status_usulan(status_usulan_id) on delete restrict,
  constraint ck_approval_log_id                check (trim(approval_log_id) <> ''),
  constraint ck_approval_log_usulan            check (trim(riwayat_usulan_id) <> ''),
  constraint ck_approval_log_actor             check (trim(actor_user_id) <> ''),
  constraint ck_approval_log_aksi              check (trim(aksi_approval_id) <> '')
);

create index if not exists idx_approval_log_usulan_id    on public.approval_log(riwayat_usulan_id);
create index if not exists idx_approval_log_actor        on public.approval_log(actor_user_id);
create index if not exists idx_approval_log_tanggal      on public.approval_log(tanggal_aksi);

create trigger trg_approval_log_updated_at
  before update on public.approval_log
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- R. audit_log (append-only system audit)
-- -------------------------------------------------------
create table if not exists public.audit_log (
  audit_log_id     text        not null,
  actor_user_id    text        not null,
  aksi_audit_id    text,
  target_table     text        not null,
  target_record_id text        not null,
  aksi_at          timestamptz not null,
  metadata         jsonb,
  keterangan       text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  created_by       text,
  updated_by       text,

  constraint pk_audit_log                primary key (audit_log_id),
  constraint fk_audit_log_actor          foreign key (actor_user_id) references public.users(user_id) on delete restrict,
  constraint fk_audit_log_aksi           foreign key (aksi_audit_id) references public.master_aksi_audit(aksi_audit_id) on delete restrict,
  constraint ck_audit_log_id             check (trim(audit_log_id) <> ''),
  constraint ck_audit_log_actor          check (trim(actor_user_id) <> ''),
  constraint ck_audit_log_target_table   check (trim(target_table) <> ''),
  constraint ck_audit_log_target_record  check (trim(target_record_id) <> '')
);

create index if not exists idx_audit_log_actor          on public.audit_log(actor_user_id);
create index if not exists idx_audit_log_aksi_at        on public.audit_log(aksi_at);
create index if not exists idx_audit_log_target         on public.audit_log(target_table, target_record_id);

create trigger trg_audit_log_updated_at
  before update on public.audit_log
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- U. dokumen_pegawai
-- -------------------------------------------------------
create table if not exists public.dokumen_pegawai (
  dokumen_pegawai_id    text        not null,
  pegawai_id            text        not null,
  jenis_dokumen_id      text        not null,
  status_dokumen_id     text,
  modul_sumber          text,
  referensi_record_id   text,
  nomor_dokumen         text,
  nama_dokumen          text        not null,
  object_path           text        not null,
  file_url              text,
  file_mime_type        text,
  file_size_bytes       bigint      not null default 0,
  tanggal_dokumen       date,
  tanggal_mulai_berlaku date,
  tanggal_akhir_berlaku date,
  uploaded_at           timestamptz not null default now(),
  uploaded_by           text,
  keterangan            text,
  is_active             boolean     not null default true,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),
  created_by            text,
  updated_by            text,

  constraint pk_dokumen_pegawai                    primary key (dokumen_pegawai_id),
  constraint fk_dokumen_pegawai_pegawai            foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint fk_dokumen_pegawai_jenis              foreign key (jenis_dokumen_id) references public.master_jenis_dokumen(jenis_dokumen_id) on delete restrict,
  constraint fk_dokumen_pegawai_status             foreign key (status_dokumen_id) references public.master_status_dokumen(status_dokumen_id) on delete restrict,
  constraint fk_dokumen_pegawai_uploaded_by        foreign key (uploaded_by) references public.users(user_id) on delete set null,
  constraint ck_dokumen_pegawai_id                 check (trim(dokumen_pegawai_id) <> ''),
  constraint ck_dokumen_pegawai_pegawai            check (trim(pegawai_id) <> ''),
  constraint ck_dokumen_pegawai_jenis              check (trim(jenis_dokumen_id) <> ''),
  constraint ck_dokumen_pegawai_nama               check (trim(nama_dokumen) <> ''),
  constraint ck_dokumen_pegawai_object_path        check (trim(object_path) <> ''),
  constraint ck_dokumen_pegawai_file_size          check (file_size_bytes >= 0),
  constraint ck_dokumen_pegawai_berlaku            check (tanggal_akhir_berlaku is null or tanggal_mulai_berlaku is null or tanggal_akhir_berlaku >= tanggal_mulai_berlaku)
);

create index if not exists idx_dokumen_pegawai_pegawai_id    on public.dokumen_pegawai(pegawai_id);
create index if not exists idx_dokumen_pegawai_jenis         on public.dokumen_pegawai(jenis_dokumen_id);
create index if not exists idx_dokumen_pegawai_status        on public.dokumen_pegawai(status_dokumen_id);
create index if not exists idx_dokumen_pegawai_uploaded_by   on public.dokumen_pegawai(uploaded_by);
create index if not exists idx_dokumen_pegawai_pegawai_jenis on public.dokumen_pegawai(pegawai_id, jenis_dokumen_id);
create index if not exists idx_dokumen_pegawai_modul_ref     on public.dokumen_pegawai(modul_sumber, referensi_record_id);
create index if not exists idx_dokumen_pegawai_tanggal       on public.dokumen_pegawai(tanggal_dokumen);

create trigger trg_dokumen_pegawai_updated_at
  before update on public.dokumen_pegawai
  for each row execute function public.tg_set_updated_at();
