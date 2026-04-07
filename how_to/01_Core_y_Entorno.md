# Guía 01: Core y Entorno

Esta guía abarca los módulos fundacionales de FORJA: **00-core**, **01-dashboard** y la adaptación a dispositivos móviles con **02-termux** (o reglas equivalentes en PC).

## Dashboard (`01-dashboard`)
Cuando abres FORJA, lo primero que ves es el Dashboard interactivo.
- **Navegación visual:** Puedes usar el ratón o la tecla `Tab` para navegar por las opciones (abrir proyectos recientes, abrir notas de agenda, etc.) y presionar `Enter`.
- **Actualizar Dashboard:** Para refrescar la vista del estado actual del repositorio, posiciona el cursor sobre cualquier parte del dashboard y presiona `g` (refresh).

## Funciones Core (`00-core`)

El núcleo del entorno configura lo indispensable: tipografías, motores de autocompletado y el Menú Hydra.

### Generadores de Proyectos (Templates)
En lugar de escribir *boilerplate* a mano o perder tiempo configurando entornos de prueba en cada clase, utilizamos generadores automáticos:
1. Presiona `C-c n` (`Control` + `c`, y luego la letra `n`).
2. Verás una lista de opciones en la parte inferior:
   - `e`: Express API (Node.js)
   - `a`: Go API
   - `p`: Python FastAPI
   - `+`: RayLib Game en C++
3. Selecciona una opción, ingresa el nombre que deseas darle a tu carpeta, y FORJA ensamblará todo el scaffold (`git init`, dependencias base, `.gitignore` completo, etc.) por ti al instante.

### Menú de Compilación y Comandos (Hydra)
No más memoria muscular para "atajos oscuros". Presiona `C-c x` una sola vez para abrir el menú flotante en pantalla con todas las herramientas aplicables a tu lenguaje.  
Ejemplo de flujo de uso unificado para cualquier lenguaje (Go, Python, JS, C...):
1. Terminas de corregir tu código.
2. Presionas `C-c x` para abrir Hydra, luego la tecla `f` para **Formatearlo** (Format).
3. Presionas `C-c x` para abrir Hydra de nuevo, luego la tecla `r` para **Correrlo** (Run).

### LSP (Inteligencia de Código)
A medida que escribes, aparecerá un panel flotante autocompletando tu código (usando `Language Server Protocol`), con sugerencias contextualmente correctas.
- **Seleccionar opción:** Usa las flechas o `C-n` (abajo), `C-p` (arriba), y confirma con `Enter` o `Tab`.
- **Ir a Definición (F12):** Posiciónate en una palabra clave, llamado a API de sistema, variable global o función externa, y presiona `F12`. Emacs saltará directamente al archivo (así sea una dependencia instalada 2 carpetas arriba) donde "nació" esa función.
- **Ver Errores (Diagnósticos):** Si hay algún error en tu código (rojo o amarillo en la línea), presionar `C-c x e` mostrará una lista completa de los errores detectados en este archivo y por qué surgen.

## Entorno en Termux (`02-termux`)
Para que FORJA sea productivo sin un teclado de computadora en tu teléfono o tablet (Android):
1. **La barra extra de Termux:** Se inyecta autmáticamente con atajos (`F5`, `F7`, `F12`, `ESC`, flechas). Ya no tienes que tratar de invocar estas teclas usando combinaciones complejas.
2. **UX Adaptada:** FORJA detecta Termux y es capaz de alargar los "tiempos en que el Linter dibuja rayas rojas" (retraso intencional) para que la pantalla de un móvil más modesto no se queme refrescando el buffer mientras escribes en la pantalla táctil.

---
[⬅️ Volver al README](../README.md)
