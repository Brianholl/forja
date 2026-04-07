# FORJA - Portable Educational Integrated Development Environment
## Emacs Modular Config - Full Stack & Game Dev

![Emacs Version](https://img.shields.io/badge/Emacs-29%2B-purple)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Supported-blue)
![Termux](https://img.shields.io/badge/Termux%20(Android)-Supported-green)
![WSL2](https://img.shields.io/badge/WSL2%20(Windows)-Supported-orange)
![License](https://img.shields.io/badge/License-MIT-green)

Configuracion modular de Emacs para **desarrollo Full Stack** (Node.js, Python, PHP, Go, Rust), **Game Dev** (C/C++, Raylib, Godot, Unreal) y **Sistemas** (ASM, ESP32). Soporta **Arch Linux (PC)**, **Termux (Android)** y **WSL2 (Windows)** con deteccion automatica de plataforma.

Incluye **IA local** via Aider + Ollama, **sistema multiusuario** para entornos educativos, **sincronizacion Google Drive** via rclone y **GTD** con Org Mode.

---

## Caracteristicas Principales

- **Arquitectura modular:** 18 modulos `.org` (literate config) con carga selectiva por maquina
- **Multiplataforma:** Arch Linux (PC), Termux (Android) y WSL2 (Windows) con adaptacion automatica
- **Full Stack REST APIs:** Templates para Express, FastAPI, Laravel, Gin, Actix-web
- **Game Dev:** Raylib (C/C++), Godot (GDScript), Unreal Engine (solo PC)
- **AI Code Agent:** Aider + Ollama (sin API keys, 100% local, solo PC)
- **Sistema multiusuario:** Gestion de alumnos, backup USB, sync Google Drive
- **Sincronizacion Drive:** rclone semi-automatico — `C-c U s` sube, `C-c U S` descarga
- **GTD y documentacion:** Org Mode, org-roam, Kanban, diagramas, LaTeX
- **Hydra de compilacion:** Menu `C-c x` unificado para todos los lenguajes

---

## Guías de Uso (How-To)

Para aprender a utilizar el entorno FORJA paso a paso, consulta nuestra serie de guías en la carpeta `how_to`:

- [00_Basics.md](how_to/00_Basics.md) - Conceptos básicos, navegación y primeros pasos.
- [01_Core_y_Entorno.md](how_to/01_Core_y_Entorno.md) - Hydra, Autocompletado, Dashboard y Termux.
- [02_Proyectos_y_Git.md](how_to/02_Proyectos_y_Git.md) - Treemacs, Projectile y Magit.
- [03_Desarrollo_Web.md](how_to/03_Desarrollo_Web.md) - HTML, CSS, JS, Node y Live Server.
- [04_Lenguajes_Backend.md](how_to/04_Lenguajes_Backend.md) - Rust, Go, Python y PHP.
- [05_Juegos_y_Sistemas.md](how_to/05_Juegos_y_Sistemas.md) - C/C++, ESP32, Godot y Unreal Engine.
- [06_Inteligencia_Artificial.md](how_to/06_Inteligencia_Artificial.md) - Uso de Aider (IA Local) interactivo.
- [07_Multiusuario_y_Sync.md](how_to/07_Multiusuario_y_Sync.md) - Sincronización Google Drive y copias locales (USB).
- [08_Productividad_y_Org.md](how_to/08_Productividad_y_Org.md) - Sistema GTD, Procedimientos y renderizado de Diagramas.

---

## Instalacion Rapida

### Opcion 1: Arch Linux (PC del colegio/casa)

```bash
git clone https://github.com/Brianholl/forja
cd ~/forja
install.sh
update.sh
```

### Opcion 2: Termux (Android)

```bash
pkg install git
git clone https://github.com/Brianholl/forja
cd ~/forja
install.sh
update.sh
```

> **Nota:** En Termux se usa `cp` en vez de `stow` para `termux.properties` porque Termux no sigue symlinks en su directorio de config.

### Opcion 3: Windows (WSL2)

```powershell
# Desde PowerShell (como Administrador):
wsl --install
# Reiniciar Windows, abrir Ubuntu desde el menu Inicio
```

```bash
# Dentro de WSL (Ubuntu):
git clone https://github.com/Brianholl/forja
cd ~/forja
install.sh
update.sh
```

### Actualizar

```bash
cd ~/forja
update.sh
```

Actualiza: sistema, Rust, npm globals, Python LSP, Aider, Ollama, dotfiles, re-tangle de modulos y paquetes MELPA.

---

## Estructura del Repositorio

```
forja/
├── emacs/
│   └── .emacs.d/
│       ├── init.el              # Orquestador: detecta maquina y carga modulos
│       └── modules/
│           ├── 00-core.org      # UX, fuentes, LSP, snippets, templates, hydra
│           ├── 01-dashboard.org # Dashboard de inicio
│           ├── 10-git.org       # Magit, Projectile, Treemacs
│           ├── 20-web.org       # JS, TS, HTML, CSS, Node.js, Live Server
│           ├── 30-cpp.org       # C, C++, FASM, GDB, ESP32
│           ├── 31-rust.org      # Rust: tree-sitter, LSP, cargo
│           ├── 32-go.org        # Go: tree-sitter, LSP, go build/test
│           ├── 33-aider.org     # Aider: Code Agent con Ollama local
│           ├── 34-python.org    # Python: tree-sitter, pylsp, black, FastAPI
│           ├── 35-php.org       # PHP: tree-sitter, intelephense, Laravel
│           ├── 40-unreal.org    # Unreal Engine (solo PC Casa)
│           ├── 41-godot.org     # Godot (GDScript)
│           ├── 49-multiusuario.org  # Sistema multiusuario + sync Drive
│           ├── 50-gtd.org       # Getting Things Done con Org Mode
│           ├── 51-estandarizacion.org # SOPs y checklists
│           ├── 52-vision-sistemica.org # Diagramas y mapas mentales
│           ├── 53-soporte.org   # Asistencia operativa y KB
│           └── 99-misc.org      # PDF, Org extras, docencia
├── shell/
│   └── .bashrc_custom           # Aliases y config de shell
├── termux/
│   └── .termux/
│       └── termux.properties    # Extra-keys (F5, F7, F12, arrows)
├── install.sh                   # Instalador completo (PC + Termux + WSL)
├── update.sh                    # Actualizador de dependencias
└── README.md
```

---

## Arquitectura de Modulos

`init.el` detecta la maquina y carga modulos selectivamente:

| Modulo | Descripcion | Termux | WSL | Escuela | Casa |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **00-core** | UX, fuentes, LSP, snippets, generadores, hydra | ✅ | ✅ | ✅ | ✅ |
| **01-dashboard** | Dashboard de inicio personalizado | ✅ | ✅ | ✅ | ✅ |
| **10-git** | Magit, Projectile, Treemacs, diff-hl | ✅ | ✅ | ✅ | ✅ |
| **20-web** | JS, TS, HTML, CSS, Node.js, Live Server | ✅ | ✅ | ✅ | ✅ |
| **30-cpp** | C/C++, FASM, GDB, ESP32, clang/gcc | ✅ | ✅ | ✅ | ✅ |
| **31-rust** | Rust: tree-sitter, rust-analyzer, cargo | ✅ | ✅ | ✅ | ✅ |
| **32-go** | Go: tree-sitter, gopls, go build/test | ✅ | ✅ | ✅ | ✅ |
| **33-aider** | Aider + Ollama (IA local) | ❌ | ❌ | ✅ | ✅ |
| **34-python** | Python: pylsp, black, FastAPI/Django | ✅ | ✅ | ✅ | ✅ |
| **35-php** | PHP: intelephense, prettier, Laravel | ✅ | ✅ | ✅ | ✅ |
| **40-unreal** | Unreal Engine 4/5 | ❌ | ❌ | ❌ | ✅ |
| **41-godot** | Godot: GDScript, gdformat | ❌ | ❌ | ✅ | ✅ |
| **49-multiusuario** | Gestion alumnos, USB, sync Drive | ✅ | ✅ | ✅ | ✅ |
| **50-gtd** | GTD con Org Mode, agenda, capturas | ✅ | ✅ | ✅ | ✅ |
| **51-estandarizacion** | SOPs, checklists, templates | ✅ | ✅ | ✅ | ✅ |
| **52-vision-sistemica** | Diagramas, Mermaid, Graphviz | ✅ | ✅ | ✅ | ✅ |
| **53-soporte** | Asistencia operativa, KB | ✅ | ✅ | ✅ | ✅ |
| **99-misc** | PDF, Org extras, docencia | ✅ | ✅ | ✅ | ✅ |

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

### Sistema Multiusuario y Sync (`C-c U`)

| Tecla | Accion |
| :--- | :--- |
| `C-c U s` | **Sync → Drive** — Subir datos a Google Drive |
| `C-c U S` | **Sync ← Drive** — Descargar datos desde Google Drive |
| `C-c U D` | **Configurar Drive** — Setup guiado de rclone |
| `C-c U u` | Backup a USB |
| `C-c U r` | Restaurar desde USB |
| `C-c U e` | Exportar `.tar.gz` |
| `C-c U i` | Importar `.tar.gz` |
| `C-c U c` | Cambiar alumno activo |
| `C-c U t` | Estado actual (alumno, USB, Drive) |

### Sincronizacion Google Drive

Los datos del alumno se sincronizan entre dispositivos via **rclone + Google Drive**:

```
PC Escuela (Arch) ←→ Google Drive ←→ Celular (Termux) / PC Casa (WSL/Arch)
```

**Primera vez:** `C-c U D` abre un asistente de configuracion de rclone.

**Uso diario:**
1. Al terminar en el colegio: `C-c U s` (sube a Drive)
2. Al llegar a casa: `C-c U S` (descarga desde Drive)
3. Al terminar en casa: `C-c U s` (sube a Drive)

> Solo se sincronizan archivos mas nuevos (`--update`). No se borran archivos remotos.

### Aider — IA Local (solo PC)

| Tecla | Accion |
| :--- | :--- |
| `C-c i` | Menu completo de Aider |
| `C-c i o` | Abrir Aider en el proyecto |
| `C-c i a` | Agregar archivo al contexto |
| `C-c i c` | Cambiar funcion o region |
| `C-c i t` | Generar unit tests |
| `C-c i f` | Corregir errores de Flycheck |

> Usa `qwen2.5-coder` via Ollama. Sin API keys, sin internet, 100% local.

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
| `C-c T` | Traducir seleccion (Ollama) |
| `C-c d a` | Ver codigo Assembly |
| `F12` | Ir a definicion (LSP) |
| `S-F12` | Ver referencias (LSP) |

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
| FASM (x86 ASM) | ✅ | ❌ | ❌ |
| ESP32 (idf.py) | ✅ | ❌ | ❌ |
| Aider (IA) | ✅ | ❌ | ❌ |
| Ollama | ✅ | ❌ | ❌ |
| Live Server | Abre Firefox | `--no-browser` | `--no-browser` |
| Godot | ✅ | ❌ | ❌ |
| Unreal Engine | Solo perfil Casa | ❌ | ❌ |
| LaTeX export | ✅ | ❌ | ❌ |
| Sync Drive (rclone) | ✅ | ✅ | ✅ |
| Backup USB | ✅ | ✅ (storage) | ✅ |
| F-keys | Teclado nativo | Extra-keys en barra | Teclado nativo |
| Stow | Symlinks | `cp` directo | Symlinks |
| GC threshold | 50MB / 1GB | 16MB / 64MB | 50MB / 1GB |
| UI & Autocompletado | Normal (delay 0.0) | Ligero (delay 0.3s, N. abs) | Normal |
| Linter (Flycheck) | Dinámico (0.5s) | Al guardar (2.0s) | Dinámico |
| Cliente Git (Magit) | Completo | Secciones pesadas omitidas | Completo |

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

## Desarrollo

- Branch principal: `experimental/emacs-next-gen`
- Los archivos `.el` son **generados** — editar solo los `.org`
- Despues de modificar un `.org`, borrar el `.el` correspondiente para forzar re-tangle
- Commits en espanol, formato conventional commits (`feat:`, `fix:`, `refactor:`)
- Variables de plataforma: `my/is-termux`, `my/is-gui`, `my/is-wsl` (definidas en `init.el`)
- Guard pattern: `(bound-and-true-p my/is-termux)`, `(bound-and-true-p my/is-wsl)`

---

Happy Hacking!
