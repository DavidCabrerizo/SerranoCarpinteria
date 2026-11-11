-- Estado de la base de datos de Serrano (proyecto de Supabase "Serrano Carpintería").
-- El proyecto ya estaba configurado; NO hace falta ejecutar nada. Este archivo documenta lo que existe.
--
-- Tablas: public.trabajos (título, categoría `cat`, descripción, `path` y `kind` del archivo principal,
--         `media` jsonb con hasta 20 archivos {path, phase: before|after, kind: image|video}),
--         public.administradores (user_id de quienes pueden gestionar).
-- Función: public.es_admin() -> true si auth.uid() está en administradores.
-- Almacenamiento: bucket público `trabajos` (50 MB, JPG/PNG/WebP/MP4/WebM, nombres uuid.ext en la raíz).
-- Políticas: lectura pública de public.trabajos; insertar, actualizar y borrar solo es_admin().
--
-- Migración aplicada el 11-11-2026 (serrano_actualizar_y_alta_admin_autorizado):
create policy actualizar on public.trabajos for update to authenticated
  using (public.es_admin()) with check (public.es_admin());

-- Quien se registre con un correo de esta lista pasa a ser administrador automáticamente.
-- Para autorizar a más personas, añade su correo al array y vuelve a ejecutar la función.
create or replace function public.alta_admin_autorizado()
returns trigger language plpgsql security definer set search_path = ''
as $$
begin
  if lower(new.email) = any (array['infocannabis24h@gmail.com']) then
    insert into public.administradores (user_id) values (new.id) on conflict do nothing;
  end if;
  return new;
end $$;
revoke all on function public.alta_admin_autorizado() from public, anon, authenticated;
create trigger alta_admin_autorizado after insert on auth.users
  for each row execute function public.alta_admin_autorizado();
