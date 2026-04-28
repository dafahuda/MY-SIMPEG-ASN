-- ============================================================
-- Seed Data: Master Referensi Inti + Master Workflow + Roles
-- Idempotent upsert by kode_* (ON CONFLICT DO UPDATE)
-- ============================================================

-- -------------------------------------------------------
-- master_status_pegawai
-- -------------------------------------------------------
insert into public.master_status_pegawai (status_pegawai_id, kode_status_pegawai, nama_status_pegawai, urutan, is_active, created_by, updated_by) values
  ('STS-001', 'PNS',   'Pegawai Negeri Sipil',          1, true, 'system_seed', 'system_seed'),
  ('STS-002', 'CPNS',  'Calon Pegawai Negeri Sipil',    2, true, 'system_seed', 'system_seed'),
  ('STS-003', 'PPPK',  'Pegawai Pemerintah dengan Perjanjian Kerja', 3, true, 'system_seed', 'system_seed'),
  ('STS-004', 'PENSIUN', 'Pensiun',                     4, true, 'system_seed', 'system_seed'),
  ('STS-005', 'MENINGGAL', 'Meninggal Dunia',           5, true, 'system_seed', 'system_seed'),
  ('STS-006', 'DIBERHENTIKAN', 'Diberhentikan',          6, true, 'system_seed', 'system_seed')
on conflict (kode_status_pegawai) do update set
  nama_status_pegawai = excluded.nama_status_pegawai,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_kedudukan_hukum
-- -------------------------------------------------------
insert into public.master_kedudukan_hukum (kedudukan_hukum_id, kode_kedudukan_hukum, nama_kedudukan_hukum, urutan, is_active, created_by, updated_by) values
  ('KDH-001', 'AKTIF',              'Aktif',                          1, true, 'system_seed', 'system_seed'),
  ('KDH-002', 'CUTI_LUAR_TANGGUNGAN', 'Cuti di Luar Tanggungan Negara', 2, true, 'system_seed', 'system_seed'),
  ('KDH-003', 'TUGAS_BELAJAR',      'Tugas Belajar',                  3, true, 'system_seed', 'system_seed'),
  ('KDH-004', 'DIPERBANTUKAN',      'Diperbantukan',                  4, true, 'system_seed', 'system_seed'),
  ('KDH-005', 'DIBERHENTIKAN_SEMENTARA', 'Diberhentikan Sementara',   5, true, 'system_seed', 'system_seed')
on conflict (kode_kedudukan_hukum) do update set
  nama_kedudukan_hukum = excluded.nama_kedudukan_hukum,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_kerja
-- -------------------------------------------------------
insert into public.master_status_kerja (status_kerja_id, kode_status_kerja, nama_status_kerja, urutan, is_active, created_by, updated_by) values
  ('SKR-001', 'AKTIF_BEKERJA',  'Aktif Bekerja',           1, true, 'system_seed', 'system_seed'),
  ('SKR-002', 'CUTI',           'Cuti',                     2, true, 'system_seed', 'system_seed'),
  ('SKR-003', 'TUGAS_BELAJAR',  'Tugas Belajar',            3, true, 'system_seed', 'system_seed'),
  ('SKR-004', 'SAKIT_BERKEPANJANGAN', 'Sakit Berkepanjangan', 4, true, 'system_seed', 'system_seed'),
  ('SKR-005', 'TIDAK_AKTIF',    'Tidak Aktif',              5, true, 'system_seed', 'system_seed')
on conflict (kode_status_kerja) do update set
  nama_status_kerja = excluded.nama_status_kerja,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_agama
-- -------------------------------------------------------
insert into public.master_agama (agama_id, kode_agama, nama_agama, urutan, is_active, created_by, updated_by) values
  ('AGM-001', 'ISLAM',     'Islam',     1, true, 'system_seed', 'system_seed'),
  ('AGM-002', 'KRISTEN',   'Kristen',   2, true, 'system_seed', 'system_seed'),
  ('AGM-003', 'KATOLIK',   'Katolik',   3, true, 'system_seed', 'system_seed'),
  ('AGM-004', 'HINDU',     'Hindu',     4, true, 'system_seed', 'system_seed'),
  ('AGM-005', 'BUDDHA',    'Buddha',    5, true, 'system_seed', 'system_seed'),
  ('AGM-006', 'KONGHUCU',  'Konghucu',  6, true, 'system_seed', 'system_seed'),
  ('AGM-007', 'KEPERCAYAAN', 'Kepercayaan terhadap Tuhan YME', 7, true, 'system_seed', 'system_seed')
on conflict (kode_agama) do update set
  nama_agama = excluded.nama_agama,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_perkawinan
-- -------------------------------------------------------
insert into public.master_status_perkawinan (status_perkawinan_id, kode_status_perkawinan, nama_status_perkawinan, urutan, is_active, created_by, updated_by) values
  ('SPW-001', 'BELUM_KAWIN', 'Belum Kawin',  1, true, 'system_seed', 'system_seed'),
  ('SPW-002', 'KAWIN',       'Kawin',         2, true, 'system_seed', 'system_seed'),
  ('SPW-003', 'CERAI_HIDUP', 'Cerai Hidup',   3, true, 'system_seed', 'system_seed'),
  ('SPW-004', 'CERAI_MATI',  'Cerai Mati',    4, true, 'system_seed', 'system_seed')
on conflict (kode_status_perkawinan) do update set
  nama_status_perkawinan = excluded.nama_status_perkawinan,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_keluarga (kontrak seed tetap: MSK-001=SUAMI, MSK-002=ISTRI)
-- -------------------------------------------------------
insert into public.master_status_keluarga (status_keluarga_id, kode_status_keluarga, nama_status_keluarga, urutan, is_active, created_by, updated_by) values
  ('MSK-001', 'SUAMI',  'Suami',  1, true, 'system_seed', 'system_seed'),
  ('MSK-002', 'ISTRI',  'Istri',  2, true, 'system_seed', 'system_seed'),
  ('MSK-003', 'ANAK',   'Anak',   3, true, 'system_seed', 'system_seed'),
  ('MSK-004', 'AYAH',   'Ayah',   4, true, 'system_seed', 'system_seed'),
  ('MSK-005', 'IBU',    'Ibu',    5, true, 'system_seed', 'system_seed')
on conflict (kode_status_keluarga) do update set
  nama_status_keluarga = excluded.nama_status_keluarga,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_tingkat_pendidikan
-- -------------------------------------------------------
insert into public.master_tingkat_pendidikan (tingkat_pendidikan_id, kode_tingkat_pendidikan, nama_tingkat_pendidikan, urutan, is_active, created_by, updated_by) values
  ('TPD-001', 'SD',    'Sekolah Dasar',                    1, true, 'system_seed', 'system_seed'),
  ('TPD-002', 'SMP',   'Sekolah Menengah Pertama',         2, true, 'system_seed', 'system_seed'),
  ('TPD-003', 'SMA',   'Sekolah Menengah Atas',            3, true, 'system_seed', 'system_seed'),
  ('TPD-004', 'D1',    'Diploma I',                        4, true, 'system_seed', 'system_seed'),
  ('TPD-005', 'D2',    'Diploma II',                       5, true, 'system_seed', 'system_seed'),
  ('TPD-006', 'D3',    'Diploma III',                      6, true, 'system_seed', 'system_seed'),
  ('TPD-007', 'D4',    'Diploma IV / Sarjana Terapan',     7, true, 'system_seed', 'system_seed'),
  ('TPD-008', 'S1',    'Sarjana (S1)',                     8, true, 'system_seed', 'system_seed'),
  ('TPD-009', 'S2',    'Magister (S2)',                    9, true, 'system_seed', 'system_seed'),
  ('TPD-010', 'S3',    'Doktor (S3)',                      10, true, 'system_seed', 'system_seed')
on conflict (kode_tingkat_pendidikan) do update set
  nama_tingkat_pendidikan = excluded.nama_tingkat_pendidikan,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_studi
-- -------------------------------------------------------
insert into public.master_status_studi (status_studi_id, kode_status_studi, nama_status_studi, urutan, is_active, created_by, updated_by) values
  ('SST-001', 'TIDAK_TUBEL',  'Bukan Tugas Belajar',  1, true, 'system_seed', 'system_seed'),
  ('SST-002', 'TUBEL',        'Tugas Belajar',         2, true, 'system_seed', 'system_seed'),
  ('SST-003', 'IZIN_BELAJAR', 'Izin Belajar',          3, true, 'system_seed', 'system_seed')
on conflict (kode_status_studi) do update set
  nama_status_studi = excluded.nama_status_studi,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_jenis_jabatan
-- -------------------------------------------------------
insert into public.master_jenis_jabatan (jenis_jabatan_id, kode_jenis_jabatan, nama_jenis_jabatan, urutan, is_active, created_by, updated_by) values
  ('JNJ-001', 'STRUKTURAL',  'Jabatan Struktural',                1, true, 'system_seed', 'system_seed'),
  ('JNJ-002', 'FUNGSIONAL',  'Jabatan Fungsional',                2, true, 'system_seed', 'system_seed'),
  ('JNJ-003', 'PELAKSANA',   'Jabatan Pelaksana',                 3, true, 'system_seed', 'system_seed'),
  ('JNJ-004', 'JPT_PRATAMA', 'Jabatan Pimpinan Tinggi Pratama',   4, true, 'system_seed', 'system_seed'),
  ('JNJ-005', 'JPT_MADYA',   'Jabatan Pimpinan Tinggi Madya',     5, true, 'system_seed', 'system_seed'),
  ('JNJ-006', 'JPT_UTAMA',   'Jabatan Pimpinan Tinggi Utama',     6, true, 'system_seed', 'system_seed')
on conflict (kode_jenis_jabatan) do update set
  nama_jenis_jabatan = excluded.nama_jenis_jabatan,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_eselon
-- -------------------------------------------------------
insert into public.master_eselon (eselon_id, kode_eselon, nama_eselon, urutan, is_active, created_by, updated_by) values
  ('ESL-001', 'I.A',   'Eselon I.a',   1, true, 'system_seed', 'system_seed'),
  ('ESL-002', 'I.B',   'Eselon I.b',   2, true, 'system_seed', 'system_seed'),
  ('ESL-003', 'II.A',  'Eselon II.a',  3, true, 'system_seed', 'system_seed'),
  ('ESL-004', 'II.B',  'Eselon II.b',  4, true, 'system_seed', 'system_seed'),
  ('ESL-005', 'III.A', 'Eselon III.a', 5, true, 'system_seed', 'system_seed'),
  ('ESL-006', 'III.B', 'Eselon III.b', 6, true, 'system_seed', 'system_seed'),
  ('ESL-007', 'IV.A',  'Eselon IV.a',  7, true, 'system_seed', 'system_seed'),
  ('ESL-008', 'IV.B',  'Eselon IV.b',  8, true, 'system_seed', 'system_seed'),
  ('ESL-009', 'V',     'Eselon V',     9, true, 'system_seed', 'system_seed')
on conflict (kode_eselon) do update set
  nama_eselon = excluded.nama_eselon,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_pangkat
-- -------------------------------------------------------
insert into public.master_pangkat (pangkat_id, kode_pangkat, nama_pangkat, urutan, is_active, created_by, updated_by) values
  ('PKT-001', 'JURU_MUDA',           'Juru Muda',                1, true, 'system_seed', 'system_seed'),
  ('PKT-002', 'JURU_MUDA_TK_I',      'Juru Muda Tingkat I',      2, true, 'system_seed', 'system_seed'),
  ('PKT-003', 'JURU',                 'Juru',                     3, true, 'system_seed', 'system_seed'),
  ('PKT-004', 'JURU_TK_I',           'Juru Tingkat I',           4, true, 'system_seed', 'system_seed'),
  ('PKT-005', 'PENGATUR_MUDA',       'Pengatur Muda',            5, true, 'system_seed', 'system_seed'),
  ('PKT-006', 'PENGATUR_MUDA_TK_I',  'Pengatur Muda Tingkat I',  6, true, 'system_seed', 'system_seed'),
  ('PKT-007', 'PENGATUR',            'Pengatur',                 7, true, 'system_seed', 'system_seed'),
  ('PKT-008', 'PENGATUR_TK_I',       'Pengatur Tingkat I',       8, true, 'system_seed', 'system_seed'),
  ('PKT-009', 'PENATA_MUDA',         'Penata Muda',              9, true, 'system_seed', 'system_seed'),
  ('PKT-010', 'PENATA_MUDA_TK_I',    'Penata Muda Tingkat I',    10, true, 'system_seed', 'system_seed'),
  ('PKT-011', 'PENATA',              'Penata',                   11, true, 'system_seed', 'system_seed'),
  ('PKT-012', 'PENATA_TK_I',         'Penata Tingkat I',         12, true, 'system_seed', 'system_seed'),
  ('PKT-013', 'PEMBINA',             'Pembina',                  13, true, 'system_seed', 'system_seed'),
  ('PKT-014', 'PEMBINA_TK_I',        'Pembina Tingkat I',        14, true, 'system_seed', 'system_seed'),
  ('PKT-015', 'PEMBINA_UTAMA_MUDA',  'Pembina Utama Muda',       15, true, 'system_seed', 'system_seed'),
  ('PKT-016', 'PEMBINA_UTAMA_MADYA', 'Pembina Utama Madya',      16, true, 'system_seed', 'system_seed'),
  ('PKT-017', 'PEMBINA_UTAMA',       'Pembina Utama',            17, true, 'system_seed', 'system_seed')
on conflict (kode_pangkat) do update set
  nama_pangkat = excluded.nama_pangkat,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_golongan
-- -------------------------------------------------------
insert into public.master_golongan (golongan_id, kode_golongan, nama_golongan, urutan, is_active, created_by, updated_by) values
  ('GOL-001', 'I/a',   'Golongan I/a',   1, true, 'system_seed', 'system_seed'),
  ('GOL-002', 'I/b',   'Golongan I/b',   2, true, 'system_seed', 'system_seed'),
  ('GOL-003', 'I/c',   'Golongan I/c',   3, true, 'system_seed', 'system_seed'),
  ('GOL-004', 'I/d',   'Golongan I/d',   4, true, 'system_seed', 'system_seed'),
  ('GOL-005', 'II/a',  'Golongan II/a',  5, true, 'system_seed', 'system_seed'),
  ('GOL-006', 'II/b',  'Golongan II/b',  6, true, 'system_seed', 'system_seed'),
  ('GOL-007', 'II/c',  'Golongan II/c',  7, true, 'system_seed', 'system_seed'),
  ('GOL-008', 'II/d',  'Golongan II/d',  8, true, 'system_seed', 'system_seed'),
  ('GOL-009', 'III/a', 'Golongan III/a', 9, true, 'system_seed', 'system_seed'),
  ('GOL-010', 'III/b', 'Golongan III/b', 10, true, 'system_seed', 'system_seed'),
  ('GOL-011', 'III/c', 'Golongan III/c', 11, true, 'system_seed', 'system_seed'),
  ('GOL-012', 'III/d', 'Golongan III/d', 12, true, 'system_seed', 'system_seed'),
  ('GOL-013', 'IV/a',  'Golongan IV/a',  13, true, 'system_seed', 'system_seed'),
  ('GOL-014', 'IV/b',  'Golongan IV/b',  14, true, 'system_seed', 'system_seed'),
  ('GOL-015', 'IV/c',  'Golongan IV/c',  15, true, 'system_seed', 'system_seed'),
  ('GOL-016', 'IV/d',  'Golongan IV/d',  16, true, 'system_seed', 'system_seed'),
  ('GOL-017', 'IV/e',  'Golongan IV/e',  17, true, 'system_seed', 'system_seed')
on conflict (kode_golongan) do update set
  nama_golongan = excluded.nama_golongan,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_jenis_kenaikan_pangkat
-- -------------------------------------------------------
insert into public.master_jenis_kenaikan_pangkat (jenis_kenaikan_id, kode_jenis_kenaikan, nama_jenis_kenaikan, urutan, is_active, created_by, updated_by) values
  ('JKP-001', 'REGULER',       'Kenaikan Pangkat Reguler',          1, true, 'system_seed', 'system_seed'),
  ('JKP-002', 'PILIHAN',       'Kenaikan Pangkat Pilihan',          2, true, 'system_seed', 'system_seed'),
  ('JKP-003', 'ISTIMEWA',      'Kenaikan Pangkat Istimewa',         3, true, 'system_seed', 'system_seed'),
  ('JKP-004', 'PENGABDIAN',    'Kenaikan Pangkat Pengabdian',       4, true, 'system_seed', 'system_seed'),
  ('JKP-005', 'ANUMERTA',      'Kenaikan Pangkat Anumerta',         5, true, 'system_seed', 'system_seed'),
  ('JKP-006', 'PENYESUAIAN',   'Kenaikan Pangkat Penyesuaian Ijazah', 6, true, 'system_seed', 'system_seed')
on conflict (kode_jenis_kenaikan) do update set
  nama_jenis_kenaikan = excluded.nama_jenis_kenaikan,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_jenis_pak
-- -------------------------------------------------------
insert into public.master_jenis_pak (jenis_pak_id, kode_jenis_pak, nama_jenis_pak, urutan, is_active, created_by, updated_by) values
  ('JPK-001', 'INTEGRASI',  'PAK Integrasi',   1, true, 'system_seed', 'system_seed'),
  ('JPK-002', 'KONVERSI',   'PAK Konversi',    2, true, 'system_seed', 'system_seed'),
  ('JPK-003', 'REGULER',    'PAK Reguler',     3, true, 'system_seed', 'system_seed')
on conflict (kode_jenis_pak) do update set
  nama_jenis_pak = excluded.nama_jenis_pak,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_dokumen
-- -------------------------------------------------------
insert into public.master_status_dokumen (status_dokumen_id, kode_status_dokumen, nama_status_dokumen, is_final, urutan, is_active, created_by, updated_by) values
  ('SDK-001', 'DRAFT',      'Draft',       false, 1, true, 'system_seed', 'system_seed'),
  ('SDK-002', 'DIAJUKAN',   'Diajukan',    false, 2, true, 'system_seed', 'system_seed'),
  ('SDK-003', 'DIVERIFIKASI', 'Diverifikasi', false, 3, true, 'system_seed', 'system_seed'),
  ('SDK-004', 'DISETUJUI',  'Disetujui',   true,  4, true, 'system_seed', 'system_seed'),
  ('SDK-005', 'DITOLAK',    'Ditolak',     true,  5, true, 'system_seed', 'system_seed')
on conflict (kode_status_dokumen) do update set
  nama_status_dokumen = excluded.nama_status_dokumen,
  is_final = excluded.is_final,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_tingkat_hukuman
-- -------------------------------------------------------
insert into public.master_tingkat_hukuman (tingkat_hukuman_id, kode_tingkat_hukuman, nama_tingkat_hukuman, urutan, is_active, created_by, updated_by) values
  ('THK-001', 'RINGAN',  'Hukuman Disiplin Ringan',  1, true, 'system_seed', 'system_seed'),
  ('THK-002', 'SEDANG',  'Hukuman Disiplin Sedang',  2, true, 'system_seed', 'system_seed'),
  ('THK-003', 'BERAT',   'Hukuman Disiplin Berat',   3, true, 'system_seed', 'system_seed')
on conflict (kode_tingkat_hukuman) do update set
  nama_tingkat_hukuman = excluded.nama_tingkat_hukuman,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_jenis_hukuman
-- -------------------------------------------------------
insert into public.master_jenis_hukuman (jenis_hukuman_id, kode_jenis_hukuman, nama_jenis_hukuman, tingkat_hukuman_id, urutan, is_active, created_by, updated_by) values
  ('JHK-001', 'TEGURAN_LISAN',       'Teguran Lisan',                          'THK-001', 1, true, 'system_seed', 'system_seed'),
  ('JHK-002', 'TEGURAN_TERTULIS',    'Teguran Tertulis',                       'THK-001', 2, true, 'system_seed', 'system_seed'),
  ('JHK-003', 'PERNYATAAN_TIDAK_PUAS', 'Pernyataan Tidak Puas Secara Tertulis', 'THK-001', 3, true, 'system_seed', 'system_seed'),
  ('JHK-004', 'PENUNDAAN_KP',        'Penundaan Kenaikan Pangkat',             'THK-002', 4, true, 'system_seed', 'system_seed'),
  ('JHK-005', 'PENURUNAN_PANGKAT',   'Penurunan Pangkat Setingkat Lebih Rendah', 'THK-002', 5, true, 'system_seed', 'system_seed'),
  ('JHK-006', 'PEMBEBASAN_JABATAN',  'Pembebasan dari Jabatan',               'THK-002', 6, true, 'system_seed', 'system_seed'),
  ('JHK-007', 'PEMBERHENTIAN_HORMAT', 'Pemberhentian dengan Hormat Tidak Atas Permintaan Sendiri', 'THK-003', 7, true, 'system_seed', 'system_seed'),
  ('JHK-008', 'PEMBERHENTIAN_TIDAK_HORMAT', 'Pemberhentian Tidak dengan Hormat', 'THK-003', 8, true, 'system_seed', 'system_seed')
on conflict (kode_jenis_hukuman) do update set
  nama_jenis_hukuman = excluded.nama_jenis_hukuman,
  tingkat_hukuman_id = excluded.tingkat_hukuman_id,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_proses_disiplin
-- -------------------------------------------------------
insert into public.master_status_proses_disiplin (status_proses_id, kode_status_proses, nama_status_proses, urutan, is_active, created_by, updated_by) values
  ('SPD-001', 'PELAPORAN',    'Pelaporan',                1, true, 'system_seed', 'system_seed'),
  ('SPD-002', 'PEMERIKSAAN',  'Pemeriksaan',              2, true, 'system_seed', 'system_seed'),
  ('SPD-003', 'PENJATUHAN',   'Penjatuhan Hukuman',       3, true, 'system_seed', 'system_seed'),
  ('SPD-004', 'PELAKSANAAN',  'Pelaksanaan Hukuman',      4, true, 'system_seed', 'system_seed'),
  ('SPD-005', 'SELESAI',      'Selesai',                  5, true, 'system_seed', 'system_seed'),
  ('SPD-006', 'REHABILITASI', 'Rehabilitasi',             6, true, 'system_seed', 'system_seed')
on conflict (kode_status_proses) do update set
  nama_status_proses = excluded.nama_status_proses,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_predikat_skp
-- -------------------------------------------------------
insert into public.master_predikat_skp (predikat_id, kode_predikat, nama_predikat, nilai_minimum, nilai_maksimum, urutan, is_active, created_by, updated_by) values
  ('PSK-001', 'SANGAT_BAIK',    'Sangat Baik',    91.00, 100.00, 1, true, 'system_seed', 'system_seed'),
  ('PSK-002', 'BAIK',           'Baik',            76.00,  90.99, 2, true, 'system_seed', 'system_seed'),
  ('PSK-003', 'CUKUP',          'Cukup',           61.00,  75.99, 3, true, 'system_seed', 'system_seed'),
  ('PSK-004', 'KURANG',         'Kurang',          51.00,  60.99, 4, true, 'system_seed', 'system_seed'),
  ('PSK-005', 'SANGAT_KURANG',  'Sangat Kurang',    0.00,  50.99, 5, true, 'system_seed', 'system_seed')
on conflict (kode_predikat) do update set
  nama_predikat = excluded.nama_predikat,
  nilai_minimum = excluded.nilai_minimum,
  nilai_maksimum = excluded.nilai_maksimum,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_jenjang_skp
-- -------------------------------------------------------
insert into public.master_jenjang_skp (jenjang_id, kode_jenjang, nama_jenjang, urutan, is_active, created_by, updated_by) values
  ('JSK-001', 'PELAKSANA',  'Pelaksana',   1, true, 'system_seed', 'system_seed'),
  ('JSK-002', 'PENGAWAS',   'Pengawas',    2, true, 'system_seed', 'system_seed'),
  ('JSK-003', 'ADMINISTRATOR', 'Administrator', 3, true, 'system_seed', 'system_seed'),
  ('JSK-004', 'JPT',        'Jabatan Pimpinan Tinggi', 4, true, 'system_seed', 'system_seed')
on conflict (kode_jenjang) do update set
  nama_jenjang = excluded.nama_jenjang,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_jenis_dokumen
-- -------------------------------------------------------
insert into public.master_jenis_dokumen (jenis_dokumen_id, kode_jenis_dokumen, nama_jenis_dokumen, modul_sumber_default, is_wajib, urutan, is_active, created_by, updated_by) values
  ('JDK-001', 'SK_CPNS',          'SK CPNS',                    'PROFIL',   true,  1, true, 'system_seed', 'system_seed'),
  ('JDK-002', 'SK_PNS',           'SK PNS',                     'PROFIL',   true,  2, true, 'system_seed', 'system_seed'),
  ('JDK-003', 'SK_PANGKAT',       'SK Kenaikan Pangkat',        'PANGKAT',  false, 3, true, 'system_seed', 'system_seed'),
  ('JDK-004', 'SK_JABATAN',       'SK Jabatan',                 'JABATAN',  false, 4, true, 'system_seed', 'system_seed'),
  ('JDK-005', 'IJAZAH',           'Ijazah',                     'PENDIDIKAN', false, 5, true, 'system_seed', 'system_seed'),
  ('JDK-006', 'SERTIFIKAT_DIKLAT', 'Sertifikat Diklat',         'DIKLAT',   false, 6, true, 'system_seed', 'system_seed'),
  ('JDK-007', 'SK_KGB',           'SK Kenaikan Gaji Berkala',   'KGB',      false, 7, true, 'system_seed', 'system_seed'),
  ('JDK-008', 'SK_HUKUMAN',       'SK Hukuman Disiplin',        'DISIPLIN', false, 8, true, 'system_seed', 'system_seed'),
  ('JDK-009', 'DOKUMEN_SKP',      'Dokumen SKP',                'SKP',      false, 9, true, 'system_seed', 'system_seed'),
  ('JDK-010', 'SK_PAK',           'SK Penetapan Angka Kredit',  'PAK',      false, 10, true, 'system_seed', 'system_seed'),
  ('JDK-011', 'KTP',              'Kartu Tanda Penduduk',       'PROFIL',   true,  11, true, 'system_seed', 'system_seed'),
  ('JDK-012', 'NPWP',             'NPWP',                       'PROFIL',   false, 12, true, 'system_seed', 'system_seed'),
  ('JDK-013', 'AKTA_NIKAH',       'Akta Nikah',                 'KELUARGA', false, 13, true, 'system_seed', 'system_seed'),
  ('JDK-014', 'AKTA_KELAHIRAN',   'Akta Kelahiran Anak',        'KELUARGA', false, 14, true, 'system_seed', 'system_seed'),
  ('JDK-015', 'FOTO_PEGAWAI',     'Foto Pegawai',               'PROFIL',   true,  15, true, 'system_seed', 'system_seed'),
  ('JDK-016', 'LAINNYA',          'Dokumen Lainnya',            null,       false, 99, true, 'system_seed', 'system_seed')
on conflict (kode_jenis_dokumen) do update set
  nama_jenis_dokumen = excluded.nama_jenis_dokumen,
  modul_sumber_default = excluded.modul_sumber_default,
  is_wajib = excluded.is_wajib,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_opd (contoh data — sesuaikan dengan instansi)
-- -------------------------------------------------------
insert into public.master_opd (opd_id, kode_opd, nama_opd, urutan, is_active, created_by, updated_by) values
  ('OPD-001', 'BKPSDM',  'Badan Kepegawaian dan Pengembangan SDM', 1, true, 'system_seed', 'system_seed'),
  ('OPD-002', 'BAPPEDA', 'Badan Perencanaan Pembangunan Daerah',   2, true, 'system_seed', 'system_seed'),
  ('OPD-003', 'DINKES',  'Dinas Kesehatan',                        3, true, 'system_seed', 'system_seed'),
  ('OPD-004', 'DISDIK',  'Dinas Pendidikan',                       4, true, 'system_seed', 'system_seed'),
  ('OPD-005', 'DPUPR',   'Dinas Pekerjaan Umum dan Penataan Ruang', 5, true, 'system_seed', 'system_seed')
on conflict (kode_opd) do update set
  nama_opd = excluded.nama_opd,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_unit_kerja (contoh data — sesuaikan dengan instansi)
-- -------------------------------------------------------
insert into public.master_unit_kerja (unit_kerja_id, kode_unit_kerja, nama_unit_kerja, opd_id, urutan, is_active, created_by, updated_by) values
  ('UK-001', 'BKPSDM-SEKRETARIAT', 'Sekretariat BKPSDM',                    'OPD-001', 1, true, 'system_seed', 'system_seed'),
  ('UK-002', 'BKPSDM-BID-MUTASI',  'Bidang Mutasi dan Kepangkatan',         'OPD-001', 2, true, 'system_seed', 'system_seed'),
  ('UK-003', 'BKPSDM-BID-DIKLAT',  'Bidang Pendidikan dan Pelatihan',       'OPD-001', 3, true, 'system_seed', 'system_seed'),
  ('UK-004', 'BKPSDM-BID-FORMASI', 'Bidang Formasi dan Pengadaan',          'OPD-001', 4, true, 'system_seed', 'system_seed'),
  ('UK-005', 'BKPSDM-BID-PENILAIAN', 'Bidang Penilaian Kinerja dan Disiplin', 'OPD-001', 5, true, 'system_seed', 'system_seed')
on conflict (kode_unit_kerja) do update set
  nama_unit_kerja = excluded.nama_unit_kerja,
  opd_id = excluded.opd_id,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- ============================================================
-- Master Workflow Seeds
-- ============================================================

-- -------------------------------------------------------
-- master_jenis_usulan
-- -------------------------------------------------------
insert into public.master_jenis_usulan (jenis_usulan_id, kode_jenis_usulan, nama_jenis_usulan, modul_sumber_default, requires_approval, urutan, is_active, created_by, updated_by) values
  ('JUS-001', 'KENAIKAN_PANGKAT',  'Usulan Kenaikan Pangkat',       'PANGKAT',     true,  1, true, 'system_seed', 'system_seed'),
  ('JUS-002', 'MUTASI_JABATAN',    'Usulan Mutasi Jabatan',         'JABATAN',     true,  2, true, 'system_seed', 'system_seed'),
  ('JUS-003', 'PENSIUN',           'Usulan Pensiun',                'PENSIUN',     true,  3, true, 'system_seed', 'system_seed'),
  ('JUS-004', 'KGB',               'Usulan KGB',                    'KGB',         true,  4, true, 'system_seed', 'system_seed'),
  ('JUS-005', 'UPDATE_DATA',       'Usulan Perubahan Data Pegawai', 'PROFIL',      true,  5, true, 'system_seed', 'system_seed'),
  ('JUS-006', 'TUGAS_BELAJAR',     'Usulan Tugas Belajar',          'PENDIDIKAN',  true,  6, true, 'system_seed', 'system_seed'),
  ('JUS-007', 'DIKLAT',            'Usulan Diklat',                 'DIKLAT',      false, 7, true, 'system_seed', 'system_seed')
on conflict (kode_jenis_usulan) do update set
  nama_jenis_usulan = excluded.nama_jenis_usulan,
  modul_sumber_default = excluded.modul_sumber_default,
  requires_approval = excluded.requires_approval,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_status_usulan
-- -------------------------------------------------------
insert into public.master_status_usulan (status_usulan_id, kode_status_usulan, nama_status_usulan, is_final, urutan, is_active, created_by, updated_by) values
  ('STU-001', 'DRAFT',        'Draft',                  false, 1, true, 'system_seed', 'system_seed'),
  ('STU-002', 'DIAJUKAN',     'Diajukan',               false, 2, true, 'system_seed', 'system_seed'),
  ('STU-003', 'DIVERIFIKASI', 'Diverifikasi',           false, 3, true, 'system_seed', 'system_seed'),
  ('STU-004', 'DISETUJUI',    'Disetujui',              true,  4, true, 'system_seed', 'system_seed'),
  ('STU-005', 'DITOLAK',      'Ditolak',                true,  5, true, 'system_seed', 'system_seed'),
  ('STU-006', 'DIKEMBALIKAN', 'Dikembalikan / Revisi',  false, 6, true, 'system_seed', 'system_seed'),
  ('STU-007', 'DIBATALKAN',   'Dibatalkan',             true,  7, true, 'system_seed', 'system_seed')
on conflict (kode_status_usulan) do update set
  nama_status_usulan = excluded.nama_status_usulan,
  is_final = excluded.is_final,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_aksi_approval
-- -------------------------------------------------------
insert into public.master_aksi_approval (aksi_approval_id, kode_aksi_approval, nama_aksi_approval, urutan, is_active, created_by, updated_by) values
  ('AAP-001', 'SUBMIT',     'Submit Usulan',       1, true, 'system_seed', 'system_seed'),
  ('AAP-002', 'VERIFY',     'Verifikasi',          2, true, 'system_seed', 'system_seed'),
  ('AAP-003', 'APPROVE',    'Setujui',             3, true, 'system_seed', 'system_seed'),
  ('AAP-004', 'REJECT',     'Tolak',               4, true, 'system_seed', 'system_seed'),
  ('AAP-005', 'RETURN',     'Kembalikan / Revisi', 5, true, 'system_seed', 'system_seed'),
  ('AAP-006', 'CANCEL',     'Batalkan',            6, true, 'system_seed', 'system_seed')
on conflict (kode_aksi_approval) do update set
  nama_aksi_approval = excluded.nama_aksi_approval,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- -------------------------------------------------------
-- master_aksi_audit
-- -------------------------------------------------------
insert into public.master_aksi_audit (aksi_audit_id, kode_aksi_audit, nama_aksi_audit, kategori_aksi, urutan, is_active, created_by, updated_by) values
  ('AAU-001', 'CREATE',     'Buat Data',           'DATA',     1, true, 'system_seed', 'system_seed'),
  ('AAU-002', 'UPDATE',     'Ubah Data',           'DATA',     2, true, 'system_seed', 'system_seed'),
  ('AAU-003', 'DELETE',     'Hapus Data',          'DATA',     3, true, 'system_seed', 'system_seed'),
  ('AAU-004', 'DEACTIVATE', 'Nonaktifkan',         'DATA',     4, true, 'system_seed', 'system_seed'),
  ('AAU-005', 'LOGIN',      'Login',               'AUTH',     5, true, 'system_seed', 'system_seed'),
  ('AAU-006', 'LOGOUT',     'Logout',              'AUTH',     6, true, 'system_seed', 'system_seed'),
  ('AAU-007', 'EXPORT',     'Export Data',          'REPORT',   7, true, 'system_seed', 'system_seed'),
  ('AAU-008', 'IMPORT',     'Import Data',          'DATA',     8, true, 'system_seed', 'system_seed')
on conflict (kode_aksi_audit) do update set
  nama_aksi_audit = excluded.nama_aksi_audit,
  kategori_aksi = excluded.kategori_aksi,
  urutan = excluded.urutan,
  updated_at = now(),
  updated_by = 'system_seed';

-- ============================================================
-- Roles Seeds (kontrak lintas environment)
-- ============================================================
insert into public.roles (role_id, kode_role, nama_role, deskripsi, is_system, is_active, created_by, updated_by) values
  ('ROL-001', 'SUPERADMIN',      'Super Administrator',     'Akses penuh ke seluruh sistem',                          true, true, 'system_seed', 'system_seed'),
  ('ROL-002', 'ADMIN_OPD',       'Admin OPD',               'Mengelola data pegawai dalam lingkup OPD',               true, true, 'system_seed', 'system_seed'),
  ('ROL-003', 'VERIFIKATOR_BKD', 'Verifikator BKD',         'Memverifikasi usulan kepegawaian',                       true, true, 'system_seed', 'system_seed'),
  ('ROL-004', 'APPROVER_BKD',    'Approver BKD',            'Menyetujui atau menolak usulan kepegawaian',             true, true, 'system_seed', 'system_seed'),
  ('ROL-005', 'PEGAWAI',         'Pegawai',                 'Akses self-service untuk melihat dan mengajukan data',   true, true, 'system_seed', 'system_seed')
on conflict (kode_role) do update set
  nama_role = excluded.nama_role,
  deskripsi = excluded.deskripsi,
  updated_at = now(),
  updated_by = 'system_seed';
