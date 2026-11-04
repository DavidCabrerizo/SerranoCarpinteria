# Serrano · Proyecto para Vercel

Conserva el HTML, estilo y animación originales. Logo real incluido. Siete ilustraciones SVG propias de demostración (no fotografías de trabajos reales). Cada categoría muestra su ilustración hasta que se publique un trabajo en ella. Para sustituir una imagen de demostración manualmente: public/demo-0.svg a demo-6.svg; el orden está en src/categories.json.

## Arranque
Necesitas Node.js 22.12 o posterior y npm. Desde esta carpeta:

    npm ci
    npm run dev

Si no hay package-lock.json, utiliza npm install en lugar de npm ci. Abre la dirección que indique Vite. Copia .env.example a .env.local para configurar el backend. Sin variables, el catálogo de ejemplo funciona y el acceso aparece desactivado expresamente.

## Backend real: Supabase
1. Crea un proyecto Supabase nuevo. En SQL Editor ejecuta supabase/schema.sql una vez. Crea tablas, políticas y bucket público trabajos. No ejecutarlo sobre un proyecto con tablas homónimas sin revisar.
2. En Authentication desactiva el registro de nuevos usuarios. Crea manualmente el usuario del carpintero con correo y contraseña segura, confirmado. No hay registro público en esta web.
3. Copia su UUID desde Authentication y ejecuta en SQL Editor:

       insert into public.administradores(user_id) values ('UUID-DEL-USUARIO');

   La lista de administradores no se puede modificar desde el navegador. Para revocar acceso, elimina esa fila y revoca las sesiones del usuario desde Supabase.
4. Obtén Project URL y la clave pública anon/publishable desde la configuración de API de Supabase. Configura:

       VITE_SUPABASE_URL=https://TU-PROYECTO.supabase.co
       VITE_SUPABASE_ANON_KEY=TU-CLAVE-PUBLICA
       VITE_WHATSAPP=34NUMEROREAL

   Estas variables son públicas por diseño; las políticas RLS protegen las escrituras. NUNCA introduzcas una clave service_role o secret en variables VITE_. No se necesita ninguna clave administrativa en Vercel.
5. En Authentication configura Site URL con tu dominio final HTTPS. Contraseñas perdidas: restablecer desde la administración de Supabase; esta versión no incluye pantalla de recuperación. Configura SMTP propio antes de depender de los correos de autenticación.

## Desplegar en Vercel
1. Sube esta carpeta a un repositorio Git privado e impórtalo en Vercel. No subas .env.local ni node_modules.
2. Selecciona Vite; raíz: la carpeta que contiene package.json; instalación npm ci (o npm install si no hay lock), build npm run build, salida dist. Usa Node 22.12+.
3. Añade las tres variables anteriores en Settings > Environment Variables (Production y Preview según corresponda). Vuelve a desplegar cada vez que cambies variables: Vite las incorpora al compilar.
4. Sin Supabase puedes desplegar una demostración visual, pero no iniciar sesión ni publicar. Sin VITE_WHATSAPP el formulario avisa y no envía nada. Sustituye también el texto de teléfono/correo pendiente en index.html con los datos reales antes de presentar una web comercial definitiva.
5. Prueba con el dominio final: entrar desde Acceso del taller, publicar JPG y MP4, comprobarlos en una ventana privada, filtrar categoría, eliminar y cerrar sesión. Una cuenta no incluida en administradores no debe poder publicar ni borrar.

## Funcionamiento y seguridad
Supabase es el backend persistente: Auth, Postgres con RLS y Storage. Vercel sirve el frontend compilado. Las subidas van directamente al almacenamiento autenticado, sin pasar vídeos por funciones de Vercel. Límite 50 MB por archivo, JPG/PNG/WebP/MP4/WebM, nombres UUID, sin SVG ni HTML subidos por usuarios. Políticas del servidor restringen tamaño y tipos declarados; no hay análisis antivirus ni transcodificación. Exporta MP4 H.264 para mayor compatibilidad. La publicación es inmediata y pública: no subas material privado. Los archivos públicos pueden conservarse en cachés tras borrarlos.

Publicar añade un archivo y una fila; ante fallo de la fila se intenta retirar el archivo. Eliminar retira primero la fila; si falla Storage se avisa para limpiar el archivo residual desde el panel. Las operaciones entre base de datos y Storage no son transacciones atómicas. Revisa periódicamente archivos huérfanos. No hay paginación: pensada para un catálogo pequeño.

Hay validación de título/categorías en Postgres y salida de texto escapada en la galería. Los permisos no dependen de ocultar botones. La sesión se guarda en el navegador: utiliza un dispositivo de confianza y cierra sesión al terminar. El bucket es público para visualizar trabajos; solo administradores pueden escribir. Configura límites de gasto, copias de seguridad y retención en tu cuenta Supabase según tus necesidades.

## Verificación
La configuración de producción requiere tus credenciales y no se ha probado contra una cuenta real. Consulta VERIFICACION.txt para el resultado de la compilación local. No se ha desplegado ni se han creado servicios externos. Fuentes: https://supabase.com/docs/guides/storage/security/access-control y https://supabase.com/docs/reference/javascript/auth-getuser.

## Textos legales y consentimiento (versión provisional)
Se incluyen aviso-legal.html, privacidad.html y cookies.html, enlazados desde el pie, y cláusula informativa en el formulario WhatsApp. Los datos ficticios usan dominio .example y NIF no válido para evitar confusión con personas reales. Sustituirlos en las tres páginas y en index.html antes de publicar comercialmente. Completar registro mercantil si corresponde.

Panel: aceptar y rechazar analítica con igual aspecto, preferencia local durante seis meses, acceso permanente a configuración y retirada con recarga. Las imágenes/vídeos propios no usan reproductores sociales. Se eliminaron peticiones a Google Fonts.

Analítica prevista: Matomo opcional, sin cookies y con consentimiento previo a cargar el script. Configurar VITE_MATOMO_URL (URL HTTPS de la instancia) y VITE_MATOMO_SITE_ID. Ninguna instancia ha sido creada. Antes de activar: identificar proveedor/ubicación/transferencias en privacidad y cookies, contratar encargos, anonimizar IP en Matomo, limitar retención a 13 meses, desactivar funciones adicionales de publicidad, grabación y seguimiento no previstas. No añadir scripts de analítica por otra vía, incluido Vercel Analytics, sin adaptar el consentimiento. El navegador puede bloquear la medición y se respeta Do Not Track.

Pruebas necesarias: en navegador limpio no debe haber peticiones a Matomo antes de decidir ni tras rechazar; después de aceptar solo con variables válidas; retirar debe detener la medición tras recarga. Revisar navegación por teclado, enlaces legales y vista móvil. La configuración real de proveedores sigue pendiente; los textos son un borrador para completar con los datos y operaciones definitivos.

Referencias: https://www.aepd.es/guias/guia-cookies.pdf ; https://www.aepd.es/derechos-y-deberes/conoce-tus-derechos/derecho-de-informacion ; https://developer.matomo.org/guides/tracking-consent

## Versión con carruseles Antes / Después
Consulta GUIA-SUPABASE.md. Después del esquema inicial ejecuta también supabase/02-carruseles.sql, tanto en instalaciones nuevas como al actualizar una instalación antigua. El formulario ahora publica varios archivos en un único trabajo; conserva compatibilidad con los trabajos antiguos. El favicon SVG está en public/favicon.svg y el logo original aparece en la navegación superior.
