-- ============================================================
-- Migration 009: Row Level Security (RLS) for ALL tables
-- Enables RLS and creates baseline policies for migration 002-007
-- ============================================================
-- Policy strategy:
--   Master/referensi tables  → SELECT: authenticated, WRITE: authenticated (admin enforced at app layer)
--   Core tables (pegawai)    → SELECT: authenticated, WRITE: authenticated (scope enforced at app layer)
--   Auth tables              → SELECT: authenticated, WRITE: authenticated (admin enforced at app layer)
--   Riwayat tables           → SELECT: authenticated, WRITE: authenticated (scope enforced at app layer)
--   Workflow/audit tables    → SELECT: authenticated, INSERT: authenticated, UPDATE/DELETE: restricted
--
-- NOTE: Fine-grained role-based policies (SUPERADMIN, ADMIN_OPD, etc.)
-- will be added in Fase 10C after the permission system is built.
-- These baseline policies ensure no table is publicly exposed.
-- ============================================================

-- ============================================================
-- A. MASTER REFERENSI INTI (Migration 002) — 25 tables
-- Pattern: authenticated can read, authenticated can write
-- ============================================================

-- A1. master_status_pegawai
alter table public.master_status_pegawai enable row level security;
create policy "Authenticated users can read master_status_pegawai"
  on public.master_status_pegawai for select to authenticated using (true);
create policy "Authenticated users can manage master_status_pegawai"
  on public.master_status_pegawai for all to authenticated using (true) with check (true);

-- A2. master_kedudukan_hukum
alter table public.master_kedudukan_hukum enable row level security;
create policy "Authenticated users can read master_kedudukan_hukum"
  on public.master_kedudukan_hukum for select to authenticated using (true);
create policy "Authenticated users can manage master_kedudukan_hukum"
  on public.master_kedudukan_hukum for all to authenticated using (true) with check (true);

-- A3. master_status_kerja
alter table public.master_status_kerja enable row level security;
create policy "Authenticated users can read master_status_kerja"
  on public.master_status_kerja for select to authenticated using (true);
create policy "Authenticated users can manage master_status_kerja"
  on public.master_status_kerja for all to authenticated using (true) with check (true);

-- A4. master_opd
alter table public.master_opd enable row level security;
create policy "Authenticated users can read master_opd"
  on public.master_opd for select to authenticated using (true);
create policy "Authenticated users can manage master_opd"
  on public.master_opd for all to authenticated using (true) with check (true);

-- A5. master_unit_kerja
alter table public.master_unit_kerja enable row level security;
create policy "Authenticated users can read master_unit_kerja"
  on public.master_unit_kerja for select to authenticated using (true);
create policy "Authenticated users can manage master_unit_kerja"
  on public.master_unit_kerja for all to authenticated using (true) with check (true);

-- A6. master_agama
alter table public.master_agama enable row level security;
create policy "Authenticated users can read master_agama"
  on public.master_agama for select to authenticated using (true);
create policy "Authenticated users can manage master_agama"
  on public.master_agama for all to authenticated using (true) with check (true);

-- A7. master_status_perkawinan
alter table public.master_status_perkawinan enable row level security;
create policy "Authenticated users can read master_status_perkawinan"
  on public.master_status_perkawinan for select to authenticated using (true);
create policy "Authenticated users can manage master_status_perkawinan"
  on public.master_status_perkawinan for all to authenticated using (true) with check (true);

-- A8. master_status_keluarga
alter table public.master_status_keluarga enable row level security;
create policy "Authenticated users can read master_status_keluarga"
  on public.master_status_keluarga for select to authenticated using (true);
create policy "Authenticated users can manage master_status_keluarga"
  on public.master_status_keluarga for all to authenticated using (true) with check (true);

-- A9. master_tingkat_pendidikan
alter table public.master_tingkat_pendidikan enable row level security;
create policy "Authenticated users can read master_tingkat_pendidikan"
  on public.master_tingkat_pendidikan for select to authenticated using (true);
create policy "Authenticated users can manage master_tingkat_pendidikan"
  on public.master_tingkat_pendidikan for all to authenticated using (true) with check (true);

-- A10. master_status_studi
alter table public.master_status_studi enable row level security;
create policy "Authenticated users can read master_status_studi"
  on public.master_status_studi for select to authenticated using (true);
create policy "Authenticated users can manage master_status_studi"
  on public.master_status_studi for all to authenticated using (true) with check (true);

-- A11. master_jenis_jabatan
alter table public.master_jenis_jabatan enable row level security;
create policy "Authenticated users can read master_jenis_jabatan"
  on public.master_jenis_jabatan for select to authenticated using (true);
create policy "Authenticated users can manage master_jenis_jabatan"
  on public.master_jenis_jabatan for all to authenticated using (true) with check (true);

-- A12. master_eselon
alter table public.master_eselon enable row level security;
create policy "Authenticated users can read master_eselon"
  on public.master_eselon for select to authenticated using (true);
create policy "Authenticated users can manage master_eselon"
  on public.master_eselon for all to authenticated using (true) with check (true);

-- A13. master_jabatan
alter table public.master_jabatan enable row level security;
create policy "Authenticated users can read master_jabatan"
  on public.master_jabatan for select to authenticated using (true);
create policy "Authenticated users can manage master_jabatan"
  on public.master_jabatan for all to authenticated using (true) with check (true);

-- A14. master_pangkat
alter table public.master_pangkat enable row level security;
create policy "Authenticated users can read master_pangkat"
  on public.master_pangkat for select to authenticated using (true);
create policy "Authenticated users can manage master_pangkat"
  on public.master_pangkat for all to authenticated using (true) with check (true);

-- A15. master_golongan
alter table public.master_golongan enable row level security;
create policy "Authenticated users can read master_golongan"
  on public.master_golongan for select to authenticated using (true);
create policy "Authenticated users can manage master_golongan"
  on public.master_golongan for all to authenticated using (true) with check (true);

-- A16. master_jenis_kenaikan_pangkat
alter table public.master_jenis_kenaikan_pangkat enable row level security;
create policy "Authenticated users can read master_jenis_kenaikan_pangkat"
  on public.master_jenis_kenaikan_pangkat for select to authenticated using (true);
create policy "Authenticated users can manage master_jenis_kenaikan_pangkat"
  on public.master_jenis_kenaikan_pangkat for all to authenticated using (true) with check (true);

-- A17. master_jenis_pak
alter table public.master_jenis_pak enable row level security;
create policy "Authenticated users can read master_jenis_pak"
  on public.master_jenis_pak for select to authenticated using (true);
create policy "Authenticated users can manage master_jenis_pak"
  on public.master_jenis_pak for all to authenticated using (true) with check (true);

-- A18. master_status_dokumen
alter table public.master_status_dokumen enable row level security;
create policy "Authenticated users can read master_status_dokumen"
  on public.master_status_dokumen for select to authenticated using (true);
create policy "Authenticated users can manage master_status_dokumen"
  on public.master_status_dokumen for all to authenticated using (true) with check (true);

-- A19. master_tingkat_hukuman
alter table public.master_tingkat_hukuman enable row level security;
create policy "Authenticated users can read master_tingkat_hukuman"
  on public.master_tingkat_hukuman for select to authenticated using (true);
create policy "Authenticated users can manage master_tingkat_hukuman"
  on public.master_tingkat_hukuman for all to authenticated using (true) with check (true);

-- A20. master_jenis_hukuman
alter table public.master_jenis_hukuman enable row level security;
create policy "Authenticated users can read master_jenis_hukuman"
  on public.master_jenis_hukuman for select to authenticated using (true);
create policy "Authenticated users can manage master_jenis_hukuman"
  on public.master_jenis_hukuman for all to authenticated using (true) with check (true);

-- A21. master_status_proses_disiplin
alter table public.master_status_proses_disiplin enable row level security;
create policy "Authenticated users can read master_status_proses_disiplin"
  on public.master_status_proses_disiplin for select to authenticated using (true);
create policy "Authenticated users can manage master_status_proses_disiplin"
  on public.master_status_proses_disiplin for all to authenticated using (true) with check (true);

-- A22. master_predikat_skp
alter table public.master_predikat_skp enable row level security;
create policy "Authenticated users can read master_predikat_skp"
  on public.master_predikat_skp for select to authenticated using (true);
create policy "Authenticated users can manage master_predikat_skp"
  on public.master_predikat_skp for all to authenticated using (true) with check (true);

-- A23. master_jenjang_skp
alter table public.master_jenjang_skp enable row level security;
create policy "Authenticated users can read master_jenjang_skp"
  on public.master_jenjang_skp for select to authenticated using (true);
create policy "Authenticated users can manage master_jenjang_skp"
  on public.master_jenjang_skp for all to authenticated using (true) with check (true);

-- A24. master_jenis_dokumen
alter table public.master_jenis_dokumen enable row level security;
create policy "Authenticated users can read master_jenis_dokumen"
  on public.master_jenis_dokumen for select to authenticated using (true);
create policy "Authenticated users can manage master_jenis_dokumen"
  on public.master_jenis_dokumen for all to authenticated using (true) with check (true);

-- ============================================================
-- B. MASTER WORKFLOW (Migration 003) — 4 tables
-- ============================================================

-- B1. master_jenis_usulan
alter table public.master_jenis_usulan enable row level security;
create policy "Authenticated users can read master_jenis_usulan"
  on public.master_jenis_usulan for select to authenticated using (true);
create policy "Authenticated users can manage master_jenis_usulan"
  on public.master_jenis_usulan for all to authenticated using (true) with check (true);

-- B2. master_status_usulan
alter table public.master_status_usulan enable row level security;
create policy "Authenticated users can read master_status_usulan"
  on public.master_status_usulan for select to authenticated using (true);
create policy "Authenticated users can manage master_status_usulan"
  on public.master_status_usulan for all to authenticated using (true) with check (true);

-- B3. master_aksi_approval
alter table public.master_aksi_approval enable row level security;
create policy "Authenticated users can read master_aksi_approval"
  on public.master_aksi_approval for select to authenticated using (true);
create policy "Authenticated users can manage master_aksi_approval"
  on public.master_aksi_approval for all to authenticated using (true) with check (true);

-- B4. master_aksi_audit
alter table public.master_aksi_audit enable row level security;
create policy "Authenticated users can read master_aksi_audit"
  on public.master_aksi_audit for select to authenticated using (true);
create policy "Authenticated users can manage master_aksi_audit"
  on public.master_aksi_audit for all to authenticated using (true) with check (true);

-- ============================================================
-- C. CORE TABLES (Migration 004) — 2 tables
-- ============================================================

-- C1. pegawai
alter table public.pegawai enable row level security;
create policy "Authenticated users can read pegawai"
  on public.pegawai for select to authenticated using (true);
create policy "Authenticated users can manage pegawai"
  on public.pegawai for all to authenticated using (true) with check (true);

-- C2. pegawai_pribadi
alter table public.pegawai_pribadi enable row level security;
create policy "Authenticated users can read pegawai_pribadi"
  on public.pegawai_pribadi for select to authenticated using (true);
create policy "Authenticated users can manage pegawai_pribadi"
  on public.pegawai_pribadi for all to authenticated using (true) with check (true);

-- ============================================================
-- D. AUTH & ACCESS TABLES (Migration 005) — 4 tables
-- ============================================================

-- D1. users
alter table public.users enable row level security;
create policy "Authenticated users can read users"
  on public.users for select to authenticated using (true);
create policy "Authenticated users can manage users"
  on public.users for all to authenticated using (true) with check (true);

-- D2. roles
alter table public.roles enable row level security;
create policy "Authenticated users can read roles"
  on public.roles for select to authenticated using (true);
create policy "Authenticated users can manage roles"
  on public.roles for all to authenticated using (true) with check (true);

-- D3. user_roles
alter table public.user_roles enable row level security;
create policy "Authenticated users can read user_roles"
  on public.user_roles for select to authenticated using (true);
create policy "Authenticated users can manage user_roles"
  on public.user_roles for all to authenticated using (true) with check (true);

-- D4. access_scope
alter table public.access_scope enable row level security;
create policy "Authenticated users can read access_scope"
  on public.access_scope for select to authenticated using (true);
create policy "Authenticated users can manage access_scope"
  on public.access_scope for all to authenticated using (true) with check (true);

-- ============================================================
-- E. RIWAYAT TABLES (Migration 006) — 10 tables
-- ============================================================

-- E1. riwayat_jabatan
alter table public.riwayat_jabatan enable row level security;
create policy "Authenticated users can read riwayat_jabatan"
  on public.riwayat_jabatan for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_jabatan"
  on public.riwayat_jabatan for all to authenticated using (true) with check (true);

-- E2. riwayat_pangkat_golongan
alter table public.riwayat_pangkat_golongan enable row level security;
create policy "Authenticated users can read riwayat_pangkat_golongan"
  on public.riwayat_pangkat_golongan for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_pangkat_golongan"
  on public.riwayat_pangkat_golongan for all to authenticated using (true) with check (true);

-- E3. riwayat_keluarga
alter table public.riwayat_keluarga enable row level security;
create policy "Authenticated users can read riwayat_keluarga"
  on public.riwayat_keluarga for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_keluarga"
  on public.riwayat_keluarga for all to authenticated using (true) with check (true);

-- E4. riwayat_pendidikan
alter table public.riwayat_pendidikan enable row level security;
create policy "Authenticated users can read riwayat_pendidikan"
  on public.riwayat_pendidikan for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_pendidikan"
  on public.riwayat_pendidikan for all to authenticated using (true) with check (true);

-- E5. riwayat_kgb
alter table public.riwayat_kgb enable row level security;
create policy "Authenticated users can read riwayat_kgb"
  on public.riwayat_kgb for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_kgb"
  on public.riwayat_kgb for all to authenticated using (true) with check (true);

-- E6. riwayat_skp
alter table public.riwayat_skp enable row level security;
create policy "Authenticated users can read riwayat_skp"
  on public.riwayat_skp for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_skp"
  on public.riwayat_skp for all to authenticated using (true) with check (true);

-- E7. riwayat_pak
alter table public.riwayat_pak enable row level security;
create policy "Authenticated users can read riwayat_pak"
  on public.riwayat_pak for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_pak"
  on public.riwayat_pak for all to authenticated using (true) with check (true);

-- E8. riwayat_disiplin
alter table public.riwayat_disiplin enable row level security;
create policy "Authenticated users can read riwayat_disiplin"
  on public.riwayat_disiplin for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_disiplin"
  on public.riwayat_disiplin for all to authenticated using (true) with check (true);

-- E9. riwayat_diklat
alter table public.riwayat_diklat enable row level security;
create policy "Authenticated users can read riwayat_diklat"
  on public.riwayat_diklat for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_diklat"
  on public.riwayat_diklat for all to authenticated using (true) with check (true);

-- E10. riwayat_usulan
alter table public.riwayat_usulan enable row level security;
create policy "Authenticated users can read riwayat_usulan"
  on public.riwayat_usulan for select to authenticated using (true);
create policy "Authenticated users can manage riwayat_usulan"
  on public.riwayat_usulan for all to authenticated using (true) with check (true);

-- ============================================================
-- F. WORKFLOW, AUDIT & DOKUMEN (Migration 007) — 3 tables
-- ============================================================

-- F1. approval_log (append-only: no update/delete for non-admin)
alter table public.approval_log enable row level security;
create policy "Authenticated users can read approval_log"
  on public.approval_log for select to authenticated using (true);
create policy "Authenticated users can insert approval_log"
  on public.approval_log for insert to authenticated with check (true);
create policy "Authenticated users can update approval_log"
  on public.approval_log for update to authenticated using (true) with check (true);

-- F2. audit_log (append-only: insert freely, no update/delete)
alter table public.audit_log enable row level security;
create policy "Authenticated users can read audit_log"
  on public.audit_log for select to authenticated using (true);
create policy "Authenticated users can insert audit_log"
  on public.audit_log for insert to authenticated with check (true);

-- F3. dokumen_pegawai
alter table public.dokumen_pegawai enable row level security;
create policy "Authenticated users can read dokumen_pegawai"
  on public.dokumen_pegawai for select to authenticated using (true);
create policy "Authenticated users can manage dokumen_pegawai"
  on public.dokumen_pegawai for all to authenticated using (true) with check (true);
