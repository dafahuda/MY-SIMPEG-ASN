-- ============================================================================
-- Migration: Permission Integration (Fase 10C)
-- Deskripsi: authorize() function untuk RLS + seed default role_permissions
-- Dependency: 20260428000013_permission_matrix.sql (Fase 10B)
-- ============================================================================

-- ─── Task 10C.0: authorize() function ───────────────────────────────────────
-- Function yang bisa dipanggil dari RLS policies untuk cek permission.
-- Membaca user_roles dari JWT claims (diinject oleh custom_access_token_hook).
-- SECURITY DEFINER agar bisa query role_permissions tanpa RLS recursion.
-- Cek rp.is_active untuk support soft-disable permission.

create or replace function public.authorize(requested_permission text)
returns boolean
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  user_roles_arr jsonb;
  has_permission boolean := false;
begin
  -- Ambil array role dari JWT claims
  user_roles_arr := auth.jwt()->'user_roles';

  -- Jika tidak ada roles, deny
  if user_roles_arr is null or jsonb_array_length(user_roles_arr) = 0 then
    return false;
  end if;

  -- SUPERADMIN bypass: jika level >= 99, selalu true
  if (auth.jwt()->>'user_role_level')::int >= 99 then
    return true;
  end if;

  -- Cek apakah salah satu role user punya permission yang diminta
  -- Multi-role: UNION — jika salah satu role punya permission, return true
  select exists(
    select 1
    from public.role_permissions rp
    join public.permissions p on p.permission_id = rp.permission_id
    join public.roles r on r.role_id = rp.role_id
    where p.kode_permission = requested_permission
      and rp.is_active = true
      and p.is_active = true
      and r.is_active = true
      and r.kode_role in (select jsonb_array_elements_text(user_roles_arr))
  ) into has_permission;

  return has_permission;
end;
$$;

-- Grant: hanya authenticated yang bisa panggil
grant execute on function public.authorize(text) to authenticated;
revoke execute on function public.authorize(text) from anon, public;

comment on function public.authorize(text) is
  'Cek apakah user saat ini punya permission tertentu. Digunakan di RLS policies. Membaca role dari JWT claims. Cek rp.is_active untuk soft-disable support.';

-- ─── Task 10C.1: Seed default role_permissions ──────────────────────────────

-- SUPERADMIN: semua permissions (auto-grant)
insert into public.role_permissions (role_permission_id, role_id, permission_id, granted_by)
select
  'RP-SA-' || lpad(row_number() over (order by permission_id)::text, 3, '0'),
  'ROL-001',
  permission_id,
  'SYSTEM'
from public.permissions
where is_active = true
on conflict (role_id, permission_id) do nothing;

-- ADMIN_OPD: VIEW + CREATE + EDIT semua modul data + EXPORT + VIEW laporan/master
insert into public.role_permissions (role_permission_id, role_id, permission_id, granted_by)
select
  'RP-AO-' || lpad(row_number() over (order by permission_id)::text, 3, '0'),
  'ROL-002',
  permission_id,
  'SYSTEM'
from public.permissions
where kode_permission in (
  'DASHBOARD.VIEW',
  'PEGAWAI.VIEW', 'PEGAWAI.CREATE', 'PEGAWAI.EDIT', 'PEGAWAI.EXPORT',
  'KEPANGKATAN.VIEW', 'KEPANGKATAN.CREATE', 'KEPANGKATAN.EDIT',
  'JABATAN.VIEW', 'JABATAN.CREATE', 'JABATAN.EDIT',
  'PENDIDIKAN.VIEW', 'PENDIDIKAN.CREATE', 'PENDIDIKAN.EDIT',
  'DIKLAT.VIEW', 'DIKLAT.CREATE', 'DIKLAT.EDIT',
  'KELUARGA.VIEW', 'KELUARGA.CREATE', 'KELUARGA.EDIT',
  'KINERJA.VIEW', 'KINERJA.CREATE', 'KINERJA.EDIT',
  'DISIPLIN.VIEW', 'DISIPLIN.CREATE', 'DISIPLIN.EDIT',
  'KGB.VIEW', 'KGB.CREATE', 'KGB.EDIT',
  'USULAN.VIEW', 'USULAN.CREATE',
  'DOKUMEN.VIEW', 'DOKUMEN.CREATE', 'DOKUMEN.EDIT',
  'MASTER.VIEW',
  'LAPORAN.VIEW', 'LAPORAN.EXPORT', 'LAPORAN.PRINT'
)
on conflict (role_id, permission_id) do nothing;

-- VERIFIKATOR_BKD: VIEW semua + APPROVE/REJECT usulan
insert into public.role_permissions (role_permission_id, role_id, permission_id, granted_by)
select
  'RP-VB-' || lpad(row_number() over (order by permission_id)::text, 3, '0'),
  'ROL-003',
  permission_id,
  'SYSTEM'
from public.permissions
where aksi = 'VIEW'
   or kode_permission in ('USULAN.APPROVE', 'USULAN.REJECT')
on conflict (role_id, permission_id) do nothing;

-- APPROVER_BKD: VIEW semua + APPROVE/REJECT usulan (separation of duties)
insert into public.role_permissions (role_permission_id, role_id, permission_id, granted_by)
select
  'RP-AB-' || lpad(row_number() over (order by permission_id)::text, 3, '0'),
  'ROL-004',
  permission_id,
  'SYSTEM'
from public.permissions
where aksi = 'VIEW'
   or kode_permission in ('USULAN.APPROVE', 'USULAN.REJECT')
on conflict (role_id, permission_id) do nothing;

-- PEGAWAI: VIEW data diri + CREATE usulan + VIEW/CREATE dokumen
insert into public.role_permissions (role_permission_id, role_id, permission_id, granted_by)
select
  'RP-PG-' || lpad(row_number() over (order by permission_id)::text, 3, '0'),
  'ROL-005',
  permission_id,
  'SYSTEM'
from public.permissions
where kode_permission in (
  'DASHBOARD.VIEW',
  'PEGAWAI.VIEW',
  'KEPANGKATAN.VIEW', 'JABATAN.VIEW', 'PENDIDIKAN.VIEW',
  'DIKLAT.VIEW', 'KELUARGA.VIEW', 'KINERJA.VIEW',
  'DISIPLIN.VIEW', 'KGB.VIEW',
  'USULAN.VIEW', 'USULAN.CREATE',
  'DOKUMEN.VIEW', 'DOKUMEN.CREATE'
)
on conflict (role_id, permission_id) do nothing;
