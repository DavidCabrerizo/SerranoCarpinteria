-- Ejecutar una vez en un proyecto Supabase nuevo.
create table public.administradores(user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.administradores enable row level security;
create policy leer_propio on public.administradores for select to authenticated using(user_id=auth.uid());
create function public.es_admin() returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.administradores where user_id=auth.uid()) $$;
revoke all on function public.es_admin() from public;
grant execute on function public.es_admin() to anon,authenticated;
create table public.trabajos(
 id uuid primary key default gen_random_uuid(),
 title text not null check(length(trim(title)) between 1 and 80),
 description text not null default '' check(length(description)<=160),
 cat text not null check(cat in ('Armarios y vestidores','Cocinas','Puertas','Ventanas','Baños','Tarimas y rodapiés','Ebanistería')),
 path text not null unique check(path ~ '^[a-f0-9-]+\.(jpg|png|webp|mp4|webm)$'),
 kind text not null check(kind in ('image','video')),
 created_at timestamptz not null default now()
);
alter table public.trabajos enable row level security;
grant select on public.trabajos to anon,authenticated;
grant insert,delete on public.trabajos to authenticated;
grant select on public.administradores to authenticated;
revoke insert,update,delete on public.administradores from anon,authenticated;
create policy catalogo on public.trabajos for select using(true);
create policy publicar on public.trabajos for insert to authenticated with check(public.es_admin());
create policy retirar on public.trabajos for delete to authenticated using(public.es_admin());
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('trabajos','trabajos',true,52428800,array['image/jpeg','image/png','image/webp','video/mp4','video/webm']);
create policy subir on storage.objects for insert to authenticated with check(bucket_id='trabajos' and public.es_admin() and name ~ '^[a-f0-9-]+\.(jpg|png|webp|mp4|webm)$');
create policy borrar on storage.objects for delete to authenticated using(bucket_id='trabajos' and public.es_admin());
create policy ver_archivos on storage.objects for select to authenticated using(bucket_id='trabajos' and public.es_admin());
