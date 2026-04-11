# Guia 01: Core, Dashboard y Entorno

> Profundiza en el nucleo de FORJA: el Dashboard de inicio, el autocompletado inteligente (LSP), los generadores de proyectos y la adaptacion a Termux.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Usar el Dashboard para acceder rapidamente a tus proyectos
- Generar proyectos completos con un solo comando (templates)
- Aprovechar el autocompletado inteligente mientras escribes codigo
- Navegar errores de codigo usando el sistema de diagnosticos
- Entender como FORJA se adapta a Termux (Android)

## Prerequisitos

- Haber completado la [Guia 00: Conceptos Basicos](00_Basics.md)
- Saber usar `C-c x` (Hydra) y `F5` (ejecutar)

---

## 1. El Dashboard

El Dashboard es la pantalla de bienvenida de FORJA. Aparece cada vez que abres Emacs sin especificar un archivo.

### Que muestra

- **Proyectos recientes:** Los ultimos repositorios en los que trabajaste. Haz clic o presiona `Enter` para abrir cualquiera.
- **Archivos recientes:** Los ultimos archivos que editaste.
- **Accesos rapidos:** Botones para abrir la agenda GTD, crear un proyecto nuevo, etc.

### Atajos del Dashboard

| Tecla | Accion |
| :---: | :--- |
| `Tab` | Saltar a la siguiente seccion/boton |
| `Enter` | Abrir el item seleccionado |
| `g` | Refrescar el Dashboard (actualizar datos) |
| `C-x C-f` | Salir del Dashboard y abrir un archivo |

> **Tip:** Si el Dashboard no muestra tus proyectos recientes, es porque todavia no abriste ninguno. Despues de trabajar con tu primer proyecto, aparecera automaticamente.

## 2. Generadores de Proyectos (Templates)

En lugar de crear carpetas, archivos y configuraciones manualmente, FORJA puede generar proyectos completos en un segundo.

### Como usar los generadores

1. Presiona `C-c n` (la "n" es de "new")
2. Aparece el menu de generadores:

| Tecla | Proyecto | Que genera |
| :---: | :--- | :--- |
| `c` | C (generico) | Carpeta + `main.c` + `Makefile` + `.gitignore` + `git init` |
| `C` | C++ (generico) | Carpeta + `main.cpp` + `CMakeLists.txt` + `.gitignore` + `git init` |
| `g` | Game (Raylib C) | Estructura de juego con Raylib + Makefile |
| `+` | Game (Raylib C++) | Estructura de juego con Raylib + CMake |
| `r` | Rust (generico) | `cargo new` con estructura estandar |
| `R` | Rust REST API | Actix-web + serde + CORS + endpoints base |
| `G` | Go (generico) | `go mod init` con estructura limpia |
| `a` | Go REST API | Gin + handlers + CORS + endpoints base |
| `w` | Web (estatica) | HTML + CSS + JS basico |
| `W` | Web (Tailwind) | HTML + Tailwind CSS via CDN |
| `e` | Node.js REST API | Express + routes + CORS + `package.json` |
| `p` | Python REST API | FastAPI + uvicorn + venv + dependencias |
| `P` | PHP REST API | Laravel (o estructura manual PHP) |

3. Selecciona una opcion presionando la tecla correspondiente
4. Escribe el nombre que quieres darle a tu proyecto
5. FORJA crea todo: carpeta, archivos, dependencias, `git init` y primer commit

### Ejemplo paso a paso: Crear una API en Go

```
C-c n       → Abre el menu de generadores
a           → Selecciona "Go REST API"
mi-api      → Escribe el nombre del proyecto
Enter       → Confirma
```

Resultado: se crea la carpeta `~/mi-api/` con:
```
mi-api/
├── main.go          ← Servidor con Gin
├── handlers.go      ← Endpoints: /, /health, /api/items
├── go.mod           ← Dependencias de Go
├── .gitignore       ← Archivos a ignorar por Git
└── .git/            ← Repositorio inicializado + primer commit
```

Ahora solo necesitas abrir `main.go` y presionar `F5` para tener tu API corriendo.

> **Tip para templates REST API:** Todos los templates de API vienen con endpoints `/`, `/health` y `/api/items` (GET y POST) ya funcionando. Es decir, al presionar `F5` ya tienes un servidor al que puedes hacerle requests.

## 3. Autocompletado Inteligente (LSP)

LSP (Language Server Protocol) es el sistema que le da "inteligencia" a FORJA. Mientras escribes codigo, un servidor de lenguaje analiza tu proyecto en tiempo real y te ofrece:

- **Autocompletado contextual:** Sugerencias de funciones, variables y metodos
- **Deteccion de errores:** Lineas rojas/amarillas en codigo con problemas
- **Informacion al vuelo:** Documentacion de funciones al posicionar el cursor

### Como funciona el autocompletado

1. Empieza a escribir el nombre de una funcion o variable
2. Aparece un panel flotante con sugerencias
3. Navega con las flechas o con `C-n` (abajo) y `C-p` (arriba)
4. Confirma con `Enter` o `Tab`
5. Presiona `C-g` para cerrar el panel sin seleccionar nada

### Ejemplo visual

Imagina que estas escribiendo en Go:
```go
fmt.Pr
```
Al llegar a "Pr", el autocompletado mostrara:
```
fmt.Println    → Imprime con salto de linea
fmt.Printf     → Imprime con formato
fmt.Print      → Imprime sin salto de linea
```
Seleccionas `Println` con las flechas y `Enter`.

### Ir a Definicion (F12)

Esta es una de las funciones mas poderosas del LSP:

1. Posiciona el cursor sobre el nombre de una funcion, variable o tipo
2. Presiona `F12`
3. FORJA salta directamente al archivo y linea donde esa funcion fue definida

Esto funciona incluso con funciones de librerias externas. Si tu codigo usa `gin.Default()`, presionar `F12` sobre `Default` te lleva al codigo fuente del framework Gin.

**Para volver:** Presiona `M-,` (Alt + coma) y vuelves a donde estabas.

### Ver Referencias (S-F12 o `C-c x ,`)

El inverso de "Ir a Definicion": te muestra **todos los lugares** donde se usa una funcion.

1. Posiciona el cursor sobre una funcion
2. Presiona `S-F12` (Shift+F12) o abre el Hydra (`C-c x`) y presiona `,`
3. Aparece una lista con todos los archivos y lineas que usan esa funcion

### Diagnosticos y Errores

Cuando hay un error en tu codigo, FORJA lo marca con un indicador visual (subrayado rojo o amarillo en la linea).

Para ver la lista completa de errores:
1. Presiona `C-c x` (abrir Hydra)
2. Presiona `e` (Errors)
3. Se abre una lista con todos los errores del archivo actual
4. Haz clic o presiona `Enter` en cualquier error para saltar a esa linea

> **Tip:** Los errores se actualizan automaticamente mientras escribes en PC. En Termux, se actualizan al guardar (para no consumir recursos innecesarios).

## 4. Entorno Termux (Android)

FORJA detecta automaticamente cuando esta corriendo en Termux y aplica ajustes:

### Adaptaciones automaticas

| Aspecto | PC | Termux |
| :--- | :--- | :--- |
| Teclas F | Teclado fisico | Barra extra en pantalla |
| Autocompletado | Inmediato (0.0s delay) | Con retraso (0.3s) para no saturar |
| Linter | Analisis en vivo (0.5s) | Analisis al guardar (2.0s) |
| Memoria | Uso normal (50MB-1GB) | Reducido (16-64MB) |
| Magit (Git) | Todas las secciones | Secciones pesadas omitidas |

### La barra de extra-keys

En Termux, aparece una barra adicional encima del teclado con las teclas esenciales:

```
 ESC | F5 | F7 | F12 | ← | → | ↑ | ↓
```

Esto te permite usar todas las funciones de FORJA sin un teclado fisico. Si la barra no aparece, ejecuta `~/forja/install.sh` y reinicia Termux.

### Recomendaciones para Termux

1. **Usa un teclado Bluetooth** si vas a programar extensivamente — la experiencia mejora drasticamente
2. **Trabaja con archivos pequenos** — el autocompletado puede ser lento en archivos muy grandes
3. **Guarda seguido** (`C-x C-s`) — el linter se activa al guardar, asi ves errores antes

---

## Ejercicio Practico: Generar y Explorar un Proyecto

1. **Genera un proyecto web:** Presiona `C-c n`, luego `w`, escribe `mi-web` y presiona `Enter`
2. **Abre el explorador:** Presiona `F7` para ver la estructura generada
3. **Abre el HTML:** Navega hasta `index.html` y presiona `Enter`
4. **Prueba el autocompletado:** Escribe `<di` y espera a que aparezca la sugerencia de `<div>`
5. **Ejecuta con Live Server:** Presiona `F5` — se abrira tu navegador mostrando la pagina
6. **Modifica algo:** Cambia el texto dentro de un `<h1>` y guarda con `C-x C-s`. Observa como el navegador se actualiza automaticamente.
7. **Formatea:** Si el HTML quedo desalineado, presiona `C-c x f` para formatearlo

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| El autocompletado no aparece | El servidor LSP no se inicio | Espera unos segundos despues de abrir el archivo. Si persiste, guarda el archivo (`C-x C-s`) |
| "Cannot find module" en el autocompletado | Faltan dependencias del proyecto | Presiona `C-c x b` (Build) para instalar dependencias |
| El generador no crea el proyecto | Falta Git instalado | Verifica con `git --version` en terminal |
| F12 no funciona | El LSP aun esta inicializando | Espera unos segundos. En proyectos grandes puede tardar la primera vez |
| Dashboard vacio | Primera vez usando FORJA | Es normal. Se llenara a medida que trabajes con proyectos |

## Resumen de Atajos de esta Guia

```
C-c n        → Menu de generadores de proyectos
C-c x        → Menu Hydra (compilacion/acciones)
C-c x e      → Lista de errores del archivo actual
F5           → Ejecutar programa / Live Server
F12          → Ir a definicion (LSP)
S-F12        → Ver referencias (LSP)
M-,          → Volver despues de F12
C-n / C-p    → Navegar autocompletado (abajo / arriba)
C-g          → Cancelar / cerrar autocompletado
```

---

**Anterior:** [Guia 00: Conceptos Basicos](00_Basics.md) | **Siguiente:** [Guia 02: Proyectos y Git](02_Proyectos_y_Git.md) | [Volver al README](../README.md)
