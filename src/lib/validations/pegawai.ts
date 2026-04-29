import { z } from 'zod'

export const nipSchema = z
  .string()
  .transform((v) => v.replace(/\s/g, ''))
  .pipe(
    z
      .string()
      .length(18, 'NIP harus 18 digit')
      .regex(/^\d+$/, 'NIP hanya boleh angka'),
  )

export const pegawaiFormSchema = z.object({
  nip: nipSchema,
  nama_lengkap: z.string().min(3, 'Nama minimal 3 karakter').max(200),
  gelar_depan: z.string().max(50).optional().nullable(),
  gelar_belakang: z.string().max(50).optional().nullable(),
  status_pegawai_id: z.string().uuid('Pilih status pegawai'),
  kedudukan_hukum_id: z.string().uuid('Pilih kedudukan hukum'),
  status_kerja_id: z.string().uuid('Pilih status kerja'),
  opd_id: z.string().uuid('Pilih OPD'),
  unit_kerja_id: z.string().uuid('Pilih unit kerja').optional().nullable(),
  tmt_cpns: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Format tanggal: YYYY-MM-DD'),
  tmt_pns: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, 'Format tanggal: YYYY-MM-DD')
    .optional()
    .nullable(),
  foto_url: z.string().url().optional().nullable(),
})

export type PegawaiFormValues = z.infer<typeof pegawaiFormSchema>
