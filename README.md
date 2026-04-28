# SIMPEG APP PUSDAYA

Sistem Informasi Manajemen Kepegawaian (SIMPEG) untuk Pusdaya. Aplikasi web berbasis **Next.js 16** dan **Supabase** untuk mengelola data kepegawaian secara digital, termasuk data pegawai, jabatan, kepangkatan, pendidikan, diklat, kinerja, dan lainnya.

## Tech Stack

| Teknologi | Versi | Keterangan |
|-----------|-------|------------|
| [Next.js](https://nextjs.org/) | 16 | React framework (App Router) |
| [React](https://react.dev/) | 19 | UI library |
| [Supabase](https://supabase.com/) | v2 | Backend-as-a-Service (Auth, Database, Storage) |
| [TypeScript](https://www.typescriptlang.org/) | 5.9 | Type-safe JavaScript |
| [Tailwind CSS](https://tailwindcss.com/) | 4 | Utility-first CSS framework |
| [shadcn/ui](https://ui.shadcn.com/) | - | Komponen UI |
| [TanStack Query](https://tanstack.com/query) | v5 | Data fetching & caching |
| [pnpm](https://pnpm.io/) | 10 | Package manager |

## Fitur Modul

- **Dashboard** - Ringkasan data kepegawaian
- **Pegawai** - Manajemen data pegawai
- **Jabatan** - Riwayat jabatan pegawai
- **Kepangkatan** - Riwayat pangkat/golongan
- **Pendidikan** - Riwayat pendidikan
- **Keluarga** - Data keluarga pegawai
- **KGB** - Kenaikan Gaji Berkala
- **Kinerja** - SKP & PAK (Sasaran Kinerja Pegawai & Penilaian Angka Kredit)
- **Disiplin** - Riwayat disiplin pegawai
- **Diklat** - Riwayat pendidikan & pelatihan
- **Dokumen** - Manajemen dokumen pegawai
- **Usulan** - Workflow usulan kepegawaian
- **Laporan** - Laporan & export data
- **Master Data** - Data referensi (unit kerja, jabatan, golongan, dll)
- **Pengaturan** - Konfigurasi sistem

## Prasyarat

Pastikan sudah terinstall di komputer kamu:

- **Node.js** >= 20.18.1 ([Download](https://nodejs.org/))
- **pnpm** >= 10 ([Panduan Install](https://pnpm.io/installation))
- **Git** ([Download](https://git-scm.com/))
- Akun **Supabase** ([Daftar Gratis](https://supabase.com/))

## Instalasi

### 1. Clone Repository

```bash
git clone https://github.com/dafahuda/SIMPEG-APP-PUSDAYA.git
cd SIMPEG-APP-PUSDAYA
```

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Setup Environment Variables

Salin file `.env.example` menjadi `.env.local`:

```bash
# Windows (Command Prompt)
copy .env.example .env.local

# Windows (PowerShell)
Copy-Item .env.example .env.local

# macOS / Linux
cp .env.example .env.local
```

Kemudian buka file `.env.local` dan isi dengan kredensial Supabase kamu:

```env
# Supabase Project URL (dari Dashboard > Settings > API)
NEXT_PUBLIC_SUPABASE_URL=https://[PROJECT-REF].supabase.co

# Supabase Anon Key (dari Dashboard > Settings > API > anon/public)
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=your-anon-key-here

# (Opsional) Service Role Key - untuk server-side operations yang bypass RLS
# JANGAN expose ke client!
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
```

> **Cara mendapatkan kredensial Supabase:**
>
> 1. Login ke [Supabase Dashboard](https://supabase.com/dashboard)
> 2. Pilih project kamu (atau buat project baru)
> 3. Buka **Settings** > **API**
> 4. Salin **Project URL** dan **anon/public key**

### 4. Setup Database (Supabase Migrations)

Project ini sudah menyertakan file migrasi database di folder `supabase/migrations/`. Untuk menerapkan schema ke project Supabase kamu:

```bash
# Install Supabase CLI (jika belum)
pnpm add -g supabase

# Login ke Supabase
supabase login

# Link ke project Supabase kamu
supabase link --project-ref [PROJECT-REF]

# Push migrasi ke database
supabase db push
```

> Ganti `[PROJECT-REF]` dengan Project Reference ID dari Supabase Dashboard kamu.

### 5. Jalankan Development Server

```bash
pnpm dev
```

Buka [http://localhost:3000](http://localhost:3000) di browser.

## Scripts

| Perintah | Keterangan |
|----------|------------|
| `pnpm dev` | Jalankan development server |
| `pnpm build` | Build untuk production |
| `pnpm start` | Jalankan production server |
| `pnpm lint` | Cek linting (ESLint) |
| `pnpm lint-fix` | Auto-fix linting issues |
| `pnpm format` | Format kode (Prettier) |
| `pnpm format-check` | Cek format kode |
| `pnpm type-check` | Cek TypeScript types |
| `pnpm test` | Jalankan unit tests |
| `pnpm test:ci` | Jalankan tests (CI mode) |

## Struktur Folder

```
SIMPEG-APP-PUSDAYA/
├── public/                  # Static assets
├── src/
│   ├── app/                 # Next.js App Router pages
│   │   ├── (dashboard)/     # Dashboard route group
│   │   │   ├── dashboard/   # Halaman dashboard
│   │   │   ├── pegawai/     # Modul pegawai
│   │   │   ├── jabatan/     # Modul jabatan
│   │   │   ├── kepangkatan/ # Modul kepangkatan
│   │   │   ├── pendidikan/  # Modul pendidikan
│   │   │   ├── keluarga/    # Modul keluarga
│   │   │   ├── kgb/         # Modul KGB
│   │   │   ├── kinerja/     # Modul kinerja (SKP & PAK)
│   │   │   ├── disiplin/    # Modul disiplin
│   │   │   ├── diklat/      # Modul diklat
│   │   │   ├── dokumen/     # Modul dokumen
│   │   │   ├── usulan/      # Modul usulan
│   │   │   ├── laporan/     # Modul laporan
│   │   │   ├── master/      # Master data
│   │   │   └── pengaturan/  # Pengaturan sistem
│   │   ├── auth/            # Halaman autentikasi
│   │   └── protected/       # Protected routes
│   ├── components/          # Reusable components
│   │   ├── ui/              # shadcn/ui components
│   │   ├── forms/           # Form components
│   │   ├── tables/          # Table components
│   │   ├── layout/          # Layout components
│   │   └── pegawai/         # Pegawai-specific components
│   ├── hooks/               # Custom React hooks
│   ├── lib/                 # Utility libraries
│   ├── providers/           # React context providers
│   ├── supabase/            # Supabase client config
│   ├── types/               # TypeScript type definitions
│   └── utils/               # Helper functions
├── supabase/
│   ├── config.toml          # Supabase local config
│   ├── migrations/          # Database migrations (SQL)
│   └── seed.sql             # Seed data
├── .env.example             # Template environment variables
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

## Environment Variables

| Variable | Wajib | Keterangan |
|----------|-------|------------|
| `NEXT_PUBLIC_SUPABASE_URL` | Ya | URL project Supabase |
| `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` | Ya | Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Tidak | Service role key (server-side only) |

> **PENTING:** Jangan pernah commit file `.env.local` atau file yang berisi kredensial ke repository. File `.env.example` sudah disediakan sebagai template tanpa nilai sensitif.

## Kontributor

Jika ingin berkontribusi:

1. Fork repository ini
2. Buat branch baru (`git checkout -b feature/nama-fitur`)
3. Commit perubahan (`git commit -m "feat: tambah fitur baru"`)
4. Push ke branch (`git push origin feature/nama-fitur`)
5. Buat Pull Request

## Lisensi

Project ini dilisensikan di bawah [MIT License](LICENSE).
