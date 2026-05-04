# FORJA — Ayuda y Referencia

Punto unico de ayuda para el alumno que ya tiene FORJA instalado.
Para instalar FORJA → [README.md](README.md)

---

## Indice

1. [Primeros Pasos](#1-primeros-pasos)
2. [Cheatsheet: Teclas Principales](#2-cheatsheet-teclas-principales)
3. [Guias How-To](#3-guias-how-to)
4. [Modelos de IA](#4-modelos-de-ia)
5. [Referencia: Modulos](#5-referencia-modulos)
6. [Referencia: Lenguajes y LSP](#6-referencia-lenguajes-y-lsp)
7. [Referencia: Plataformas](#7-referencia-plataformas)

---

## 1. Primeros Pasos

Abri Emacs. El Dashboard aparece automaticamente. Desde ahi podes:

- `C-c x` — Menu de compilacion/ejecucion (detecta el lenguaje del buffer)
- `C-c n` — Crear nuevo proyecto
- `C-c i` — Menu de Aider (asistente IA)
- `F7` — Arbol de archivos del proyecto (Treemacs)
- `F5` — Ejecutar el archivo/proyecto actual

Para aprender paso a paso → [Guia 00: Conceptos Basicos](how_to/00_Basics.md)

---

## 2. Cheatsheet: Teclas Principales

### Compilacion y Ejecucion — Hydra (`C-c x`)

Menu unificado que detecta el lenguaje del buffer actual:

| Tecla | Accion |
| :--- | :--- |
| `r` | **Run** — Ejecutar (equivale a F5) |
| `b` | **Build** — Compilar/instalar dependencias |
| `t` | **Test** — Ejecutar tests |
| `k` | **Stop** — Parar servidor/proceso corriendo |
| `f` | **Format** — Formatear codigo |
| `d` | **Debug** — Iniciar debugger (solo PC) |
| `7` | Treemacs (arbol de proyecto) |
| `.` | Ir a definicion (LSP) |
| `,` | Ver referencias (LSP) |
| `e` | Lista de errores (Flycheck) |

**Comportamiento por lenguaje:**

| Lenguaje | Run | Build | Test | Format |
| :--- | :--- | :--- | :--- | :--- |
| C/C++ | gcc/clang + ejecutar | Makefile/CMake | — | clang-format |
| Rust | `cargo run` | `cargo build` | `cargo test` | rustfmt (LSP) |
| Go | `go run .` | `go build` | `go test` | gofmt (LSP) |
| Python | uvicorn/django/python | `pip install -r` | pytest/unittest | black (LSP) |
| PHP | artisan serve/php | `composer install` | phpunit/artisan | prettier |
| JS/TS | `npm run dev`/`npm start` | `npm install` | jest/`npm test` | prettier |
| HTML/CSS | Live Server | — | — | prettier |

### Compilacion y Ejecucion — F-keys

| Tecla | Contexto | Accion |
| :--- | :--- | :--- |
| **F5** | C/C++ | Compilar y ejecutar (detecta Makefile/CMake) |
| **F5** | Rust | `cargo run` |
| **F5** | Go | `go run .` |
| **F5** | Python | uvicorn (FastAPI) / django / `python archivo.py` |
| **F5** | PHP | `php artisan serve` / `php archivo.php` |
| **F5** | JS/TS | `npm run dev` / `npm start` / `node archivo.js` |
| **F5** | HTML/CSS | Live Server (hot reload) |
| **F6** | ESP32 | Flash & Monitor |
| **F7** | Global | Treemacs (arbol de proyecto) |
| **F9** | C/C++ | GDB Debugger |
| **F12** | Global | Ir a definicion (LSP) |

> **Termux:** Las F-keys aparecen en la barra de extra-keys.

### Generadores de Proyectos (`C-c n`)

Todos crean estructura, `.gitignore`, `.projectile`, `git init` + primer commit:

| Tecla | Proyecto | Stack |
| :--- | :--- | :--- |
| `C-c n c` | C (generico) | gcc/clang + Makefile |
| `C-c n C` | C++ (generico) | CMake |
| `C-c n g` | Game Dev (Raylib C) | Raylib + Makefile |
| `C-c n +` | Game Dev (Raylib C++) | Raylib + CMake |
| `C-c n r` | Rust (generico) | `cargo new` |
| `C-c n R` | Rust REST API | Actix-web + serde + CORS |
| `C-c n G` | Go (generico) | `go mod init` |
| `C-c n a` | Go REST API | Gin + handlers + CORS |
| `C-c n w` | Web (estatico) | HTML/CSS/JS |
| `C-c n W` | Web (Tailwind) | HTML + Tailwind CDN |
| `C-c n e` | Node.js REST API | Express + routes + CORS |
| `C-c n p` | Python REST API | FastAPI + uvicorn + venv |
| `C-c n P` | PHP REST API | Laravel (o estructura manual) |

### Aider — Asistente IA (`C-c i`)

| Tecla | Accion |
| :--- | :--- |
| `C-c i` | **Menu Aider** (hydra completo) |
| `C-c i o` | Abrir Aider en el proyecto |
| `C-c i a` | Agregar archivo al contexto |
| `C-c i c` | Cambiar funcion o region |
| `C-c i r` | Preguntar sobre region seleccionada |
| `C-c i f` | Corregir errores de Flycheck |
| `C-c i t` | Generar unit tests |
| `C-c i p` | Planificacion de software |
| `C-c i u` | Deshacer ultimo cambio de Aider |
| `C-c i h` | Historial de Aider |
| `M-i` | **Minuet** — Mostrar sugerencia inline |
| `TAB` | **Minuet** — Aceptar sugerencia |
| `M-[` | **Minuet** — Descartar sugerencia |

> **Aider** usa OpenRouter/Nemotron en la nube. Requiere `OPENROUTER_API_KEY`.
> **Minuet** usa `qwen2.5-coder:0.5b` local en Ollama. Funciona sin internet.

### OpenCode — Asistente Agentico en la Nube (`C-c O`)

| Tecla | Accion |
| :--- | :--- |
| `C-c O o` | Abrir TUI en raiz del proyecto |
| `C-c O s` | Cambiar al buffer TUI |
| `C-c O p` | Pregunta inline sobre el archivo actual |
| `C-c O r` | Pregunta sobre region seleccionada |
| `C-c O f` | Procesar archivo — analisis completo |
| `C-c O t` | Generar tests para el archivo |
| `C-c O e` | Corregir errores Flycheck con IA |

### Modelos IA (`C-c M`)

| Tecla | Accion |
| :--- | :--- |
| `C-c M` | Menu de modelos IA |
| `C-c M c` | Cambiar modelo de CODIGO (Ollama) |
| `C-c M e` | Cambiar modelo de ESPANOL (Ollama) |
| `C-c M s` | Guardar cambios a `profile.conf` |
| `C-c M i` | Ver modelos instalados en Ollama |
| `C-c T` | Traducir seleccion al espanol |

### Multiusuario y Sync (`C-c U`)

| Tecla | Accion |
| :--- | :--- |
| `C-c U s` | Sync a Drive — Subir |
| `C-c U S` | Sync desde Drive — Descargar |
| `C-c U D` | Configurar Drive (rclone) |
| `C-c U u` | Backup a USB |
| `C-c U r` | Restaurar desde USB |
| `C-c U e` | Exportar `.tar.gz` |
| `C-c U i` | Importar `.tar.gz` |
| `C-c U c` | Cambiar alumno activo |
| `C-c U t` | Estado actual (alumno, USB, Drive, n8n) |
| `C-c U N s` | n8n — Iniciar |
| `C-c U N x` | n8n — Detener |
| `C-c U N o` | n8n — Abrir en navegador |

### Gestion de Proyectos y Utilidades

| Tecla | Accion |
| :--- | :--- |
| `F7` | Treemacs (arbol de proyecto) |
| `C-c p f` | Buscar archivo en proyecto |
| `C-c p s g` | Buscar texto en proyecto (grep) |
| `C-c e` | Editar configuracion (carpeta modulos) |
| `C-c C-r` | Recargar configuracion |
| `C-c d a` | Ver codigo Assembly (C/C++) |
| `F12` | Ir a definicion (LSP) |
| `S-F12` | Ver referencias (LSP) |
| `C-c D` | Duplicar linea o region |
| `C-c R` | Invertir lista (Smart Reverse) |
| `C-c f b` | Formatear buffer completo |

---

## 3. Guias How-To

Serie de guias paso a paso con objetivos, ejercicios y tabla de errores comunes:

| # | Guia | Temas |
| :---: | :--- | :--- |
| 00 | [Conceptos Basicos](how_to/00_Basics.md) | Primeros pasos, Hydra, F-keys, navegacion basica |
| 01 | [Core y Entorno](how_to/01_Core_y_Entorno.md) | Dashboard, generadores de proyectos, LSP, Termux |
| 02 | [Proyectos y Git](how_to/02_Proyectos_y_Git.md) | Treemacs, Projectile, Magit, branches |
| 03 | [Desarrollo Web](how_to/03_Desarrollo_Web.md) | HTML, CSS, JS, Node.js, Live Server, NPM, tests |
| 04 | [Lenguajes Backend](how_to/04_Lenguajes_Backend.md) | Python, Go, Rust, PHP, APIs REST |
| 05 | [Juegos y Sistemas](how_to/05_Juegos_y_Sistemas.md) | C/C++, Raylib, ESP32, Godot, Unreal Engine |
| 06 | [Inteligencia Artificial](how_to/06_Inteligencia_Artificial.md) | Aider + Ollama, chat IA, refactoring, tests, fix |
| 07 | [Multiusuario y Sync](how_to/07_Multiusuario_y_Sync.md) | Alumnos, Google Drive, backup USB, exportar |
| 08 | [Productividad y Org](how_to/08_Productividad_y_Org.md) | GTD, captura, agenda, SOPs, checklists, Mermaid |
| 09 | [Automatizacion n8n](how_to/09_Automatizacion_n8n.md) | Workflows, webhooks, Telegram, email, GTD + n8n |
| 10 | [Depuracion y Diagnostico](how_to/10_Depuracion_y_Diagnostico.md) | GDB, breakpoints, diagnosticos LSP, Assembly, FASM |
| 11 | [Soporte y Extras](how_to/11_Soporte_y_Extras.md) | Tickets de soporte, PDF, LaTeX, Kanban, Org-babel |
| 12 | [Agentes IA Autonomos](how_to/12_Agente_Autonomo.md) | PicoClaw, OpenClaw, resolucion de tickets con IA |
| 13 | [Flujo TAO](how_to/13_Flujo_TAO.md) | Soporte operativo, tickets, caldav, modo examen |
| 14 | [OpenCode](how_to/14_OpenCode.md) | TUI agentico en la nube, consultas inline, procesamiento de archivos |

---

## 4. Modelos de IA

FORJA usa dos fuentes de IA complementarias:

- **Ollama (local):** autocompletado inline (Minuet), traduccion (`C-c T`), GTD. Tu codigo no sale de tu maquina.
- **OpenRouter (nube):** Aider (refactoring/agentic) y OpenCode (TUI). Requieren `OPENROUTER_API_KEY`.

### Modelos para codigo (Minuet / Ollama)

| Modelo | RAM | Notas |
| :--- | :--- | :--- |
| `qwen2.5-coder:0.5b` | ~400 MB | Minimo, rapido |
| `qwen2.5-coder:1.5b` | ~1 GB | Ligero, buen balance |
| `qwen2.5-coder:3b` | ~2 GB | Bueno para code review |
| `deepseek-coder-v2:lite` | ~3 GB | MoE 16B, muy bueno |
| `qwen2.5-coder:7b` | ~5 GB | Preciso, recomendado para desktop |
| `codellama:7b` | ~4 GB | Meta, bueno para C/C++ |
| `qwen2.5-coder:14b` | ~9 GB | Avanzado |
| `qwen2.5-coder:32b` | ~20 GB | El mejor, pesado |

### Modelos para espanol (traduccion / GTD / Ollama)

| Modelo | RAM | Notas |
| :--- | :--- | :--- |
| `qwen2.5:0.5b` | ~400 MB | Minimo, espanol basico |
| `gemma3:1b` | ~800 MB | Google, multilingue |
| `qwen2.5:3b` | ~2 GB | Bueno para traduccion |
| `llama3.2:3b` | ~2 GB | Meta, rapido y capaz |
| `mistral:7b` | ~4 GB | Fuerte en espanol |
| `qwen2.5:7b` | ~5 GB | Preciso, recomendado |
| `gemma3:12b` | ~8 GB | Google, excelente |
| `qwen2.5:14b` | ~9 GB | Avanzado, traduce bien |

> El menu `forja-menu.sh` solo muestra los modelos compatibles con tu RAM.
> Para cambiar en caliente: `C-c M c` (codigo) o `C-c M e` (espanol).

---

## 5. Referencia: Modulos

`init.el` detecta la maquina y carga modulos selectivamente:

| Modulo | Descripcion | Termux | WSL | Escuela | Casa |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **00-core** | UX, fuentes, LSP, snippets, hydra maestro | ✅ | ✅ | ✅ | ✅ |
| **01-dashboard** | Dashboard de inicio personalizado | ✅ | ✅ | ✅ | ✅ |
| **02-termux** | Parches Termux (teclado, UI, stubs IA) | ✅ | ❌ | ❌ | ❌ |
| **10-git** | Magit, Projectile, Treemacs, diff-hl | ✅ | ✅ | ✅ | ✅ |
| **20-web** | JS, TS, HTML, CSS, Node.js, Live Server | ✅ | ✅ | ✅ | ✅ |
| **30-cpp** | C/C++, FASM, GDB, ESP32, generadores C/Raylib | ✅ | ✅ | ✅ | ✅ |
| **31-rust** | Rust: rust-analyzer, cargo, generadores | ✅ | ✅ | ✅ | ✅ |
| **32-go** | Go: gopls, go build/test, generadores | ✅ | ✅ | ✅ | ✅ |
| **33-aider** | Aider (OpenRouter/nube) + Minuet inline (Ollama) | ❌ | ❌ | ✅ | ✅ |
| **34-python** | Python: pylsp, black, FastAPI/Django | ✅ | ✅ | ✅ | ✅ |
| **35-php** | PHP: intelephense, prettier, Laravel | ✅ | ✅ | ✅ | ✅ |
| **36-modelos** | Config central modelos IA, traduccion, C-c M/T | ❌ | ✅ | ✅ | ✅ |
| **40-unreal** | Unreal Engine 4/5 | ❌ | ❌ | ❌ | ✅ |
| **41-godot** | Godot: GDScript, gdformat | ❌ | ❌ | ✅ | ✅ |
| **49-multiusuario** | Gestion alumnos, USB, sync Drive, n8n | ✅ | ✅ | ✅ | ✅ |
| **50-gtd** | GTD con Org Mode, agenda, capturas, IA | ✅ | ✅ | ✅ | ✅ |
| **51-estandarizacion** | SOPs, checklists, templates | ✅ | ✅ | ✅ | ✅ |
| **52-vision-sistemica** | Diagramas, Mermaid, Graphviz | ✅ | ✅ | ✅ | ✅ |
| **53-soporte** | Asistencia operativa, KB, diagnosticos | ✅ | ✅ | ✅ | ✅ |
| **55-picoclaw** | PicoClaw: agente IA ligero (~20MB) | ❌ | ❌ | ❌ | ✅ |
| **56-openclaw** | OpenClaw: agente IA completo (~1.5GB) | ❌ | ❌ | ❌ | ✅ |
| **57-opencode** | OpenCode: TUI agentico en la nube (OpenRouter) | ✅* | ✅ | ✅ | ✅ |
| **99-misc** | PDF, Org extras, docencia | ✅ | ✅ | ✅ | ✅ |

> *Termux: requiere proot-distro Ubuntu (~500MB)

---

## 6. Referencia: Lenguajes y LSP

| Lenguaje | Tree-Sitter | LSP Server | Formatter | Termux | WSL |
| :--- | :--- | :--- | :--- | :---: | :---: |
| C/C++ | ✅ | clangd | clang-format | ✅ | ✅ |
| Rust | ✅ | rust-analyzer | rustfmt | ✅ | ✅ |
| Go | ✅ | gopls | gofmt | ✅ | ✅ |
| Python | ✅ | pylsp | black | ✅ | ✅ |
| PHP | ✅ | intelephense | prettier | ✅ | ✅ |
| JavaScript | ✅ | typescript-language-server | prettier | ✅ | ✅ |
| TypeScript | ✅ | typescript-language-server | prettier | ✅ | ✅ |
| HTML | ✅ | vscode-langservers | prettier | ✅ | ✅ |
| CSS | ✅ | vscode-langservers | prettier | ✅ | ✅ |
| GDScript | — | — | gdformat | ❌ | ❌ |

---

## 7. Referencia: Plataformas

| Caracteristica | PC (Arch Linux) | Termux (Android) | WSL2 (Windows) |
| :--- | :--- | :--- | :--- |
| Compilador C/C++ | gcc + clang | clang (solo) | clang + gdb |
| GDB Debugger | ✅ | ❌ | ✅ |
| FASM (x86 ASM) | ✅ (si seleccionado) | ❌ | ❌ |
| ESP32 (idf.py) | ✅ (si seleccionado) | ❌ | ❌ |
| Aider (nube) | ✅ (si seleccionado) | ❌ | ❌ |
| Minuet inline (Ollama) | ✅ (si seleccionado) | ❌ | ❌ |
| Modelos IA locales | Configurable (0.5b-32b) | ❌ | ❌ |
| Traduccion (C-c T) | ✅ | ❌ (stub) | ✅ |
| Live Server | Abre Firefox | `--no-browser` | `--no-browser` |
| Godot | ✅ (si seleccionado) | ❌ | ❌ |
| Unreal Engine | ✅ (si seleccionado) | ❌ | ❌ |
| PicoClaw / OpenClaw | ✅ (si seleccionado) | ❌ | ❌ |
| OpenCode (TUI nube) | ✅ (si seleccionado) | ✅ (proot-distro) | ✅ (si seleccionado) |
| LaTeX export | ✅ (si seleccionado) | ❌ | ❌ |
| n8n (automatizacion) | ✅ (si seleccionado) | ❌ | ✅ |
| Sync Drive (rclone) | ✅ | ✅ | ✅ |
| Backup USB | ✅ | ✅ (storage) | ✅ |
| F-keys | Teclado nativo | Extra-keys en barra | Teclado nativo |
| GC threshold | 50MB / 1GB | 16MB / 64MB | 50MB / 1GB |
| Linter (Flycheck) | Dinamico (0.5s) | Al guardar (2.0s) | Dinamico |

> En PC, cada componente marcado "si seleccionado" depende de lo elegido en `forja-menu.sh`.
