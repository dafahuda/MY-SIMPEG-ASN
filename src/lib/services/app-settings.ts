import { createClient } from '@/supabase/server'

// ─── Type-safe setting keys ──────────────────────────────────────

export type BrandingKey =
  | 'app.name'
  | 'app.description'
  | 'app.logo_url'
  | 'app.favicon_url'
  | 'app.primary_color'
  | 'app.footer_text'
  | 'app.login_banner'

export type InstansiKey =
  | 'inst.nama'
  | 'inst.alamat'
  | 'inst.telepon'
  | 'inst.email'
  | 'inst.website'
  | 'inst.kode_satker'
  | 'inst.kode_bkn'
  | 'inst.kepala_nama'
  | 'inst.kepala_nip'

export type SettingKey = BrandingKey | InstansiKey

// ─── Branding data shape ─────────────────────────────────────────

export type BrandingData = {
  appName: string
  appDescription: string
  logoUrl: string
  faviconUrl: string
  primaryColor: string
  footerText: string
  loginBanner: string
  instansiNama: string
}

// ─── Defaults (fallback jika DB belum tersedia) ──────────────────

const BRANDING_DEFAULTS: BrandingData = {
  appName: 'SIMPEG ASN',
  appDescription: 'Sistem Informasi Manajemen Pegawai ASN',
  logoUrl: '/images/logo.png',
  faviconUrl: '/favicon.ico',
  primaryColor: '#1e40af',
  footerText: '',
  loginBanner: '',
  instansiNama: '',
}

// ─── Fetch semua settings ────────────────────────────────────────
// Langsung query tanpa unstable_cache karena Next.js 16 melarang
// cookies() di dalam cache scope. React request deduplication
// sudah otomatis mencegah query berulang dalam satu render pass.

export async function getAppSettings(
  kategori?: string,
): Promise<Record<string, string | null>> {
  try {
    const supabase = await createClient()

    let query = supabase
      .from('app_settings')
      .select('setting_key, setting_value')
      .order('urutan')

    if (kategori) {
      query = query.eq('kategori', kategori)
    }

    const { data, error } = await query

    if (error) {
      console.error('[app-settings] Failed to fetch:', error.message)
      return {}
    }

    const result: Record<string, string | null> = {}
    for (const row of data ?? []) {
      result[row.setting_key] = row.setting_value
    }
    return result
  } catch {
    // Fail-open: return empty jika DB belum tersedia
    return {}
  }
}

// ─── Fetch single setting ────────────────────────────────────────

export async function getAppSetting(
  key: SettingKey,
): Promise<string | null> {
  const settings = await getAppSettings()
  return settings[key] ?? null
}

// ─── Branding shortcut (sering dipakai di layout) ────────────────
// Mengembalikan objek dengan fallback defaults sehingga UI tidak
// pernah menampilkan string kosong untuk field kritis.

export async function getBranding(): Promise<BrandingData> {
  const s = await getAppSettings()

  return {
    appName: s['app.name'] || BRANDING_DEFAULTS.appName,
    appDescription:
      s['app.description'] || BRANDING_DEFAULTS.appDescription,
    logoUrl: s['app.logo_url'] || BRANDING_DEFAULTS.logoUrl,
    faviconUrl: s['app.favicon_url'] || BRANDING_DEFAULTS.faviconUrl,
    primaryColor:
      s['app.primary_color'] || BRANDING_DEFAULTS.primaryColor,
    footerText: s['app.footer_text'] ?? BRANDING_DEFAULTS.footerText,
    loginBanner: s['app.login_banner'] ?? BRANDING_DEFAULTS.loginBanner,
    instansiNama: s['inst.nama'] ?? BRANDING_DEFAULTS.instansiNama,
  }
}
