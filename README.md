# Pagina-Nashh

Sitio web: **Un rinconcito para ti**

Regalo web estático hecho con HTML, CSS y JavaScript. No necesita instalar dependencias ni compilarse.

## Publicarlo con Netlify

La configuración de `netlify.toml` publica la carpeta raíz del proyecto directamente, sin comando de compilación.

### Conectar este repositorio de GitHub

1. En Netlify, selecciona **Add new site → Import an existing project** y conecta GitHub.
2. Elige el repositorio `Anto-Rodara/Pagina-Nashh` y la rama `main`.
3. Deja vacío el comando de compilación y usa `.` como directorio de publicación. Netlify también puede leer estos valores de `netlify.toml`.
4. Selecciona **Deploy** y abre la URL que Netlify asigne al sitio.

### Publicar manualmente

Arrastra la carpeta del proyecto a Netlify Drop. Incluye `index.html`, `style.css`, `app.js` y las carpetas `Imagenes` y `Musica`.

## Publicarlo con GitHub Pages

1. Sube los archivos y carpetas de este proyecto a la rama principal (`main`), conservando sus nombres y mayúsculas.
2. En el repositorio, abre **Settings → Pages**.
3. En **Build and deployment**, selecciona **Deploy from a branch**.
4. Selecciona `main` y la carpeta raíz (`/root`), y guarda.
5. Cuando termine la publicación, abre la URL que GitHub Pages muestre en esa misma sección.

La página de inicio debe permanecer como `index.html` en la raíz del repositorio. Las carpetas `Imagenes` y `Musica` también deben estar en la raíz para que las rutas relativas funcionen.

## Archivos

- `index.html`: contenido de la página.
- `style.css`: estilos y diseño adaptable.
- `app.js`: interacciones del menú.
- `Imagenes/`: imágenes de portada, personajes y parejas.
- `Musica/`: archivos de audio MP4 reproducidos desde la sección de canciones.

Las fuentes tipográficas se cargan desde Google Fonts, por lo que necesitan conexión a Internet.

## Antes de publicar

Si el repositorio o el sitio se configura como público, cualquier persona podrá ver y descargar los archivos, incluidas las imágenes, la carta y la música. Confirma que tienes permiso para compartir esos recursos y elimina o reemplaza cualquier dato personal que prefieras mantener privado.
