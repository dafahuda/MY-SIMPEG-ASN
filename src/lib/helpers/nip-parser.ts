/**
 * Parse NIP ASN (18 digit) → informasi pegawai
 * Format: TTTTMMDD SSSSSS X YY
 * - TTTTMMDD = tanggal lahir
 * - SSSSSS = tanggal pengangkatan (YYYYMM)
 * - X = jenis kelamin (1=pria, 2=wanita)
 * - YY = urutan
 */
export function parseNIP(nip: string) {
  const clean = nip.replace(/\s/g, '')

  if (clean.length !== 18) return null

  const tanggalLahir = `${clean.slice(0, 4)}-${clean.slice(4, 6)}-${clean.slice(6, 8)}`
  const tahunPengangkatan = clean.slice(8, 12)
  const bulanPengangkatan = clean.slice(12, 14)
  const jenisKelamin = clean[14] === '1' ? 'Laki-laki' : 'Perempuan'
  const urutan = clean.slice(15, 18)

  return {
    tanggalLahir,
    tmtCpns: `${tahunPengangkatan}-${bulanPengangkatan}-01`,
    jenisKelamin,
    urutan,
    formatted: `${clean.slice(0, 8)} ${clean.slice(8, 14)} ${clean[14]} ${clean.slice(15)}`,
  }
}

export function formatNIP(nip: string): string {
  const clean = nip.replace(/\s/g, '')

  if (clean.length !== 18) return nip

  return `${clean.slice(0, 8)} ${clean.slice(8, 14)} ${clean[14]} ${clean.slice(15)}`
}

export function isValidNIP(nip: string): boolean {
  const clean = nip.replace(/\s/g, '')

  return /^\d{18}$/.test(clean)
}
