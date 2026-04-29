import {
  differenceInMonths,
  differenceInYears,
  format,
  formatDistanceToNow,
} from 'date-fns'
import { id } from 'date-fns/locale'

export function formatTanggal(date: string | Date): string {
  return format(new Date(date), 'dd MMMM yyyy', { locale: id })
}

export function formatTanggalPendek(date: string | Date): string {
  return format(new Date(date), 'dd/MM/yyyy')
}

export function formatRelatif(date: string | Date): string {
  return formatDistanceToNow(new Date(date), { addSuffix: true, locale: id })
}

export function hitungMasaKerja(tmtCpns: string | Date): string {
  const start = new Date(tmtCpns)
  const now = new Date()
  const tahun = differenceInYears(now, start)
  const bulan = differenceInMonths(now, start) % 12

  return `${tahun} tahun ${bulan} bulan`
}

export function hitungBUP(tanggalLahir: string | Date, batasUsia = 58): Date {
  const lahir = new Date(tanggalLahir)

  return new Date(
    lahir.getFullYear() + batasUsia,
    lahir.getMonth(),
    lahir.getDate(),
  )
}
