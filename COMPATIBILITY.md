# FORJA — Matriz de Compatibilidad

Generada por `bash test.sh --matrix`. Ejecutar en cada plataforma para actualizar su sección.
Leyenda: **✓** funciona · **✗** error · **—** no instalado / N/A

---

## Arch Linux — Perfil: full

_Última verificación: 2026-04-25 11:53_

| Herramienta | Estado |
|:---|:---:|
| C (gcc) | ✓ |
| C++ (g++) | ✓ |
| Rust (rustc) | ✓ |
| Rust (cargo disponible) | ✓ |
| Go (go run) | ✓ |
| Python (/usr/bin/python3) | ✓ |
| Python (pylsp disponible) | ✓ |
| Node.js | ✓ |
| TypeScript (tsc + node) | ✓ |
| PHP | ✓ |
| Lua (/usr/bin/lua) | ✓ |
| Zig (zig run) | ✓ |
| Java (javac + java) | ✓ |
| Java (Maven disponible) | ✓ |
| Java (Gradle disponible) | ✓ |
| LSP clangd | ✓ |
| LSP rust-analyzer | ✓ |
| LSP gopls | ✓ |
| LSP pylsp | ✓ |
| LSP tsserver | ✓ |
| LSP zls | ✓ |

---

## Diferencias conocidas por plataforma

| Feature | Arch Linux | Termux Android | WSL2 Windows |
|:---|:---:|:---:|:---:|
| Perfil Full | ✓ | — | ✓ |
| Perfil Moderado | ✓ | — | ✓ |
| Perfil Minimal | ✓ | ✓ | ✓ |
| Unreal Engine (UE4) | ✓ | — | — |
| Ollama / IA local | ✓ | ✓ | ✓ |
| Agentes PicoClaw/OpenClaw | ✓ | ✓ | ✓ |
| Docker / n8n | ✓ | — | ✓ (Docker Desktop) |
| rclone / Google Drive | ✓ | ✓ | ✓ |
| GUI Emacs gráfico | ✓ | — (X11 opcional) | ✓ (WSLg) |
| GDB / Valgrind | ✓ | ✓ | ✓ |
| Java / Maven / Gradle | ✓ | ✓ | ✓ |

---

## Lista de verificación — WSL2 (pendiente verificación manual)

> Ejecutar `bash test.sh --matrix` en Windows 11 + WSL2 Ubuntu para actualizar automáticamente.

- [ ] Instalación limpia desde GitHub con `install.sh`
- [ ] Emacs abre con dashboard correcto (WSLg)
- [ ] LSP servers funcionan (clangd, pylsp, gopls)
- [ ] Perfil Minimal arranca en < 5s
- [ ] n8n levanta con Docker Desktop
- [ ] `forja doctor` sin errores requeridos

## Lista de verificación — Android 14+ / Termux (pendiente verificación manual)

> Ejecutar `bash test.sh --matrix` en Termux en Android 14+ para actualizar automáticamente.

- [ ] `pkg install` sin errores de permisos (Android 14 storage changes)
- [ ] Perfil Minimal carga correctamente
- [ ] LSP pylsp y clangd disponibles
- [ ] F5 compila y ejecuta C sin error
- [ ] Ollama disponible vía Termux (arm64)
