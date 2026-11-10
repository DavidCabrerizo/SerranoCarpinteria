# Web de Serrano

- `index.html` web pública (sin ninguna opción de subida). Muestra categorías, proyectos y galería con fotos y vídeos.
- `admin.html` panel independiente para el carpintero (móvil o PC). No aparece enlazado en la web y lleva `noindex`.
- `config.js` datos de Supabase. `supabase.sql` tablas, seguridad y almacenamiento.

Mientras `config.js` conserve `TU-PROYECTO`, `index.html` enseña los proyectos de ejemplo.

## Puesta en marcha (fase inicial)
1. Crea un proyecto en supabase.com. En **SQL Editor** pega y ejecuta `supabase.sql`.
2. **Authentication → Users → Add user**: crea un usuario por persona que deba subir trabajos (correo y contraseña).
   En **Authentication → Sign In / Providers** desactiva el alta pública de usuarios (*Allow new users to sign up*). Cualquier usuario con sesión puede publicar y borrar.
3. En **Project Settings → API** copia la *Project URL* y la clave *anon public* en `config.js`.
4. Sube la carpeta a un hosting estático (Vercel, Netlify o Cloudflare Pages). Supabase aporta base de datos, archivos y usuarios, pero no sirve páginas web propias.
5. El panel queda en `https://tu-dominio/admin.html`.

## Paso a IONOS más adelante
Sube estos mismos archivos por FTP a tu hosting de IONOS: funciona igual porque los datos siguen en Supabase. Si después quieres mover también los datos a IONOS (MySQL y PHP), habría que reescribir el panel.

## Límites a tener en cuenta
- Las fotos se reducen a 1920 px en el propio móvil antes de subirse. Los vídeos se suben tal cual: el plan gratuito de Supabase admite unos 50 MB por archivo, así que conviene grabarlos cortos o comprimidos. Comprueba los límites vigentes de almacenamiento y tráfico en tu plan.

## Antes de publicar (cumplimiento legal)
1. Rellena los datos resaltados en amarillo en `aviso-legal.html`, `privacidad.html` y `cookies.html`: titular, NIF/CIF, domicilio, correo, teléfono, dominio, proveedor de hosting, región del servidor de Supabase y, si es sociedad, datos del Registro Mercantil. Sin ellos la web no cumple el artículo 10 de la LSSI-CE.
2. Crea el proyecto de Supabase en una región de la UE y firma o acepta su acuerdo de encargado del tratamiento (DPA).
3. En `index.html` y los textos legales sustituye el marcador de teléfono de WhatsApp (`34600000000`) y los datos de contacto del pie.
4. No subas fotos o vídeos donde se vean personas identificables, matrículas, documentos o la dirección exacta de un cliente sin su consentimiento.
5. Si añades analítica, píxeles o mapas de terceros, cárgalos solo tras el consentimiento (evento `serrano:consent` en `cookies.js`) y actualiza `cookies.html` y `privacidad.html`.
6. Estos textos son una base redactada según la normativa española vigente; conviene que los revise un abogado o un delegado de protección de datos antes de publicar.

## Publicar en Vercel
1. Sube la carpeta a un repositorio de GitHub (o usa `vercel` desde la terminal dentro de la carpeta). Vercel la detecta como sitio estático: *Framework preset: Other*, sin comando de build y con la raíz como directorio de salida.
2. `vercel.json` ya incluye URLs limpias (`/admin`, `/privacidad`), cabeceras de seguridad y una política CSP que solo permite conectar con tu proyecto de Supabase y con el CDN de `supabase-js`. Si añades otro servicio externo, amplía la CSP.
3. Rellena `config.js` (URL y clave anon de Supabase) antes de desplegar.
4. Cuando tengas dominio, sustituye `TU-DOMINIO.es` en `robots.txt` y `sitemap.xml` y añádelo en Vercel (Settings → Domains).
5. El panel queda en `https://tu-dominio/admin`.

## Imagen al compartir y favicon
`og-image.png` (1200×630, con el logo), `favicon.svg`, `favicon.ico` y `apple-touch-icon.png` ya están enlazados. Las etiquetas de Open Graph necesitan la dirección completa: sustituye `https://TU-DOMINIO.es` por tu dominio real en `index.html` (canonical, `og:url`, `og:image`, `twitter:image`), en `robots.txt` y en `sitemap.xml`. Para comprobar cómo se ve al compartir, usa el depurador de Facebook/Meta o LinkedIn Post Inspector; las redes guardan en caché la imagen anterior.
