-- ============================================================
-- Migration 005: Auth & Access Tables (Chapter M-P)
-- users, roles, user_roles, access_scope
-- ============================================================

-- -------------------------------------------------------
-- M. users (auth bridge)
-- -------------------------------------------------------
create table if not exists public.users (
  user_id             text        not null,
  pegawai_id          text,
  username            text        not null,
  email_login         text,
  auth_user_id        uuid,
  password_hash       text,
  password_changed_at timestamptz,
  last_login_at       timestamptz,
  failed_login_count  integer     not null default 0,
  is_locked           boolean     not null default false,
  is_active           boolean     not null default true,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  created_by          text,
  updated_by          text,

  constraint pk_users                  primary key (user_id),
  constraint uq_users_username         unique (username),
  constraint uq_users_pegawai_id       unique (pegawai_id),
  constraint uq_users_auth_user_id     unique (auth_user_id),
  constraint fk_users_pegawai          foreign key (pegawai_id) references public.pegawai(pegawai_id) on delete set null,
  constraint fk_users_auth             foreign key (auth_user_id) references auth.users(id) on delete restrict,
  constraint ck_users_id               check (trim(user_id) <> ''),
  constraint ck_users_username         check (trim(username) <> ''),
  constraint ck_users_failed_login     check (failed_login_count >= 0)
);

create index if not exists idx_users_pegawai_id   on public.users(pegawai_id);
create index if not exists idx_users_auth_user_id on public.users(auth_user_id);

create trigger trg_users_updated_at
  before update on public.users
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- N. roles
-- -------------------------------------------------------
create table if not exists public.roles (
  role_id    text        not null,
  kode_role  text        not null,
  nama_role  text        not null,
  deskripsi  text,
  is_system  boolean     not null default false,
  is_active  boolean     not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by text,
  updated_by text,

  constraint pk_roles        primary key (role_id),
  constraint uq_roles_kode   unique (kode_role),
  constraint ck_roles_id     check (trim(role_id) <> ''),
  constraint ck_roles_kode   check (trim(kode_role) <> ''),
  constraint ck_roles_nama   check (trim(nama_role) <> '')
);

create trigger trg_roles_updated_at
  before update on public.roles
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- O. user_roles
-- -------------------------------------------------------
create table if not exists public.user_roles (
  user_role_id text        not null,
  user_id      text        not null,
  role_id      text        not null,
  status       text        not null default 'ACTIVE',
  assigned_at  timestamptz not null default now(),
  expired_at   timestamptz,
  is_active    boolean     not null default true,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  created_by   text,
  updated_by   text,

  constraint pk_user_roles              primary key (user_role_id),
  constraint fk_user_roles_user         foreign key (user_id) references public.users(user_id) on delete restrict,
  constraint fk_user_roles_role         foreign key (role_id) references public.roles(role_id) on delete restrict,
  constraint ck_user_roles_id           check (trim(user_role_id) <> ''),
  constraint ck_user_roles_user_id      check (trim(user_id) <> ''),
  constraint ck_user_roles_role_id      check (trim(role_id) <> ''),
  constraint ck_user_roles_expired      check (expired_at is null or expired_at >= assigned_at)
);

-- Partial unique: hanya satu role aktif per user
create unique index if not exists uq_user_roles_one_active_per_user
  on public.user_roles(user_id)
  where is_active = true;

create index if not exists idx_user_roles_user_id on public.user_roles(user_id);
create index if not exists idx_user_roles_role_id on public.user_roles(role_id);

create trigger trg_user_roles_updated_at
  before update on public.user_roles
  for each row execute function public.tg_set_updated_at();

-- -------------------------------------------------------
-- P. access_scope
-- -------------------------------------------------------
create table if not exists public.access_scope (
  access_scope_id    text        not null,
  user_role_id       text        not null,
  scope_type         text        not null,
  scope_opd_id       text,
  scope_unit_kerja_id text,
  scope_pegawai_id   text,
  valid_from         timestamptz,
  valid_until        timestamptz,
  keterangan         text,
  is_active          boolean     not null default true,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  created_by         text,
  updated_by         text,

  constraint pk_access_scope                primary key (access_scope_id),
  constraint fk_access_scope_user_role      foreign key (user_role_id) references public.user_roles(user_role_id) on delete cascade,
  constraint fk_access_scope_opd            foreign key (scope_opd_id) references public.master_opd(opd_id) on delete restrict,
  constraint fk_access_scope_unit_kerja     foreign key (scope_unit_kerja_id) references public.master_unit_kerja(unit_kerja_id) on delete restrict,
  constraint fk_access_scope_pegawai        foreign key (scope_pegawai_id) references public.pegawai(pegawai_id) on delete restrict,
  constraint ck_access_scope_id             check (trim(access_scope_id) <> ''),
  constraint ck_access_scope_user_role_id   check (trim(user_role_id) <> ''),
  constraint ck_access_scope_type           check (scope_type in ('GLOBAL', 'OPD', 'UNIT_KERJA', 'SELF', 'BAWAHAN_LANGSUNG')),
  constraint ck_access_scope_valid_range    check (valid_until is null or valid_from is null or valid_until >= valid_from),
  -- Typed scope enforcement
  constraint ck_access_scope_global         check (scope_type <> 'GLOBAL'         or (scope_opd_id is null and scope_unit_kerja_id is null and scope_pegawai_id is null)),
  constraint ck_access_scope_opd            check (scope_type <> 'OPD'             or (scope_opd_id is not null and scope_unit_kerja_id is null and scope_pegawai_id is null)),
  constraint ck_access_scope_unit_kerja     check (scope_type <> 'UNIT_KERJA'      or (scope_unit_kerja_id is not null and scope_opd_id is null and scope_pegawai_id is null)),
  constraint ck_access_scope_self           check (scope_type <> 'SELF'             or (scope_pegawai_id is not null and scope_opd_id is null and scope_unit_kerja_id is null)),
  constraint ck_access_scope_bawahan        check (scope_type <> 'BAWAHAN_LANGSUNG' or (scope_pegawai_id is not null and scope_opd_id is null and scope_unit_kerja_id is null))
);

create index if not exists idx_access_scope_user_role_id     on public.access_scope(user_role_id);
create index if not exists idx_access_scope_type_opd         on public.access_scope(scope_type, scope_opd_id);
create index if not exists idx_access_scope_type_unit_kerja  on public.access_scope(scope_type, scope_unit_kerja_id);
create index if not exists idx_access_scope_type_pegawai     on public.access_scope(scope_type, scope_pegawai_id);
create index if not exists idx_access_scope_valid_range      on public.access_scope(valid_from, valid_until);

create trigger trg_access_scope_updated_at
  before update on public.access_scope
  for each row execute function public.tg_set_updated_at();
