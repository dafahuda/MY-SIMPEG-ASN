-- ============================================================
-- Migration 012: Multi-Role Engine (Fase 10A)
-- DROP single-role constraint, ADD multi-role triggers,
-- auto-assign PEGAWAI, custom access token hook
-- ============================================================

-- -------------------------------------------------------
-- Task 10A.1: ALTER user_roles — izinkan multi-role aktif
-- -------------------------------------------------------

-- Hapus constraint satu role aktif per user
drop index if exists public.uq_user_roles_one_active_per_user;

-- Ganti dengan constraint: satu role_id hanya bisa aktif sekali per user
-- (user boleh punya banyak role aktif, tapi tidak boleh role yang sama 2x aktif)
create unique index if not exists uq_user_roles_unique_active_role
  on public.user_roles(user_id, role_id)
  where is_active = true;

-- -------------------------------------------------------
-- Task 10A.2: Trigger max 3 role aktif per user
-- -------------------------------------------------------

create or replace function public.tg_check_max_active_roles()
returns trigger as $$
declare
  active_count integer;
begin
  if new.is_active = true then
    select count(*) into active_count
    from public.user_roles
    where user_id = new.user_id
      and is_active = true
      and (new.user_role_id is null or user_role_id <> new.user_role_id);

    if active_count >= 3 then
      raise exception 'User tidak boleh memiliki lebih dari 3 role aktif sekaligus.'
        using hint = 'Nonaktifkan salah satu role sebelum menambah role baru.';
    end if;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trg_user_roles_max_active
  before insert or update on public.user_roles
  for each row execute function public.tg_check_max_active_roles();

-- -------------------------------------------------------
-- Task 10A.3: Trigger larangan kombinasi VERIFIKATOR + APPROVER
-- -------------------------------------------------------

create or replace function public.tg_check_role_combination()
returns trigger as $$
declare
  new_role_code text;
  conflicting_code text;
  has_conflict boolean;
begin
  if new.is_active = true then
    -- Ambil kode role yang sedang di-assign
    select kode_role into new_role_code
    from public.roles where role_id = new.role_id;

    -- Tentukan role yang berkonflik
    if new_role_code = 'VERIFIKATOR_BKD' then
      conflicting_code := 'APPROVER_BKD';
    elsif new_role_code = 'APPROVER_BKD' then
      conflicting_code := 'VERIFIKATOR_BKD';
    else
      return new; -- Tidak ada konflik untuk role lain
    end if;

    -- Cek apakah user sudah punya role yang berkonflik
    select exists(
      select 1 from public.user_roles ur
      join public.roles r on r.role_id = ur.role_id
      where ur.user_id = new.user_id
        and ur.is_active = true
        and r.kode_role = conflicting_code
        and (new.user_role_id is null or ur.user_role_id <> new.user_role_id)
    ) into has_conflict;

    if has_conflict then
      raise exception 'VERIFIKATOR_BKD dan APPROVER_BKD tidak boleh aktif bersamaan pada satu user (separation of duties).';
    end if;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trg_user_roles_check_combination
  before insert or update on public.user_roles
  for each row execute function public.tg_check_role_combination();

-- -------------------------------------------------------
-- Task 10A.4: Auto-assign role PEGAWAI
-- -------------------------------------------------------
-- Relasi user↔pegawai ada di tabel `users` (kolom `pegawai_id`),
-- BUKAN di tabel `pegawai` (yang tidak punya kolom `user_id`).
-- Trigger dipasang di `public.users` pada event INSERT/UPDATE OF pegawai_id.
--
-- Kolom `assigned_by` TIDAK ADA di tabel user_roles.
-- Gunakan `created_by = 'SYSTEM'` sebagai penanda auto-assignment.

create or replace function public.tg_auto_assign_pegawai_role()
returns trigger as $$
declare
  pegawai_role_id text;
  existing_count integer;
  should_assign boolean := false;
begin
  -- Pisahkan logika INSERT vs UPDATE
  if tg_op = 'INSERT' then
    if new.pegawai_id is not null then
      should_assign := true;
    end if;
  elsif tg_op = 'UPDATE' then
    if new.pegawai_id is not null and old.pegawai_id is distinct from new.pegawai_id then
      should_assign := true;
    end if;
  end if;

  if should_assign then
    -- Cari role_id untuk PEGAWAI
    select role_id into pegawai_role_id
    from public.roles where kode_role = 'PEGAWAI' limit 1;

    if pegawai_role_id is not null then
      -- Cek apakah user sudah punya role PEGAWAI aktif
      select count(*) into existing_count
      from public.user_roles
      where user_id = new.user_id
        and role_id = pegawai_role_id
        and is_active = true;

      if existing_count = 0 then
        insert into public.user_roles (user_role_id, user_id, role_id, is_active, created_by)
        values (
          'UR-' || substring(gen_random_uuid()::text, 1, 8),
          new.user_id,
          pegawai_role_id,
          true,
          'SYSTEM'
        );
      end if;
    end if;
  end if;

  return new;
end;
$$ language plpgsql;

-- Trigger pada tabel USERS (bukan pegawai!)
create trigger trg_users_auto_assign_pegawai_role
  after insert or update of pegawai_id on public.users
  for each row execute function public.tg_auto_assign_pegawai_role();

comment on function public.tg_auto_assign_pegawai_role() is
  'Auto-assign role PEGAWAI ketika user dikaitkan ke data pegawai. created_by = SYSTEM menandakan auto-assignment.';

-- -------------------------------------------------------
-- Task 10A.6: Custom Access Token Hook — inject multi-role ke JWT
-- -------------------------------------------------------
-- Supabase Auth Hook: dijalankan sebelum JWT diterbitkan.
-- Inject array kode_role aktif ke JWT claims sebagai `user_roles`.
-- Ini memungkinkan RLS policies membaca role dari auth.jwt() tanpa JOIN.
--
-- PENTING: Supabase Auth event->>'user_id' = auth.users.id (UUID).
-- Tapi user_roles.user_id → public.users.user_id (text custom ID).
-- Maka harus JOIN melalui public.users.auth_user_id untuk bridge.

create or replace function public.custom_access_token_hook(event jsonb)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  claims jsonb;
  user_roles_arr jsonb;
  max_level integer;
begin
  -- Single query: ambil array kode_role + max level sekaligus
  -- JOIN melalui public.users.auth_user_id karena event->>'user_id' = auth UUID
  select
    coalesce(jsonb_agg(r.kode_role order by r.level desc), '[]'::jsonb),
    coalesce(max(r.level), 0)
  into user_roles_arr, max_level
  from public.user_roles ur
  join public.users u on u.user_id = ur.user_id
  join public.roles r on r.role_id = ur.role_id
  where u.auth_user_id = (event->>'user_id')::uuid
    and ur.is_active = true
    and r.is_active = true;

  claims := event->'claims';

  -- Inject array role ke claims
  claims := jsonb_set(claims, '{user_roles}', user_roles_arr);

  -- Inject highest level untuk quick check (SUPERADMIN = 99)
  claims := jsonb_set(claims, '{user_role_level}', to_jsonb(max_level));

  event := jsonb_set(event, '{claims}', claims);
  return event;
end;
$$;

-- Grant permissions untuk supabase_auth_admin
-- Hook butuh akses ke 3 tabel: users (bridge), user_roles, roles
grant usage on schema public to supabase_auth_admin;
grant execute on function public.custom_access_token_hook to supabase_auth_admin;
revoke execute on function public.custom_access_token_hook from authenticated, anon, public;
grant select on table public.users to supabase_auth_admin;
grant select on table public.user_roles to supabase_auth_admin;
grant select on table public.roles to supabase_auth_admin;

-- CATATAN: Setelah deploy, aktifkan hook di Supabase Dashboard:
-- Authentication → Hooks → Custom Access Token → pilih function ini.
