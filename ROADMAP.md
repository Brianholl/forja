# FORJA — ROADMAP

Documento vivo de planificación. Actualizar al cerrar cada ciclo de trabajo.

---

## Estado Actual — v1.0 (Abril 2026)

### Implementado

| Área | Detalle |
|:---|:---|
| **Módulos** | 22 módulos `.org` completos (00-core → 99-misc) |
| **Plataformas** | Arch Linux · Termux (Android) · WSL2 |
| **Perfiles** | Minimal · Moderado · Full |
| **Lenguajes** | C/C++ · Rust · Go · Python · PHP · JS/TS · GDScript |
| **IA local** | Aider + Ollama, modelos seleccionables (0.5b–32b) |
| **Agentes** | PicoClaw (ligero) + OpenClaw (completo) |
| **Multiusuario** | Gestión de alumnos, sync Google Drive, backup USB |
| **Automatización** | n8n por alumno, webhooks, GTD |
| **Instalador** | `forja-menu.sh` TUI + `install.sh` / `update.sh` |
| **Docs** | 13 guías how-to pedagógicas (00–12) |

---

## v1.1 — UX y Dashboard

> Objetivo: mejorar la experiencia desde el primer segundo de uso.

- [x] **Dashboard — saludo personalizado:** mostrar nombre del usuario activo al abrir Emacs
- [x] **Dashboard — versión de Forja:** mostrar la versión actual (leída desde `~/.forja/profile.conf`)
- [x] **Dashboard — proyectos recientes:** listar proyectos del usuario ordenados por fecha de modificación
- [x] **Dashboard — acceso directo a `C-c n`:** botón visible desde el dashboard para crear proyecto nuevo
- [x] **Menú `C-c n` paginado:** hydra de 2 páginas, máx. 7 elementos por página, navegación n/b/q

---

## v1.2 — C como lenguaje mimado

> Objetivo: C debe tener el soporte más completo y pulido de todos los lenguajes.

- [x] **Unit testing:** Unity Test Framework — `C-c x t` → `make test` (descarga Unity automáticamente)
- [x] **Cobertura de código:** gcov + lcov → `make coverage`, abre `coverage/index.html`
- [x] **Sanitizers:** ASan + UBSan → `make asan` / `make ubsan` desde `C-c X`
- [x] **Valgrind:** `make valgrind` desde `C-c X v`
- [x] **GDB hydra mejorada:** `my/hydra-gdb` con run/step/next/finish/break/watch/print — `C-c G`
- [x] **Análisis estático:** clang-tidy desde `C-c X s` (clangd ya usa `--clang-tidy`)
- [x] **Template C profesional:** Makefile con targets `build`, `test`, `coverage`, `asan`, `ubsan`, `valgrind`, `clean`
- [ ] **FASM completo:** snippets y hydra — pendiente (movido a backlog)

---

## v1.3 — TypeScript independiente

> Objetivo: soporte para apps TypeScript puras, sin depender del stack web completo.

- [x] **Generador `C-c n T`:** proyecto TypeScript standalone — elige CLI o librería con `completing-read`
- [x] **tsconfig.json** base estricto incluido en ambos templates
- [x] **Ejecutar con `tsx`** — `F5` detecta `.ts` y usa `tsx` si está disponible; `dev: tsx watch` en scripts
- [x] **Template CLI:** `src/index.ts` con `process.argv`, `package.json` con campo `bin`
- [x] **Template librería:** `src/index.ts` con exports, `package.json` con `types` y `files`

---

## v1.4 — Optimización y Rendimiento

> Objetivo: tiempos de carga rápidos en todos los perfiles, especialmente Termux.

- [x] **Benchmark por perfil:** `my/forja-benchmark` → script bash, 3 runs, ms por run
- [x] **Lazy loading agresivo:** `40-unreal`, `55-picoclaw`, `56-openclaw` → idle timer 3s post-startup
- [x] **Profiling:** `esup` instalado — `M-x esup` analiza tiempo de carga por módulo
- [x] **Minimal más liviano:** Termux ya no carga Unreal/agentes; perfil revisado y limpio
- [x] **GC tuning:** `early-init.el` con 128 MB pre-startup; PC 1 GB / Termux 16 MB vía gcmh

---

## v1.5 — Plataformas y Lenguajes Nuevos

> Objetivo: ampliar cobertura sin romper los perfiles existentes.

- [ ] **WSL2 testing real:** verificar instalación limpia en Windows 11 + WSL2 Ubuntu
- [x] **Lua:** soporte básico para scripting de juegos (Löve2D) — módulo `42-lua.org`; generadores `my/new-lua-project` / `my/new-love-project`; F5 detecta Löve2D por `conf.lua`; LSP via `lua-language-server`
- [x] **Zig:** lenguaje de sistemas moderno — módulo `43-zig.org`; generador `my/new-zig-project` con `build.zig` + tests; F5 = `zig build run`; LSP via `zls`
- [x] **Java/Kotlin:** backend JVM — implementado en v1.6
- [ ] **Termux en Android 14+:** verificar compatibilidad, actualizar docs si hay cambios
- [x] **Paquete AUR:** `forja-git` — `aur/PKGBUILD` generado; instala en `/opt/forja`, expone `forja-install`

---

## v1.6 — Java / Kotlin y Diagnóstico

> Objetivo: soporte JVM completo y herramienta de diagnóstico para instalaciones.

- [x] **Java (Maven):** módulo `44-java.org`; `my/new-java-project` con estructura Maven, JUnit 5, `pom.xml`; F5 = `mvn compile exec:java`; LSP via `lsp-java` (descarga Eclipse JDT automáticamente)
- [x] **Kotlin (Gradle):** `my/new-kotlin-project` con `build.gradle.kts` + Kotlin DSL; F5 = `gradle run`; LSP via `kotlin-language-server`
- [x] **`forja doctor`:** `M-x my/forja-doctor` — verifica binarios de lenguajes, LSP servers, Docker, Ollama y versión de Emacs

---

## Backlog / Ideas Futuras

Ideas anotadas sin versión asignada todavía:

- Modo "examen": deshabilitar IA y acceso externo para evaluaciones presenciales
- Integración con GitHub Projects para seguimiento de tickets desde Emacs
- Plugin system: módulos de terceros agregables sin modificar el repo base
- Dashboard con estado del sistema: RAM, modelos Ollama cargados, alumno activo
- Soporte para múltiples workspaces por alumno (más de un proyecto activo)

---

## Historial de Versiones

| Versión | Fecha | Descripción |
|:---:|:---:|:---|
| v1.0 | Abril 2026 | Release inicial: 22 módulos, 3 plataformas, 3 perfiles, IA local, agentes, multiusuario |
| v1.1 | Abril 2026 | Dashboard personalizado: saludo, versión, proyectos recientes, botón nuevo proyecto |
| v1.2 | Abril 2026 | C como lenguaje mimado: Unity tests, gcov/lcov, ASan/UBSan, Valgrind, GDB hydra, clang-tidy |
| v1.3 | Abril 2026 | TypeScript standalone: generador CLI/librería, tsconfig, tsx, templates completos |
| v1.4 | Abril 2026 | Optimización: early-init, lazy loading Unreal/agentes, esup profiler, GC tuning |
| v1.5 | Abril 2026 | Nuevos lenguajes: Lua (script/Löve2D), Zig (sistemas); PKGBUILD AUR `forja-git` |
| v1.6 | Abril 2026 | JVM: Java (Maven + JUnit 5) + Kotlin (Gradle); `M-x forja-doctor` |
