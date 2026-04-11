# Guia 03: Desarrollo Web (HTML, CSS, JavaScript)

> Construye sitios web y aplicaciones frontend con autocompletado, formateo automatico, ejecucion de Node.js y Live Server con recarga en vivo.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Escribir HTML y CSS con autocompletado inteligente
- Ejecutar archivos JavaScript con Node.js directamente desde el editor
- Usar el Live Server para ver cambios en tiempo real en el navegador
- Manejar paquetes NPM e instalar dependencias sin salir de FORJA
- Ejecutar tests con Jest o Vitest desde el Hydra

## Prerequisitos

- Haber completado la [Guia 01: Core y Entorno](01_Core_y_Entorno.md)
- Tener Node.js instalado (ya incluido en FORJA)
- Opcional: haber usado HTML/CSS/JS antes (esta guia asume conocimiento basico del lenguaje)

---

## 1. HTML y CSS con Autocompletado

FORJA activa automaticamente servidores LSP para HTML y CSS, dandote una experiencia similar a VS Code.

### Que obtienes al abrir un `.html`

- **Autocompletado de etiquetas:** Escribe `<di` y te sugiere `<div>`, `<dialog>`, etc.
- **Cierre automatico de etiquetas:** Al escribir `<div>` y presionar Enter, se genera automaticamente `</div>`
- **Atributos sugeridos:** Dentro de una etiqueta, te sugiere atributos validos (`class`, `id`, `style`, `href`, etc.)
- **Snippets de Emmet:** Escribe `ul>li*3` y se expande a una lista con 3 items

### Que obtienes al abrir un `.css`

- **Propiedades CSS:** Escribe `disp` y te sugiere `display`, con sus valores posibles (`flex`, `grid`, `block`, etc.)
- **Colores visuales:** Al escribir un color hexadecimal como `#ff6600`, el editor muestra una previsualizacion del color
- **Selectores inteligentes:** Autocompletado de clases e IDs definidos en tu HTML

### Formateo con Prettier

Si tu HTML o CSS esta mal indentado o desordenado:

1. Presiona `C-c x` para abrir el Hydra
2. Presiona `f` (Format)
3. El archivo completo se reorganiza siguiendo las reglas de **Prettier** (el formateador estandar de la industria)

**Ejemplo antes/despues:**

Antes:
```html
<div class="container"><h1>Titulo</h1><p>Parrafo muy largo que esta todo en una sola linea y no se entiende nada</p><ul><li>Item 1</li><li>Item 2</li></ul></div>
```

Despues de `C-c x f`:
```html
<div class="container">
  <h1>Titulo</h1>
  <p>
    Parrafo muy largo que esta todo en una sola linea y no se entiende
    nada
  </p>
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
  </ul>
</div>
```

## 2. JavaScript y Node.js

### Ejecutar un archivo JS aislado

Si estas practicando logica o algoritmos en un archivo como `ejercicio.js`:

1. Escribe tu codigo:
   ```javascript
   function fibonacci(n) {
       if (n <= 1) return n;
       return fibonacci(n - 1) + fibonacci(n - 2);
   }

   for (let i = 0; i < 10; i++) {
       console.log(`Fibonacci(${i}) = ${fibonacci(i)}`);
   }
   ```
2. Presiona `F5`
3. Se ejecuta con Node.js y la salida aparece en un panel inferior:
   ```
   Fibonacci(0) = 0
   Fibonacci(1) = 1
   Fibonacci(2) = 1
   Fibonacci(3) = 2
   ...
   ```

### Trabajar con un proyecto Node.js (package.json)

Cuando estas dentro de una carpeta que tiene `package.json`, el comportamiento del Hydra cambia:

| Tecla Hydra | Que ejecuta | Equivalente en terminal |
| :---: | :--- | :--- |
| `r` (Run) | `npm run dev` o `npm start` | Inicia el servidor de desarrollo |
| `b` (Build) | `npm install` | Instala todas las dependencias |
| `t` (Test) | `npm test` | Ejecuta Jest, Vitest o el test runner configurado |
| `k` (Stop) | Mata el proceso | Detiene el servidor |
| `f` (Format) | Prettier | Formatea el archivo actual |

### Ejemplo: Crear y ejecutar un proyecto Express

1. **Genera el proyecto:** `C-c n` → `e` (Node.js REST API) → nombre: `mi-api-node`
2. **Abre el archivo principal:** El generador abre `index.js` o `server.js` automaticamente
3. **Instala dependencias:** `C-c x b` (Build = `npm install`)
4. **Ejecuta el servidor:** `F5` o `C-c x r`
5. **Prueba el endpoint:** Abre otra terminal y ejecuta:
   ```bash
   curl http://localhost:3000/api/items
   ```
6. **Detiene el servidor:** `C-c x k` (Stop)

### TypeScript

FORJA trata TypeScript igual que JavaScript. Los archivos `.ts` y `.tsx` obtienen:
- Autocompletado con tipos
- Deteccion de errores de tipos en tiempo real
- Mismos atajos de Hydra que JavaScript

## 3. Live Server: Desarrollo Web con Recarga en Vivo

El Live Server es la forma mas rapida de desarrollar paginas web. Cada vez que guardas un archivo HTML, CSS o JS, el navegador se actualiza automaticamente.

### Como funciona

1. Abre un archivo `index.html`
2. Presiona `F5`
3. FORJA inicia un servidor local y abre tu navegador apuntando a el

### Comportamiento por plataforma

| Plataforma | Que sucede al presionar F5 en un `.html` |
| :--- | :--- |
| **PC (Arch Linux)** | Se abre Firefox/Chrome automaticamente en `http://127.0.0.1:puerto` |
| **Termux (Android)** | Se inicia el servidor sin abrir navegador. Abre Chrome en tu celular y ve a `http://localhost:puerto` |
| **WSL2 (Windows)** | Se inicia el servidor. Abre un navegador en Windows y ve a `http://localhost:puerto` |

### Flujo de trabajo recomendado

1. Abre `index.html` y presiona `F5` → se abre el navegador
2. Coloca el navegador y Emacs lado a lado en tu pantalla
3. Edita el HTML, CSS o JS en Emacs
4. Guarda con `C-x C-s`
5. El navegador se actualiza **automaticamente** — no necesitas presionar F5 en el navegador

### Detener el Live Server

Presiona `C-c x k` (Stop en el Hydra) para apagar el servidor.

## 4. Gestion de Paquetes NPM

FORJA integra el manejo de paquetes NPM en el flujo de trabajo:

### Instalar dependencias del proyecto

Si clonas un proyecto que tiene `package.json`:
- Presiona `C-c x b` (Build) → ejecuta `npm install`

### Instalar un paquete nuevo

Para esto necesitas la terminal. Presiona `M-x term` o abre una terminal externa:
```bash
npm install axios    # Instala como dependencia
npm install -D jest  # Instala como dependencia de desarrollo
```

> **Tip:** Despues de instalar paquetes nuevos, el autocompletado LSP los reconoce automaticamente. Si no aparecen las sugerencias, guarda el archivo para forzar una recarga del LSP.

## 5. Testing con Jest / Vitest

FORJA detecta tu test runner automaticamente por el `package.json`.

### Ejecutar todos los tests

1. Abre cualquier archivo del proyecto (no necesariamente el test)
2. Presiona `C-c x t` (Test en Hydra)
3. Se ejecuta `npm test` y ves los resultados en el panel inferior:
   ```
   PASS  tests/math.test.js
     ✓ sumar dos numeros (2ms)
     ✓ restar dos numeros (1ms)
     ✓ multiplicar por cero (1ms)

   Test Suites: 1 passed, 1 total
   Tests:       3 passed, 3 total
   ```

### Ejecutar un solo archivo de test

Si tienes abierto un archivo `.spec.js` o `.test.js`:
- `C-c x t` ejecutara solo los tests de ese archivo (si tu test runner lo soporta)

---

## Ejercicio Practico: Portafolio Personal con Live Server

Vamos a crear un portafolio web basico y verlo en vivo:

1. **Genera el proyecto:** `C-c n` → `w` (Web estatica) → nombre: `mi-portafolio`

2. **Abre `index.html`** y reemplaza el contenido con:
   ```html
   <!DOCTYPE html>
   <html lang="es">
   <head>
       <meta charset="UTF-8">
       <title>Mi Portafolio</title>
       <link rel="stylesheet" href="style.css">
   </head>
   <body>
       <header>
           <h1>Juan Perez</h1>
           <p>Estudiante de Programacion</p>
       </header>
       <main>
           <section>
               <h2>Mis Proyectos</h2>
               <ul id="proyectos"></ul>
           </section>
       </main>
       <script src="app.js"></script>
   </body>
   </html>
   ```

3. **Crea `style.css`** (`C-x C-f` → `style.css`):
   ```css
   body {
       font-family: Arial, sans-serif;
       max-width: 800px;
       margin: 0 auto;
       padding: 20px;
       background-color: #1a1a2e;
       color: #eaeaea;
   }

   header {
       text-align: center;
       border-bottom: 2px solid #e94560;
       padding-bottom: 20px;
   }

   h1 { color: #e94560; }
   h2 { color: #0f3460; }
   ```

4. **Crea `app.js`** (`C-x C-f` → `app.js`):
   ```javascript
   const proyectos = [
       "Calculadora en Python",
       "API REST en Go",
       "Juego en Raylib"
   ];

   const lista = document.getElementById("proyectos");
   proyectos.forEach(function(proyecto) {
       const li = document.createElement("li");
       li.textContent = proyecto;
       lista.appendChild(li);
   });
   ```

5. **Guarda todo:** `C-x C-s` en cada archivo
6. **Vuelve a `index.html`** y presiona `F5`
7. **Observa el resultado** en tu navegador
8. **Prueba el hot reload:** Modifica el color de fondo en `style.css`, guarda, y mira como el navegador se actualiza solo

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| F5 no abre el navegador | Estas en Termux o WSL | Abre manualmente el navegador y ve a `http://localhost:puerto` |
| `npm install` falla | Node.js no esta instalado | Ejecuta `node --version`. Si falla, ejecuta `~/forja/install.sh` |
| El autocompletado CSS no muestra colores | El LSP de CSS no se inicio | Cierra y abre el archivo, o reinicia con `M-x lsp-restart-workspace` |
| Live Server no detecta cambios | El archivo no esta guardado | Siempre guarda con `C-x C-s` antes de esperar la recarga |
| Jest no encuentra tests | Falta configuracion en `package.json` | Asegurate de tener `"test": "jest"` en la seccion `"scripts"` |
| Prettier no formatea | Falta configuracion o no esta instalado | Verifica con `npx prettier --version` en terminal |

## Resumen de Atajos de esta Guia

```
F5           → Ejecutar JS con Node / Iniciar Live Server (HTML)
C-c x r      → Run (mismo que F5, desde Hydra)
C-c x b      → Build (npm install)
C-c x t      → Test (npm test / jest / vitest)
C-c x k      → Stop (detener servidor)
C-c x f      → Format (Prettier)
C-c n w      → Generar proyecto web estatico
C-c n W      → Generar proyecto web con Tailwind
C-c n e      → Generar API Node.js (Express)
```

---

**Anterior:** [Guia 02: Proyectos y Git](02_Proyectos_y_Git.md) | **Siguiente:** [Guia 04: Lenguajes Backend](04_Lenguajes_Backend.md) | [Volver al README](../README.md)
