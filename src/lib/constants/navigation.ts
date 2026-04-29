import {
  LayoutDashboard,
  Users,
  Award,
  Briefcase,
  GraduationCap,
  BookOpen,
  Heart,
  Target,
  Scale,
  TrendingUp,
  FileText,
  FolderOpen,
  Database,
  BarChart3,
  Settings,
  type LucideIcon,
} from 'lucide-react'

export type NavItem = {
  title: string
  href: string
  icon: LucideIcon
  badge?: string
  children?: NavItem[]
}

export type NavGroup = {
  label: string
  items: NavItem[]
}

export const SIDEBAR_NAV: NavGroup[] = [
  {
    label: 'Utama',
    items: [
      { title: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
      { title: 'Data Pegawai', href: '/pegawai', icon: Users },
    ],
  },
  {
    label: 'Riwayat',
    items: [
      { title: 'Kepangkatan', href: '/kepangkatan', icon: Award },
      { title: 'Jabatan', href: '/jabatan', icon: Briefcase },
      { title: 'Pendidikan', href: '/pendidikan', icon: GraduationCap },
      { title: 'Diklat', href: '/diklat', icon: BookOpen },
      { title: 'Keluarga', href: '/keluarga', icon: Heart },
    ],
  },
  {
    label: 'Kinerja & Disiplin',
    items: [
      { title: 'SKP & PAK', href: '/kinerja', icon: Target },
      { title: 'Disiplin', href: '/disiplin', icon: Scale },
      { title: 'KGB', href: '/kgb', icon: TrendingUp },
    ],
  },
  {
    label: 'Workflow',
    items: [
      { title: 'Usulan', href: '/usulan', icon: FileText },
      { title: 'Dokumen', href: '/dokumen', icon: FolderOpen },
    ],
  },
  {
    label: 'Administrasi',
    items: [
      { title: 'Master Data', href: '/master', icon: Database },
      { title: 'Laporan', href: '/laporan', icon: BarChart3 },
      { title: 'Pengaturan', href: '/pengaturan', icon: Settings },
    ],
  },
]
