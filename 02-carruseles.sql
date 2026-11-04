-- Aplicar DESPUÉS de schema.sql. Compatible con trabajos antiguos; no elimina datos.
begin;
alter table public.trabajos add column if not exists media jsonb not null default '[]'::jsonb;
create or replace function public.validar_media(items jsonb) returns boolean
language plpgsql immutable set search_path='' as $$
declare item jsonb; hay_despues boolean := false;
begin
 if jsonb_typeof(items) <> 'array' then return false; end if;
 if jsonb_array_length(items)=0 then return true; end if;
 if jsonb_array_length(items)>20 then return false; end if;
 for item in select value from jsonb_array_elements(items) loop
  if jsonb_typeof(item)<>'object' or not (item ?& array['path','phase','kind']) then return false; end if;
  if coalesce(item->>'phase','') not in ('before','after') or coalesce(item->>'kind','') not in ('image','video') then return false; end if;
  if (item->>'kind'='image' and coalesce(item->>'path','') !~ '^[a-f0-9-]+\.(jpg|png|webp)$') or (item->>'kind'='video' and coalesce(item->>'path','') !~ '^[a-f0-9-]+\.(mp4|webm)$') then return false; end if;
  if item->>'phase'='after' then hay_despues := true; end if;
 end loop;
 return hay_despues;
end $$;
alter table public.trabajos drop constraint if exists trabajos_media_valida;
alter table public.trabajos add constraint trabajos_media_valida check(public.validar_media(media));
commit;
