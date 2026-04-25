# FORJA — ROADMAP

Documento vivo de planificación. Actualizar al cerrar cada ciclo de trabajo.

---

## Estado Actual — v2.0 (Abril 2026)

### Implementado

| Área | Detalle |
|:---|:---|
| **Módulos** | 22 módulos `.org` (00-core → 99-misc); generadores en sus módulos de lenguaje |
| **Plataformas** | Arch Linux · Termux (Android) · WSL2 |
| **Perfiles** | Minimal · Moderado · Full |
| **Lenguajes** | C/C++ · Rust · Go · Python · PHP · JS/TS · GDScript · Lua · Zig · Java · Kotlin |
| **IA local** | Aider + Ollama, modelos seleccionables (0.5b–32b); traducción integrada `C-c T` |
| **Agentes** | PicoClaw (ligero) + OpenClaw (completo), lazy-load 3s post-startup |
| **Multiusuario** | Alumnos, sesiones y progreso, sync Drive (rclone), backup USB, vista docente |
| **GTD** | inbox · proyectos · tickler · hábitos · calendario · revisión semanal · IA-GTD |
| **Soporte (TAO)** | Tickets integrados en GTD (`50-gtd.el`), dashboard de soporte en agenda |
| **Automatización** | n8n por alumno, webhooks, GTD + n8n |
| **Instalador** | `forja-menu.sh` TUI + `install.sh` / `update.sh` / `--verify` + `forja doctor` |
| **Distribución** | PKGBUILD AUR `forja-git` generado |
| **Arquitectura** | Encapsulamiento: generadores en módulos, hydras `my/hydra-*`, dispatch table |
| **Docs** | 13 guías how-to (00–12) + README v2.0 |

---

## Pendientes para Producto Terminado

Los ítems con `[ ]` son los que quedan antes de llamar a FORJA un producto **publicable y cerrado**.

### Bloque A — Taller de Asistencia Operativa (TAO) ✓ v2.1

- [x] **org-caldav:** activado y documentado (`C-c g y`, configurable desde `local.el`)
- [x] **Modo examen `C-c F e`:** suspende gptel/Aider/agentes; indicador en modeline
- [x] **Template `a` (alumno):** `seguimiento.org` integrado en GTD
- [x] **Widget GTD en dashboard:** tickets, alumnos activos e inbox al arrancar
- [x] **How-to 13 — Flujo TAO:** guía docente completa

### Bloque B — Compatibilidad y Distribución

- [ ] **Matriz de compatibilidad:** tabla plataforma × perfil × lenguaje generada desde `test.sh` → `COMPATIBILITY.md`
- [ ] **WSL2 real:** instalar y verificar en Windows 11 + WSL2 Ubuntu (sin test real hasta ahora)
- [ ] **Android 14+:** verificar Termux con permisos nuevos; actualizar docs
- [ ] **AUR publicación:** probar `forja-git` desde AUR en instalación limpia (`makepkg -si`)
- [ ] **FASM:** decisión final — snippets básicos incluidos o descartado formalmente del backlog

---

## v1.7 — Hydra Maestro y Dashboard de Updates

> Objetivo: mejorar navegación y mantener al usuario informado de cambios.

- [x] **Hydra maestro `C-c F`:** menú unificado de FORJA accesible desde cualquier buffer
- [x] **Lua/Zig/Java/Kotlin en build hydra:** todos los lenguajes nuevos integrados en `C-c x`
- [x] **Notificación de updates:** dashboard avisa cuando hay versión nueva disponible

---

## v1.8 — Dashboard de Estado del Sistema

> Objetivo: ver el estado del entorno de trabajo desde el primer segundo.

- [x] **RAM en dashboard:** uso actual de memoria visible al abrir Emacs
- [x] **Estado Ollama:** muestra si el servidor está activo y qué modelos están en memoria
- [x] **Modelos en memoria:** lista de modelos Ollama cargados en el dashboard

---

## v1.9 — Multiusuario Avanzado y Estabilización

> Objetivo: robustecer el sistema multiusuario y el instalador antes del refactor v2.0.

- [x] **Sesiones de alumno:** registro de sesiones con timestamps y duración
- [x] **Progreso de alumno:** tracking de actividad por alumno en `49-multiusuario.el`
- [x] **Auto-backup mejorado:** backup automático en cambio de alumno y al salir
- [x] **Vista docente:** resumen de actividad de todos los alumnos
- [x] **Detección por profile.conf:** `init.el` ya no depende del hostname para detectar el perfil
- [x] **Advertencias de dependencias:** aviso en startup si falta un binario requerido por el perfil
- [x] **`install.sh --verify`:** post-instalación verifica que todo esté correctamente instalado
- [x] **Test suite de integración:** `test.sh` verifica carga de módulos por lenguaje y plataforma
- [ ] **Matriz de compatibilidad (Fase 5):** tabla completa — movido a v2.2

---

## v2.0 — Encapsulamiento y Arquitectura Limpia

> Objetivo: refactorizar el núcleo antes de seguir creciendo.

- [x] **Generadores a sus módulos:** extraídos de `00-core.el`; cada lenguaje gestiona su propio generador
- [x] **Hydras normalizadas:** todos los nombres `my/hydra-*` sin excepciones
- [x] **Dispatch table de lenguajes:** `my/hydra-build` usa tabla en vez de `cond` por lenguaje
- [x] **Sistema de dependencias mejorado:** declaración de deps por módulo, carga con guards
- [x] **README v2.0:** actualizado con arquitectura nueva y conteo de módulos

---

## v2.1 — Taller de Asistencia Operativa (TAO)

> Objetivo: FORJA como herramienta completa para el TAO — flujo docente cerrado de punta a punta.

- [x] **org-caldav activado:** guarded por `my/caldav-calendar-id` en `local.el`; sync `C-c g y`; OAuth documentado en how-to 13
- [x] **Modo examen `C-c F e`:** suspende gptel/Aider/agentes; indicador `[EXAMEN]` en modeline; confirmación al activar
- [x] **Template `a` (alumno/seguimiento):** archivo `seguimiento.org`; captura con módulo, estado y observaciones
- [x] **Widget GTD en dashboard:** tickets, alumnos activos e inbox sin procesar al arrancar Emacs
- [x] **`seguimiento.org` integrado:** refile targets, agenda files y nav `C-c g A`
- [x] **How-to 13 — Flujo TAO:** guía docente completa: tickets, seguimiento, calendario, caldav, modo examen, revisión semanal

---

## v2.2 — Compatibilidad y Cierre

> Objetivo: verificar todas las plataformas y dejar FORJA publicable.

- [ ] **Matriz de compatibilidad:** `COMPATIBILITY.md` generado automáticamente desde `test.sh`
- [ ] **WSL2 real:** instalar en Windows 11 + WSL2 Ubuntu, documentar diferencias
- [ ] **Android 14+:** Termux con nuevos permisos; actualizar how-to si hay cambios
- [ ] **AUR publish:** probar `forja-git` desde AUR en instalación limpia
- [ ] **FASM:** snippets ASM básicos en `30-cpp.el` o ítem descartado con nota en backlog
- [ ] **Release notes v2.2:** changelog completo y anuncio en README

---

## v3.0 — Arquitectura Extensible (largo plazo)

Ideas post-release sin compromiso de fecha:

- **Plugin system:** módulos de terceros instalables sin modificar el repo base
- **GitHub Projects:** seguimiento de tickets desde Emacs (`forge` + Issues API)
- **Múltiples workspaces por alumno:** más de un proyecto activo simultáneo
- **Modo kiosk:** arrancar Emacs directamente en el proyecto del alumno activo
- **Historial de sesiones visual:** dashboard con tiempo activo, commits y builds por alumno

---

## Historial de Versiones

| Versión | Fecha | Descripción |
|:---:|:---:|:---|
| v1.0 | Abr 2026 | Release inicial: 22 módulos, 3 plataformas, 3 perfiles, IA local, agentes, multiusuario |
| v1.1 | Abr 2026 | Dashboard personalizado: saludo, versión, proyectos recientes, botón nuevo proyecto |
| v1.2 | Abr 2026 | C como lenguaje mimado: Unity tests, gcov/lcov, ASan/UBSan, Valgrind, GDB hydra, clang-tidy |
| v1.3 | Abr 2026 | TypeScript standalone: generador CLI/librería, tsconfig, tsx, templates completos |
| v1.4 | Abr 2026 | Optimización: early-init, lazy loading Unreal/agentes, esup profiler, GC tuning |
| v1.5 | Abr 2026 | Nuevos lenguajes: Lua (Löve2D), Zig (sistemas); PKGBUILD AUR `forja-git` |
| v1.6 | Abr 2026 | JVM: Java (Maven + JUnit 5) + Kotlin (Gradle); `M-x forja-doctor` |
| v1.7 | Abr 2026 | Hydra maestro `C-c F`; Lua/Zig/Java/Kotlin en build hydra; notificación de updates |
| v1.8 | Abr 2026 | Dashboard: RAM, estado Ollama, modelos en memoria |
| v1.9 | Abr 2026 | Multiusuario: sesiones y progreso; advertencias deps; `--verify`; test suite integración |
| v2.0 | Abr 2026 | Encapsulamiento: generadores a módulos, hydras `my/hydra-*`, dispatch table |
| v2.1 | Abr 2026 | TAO completo: org-caldav, modo examen, seguimiento.org, widget GTD, how-to 13 |
