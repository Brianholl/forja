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

### Bloque B — Compatibilidad y Distribución (parcial v2.2)

- [x] **Matriz de compatibilidad:** `test.sh --matrix` + `COMPATIBILITY.md` con checklist WSL2/Android
- [x] **PKGBUILD completo:** deps actualizados en `aur/PKGBUILD`
- [x] **FASM:** soporte básico en `30-cpp.org`; snippets NASM completos → backlog v3.0
- [ ] **WSL2 real:** verificación manual pendiente (checklist en `COMPATIBILITY.md`)
- [ ] **Android 14+ real:** verificación manual pendiente (checklist en `COMPATIBILITY.md`)
- [ ] **AUR publicación:** `makepkg -si` en instalación limpia — pendiente

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

- [x] **Matriz de compatibilidad:** `COMPATIBILITY.md` + `test.sh --matrix` — genera automáticamente la sección de la plataforma actual y preserva las demás
- [x] **PKGBUILD actualizado:** `aur/PKGBUILD` con deps completos (pylsp, rclone, jdk17, maven, gradle, kotlin-language-server, fasm, nasm, php, typescript, unzip)
- [x] **FASM resuelto:** soporte básico existe en `30-cpp.org` (nasm-mode, `my/fasm-compile-and-run`, `my/fasm-debug`, F5 y C-c d); `fasm` y `nasm` en PKGBUILD optdepends; snippets NASM completos pasan a backlog v3.0
- [ ] **WSL2 real:** instalar en Windows 11 + WSL2 — checklist en `COMPATIBILITY.md`; pendiente verificación manual
- [ ] **Android 14+:** Termux con permisos nuevos — checklist en `COMPATIBILITY.md`; pendiente verificación manual
- [ ] **AUR publish:** publicar `forja-git` en AUR y verificar con `makepkg -si` en instalación limpia

---

## v2.3 — Snippets Multilenguaje

> Objetivo: completar la biblioteca de YASnippets con patrones de diseño adaptados
> a los idiomas de cada lenguaje del curriculum. C y C++ completados en v2.2.

Los snippets van en `emacs/.emacs.d/snippets/<modo>/`.
El paquete `yasnippet-snippets` ya cubre sintaxis básica — FORJA agrega patrones idiomáticos.

| Lenguaje | Modo | Base (pkg) | FORJA | Estado |
|----------|------|:---:|:---:|:---:|
| TypeScript | `typescript-mode` | 0 | ~12 | `[ ]` |
| Python | `python-mode` | 187 (sintaxis) | ~12 | `[ ]` |
| Java | `java-mode` | 33 | ~18 | `[ ]` |
| Kotlin | `kotlin-mode` | 17 | ~10 | `[ ]` |
| Go | `go-mode` | 29 | ~10 | `[ ]` |
| Rust | `rust-mode` | 65 | ~10 | `[ ]` |
| GDScript | `gdscript-mode` | 16 | ~8 | `[ ]` |
| Lua | `lua-mode` | 11 | ~8 | `[ ]` |
| PHP | `php-mode` | 42 | ~10 | `[ ]` |
| Zig | `zig-mode` | 12 | ~8 | `[ ]` |

**Total estimado: ~106 snippets**

### Detalle por lenguaje

- **TypeScript** (prioridad 1 — sin cobertura base): `singleton` `factory` `abstractfactory` `builder` `decorator` `adapter` `proxy` `facade` `observer` `strategy` `command` `state`
- **Python** (GoF Pythónico — ABC, `@dataclass`, context managers): `singleton` `factory` `abstractfactory` `builder` `prototype` `decorator` `adapter` `proxy` `observer` `strategy` `command` `state`
- **Java** (lenguaje canónico para GoF — interfaces y abstract classes): 18 patrones
- **Kotlin** (idioms modernos): `singleton` (object), `builder` (apply/data class), `state` (sealed class), `strategy` (lambda), `decorator` (delegation by), `factory` (companion object), `observer` (callback/Flow), `command` (function type), `adapter`, `visitor` (when exhaustivo)
- **Go** (idioms propios, no GoF clásico): `functopts` `singleton` `pipeline` `workerpool` `fanout` `errwrap` `strategy` `decorator` `observer` `adapter`
- **Rust** (trait-based): `builder` `newtype` `state` `strategy` `iterator` `singleton` `observer` `command` `decorator` `factory`
- **GDScript** (gamedev Godot): `state_machine` `singleton` `observer` `factory` `command` `component` `pool` `event_bus`
- **Lua** (metatables + Löve2D): `class` `singleton` `state` `observer` `factory` `decorator` `module` `mixin`
- **PHP** (web patterns): `singleton` `factory` `abstractfactory` `builder` `observer` `strategy` `command` `decorator` `adapter` `repository`
- **Zig** (comptime patterns): `tagged_union` `comptime_generic` `interface` `errdefer` `arena` `builder` `strategy` `iterator`

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
| v2.2 | Abr 2026 | Compatibilidad: `test.sh --matrix`, COMPATIBILITY.md, PKGBUILD completo, FASM resuelto |
