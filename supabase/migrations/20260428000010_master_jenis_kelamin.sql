-- ============================================================
-- Migration 010: Master Jenis Kelamin (Fase 9 — Dynamic Architecture)
-- Mengubah jenis_kelamin dari CHECK constraint hardcode menjadi
-- FK ke master table. Termasuk data migration existing rows.
-- ============================================================
-- Keputusan: Opsi B — FK ke PK jenis_kelamin_id (bukan kode)
--   agar konsisten dengan semua FK lain di sistem.
-- ============================================================

-- -------------------------------------------------------
-- Task 9.1: Buat tabel master_jenis_kelamin
-- -------------------------------------------------------
create table if not exists public.master_jenis_kelamin (
  jenis_kelamin_id    text        not null,
  kode_jenis_kelamin  text        not null,
  nama_jenis_kelamin  text        not null,
  urutan              integer     not null default 0,
  is_active           boolean     not null default true,
  keterangan          text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_master_jenis_kelamin        primary key (jenis_kelamin_id),
  constraint uq_master_jenis_kelamin_kode   unique (kode_jenis_kelamin),
  constraint ck_master_jenis_kelamin_id     check (trim(jenis_kelamin_id) <> ''),
  constraint ck_master_jenis_kelamin_kode   check (trim(kode_jenis_kelamin) <> ''),
  constraint ck_master_jenis_kelamin_nama   check (trim(nama_jenis_kelamin) <> ''),
  constraint ck_master_jenis_kelamin_urutan check (urutan >= 0)
);

create trigger trg_master_jenis_kelamin_updated_at
  before update on public.master_jenis_kelamin
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- Task 9.2: RLS policies
-- -------------------------------------------------------
alter table public.master_jenis_kelamin enable row level security;

-- Master data bisa dibaca siapa saja (termasuk halaman publik/form)
create policy "Anyone can read master_jenis_kelamin"
  on public.master_jenis_kelamin
  for select
  to anon, authenticated
  using (true);

-- Hanya authenticated user yang bisa manage (fine-grained ke SUPERADMIN di Fase 10C)
create policy "Authenticated users can manage master_jenis_kelamin"
  on public.master_jenis_kelamin
  for all
  to authenticated
  using (true)
  with check (true);

-- -------------------------------------------------------
-- Task 9.3: Seed data default
-- -------------------------------------------------------
insert into public.master_jenis_kelamin
  (jenis_kelamin_id, kode_jenis_kelamin, nama_jenis_kelamin, urutan)
values
  ('MJK-001', 'L', 'Laki-laki', 1),
  ('MJK-002', 'P', 'Perempuan', 2)
on conflict (jenis_kelamin_id) do nothing;

-- -------------------------------------------------------
-- Task 9.4: ALTER pegawai_pribadi — migrasi data + ganti CHECK → FK
-- -------------------------------------------------------

-- Step 1: Hapus CHECK constraint lama
alter table public.pegawai_pribadi
  drop constraint if exists ck_pegawai_pribadi_jenis_kelamin;

-- Step 2: Migrasi data existing dari kode ('L','P') ke ID ('MJK-001','MJK-002')
update public.pegawai_pribadi
  set jenis_kelamin = 'MJK-001'
  where jenis_kelamin = 'L';

update public.pegawai_pribadi
  set jenis_kelamin = 'MJK-002'
  where jenis_kelamin = 'P';

-- Step 3: Tambah FK ke PK master (NOT VALID dulu untuk safety)
alter table public.pegawai_pribadi
  add constraint fk_pegawai_pribadi_jenis_kelamin
    foreign key (jenis_kelamin) references public.master_jenis_kelamin(jenis_kelamin_id)
    on delete restrict
    not valid;

-- Step 4: Validasi constraint (akan gagal jika ada data kotor)
alter table public.pegawai_pribadi
  validate constraint fk_pegawai_pribadi_jenis_kelamin;

-- Step 5: Tambah index untuk performa JOIN
create index if not exists idx_pegawai_pribadi_jenis_kelamin
  on public.pegawai_pribadi(jenis_kelamin);

-- -------------------------------------------------------
-- Task 9.5: ALTER riwayat_keluarga.jenis_kelamin — migrasi data + FK
-- -------------------------------------------------------

-- Step 1: Migrasi data existing (kolom ini tidak punya CHECK, bisa ada NULL)
update public.riwayat_keluarga
  set jenis_kelamin = 'MJK-001'
  where jenis_kelamin = 'L';

update public.riwayat_keluarga
  set jenis_kelamin = 'MJK-002'
  where jenis_kelamin = 'P';

-- Step 2: Tambah FK (NOT VALID untuk safety — NULL tetap diizinkan)
alter table public.riwayat_keluarga
  add constraint fk_riwayat_keluarga_jenis_kelamin
    foreign key (jenis_kelamin) references public.master_jenis_kelamin(jenis_kelamin_id)
    on delete restrict
    not valid;

-- Step 3: Validasi
alter table public.riwayat_keluarga
  validate constraint fk_riwayat_keluarga_jenis_kelamin;

-- Step 4: Index
create index if not exists idx_riwayat_keluarga_jenis_kelamin
  on public.riwayat_keluarga(jenis_kelamin);

-- -------------------------------------------------------
-- Task 9.6: ALTER master_status_keluarga — tambah flag is_pasangan
-- -------------------------------------------------------

-- Tambah kolom flag
alter table public.master_status_keluarga
  add column if not exists is_pasangan boolean not null default false;

-- Seed: tandai status SUAMI dan ISTRI sebagai pasangan
-- (MSK-001 = Suami, MSK-002 = Istri berdasarkan konvensi ASN)
update public.master_status_keluarga
  set is_pasangan = true
  where status_keluarga_id in ('MSK-001', 'MSK-002');

-- -------------------------------------------------------
-- Task 9.7: ALTER riwayat_keluarga — denormalisasi is_pasangan + triggers
-- -------------------------------------------------------

-- Step 1: Tambah kolom denormalisasi
alter table public.riwayat_keluarga
  add column if not exists is_pasangan boolean not null default false;

-- Step 2: Backfill data existing berdasarkan master
update public.riwayat_keluarga rk
  set is_pasangan = msk.is_pasangan
  from public.master_status_keluarga msk
  where rk.status_keluarga_id = msk.status_keluarga_id;

-- Step 3: Trigger sinkronisasi — auto-set is_pasangan saat INSERT/UPDATE riwayat_keluarga
create or replace function public.tg_sync_is_pasangan_from_master()
returns trigger as $$
begin
  select msk.is_pasangan into new.is_pasangan
    from public.master_status_keluarga msk
    where msk.status_keluarga_id = new.status_keluarga_id;

  -- Fallback jika status tidak ditemukan
  if new.is_pasangan is null then
    new.is_pasangan := false;
  end if;

  return new;
end;
$$ language plpgsql;

create trigger trg_riwayat_keluarga_sync_is_pasangan
  before insert or update of status_keluarga_id
  on public.riwayat_keluarga
  for each row execute function public.tg_sync_is_pasangan_from_master();

-- Step 4: Trigger propagasi — jika admin ubah is_pasangan di master, propagate ke riwayat
create or replace function public.tg_propagate_is_pasangan_to_riwayat()
returns trigger as $$
begin
  if old.is_pasangan is distinct from new.is_pasangan then
    update public.riwayat_keluarga
      set is_pasangan = new.is_pasangan
      where status_keluarga_id = new.status_keluarga_id;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trg_master_status_keluarga_propagate_is_pasangan
  after update of is_pasangan
  on public.master_status_keluarga
  for each row execute function public.tg_propagate_is_pasangan_to_riwayat();

-- Step 5: Hapus index lama yang pakai literal MSK-001, MSK-002
drop index if exists public.uq_riwayat_keluarga_pasangan_aktif;

-- Step 6: Buat index baru menggunakan kolom is_pasangan (tidak lagi hardcode ID)
create unique index if not exists uq_riwayat_keluarga_pasangan_aktif
  on public.riwayat_keluarga(pegawai_id)
  where is_current = true and is_pasangan = true;
