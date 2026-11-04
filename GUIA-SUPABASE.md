# Configurar Supabase y entregar el acceso al cliente

1. Crea un proyecto en https://supabase.com/dashboard. Guarda la contraseña de la base de datos de forma privada. Escoge la región de alojamiento que corresponda a tu negocio y completa las condiciones de privacidad reales.
2. Abre SQL Editor > New query. En proyecto NUEVO ejecuta primero el contenido completo de supabase/schema.sql. Si ya lo ejecutaste anteriormente, no lo repitas.
3. Ejecuta después supabase/02-carruseles.sql. Añade el carrusel y conserva los trabajos antiguos de una sola imagen. Este paso es necesario para publicar desde la versión nueva.
4. En Storage verifica que existe el bucket trabajos, público, con límite 50 MB por archivo y JPG/PNG/WebP/MP4/WebM. No añadas políticas de escritura públicas: las incluidas restringen las subidas y borrados a administradores.
5. En Authentication > Users crea manualmente el usuario de tu cliente con correo y contraseña segura, con correo confirmado. Desactiva el registro público en la configuración de Auth. Copia el ID/UUID del usuario.
6. En SQL Editor ejecuta, sustituyendo el UUID:

       insert into public.administradores(user_id)
       values ('UUID-REAL-DEL-CLIENTE')
       on conflict do nothing;

7. En la configuración de API del proyecto copia Project URL y la clave PÚBLICA publishable/anon. En Vercel > Environment Variables añade VITE_SUPABASE_URL y VITE_SUPABASE_ANON_KEY con esos valores. Nunca uses service_role ni una secret key. Guarda las variables para Production y Preview si necesitas ambos entornos, y haz Redeploy.
8. En Authentication > URL Configuration establece Site URL con la dirección HTTPS definitiva de la web. La entrada es por correo y contraseña. La recuperación de contraseña debe gestionarse desde Supabase hasta añadir un flujo específico de recuperación a la web; SMTP propio es necesario antes de depender de correos de acceso.
9. El cliente entra en https://TU-WEB/#acceso. Tras iniciar sesión ve «Subir un trabajo nuevo». Completa título, categoría y descripción, selecciona los archivos del Antes (opcionales) y del Después (al menos uno) y pulsa Publicar trabajo. No necesita entrar en Supabase ni en Vercel para publicar.
10. Cada trabajo muestra un carrusel con etiquetas Antes/Después, flechas, contador y reproductores de vídeo sin reproducción automática. Orden: archivos del Antes, después archivos del Después, en el orden seleccionado por el navegador. Máximo 20 archivos y 200 MB por trabajo, 50 MB por archivo. Para imágenes de iPhone exporta JPG; para vídeos usa MP4 H.264 si quieres máxima compatibilidad. HEIC/MOV no están admitidos. Para corregir un trabajo en esta versión, elimínalo y vuelve a publicarlo; no incluye edición ni reordenación manual.

## Comprobaciones antes de entregarlo
En ventana privada debe verse el carrusel, pero no el formulario de publicación. Una cuenta sin fila en administradores no debe poder escribir. Prueba una publicación con dos fotos Antes y una foto/vídeo Después, flechas y reproducción. Comprueba el mismo trabajo desde otro dispositivo; elimina el trabajo y revisa Storage. El cierre de sesión debe ocultar el formulario. La migración y estas pruebas con credenciales reales están pendientes: no se ha conectado ninguna cuenta Supabase desde este proyecto.

Los archivos del catálogo son públicos. El cliente debe publicar solo material con los permisos necesarios y sin datos personales innecesarios. Ante un error de red, revisa Storage por posibles archivos huérfanos: las subidas y la inserción del trabajo no son una transacción única. La web intenta limpiarlos si la publicación falla. Revocar acceso: elimina la fila de administradores y revoca sus sesiones en Supabase.

Documentación oficial: https://supabase.com/docs/guides/storage/security/access-control ; https://supabase.com/docs/guides/auth/users
