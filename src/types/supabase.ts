import type { Database } from './database.types'

// ─── Generic Helpers ─────────────────────────────────────────────
// Shorthand untuk mengakses Row / Insert / Update dari tabel mana pun
// di schema "public" tanpa harus menulis path panjang berulang kali.
//
// Contoh pemakaian:
//   type P = Tables<'pegawai'>          → tipe baris pegawai (SELECT)
//   type I = InsertTables<'pegawai'>    → tipe untuk INSERT
//   type U = UpdateTables<'pegawai'>    → tipe untuk UPDATE (semua field optional)

/** Tipe baris hasil SELECT (Row) */
export type Tables<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Row']

/** Tipe payload INSERT */
export type InsertTables<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Insert']

/** Tipe payload UPDATE (semua field optional) */
export type UpdateTables<T extends keyof Database['public']['Tables']> =
  Database['public']['Tables'][T]['Update']

// ─── Alias Tabel Utama ──────────────────────────────────────────
// Supaya tidak perlu menulis Tables<'pegawai'> di setiap file,
// cukup import { Pegawai } from '@/types/supabase'

export type Pegawai = Tables<'pegawai'>
export type PegawaiPribadi = Tables<'pegawai_pribadi'>

// Riwayat
export type RiwayatJabatan = Tables<'riwayat_jabatan'>
export type RiwayatPangkatGolongan = Tables<'riwayat_pangkat_golongan'>
export type RiwayatPendidikan = Tables<'riwayat_pendidikan'>
export type RiwayatDiklat = Tables<'riwayat_diklat'>
export type RiwayatKeluarga = Tables<'riwayat_keluarga'>
export type RiwayatDisiplin = Tables<'riwayat_disiplin'>
export type RiwayatKgb = Tables<'riwayat_kgb'>
export type RiwayatPak = Tables<'riwayat_pak'>
export type RiwayatSkp = Tables<'riwayat_skp'>
export type RiwayatUsulan = Tables<'riwayat_usulan'>

// Dokumen
export type DokumenPegawai = Tables<'dokumen_pegawai'>

// App Settings
export type AppSetting = Tables<'app_settings'>

// Auth & Roles
export type Role = Tables<'roles'>
export type UserRole = Tables<'user_roles'>

// Master Data (yang paling sering dipakai)
export type MasterOpd = Tables<'master_opd'>
export type MasterUnitKerja = Tables<'master_unit_kerja'>
export type MasterGolongan = Tables<'master_golongan'>
export type MasterPangkat = Tables<'master_pangkat'>
export type MasterJabatan = Tables<'master_jabatan'>
export type MasterAgama = Tables<'master_agama'>
export type MasterJenisKelamin = Tables<'master_jenis_kelamin'>
export type MasterStatusKeluarga = Tables<'master_status_keluarga'>
export type MasterStatusPegawai = Tables<'master_status_pegawai'>
export type MasterKedudukan = Tables<'master_kedudukan_hukum'>
export type MasterStatusKerja = Tables<'master_status_kerja'>
export type MasterTingkatPendidikan = Tables<'master_tingkat_pendidikan'>
export type MasterJenisUsulan = Tables<'master_jenis_usulan'>
export type MasterStatusUsulan = Tables<'master_status_usulan'>
