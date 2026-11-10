-- Serrano · esquema para Supabase. Ejecutar completo en SQL Editor.

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null,
  description text,
  published boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.media (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  kind text not null check (kind in ('image','video')),
  path text not null,
  position int not null default 0,
  created_at timestamptz not null default now()
);
create index media_project_idx on public.media(project_id);

alter table public.projects enable row level security;
alter table public.media enable row level security;

-- Lectura pública solo de lo publicado; los usuarios con sesión lo ven todo
create policy "projects_read" on public.projects for select
  using (published = true or auth.role() = 'authenticated');
create policy "media_read" on public.media for select
  using (exists (select 1 from public.projects p where p.id = project_id
         and (p.published = true or auth.role() = 'authenticated')));

-- Solo usuarios con sesión pueden crear, editar y borrar
create policy "projects_write" on public.projects for all to authenticated using (true) with check (true);
create policy "media_write" on public.media for all to authenticated using (true) with check (true);

-- Almacenamiento de fotos y vídeos (lectura pública)
insert into storage.buckets (id, name, public) values ('trabajos','trabajos',true)
  on conflict (id) do nothing;
create policy "trabajos_read" on storage.objects for select using (bucket_id = 'trabajos');
create policy "trabajos_insert" on storage.objects for insert to authenticated with check (bucket_id = 'trabajos');
create policy "trabajos_update" on storage.objects for update to authenticated using (bucket_id = 'trabajos');
create policy "trabajos_delete" on storage.objects for delete to authenticated using (bucket_id = 'trabajos');
