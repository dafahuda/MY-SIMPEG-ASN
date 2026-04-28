-- ============================================================
-- Migration 001: Shared trigger function for updated_at
-- ============================================================
-- Kontrak lintas tabel: function standar tg_set_updated_at()
-- Dipasang sebagai BEFORE UPDATE FOR EACH ROW pada semua tabel
-- yang memiliki kolom updated_at.
-- ============================================================

create or replace function public.tg_set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

comment on function public.tg_set_updated_at()
  is 'Shared trigger function: auto-set updated_at = now() on every row update.';
