# FORJA - Portable Educational Integrated Development Environment
## Emacs Modular Config - Full Stack & Game Dev

![Emacs Version](https://img.shields.io/badge/Emacs-29%2B-purple)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Supported-blue)
![Termux](https://img.shields.io/badge/Termux%20(Android)-Supported-green)
![WSL2](https://img.shields.io/badge/WSL2%20(Windows)-Supported-orange)
![License](https://img.shields.io/badge/License-MIT-green)

Configuracion modular de Emacs para **desarrollo Full Stack** (Node.js, Python, PHP, Go, Rust), **Game Dev** (C/C++, Raylib, Godot, Unreal) y **Sistemas** (ASM, ESP32). Soporta **Arch Linux (PC)**, **Termux (Android)** y **WSL2 (Windows)** con deteccion automatica de plataforma.

Incluye **Aider** (refactoring y agentic coding via OpenRouter/Nemotron en la nube), **Minuet** (autocompletado inline local con Ollama), **agentes autonomos** (PicoClaw + OpenClaw), **OpenCode** (asistente agentico TUI con modelos en la nube via OpenRouter), **sistema multiusuario** para entornos educativos, **sincronizacion Google Drive** via rclone, **automatizacion** con n8n y **GTD** con Org Mode.

---

## Caracteristicas Principales

- **Instalador interactivo:** Menu TUI (`forja-menu.sh`) con deteccion de hardware, perfiles y seleccion de modelos IA
- **Arquitectura modular:** 23 modulos `.org` (literate config) con carga selectiva por maquina
- **Multiplataforma:** Arch Linux (PC), Termux (Android) y WSL2 (Windows) con adaptacion automatica
- **Tres perfiles de instalacion:** Minimal (celular), Moderado (PC con poca RAM), Full (desktop)
- **Full Stack REST APIs:** Templates para Express, FastAPI, Laravel, Gin, Actix-web
- **Game Dev:** Raylib (C/C++), Godot (GDScript), Unreal Engine (solo PC)
- **Aider (cloud):** refactoring y agentic coding via OpenRouter/Nemotron (`openrouter/nvidia/nemotron-3-super-120b-a12b:free`). Requiere `OPENROUTER_API_KEY`. Los buffers se actualizan automaticamente cuando Aider aplica cambios (auto-revert)
- **Minuet inline autocomplete:** sugerencias de codigo con `qwen2.5-coder:0.5b` local en Ollama. `M-i` para mostrar, `TAB` para aceptar, `M-[` para descartar. Funciona en todos los lenguajes
- **Agentes IA autonomos:** PicoClaw (ligero) + OpenClaw (completo) para resolver tickets y diagnosticar proyectos
- **OpenCode:** asistente agentico TUI con 200+ modelos en la nube (OpenRouter) — sesiones interactivas, consultas inline, procesamiento de archivos. Disponible en Linux y Termux via proot-distro
- **Traduccion integrada:** `C-c T` traduce texto seleccionado al espanol con IA local
- **Sistema multiusuario:** Gestion de alumnos, backup USB, sync Google Drive. Estructura `forja-org`: `~/forja-org/local/` (personal/GTD/docs) y `~/forja-org/cloud/` (directorios de alumnos)
- **Sincronizacion Drive:** rclone semi-automatico — `C-c U s` sube, `C-c U S` descarga
- **GTD y documentacion:** Org Mode, org-roam, Kanban, diagramas, LaTeX
- **Automatizacion:** n8n por alumno para workflows (webhooks, Telegram, email, sync)
- **Hydra de compilacion:** Menu `C-c x` unificado para todos los lenguajes

---

## Guias de Uso (How-To)

Para aprender a utilizar el entorno FORJA paso a paso, consulta nuestra serie de guias en la carpeta `how_to`. Cada guia incluye objetivos de aprendizaje, prerequisitos, ejercicios practicos y tabla de errores comunes:

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

## Instalacion

### Paso 1: Clonar el repositorio

```bash
# Arch Linux / WSL
git clone https://github.com/Brianholl/forja ~/forja

# Termux (Android)
pkg install git
git clone https://github.com/Brianholl/forja ~/forja
```

### Paso 2: Configurar con el menu interactivo

```bash
cd ~/forja
bash forja-menu.sh
```

El menu detecta tu hardware automaticamente y te guia para elegir:

1. **Perfil de instalacion** (Minimal / Moderado / Full)
2. **Componentes opcionales** (Godot, n8n, LaTeX, ESP32, agentes IA, OpenCode, etc.)
3. **Modelos de IA** para codigo y para espanol (filtrados segun tu RAM)

La configuracion se guarda en `~/.forja/profile.conf`.

### Paso 3: Instalar

```bash
bash install.sh
```

El instalador lee `~/.forja/profile.conf` y solo instala los componentes que elegiste. Si no existe `profile.conf`, lanza el menu automaticamente. Pide la contrasena sudo una sola vez al inicio y la mantiene activa hasta terminar.

> **Modo legacy:** `bash install.sh --perfil casa` sigue funcionando para quienes prefieran CLI puro.

### Perfiles de instalacion

| Perfil | Plataforma | RAM | Que incluye |
| :--- | :--- | :--- | :--- |
| **Minimal** | Termux (Android) | < 4 GB | Editor + LSP + Git + GTD + OpenCode + Sync Drive |
| **Moderado** | Arch / WSL | 4-8 GB | + OpenCode + IA local + Game Dev + n8n + LaTeX + ESP32 |
| **Full** | Arch Linux | 16+ GB | + OpenCode + Modelos IA grandes + Agentes + Unreal + FASM |

Cada componente es opcional y se puede activar/desactivar individualmente en el menu.

---

## Uso de los Scripts

### Instalacion nueva (primera vez en la maquina)

```bash
cd ~/forja
bash forja-menu.sh   # elegir perfil y componentes
./install.sh         # instala todo — tarda ~30-60 min la primera vez
```

### Reinstalar FORJA (config rota, modulos actualizados, etc.)

```bash
cd ~/forja
./reinstall.sh
```

1. Pide confirmacion (`si`)
2. Pide contrasena sudo **una sola vez** y la mantiene activa hasta terminar
3. Limpia la config de Emacs preservando el cache de paquetes (`~/.emacs.d/elpa/`)
4. Reinstala sin actualizar el sistema ni redescargar paquetes ya cacheados

**Tiempo estimado:** 5-10 minutos (vs. 3 horas sin cache).

### Limpiar todo incluyendo cache de paquetes Emacs

Usar cuando hay paquetes corruptos o queres empezar absolutamente desde cero:

```bash
cd ~/forja
./clear.sh --purge
./update.sh
```

### Actualizar FORJA (pull + deps + MELPA)

```bash
cd ~/forja
./update.sh
```

Hace `git pull`, verifica dependencias, actualiza Rust/npm/pylsp/Aider/Ollama, re-tangle de modulos y actualiza paquetes MELPA.

### Reconfigurar perfil o features

```bash
cd ~/forja
bash forja-menu.sh   # elegir nuevos features o modelos
./install.sh         # aplicar cambios
```

### Verificar dependencias sin instalar nada

```bash
./install.sh --verify
```

---

## Modelos de IA

FORJA utiliza dos fuentes de IA complementarias:

- **Ollama (local):** autocompletado inline (Minuet), traduccion (`C-c T`), GTD y documentacion. Tu codigo no sale de tu maquina para estas funciones.
- **OpenRouter (nube):** Aider (refactoring/agentic coding) y OpenCode (TUI agentico). Requieren `OPENROUTER_API_KEY`.

Se configuran dos modelos Ollama independientes:

| Proposito | Para que se usa | Recomendado |
| :--- | :--- | :--- |
| **Modelo de codigo** | Minuet (autocomplete inline), code review, agentes locales | `qwen2.5-coder:0.5b` (Minuet) |
| **Modelo de espanol** | Traduccion (`C-c T`), GTD, soporte, documentacion | `qwen2.5`, `gemma3`, `llama3` |

> **Aider** usa `openrouter/nvidia/nemotron-3-super-120b-a12b:free` en la nube (no Ollama). Requiere la variable de entorno `OPENROUTER_API_KEY` (la misma que OpenCode).

### Modelos para codigo disponibles

| Modelo | RAM | Notas |
| :--- | :--- | :--- |
| `qwen2.5-coder:0.5b` | ~400 MB | Minimo, rapido |
| `qwen2.5-coder:1.5b` | ~1 GB | Ligero, buen balance |
| `qwen2.5-coder:3b` | ~2 GB | Bueno para code review |
| `deepseek-coder-v2:lite` | ~3 GB | MoE 16B, muy bueno |
| `qwen2.5-coder:7b` | ~5 GB | Preciso, recomendado para desktop |
| `codellama:7b` | ~4 GB | Meta, bueno para C/C++ |
| `qwen2.5-coder:14b` | ~9 GB | Avanzado |
| `codellama:13b` | ~8 GB | Meta, fuerte en C/Rust |
| `qwen2.5-coder:32b` | ~20 GB | El mejor, pesado |
| `codellama:34b` | ~20 GB | Meta, casi nivel GPT-4 |

### Modelos para espanol disponibles

| Modelo | RAM | Notas |
| :--- | :--- | :--- |
| `qwen2.5:0.5b` | ~400 MB | Minimo, espanol basico |
| `qwen2.5:1.5b` | ~1 GB | Ligero, buen espanol |
| `gemma3:1b` | ~800 MB | Google, multilingue |
| `qwen2.5:3b` | ~2 GB | Bueno para traduccion |
| `gemma3:4b` | ~3 GB | Google, buen espanol |
| `llama3.2:3b` | ~2 GB | Meta, rapido y capaz |
| `mistral:7b` | ~4 GB | Fuerte en espanol |
| `qwen2.5:7b` | ~5 GB | Preciso, recomendado |
| `llama3.1:8b` | ~5 GB | Meta, muy buen espanol |
| `gemma3:12b` | ~8 GB | Google, excelente |
| `qwen2.5:14b` | ~9 GB | Avanzado, traduce bien |
| `qwen2.5:32b` | ~20 GB | El mejor |

> El menu `forja-menu.sh` solo muestra los modelos compatibles con tu RAM. Los modelos se cargan bajo demanda, no permanecen en memoria.

### Cambiar modelos despues de instalar

Desde Emacs con `C-c M`:

| Tecla | Accion |
| :--- | :--- |
| `C-c M` | Menu de modelos IA |
| `C-c M c` | Cambiar modelo de CODIGO |
| `C-c M e` | Cambiar modelo de ESPANOL |
| `C-c M s` | Guardar cambios a `~/.forja/profile.conf` |
| `C-c M i` | Ver modelos instalados en Ollama |

O desde terminal: `bash forja-menu.sh` para reconfigurar todo.

---

## Estructura del Repositorio

```
forja/
├── emacs/
│   └── .emacs.d/
│       ├── init.el              # Orquestador: detecta maquina y carga modulos
│       └── modules/
│           ├── 00-core.org      # UX, fuentes, LSP, snippets, hydra maestro
│           ├── 01-dashboard.org # Dashboard de inicio
│           ├── 02-termux.org    # Parches y adaptaciones para Termux
│           ├── 10-git.org       # Magit, Projectile, Treemacs
│           ├── 20-web.org       # JS, TS, HTML, CSS, Node.js, Live Server, generadores web
│           ├── 30-cpp.org       # C, C++, FASM, GDB, ESP32, generadores C/Raylib
│           ├── 31-rust.org      # Rust: tree-sitter, LSP, cargo, generadores
│           ├── 32-go.org        # Go: tree-sitter, LSP, go build/test, generadores
│           ├── 33-aider.org     # Aider: Code Agent via OpenRouter/Nemotron (nube) + Minuet inline (Ollama local)
│           ├── 34-python.org    # Python: tree-sitter, pylsp, black, FastAPI, generadores
│           ├── 35-php.org       # PHP: tree-sitter, intelephense, Laravel, generadores
│           ├── 36-modelos.org   # Config central modelos IA, C-c M, C-c T
│           ├── 40-unreal.org    # Unreal Engine (solo PC)
│           ├── 41-godot.org     # Godot (GDScript)
│           ├── 49-multiusuario.org  # Sistema multiusuario + sync Drive
│           ├── 50-gtd.org       # Getting Things Done con Org Mode
│           ├── 51-estandarizacion.org # SOPs y checklists
│           ├── 52-vision-sistemica.org # Diagramas y mapas mentales
│           ├── 53-soporte.org   # Asistencia operativa y KB
│           ├── 55-picoclaw.org  # PicoClaw: agente IA ligero (solo Casa)
│           ├── 56-openclaw.org  # OpenClaw: agente IA completo (solo Casa)
│           ├── 57-opencode.org  # OpenCode: TUI agentico en la nube (OpenRouter)
│           └── 99-misc.org      # PDF, Org extras, docencia
├── shell/
│   └── .bashrc_custom           # Aliases y config de shell
├── termux/
│   └── .termux/
│       └── termux.properties    # Extra-keys (F5, F7, F12, arrows)
├── how_to/                      # 15 guias pedagogicas (00-14)
├── forja-menu.sh                # Menu interactivo de instalacion (TUI)
├── install.sh                   # Instalador (lee ~/.forja/profile.conf)
├── update.sh                    # Actualizador (lee ~/.forja/profile.conf)
└── README.md
```

### Archivo de configuracion (`~/.forja/profile.conf`)

Generado por `forja-menu.sh`, leido por `install.sh` y `update.sh`:

```bash
FORJA_PLATFORM="arch"
FORJA_PROFILE="full"
FORJA_FEATURES="opencode,aider,godot,raylib,n8n,picoclaw,openclaw,latex,esp32,fasm,sync-drive,multiusuario"
FORJA_MODEL_CODE="qwen2.5-coder:7b"
FORJA_MODEL_CHAT="qwen2.5:7b"
FORJA_CONFIG_DATE="2026-04-10"
FORJA_CONFIG_VERSION="2.0"
```

Tambien leido por Emacs (`36-modelos.org`) para configurar los modelos al iniciar.

---

## Arquitectura de Modulos

`init.el` detecta la maquina y carga modulos selectivamente:

| Modulo | Descripcion | Termux | WSL | Escuela | Casa |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **00-core** | UX, fuentes, LSP, snippets, hydra maestro | ✅ | ✅ | ✅ | ✅ |
| **01-dashboard** | Dashboard de inicio personalizado | ✅ | ✅ | ✅ | ✅ |
| **02-termux** | Parches Termux (teclado, UI, stubs IA) | ✅ | ❌ | ❌ | ❌ |
| **10-git** | Magit, Projectile, Treemacs, diff-hl | ✅ | ✅ | ✅ | ✅ |
| **20-web** | JS, TS, HTML, CSS, Node.js, Live Server, generadores web/express | ✅ | ✅ | ✅ | ✅ |
| **30-cpp** | C/C++, FASM, GDB, ESP32, clang/gcc, generadores C/Raylib | ✅ | ✅ | ✅ | ✅ |
| **31-rust** | Rust: tree-sitter, rust-analyzer, cargo, generadores | ✅ | ✅ | ✅ | ✅ |
| **32-go** | Go: tree-sitter, gopls, go build/test, generadores | ✅ | ✅ | ✅ | ✅ |
| **33-aider** | Aider (OpenRouter/Nemotron, nube) + Minuet inline (Ollama local, `qwen2.5-coder:0.5b`) | ❌ | ❌ | ✅ | ✅ |
| **34-python** | Python: pylsp, black, FastAPI/Django, generadores | ✅ | ✅ | ✅ | ✅ |
| **35-php** | PHP: intelephense, prettier, Laravel, generadores | ✅ | ✅ | ✅ | ✅ |
| **36-modelos** | Config central modelos IA, traduccion, C-c M/T | ❌ | ✅ | ✅ | ✅ |
| **40-unreal** | Unreal Engine 4/5 | ❌ | ❌ | ❌ | ✅ |
| **41-godot** | Godot: GDScript, gdformat | ❌ | ❌ | ✅ | ✅ |
| **49-multiusuario** | Gestion alumnos, USB, sync Drive, n8n. Estructura `forja-org`: `~/forja-org/local/` (personal/GTD/docs/procesos) y `~/forja-org/cloud/` (alumnos, multiusuario) | ✅ | ✅ | ✅ | ✅ |
| **50-gtd** | GTD con Org Mode, agenda, capturas, IA | ✅ | ✅ | ✅ | ✅ |
| **51-estandarizacion** | SOPs, checklists, templates | ✅ | ✅ | ✅ | ✅ |
| **52-vision-sistemica** | Diagramas, Mermaid, Graphviz | ✅ | ✅ | ✅ | ✅ |
| **53-soporte** | Asistencia operativa, KB, diagnosticos | ✅ | ✅ | ✅ | ✅ |
| **55-picoclaw** | PicoClaw: agente IA ligero (Go, ~20MB) | ❌ | ❌ | ❌ | ✅ |
| **56-openclaw** | OpenClaw: agente IA completo (Node.js) | ❌ | ❌ | ❌ | ✅ |
| **57-opencode** | OpenCode: TUI agentico en la nube (OpenRouter) | ✅* | ✅ | ✅ | ✅ |
| **99-misc** | PDF, Org extras, docencia | ✅ | ✅ | ✅ | ✅ |

> *Termux: requiere proot-distro Ubuntu (~500MB)

### Perfiles de Entorno

`init.el` detecta automaticamente Termux, WSL2, o identifica la maquina por hostname + usuario:

```elisp
;; Deteccion automatica
(defvar my/is-termux ...)  ; Termux (Android)
(defvar my/is-wsl ...)     ; WSL2 (Windows)
(defvar my/is-gui ...)     ; Modo grafico (X11/Wayland)

;; Perfiles: TERMUX → WSL → ESCUELA → CASA → fallback
(cond
 (my/is-termux ...)
 (my/is-wsl ...)
 ((and (string-equal (system-name) "archlinux")
       (string-equal user-login-name "estudiante")) ...)
 ...)
```

---

## Cheatsheet: Teclas Principales

### Hydra de Compilacion (`C-c x`)

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

### Generadores de Proyectos (`C-c n`)

Todos crean estructura, `.gitignore`, `.projectile`, `git init` + primer commit:

| Tecla | Proyecto | Stack |
| :--- | :--- | :--- |
| `C-c n c` | C (generico) | gcc/clang + Makefile |
| `C-c n C` | C++ (generico) | CMake |
| `C-c n g` | Game Dev (Raylib C) | Raylib + Makefile |
| `C-c n +` | Game Dev (Raylib C++) | Raylib + CMake |
| `C-c n r` | Rust (generico) | `cargo new` |
| `C-c n R` | **Rust REST API** | Actix-web + serde + CORS |
| `C-c n G` | Go (generico) | `go mod init` |
| `C-c n a` | **Go REST API** | Gin + handlers + CORS |
| `C-c n w` | Web (estatico) | HTML/CSS/JS |
| `C-c n W` | Web (Tailwind) | HTML + Tailwind CDN |
| `C-c n e` | **Node.js REST API** | Express + routes + CORS |
| `C-c n p` | **Python REST API** | FastAPI + uvicorn + venv |
| `C-c n P` | **PHP REST API** | Laravel (o estructura manual) |

> Los templates de REST API incluyen: endpoints `/`, `/health`, `/api/items` (GET+POST), `.env`, CORS y dependencias instaladas.

### Compilacion y Ejecucion (F-keys)

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

> **Termux:** Las F-keys aparecen en la barra de extra-keys. Si no se ven, ejecutar `install.sh` o `update.sh` y reiniciar Termux.

### Aider, Minuet y Traduccion

| Tecla | Accion |
| :--- | :--- |
| `C-c i` | Menu completo de Aider (refactoring / agentic coding) |
| `C-c i o` | Abrir Aider en el proyecto |
| `C-c i a` | Agregar archivo al contexto |
| `C-c i c` | Cambiar funcion o region |
| `C-c i t` | Generar unit tests |
| `C-c i f` | Corregir errores de Flycheck |
| `M-i` | **Minuet** — Mostrar sugerencia de autocompletado inline |
| `TAB` | **Minuet** — Aceptar sugerencia |
| `M-[` | **Minuet** — Descartar sugerencia |
| `C-c M` | **Menu de modelos IA** (cambiar, ver, guardar) |
| `C-c M c` | Cambiar modelo de CODIGO (Ollama) |
| `C-c M e` | Cambiar modelo de ESPANOL (Ollama) |
| `C-c M s` | Guardar modelos a `profile.conf` |
| `C-c M i` | Ver modelos instalados en Ollama |
| `C-c T` | **Traducir** region seleccionada al espanol |

> **Aider** usa OpenRouter/Nemotron en la nube (`openrouter/nvidia/nemotron-3-super-120b-a12b:free`). Requiere `OPENROUTER_API_KEY`. Cuando Aider aplica cambios a archivos, los buffers de Emacs se actualizan automaticamente (auto-revert).
>
> **Minuet** usa `qwen2.5-coder:0.5b` local en Ollama. Funciona en todos los lenguajes sin conexion a internet.
>
> **Traduccion y GTD** usan el modelo de espanol configurado en Ollama (100% local). Los modelos se eligen en `forja-menu.sh` o se cambian en caliente con `C-c M`.

### OpenCode — Asistente Agentico en la Nube (`C-c O`)

Disponible en todos los modos de programacion. Requiere `opencode` feature activo en `profile.conf`.

| Tecla | Accion |
| :--- | :--- |
| `C-c O o` | **Abrir TUI** en raiz del proyecto actual |
| `C-c O s` | Cambiar al buffer TUI (si ya esta abierto) |
| `C-c O p` | **Pregunta inline** sobre el archivo actual |
| `C-c O r` | **Pregunta sobre region** seleccionada |
| `C-c O f` | **Procesar archivo** — analisis completo + diffs |
| `C-c O t` | Generar tests para el archivo actual |
| `C-c O e` | Corregir errores Flycheck con IA |
| `C-c F A` | Menu maestro → Agentes IA (PicoClaw/OpenClaw/OpenCode) |

> OpenCode usa modelos en la nube (OpenRouter, 200+ modelos). El TUI se abre en Alacritty (`C-c O o`). Disponible en Termux via proot-distro Ubuntu. Ver [Guia 14](how_to/14_OpenCode.md).

### Sistema Multiusuario y Sync (`C-c U`)

| Tecla | Accion |
| :--- | :--- |
| `C-c U s` | **Sync a Drive** — Subir datos a Google Drive |
| `C-c U S` | **Sync desde Drive** — Descargar datos desde Google Drive |
| `C-c U D` | **Configurar Drive** — Setup guiado de rclone |
| `C-c U u` | Backup a USB |
| `C-c U r` | Restaurar desde USB |
| `C-c U e` | Exportar `.tar.gz` |
| `C-c U i` | Importar `.tar.gz` |
| `C-c U N s` | **n8n** — Iniciar (datos del alumno activo) |
| `C-c U N x` | **n8n** — Detener |
| `C-c U N o` | **n8n** — Abrir en navegador |
| `C-c U O` | **Agentes IA** — Submenu PicoClaw/OpenClaw/OpenCode |
| `C-c U O p` | **PicoClaw** — Agente ligero (~20MB RAM) |
| `C-c U O o` | **OpenClaw** — Agente completo (~1.5GB RAM) |
| `C-c U O c` | **OpenCode** — Asistente TUI en la nube |
| `C-c U c` | Cambiar alumno activo |
| `C-c U t` | Estado actual (alumno, USB, Drive, n8n) |

### Sincronizacion Google Drive

Los datos del alumno se sincronizan entre dispositivos via **rclone + Google Drive**:

```
PC Escuela (Arch) <-> Google Drive <-> Celular (Termux) / PC Casa (WSL/Arch)
```

**Primera vez:** `C-c U D` abre un asistente de configuracion de rclone.

**Uso diario:**
1. Al terminar en el colegio: `C-c U s` (sube a Drive)
2. Al llegar a casa: `C-c U S` (descarga desde Drive)
3. Al terminar en casa: `C-c U s` (sube a Drive)

> Solo se sincronizan archivos mas nuevos (`--update`). No se borran archivos remotos.

### Gestion de Proyectos

| Tecla | Accion |
| :--- | :--- |
| **F7** | Treemacs (arbol de proyecto) |
| `C-c p f` | Buscar archivo en proyecto |
| `C-c p s g` | Buscar texto en proyecto (grep) |
| `C-c e` | Editar configuracion (carpeta modulos) |
| `C-c C-r` | Recargar configuracion |

### Utilidades

| Tecla | Accion |
| :--- | :--- |
| `C-c T` | Traducir seleccion al espanol (Ollama) |
| `C-c d a` | Ver codigo Assembly (C/C++) |
| `F12` | Ir a definicion (LSP) |
| `S-F12` | Ver referencias (LSP) |
| `C-c D` | Duplicar linea o region |
| `C-c R` | Invertir lista (Smart Reverse) |
| `C-c f b` | Formatear buffer completo |

---

## Lenguajes y LSP Servers

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

## Diferencias PC vs Termux vs WSL

| Caracteristica | PC (Arch Linux) | Termux (Android) | WSL2 (Windows) |
| :--- | :--- | :--- | :--- |
| Compilador C/C++ | gcc + clang | clang (solo) | clang + gdb |
| GDB Debugger | ✅ | ❌ | ✅ |
| FASM (x86 ASM) | ✅ (si seleccionado) | ❌ | ❌ |
| ESP32 (idf.py) | ✅ (si seleccionado) | ❌ | ❌ |
| Aider (nube, OpenRouter) | ✅ (si seleccionado) | ❌ | ❌ |
| Minuet inline (Ollama local) | ✅ (si seleccionado) | ❌ | ❌ |
| Ollama (modelos locales) | ✅ (si seleccionado) | ❌ | ❌ |
| Modelos IA locales | Configurable (0.5b-32b) | ❌ | ❌ |
| Traduccion (C-c T) | ✅ | ❌ (stub) | ✅ |
| Live Server | Abre Firefox | `--no-browser` | `--no-browser` |
| Godot | ✅ (si seleccionado) | ❌ | ❌ |
| Unreal Engine | ✅ (si seleccionado) | ❌ | ❌ |
| PicoClaw | ✅ (si seleccionado) | ❌ | ❌ |
| OpenClaw | ✅ (si seleccionado) | ❌ | ❌ |
| OpenCode (TUI nube) | ✅ (si seleccionado) | ✅ (proot-distro) | ✅ (si seleccionado) |
| LaTeX export | ✅ (si seleccionado) | ❌ | ❌ |
| n8n (automatizacion) | ✅ (si seleccionado) | ❌ | ✅ |
| Sync Drive (rclone) | ✅ | ✅ | ✅ |
| Backup USB | ✅ | ✅ (storage) | ✅ |
| F-keys | Teclado nativo | Extra-keys en barra | Teclado nativo |
| Stow | Symlinks | `cp` directo | Symlinks |
| GC threshold | 50MB / 1GB | 16MB / 64MB | 50MB / 1GB |
| UI y autocompletado | Normal (delay 0.0) | Ligero (delay 0.3s) | Normal |
| Linter (Flycheck) | Dinamico (0.5s) | Al guardar (2.0s) | Dinamico |
| Cliente Git (Magit) | Completo | Secciones pesadas omitidas | Completo |

> En PC, cada componente marcado "si seleccionado" depende de lo que se eligio en `forja-menu.sh`. El menu filtra opciones segun la plataforma automaticamente.

---

## Post-Instalacion

### Primera vez en PC

```
M-x all-the-icons-install-fonts
M-x nerd-icons-install-fonts
```

### Primera vez en Termux

```bash
# Si las extra-keys no aparecen, reiniciar Termux
# Si falla install.sh, verificar:
termux-setup-storage  # Acceso a almacenamiento
```

### Primera vez en WSL

```bash
# Si Emacs no es version 29+:
sudo add-apt-repository ppa:ubuntuhandbook1/emacs
sudo apt-get update && sudo apt-get install emacs
```

### Configurar Google Drive (todas las plataformas)

```
# Dentro de Emacs:
C-c U D  → Abre asistente de configuracion de rclone
# O manualmente en terminal:
rclone config
# Crear remote "gdrive" de tipo "Google Drive"
```

---

## Flujo de Instalacion Completo

```
forja-menu.sh                     install.sh
┌─────────────────────┐           ┌──────────────────────────────┐
│  1. Detectar HW     │           │  Lee ~/.forja/profile.conf   │
│  2. Elegir perfil   │──saves──> │  ┌────────────────────────┐  │
│  3. Elegir features │           │  │ FORJA_PROFILE="full"   │  │
│  4. Elegir modelos  │           │  │ FORJA_FEATURES="..."   │  │
│  5. Confirmar       │           │  │ FORJA_MODEL_CODE="..." │  │
└─────────────────────┘           │  │ FORJA_MODEL_CHAT="..." │  │
                                  │  └────────────────────────┘  │
                                  │  Instala solo lo elegido     │
                                  └──────────────────────────────┘
                                               │
                                               v
                                  ┌──────────────────────────────┐
                                  │  update.sh                   │
                                  │  Lee el mismo profile.conf   │
                                  │  Actualiza solo lo instalado │
                                  └──────────────────────────────┘
                                               │
                                               v
                                  ┌──────────────────────────────┐
                                  │  Emacs (36-modelos.org)      │
                                  │  Lee profile.conf al iniciar │
                                  │  Configura gptel + aider     │
                                  │  C-c M para cambiar en vivo  │
                                  └──────────────────────────────┘
```

---

## Desarrollo

- Branch principal: `main`
- Los archivos `.el` son **generados** — editar solo los `.org`
- Despues de modificar un `.org`, borrar el `.el` correspondiente para forzar re-tangle
- Commits en espanol, formato conventional commits (`feat:`, `fix:`, `refactor:`)
- Variables de plataforma: `my/is-termux`, `my/is-gui`, `my/is-wsl` (definidas en `init.el`)
- Guard pattern: `(bound-and-true-p my/is-termux)`, `(bound-and-true-p my/is-wsl)`
- Configuracion persistente: `~/.forja/profile.conf` (no commitear, es por maquina)
- **Fix critico aplicado:** el regex en `my/forja--read-conf` excluia la letra `n`, haciendo que todos los features con 'n' en el nombre (`opencode`, `n8n`, `unreal`, etc.) no cargaran. Corregido en `init.el`.

---

Happy Hacking!
