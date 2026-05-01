// ─── Route-to-Permission mapping ─────────────────────────────────
// Mapping route path ke permission code yang dibutuhkan.
// Digunakan oleh:
// - session.ts (server) untuk requireRoutePermission()
// - app-sidebar.tsx (client) untuk filter navigasi

export const ROUTE_PERMISSIONS: Record<string, string> = {
  '/dashboard': 'DASHBOARD.VIEW',
  '/pegawai': 'PEGAWAI.VIEW',
  '/kepangkatan': 'KEPANGKATAN.VIEW',
  '/jabatan': 'JABATAN.VIEW',
  '/pendidikan': 'PENDIDIKAN.VIEW',
  '/diklat': 'DIKLAT.VIEW',
  '/keluarga': 'KELUARGA.VIEW',
  '/kinerja': 'KINERJA.VIEW',
  '/disiplin': 'DISIPLIN.VIEW',
  '/kgb': 'KGB.VIEW',
  '/usulan': 'USULAN.VIEW',
  '/dokumen': 'DOKUMEN.VIEW',
  '/master': 'MASTER.VIEW',
  '/laporan': 'LAPORAN.VIEW',
  '/pengaturan': 'PENGATURAN.VIEW',
}
