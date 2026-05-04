# FORJA - Portable Educational Integrated Development Environment
## Emacs Modular Config - Full Stack & Game Dev

![Emacs Version](https://img.shields.io/badge/Emacs-29%2B-purple)
![Arch Linux](https://img.shields.io/badge/Arch%20Linux-Supported-blue)
![Termux](https://img.shields.io/badge/Termux%20(Android)-Supported-green)
![WSL2](https://img.shields.io/badge/WSL2%20(Windows)-Supported-orange)
![License](https://img.shields.io/badge/License-MIT-green)

Configuracion modular de Emacs para **desarrollo Full Stack** (Node.js, Python, PHP, Go, Rust), **Game Dev** (C/C++, Raylib, Godot, Unreal) y **Sistemas** (ASM, ESP32). Soporta **Arch Linux (PC)**, **Termux (Android)** y **WSL2 (Windows)** con deteccion automatica de plataforma.

> **Para aprender a usar FORJA una vez instalado → [HELP.md](HELP.md)**

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

| Perfil | Plataforma | RAM | Que incluye |
| :--- | :--- | :--- | :--- |
| **Minimal** | Termux (Android) | < 4 GB | Editor + LSP + Git + GTD + OpenCode + Sync Drive |
| **Moderado** | Arch / WSL | 4-8 GB | + OpenCode + IA local + Game Dev + n8n + LaTeX + ESP32 |
| **Full** | Arch Linux | 16+ GB | + OpenCode + Modelos IA grandes + Agentes + Unreal + FASM |

### Paso 3: Instalar

```bash
bash install.sh
```

El instalador lee `~/.forja/profile.conf` y solo instala los componentes que elegiste. Pide la contrasena sudo una sola vez al inicio y la mantiene activa hasta terminar.

> **Modo legacy:** `bash install.sh --perfil casa` sigue funcionando para quienes prefieran CLI puro.

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
termux-setup-storage  # Acceso a almacenamiento (si falla install.sh)
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
```

---

## Scripts de Mantenimiento

| Script | Cuando usarlo |
| :--- | :--- |
| `bash forja-menu.sh` | Reconfigurar perfil, features o modelos |
| `./install.sh` | Instalar / aplicar cambios del menu |
| `./reinstall.sh` | Config rota o modulos actualizados (~5-10 min) |
| `./update.sh` | Pull + actualizar deps + paquetes MELPA |
| `./clear.sh --purge && ./update.sh` | Paquetes corruptos, empezar desde cero |
| `./install.sh --verify` | Verificar dependencias sin instalar |

---

## Flujo de Instalacion

```
forja-menu.sh                     install.sh
┌─────────────────────┐           ┌──────────────────────────────┐
│  1. Detectar HW     │           │  Lee ~/.forja/profile.conf   │
│  2. Elegir perfil   │──saves──> │  Instala solo lo elegido     │
│  3. Elegir features │           └──────────────────┬───────────┘
│  4. Elegir modelos  │                              │
└─────────────────────┘                    update.sh / Emacs
                                  Lee el mismo profile.conf
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

---

Happy Hacking!
