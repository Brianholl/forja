#!/bin/bash
# =============================================================================
# update.sh — Actualizador de dependencias para FORJA
# Autor: Brian Hollweg
# Soporta: Arch Linux (PC), Termux (Android) y WSL2 (Windows)
# Uso: bash update.sh
#
# Lee ~/.forja/profile.conf para saber que componentes actualizar.
# Si no existe profile.conf, actualiza todo (comportamiento legacy).
# =============================================================================

# No usar set -e: manejamos errores manualmente con || warn/err

# --- Colores ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK] $1${NC}"; }
warn() { echo -e "${YELLOW}[!!] $1${NC}"; }
info() { echo -e "${BLUE}[..] $1${NC}"; }
err()  { echo -e "${RED}[XX] $1${NC}"; exit 1; }

# --- Deteccion de plataforma ---
if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    PLATFORM="termux"
elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    PLATFORM="wsl"
else
    PLATFORM="arch"
fi

# --- Directorio temporal (Termux no tiene /tmp) ---
TMPDIR="${TMPDIR:-/tmp}"

# --- Detectar directorio del repositorio dotfiles ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

# =============================================================================
# LEER CONFIGURACION
# =============================================================================
FORJA_CONF_FILE="$HOME/.forja/profile.conf"
FORJA_FEATURES=""
FORJA_MODEL_CODE=""
FORJA_MODEL_CHAT=""
PERFIL=""

forja_has_feature() {
    local feature="$1"
    # Si no hay features definidos, actualizar todo (legacy)
    if [ -z "$FORJA_FEATURES" ]; then
        return 0
    fi
    echo ",$FORJA_FEATURES," | grep -q ",$feature,"
    return $?
}

if [ -f "$FORJA_CONF_FILE" ]; then
    source "$FORJA_CONF_FILE"
    PERFIL="${FORJA_PROFILE:-}"
    info "Configuracion: perfil=$PERFIL features=$FORJA_FEATURES"
else
    info "Sin profile.conf — actualizando todo (modo legacy)"
fi

echo ""
echo "=============================================="
echo "  FORJA — Actualizador"
echo "  Plataforma: $PLATFORM"
if [ -n "$PERFIL" ]; then
    echo "  Perfil: $PERFIL"
fi
echo "=============================================="
echo ""

# =============================================================================
# 1. ACTUALIZAR SISTEMA
# =============================================================================
info "[1/8] Actualizando sistema..."
if [ "$PLATFORM" = "termux" ]; then
    apt update -y
    apt upgrade -y -o Dpkg::Options::="--force-confnew" || true
    apt --fix-broken install -y 2>/dev/null || true
    pkg upgrade -y
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
else
    if command -v yay &>/dev/null; then
        yay -Syu --noconfirm
    else
        sudo pacman -Syu --noconfirm
    fi
fi
ok "Sistema actualizado"

# =============================================================================
# 2. ACTUALIZAR RUST Y LENGUAJES COMPILADOS
# =============================================================================
info "[2/8] Actualizando Rust y lenguajes base..."
if [ "$PLATFORM" = "termux" ]; then
    pkg upgrade -y rust 2>/dev/null || info "Rust ya esta al dia"
else
    if command -v rustup &>/dev/null; then
        rustup update stable
        ok "Rust actualizado"
    fi

    if [ "$PLATFORM" = "wsl" ]; then
        if command -v go &>/dev/null; then
            info "Actualizando gopls en WSL..."
            go install golang.org/x/tools/gopls@latest 2>/dev/null || warn "No se pudo actualizar gopls"
        fi
        if command -v composer &>/dev/null; then
            info "Actualizando Composer en WSL..."
            sudo composer self-update 2>/dev/null || warn "No se pudo actualizar composer"
        fi
    fi
fi

# =============================================================================
# 3. ACTUALIZAR PAQUETES NPM GLOBALES
# =============================================================================
info "[3/8] Actualizando paquetes npm globales..."
if [ "$PLATFORM" = "termux" ]; then
    npm update -g 2>/dev/null || warn "Error actualizando npm globals"
elif [ "$PLATFORM" = "arch" ]; then
    sudo PUPPETEER_SKIP_DOWNLOAD=true npm update -g 2>/dev/null || warn "Error actualizando npm globals"
else
    sudo npm update -g 2>/dev/null || warn "Error actualizando npm globals"
fi
ok "Paquetes npm actualizados"

# =============================================================================
# 3b. ACTUALIZAR PYTHON LSP Y HERRAMIENTAS
# =============================================================================
info "Actualizando Python LSP y herramientas..."
PIP_PKGS="python-lsp-server pylsp-mypy python-lsp-black"
if [ "$PLATFORM" = "arch" ] && forja_has_feature "godot"; then
    PIP_PKGS="$PIP_PKGS gdtoolkit"
fi
pip install --user --upgrade --break-system-packages $PIP_PKGS 2>/dev/null \
    || pip install --user --upgrade $PIP_PKGS 2>/dev/null \
    || warn "No se pudieron actualizar pip packages (pylsp)"
ok "Python LSP actualizado"

# =============================================================================
# 4. ACTUALIZAR AIDER.EL (integracion Emacs)
# =============================================================================
info "[4/8] Actualizando aider.el..."
if [ -d ~/.emacs.d/site-lisp/aider.el ] && forja_has_feature "aider"; then
    git -C ~/.emacs.d/site-lisp/aider.el pull || warn "Error actualizando aider.el"
    ok "aider.el actualizado"
else
    info "aider.el no instalado o no seleccionado, saltando"
fi

# =============================================================================
# 5. ACTUALIZAR AIDER Y AGENTES IA (SOLO PC)
# =============================================================================
info "[5/8] Actualizando Aider y agentes IA..."
if [ "$PLATFORM" = "termux" ] || [ "$PLATFORM" = "wsl" ]; then
    info "Saltando Aider/agentes (no disponible en $PLATFORM)"
else
    # Aider
    if forja_has_feature "aider" && command -v uv &>/dev/null; then
        uv tool upgrade aider-chat 2>/dev/null \
            && ok "Aider actualizado" \
            || warn "Error actualizando Aider"
    fi

    # PicoClaw
    if forja_has_feature "picoclaw" && command -v picoclaw &>/dev/null; then
        info "Actualizando PicoClaw..."
        PICOCLAW_URL="https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw-linux-amd64"
        curl -fsSL "$PICOCLAW_URL" -o /tmp/picoclaw \
            && chmod +x /tmp/picoclaw \
            && sudo mv /tmp/picoclaw /usr/local/bin/picoclaw \
            && ok "PicoClaw actualizado" \
            || warn "Error actualizando PicoClaw"
    fi

    # OpenClaw
    if forja_has_feature "openclaw" && command -v openclaw &>/dev/null; then
        info "Actualizando OpenClaw..."
        sudo npm update -g openclaw 2>/dev/null \
            && ok "OpenClaw actualizado" \
            || warn "Error actualizando OpenClaw"
    fi
fi

# =============================================================================
# 6. ACTUALIZAR MODELOS OLLAMA (SOLO PC)
# =============================================================================
info "[6/8] Actualizando modelos Ollama..."
if [ "$PLATFORM" = "termux" ] || [ "$PLATFORM" = "wsl" ]; then
    info "Saltando Ollama (no disponible en $PLATFORM)"
else
    if command -v ollama &>/dev/null; then
        MODELS=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')
        if [ -n "$MODELS" ]; then
            for model in $MODELS; do
                info "Actualizando modelo: $model"
                ollama pull "$model" || warn "Error actualizando $model"
            done
            ok "Modelos Ollama actualizados"
        else
            info "No hay modelos Ollama instalados"
        fi
    else
        info "Ollama no encontrado, saltando"
    fi
fi

# =============================================================================
# 7. ACTUALIZAR DOTFILES Y RE-STOW
# =============================================================================
info "[7/8] Actualizando dotfiles..."
if [ -d "$DOTFILES_DIR/.git" ]; then
    cd "$DOTFILES_DIR"

    if git remote -v 2>/dev/null | grep -q origin; then
        git pull origin "$(git branch --show-current)" \
            && ok "dotfiles actualizados desde remote" \
            || warn "No se pudo hacer pull (sin conexion o conflictos)"
    fi

    if [ -d emacs ]; then
        stow -v -R -t ~ emacs
        ok "emacs re-stowed"
    fi
    if [ -d shell ]; then
        stow -v -R -t ~ shell
        ok "shell re-stowed"
    fi
    if [ "$PLATFORM" = "termux" ] && [ -f termux/.termux/termux.properties ]; then
        mkdir -p ~/.termux
        cp -v termux/.termux/termux.properties ~/.termux/termux.properties
        ok "termux.properties actualizado"
        if command -v termux-reload-settings &>/dev/null; then
            termux-reload-settings
            ok "Termux settings recargadas"
        fi
    fi
else
    warn "$DOTFILES_DIR no es un repositorio git, saltando"
fi

# =============================================================================
# 8. RE-TANGLE Y ACTUALIZAR PAQUETES EMACS
# =============================================================================
info "[8/8] Re-tangling modulos y actualizando paquetes MELPA..."

if [ -d ~/.emacs.d/modules ]; then
    info "Eliminando .el generados para forzar re-tangle..."
    for el_file in ~/.emacs.d/modules/*.el; do
        [ -f "$el_file" ] || continue
        org_file="${el_file%.el}.org"
        if [ -f "$org_file" ]; then
            rm -f "$el_file"
        fi
    done
    ok "Archivos .el stale eliminados"
fi

EMACS_UPDATE_EL="$TMPDIR/emacs-update.el"
cat > "$EMACS_UPDATE_EL" << 'ELISP'
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)

(if (fboundp 'package-upgrade-all)
    (progn
      (package-upgrade-all)
      (message "Actualizacion de ELPA/MELPA y limpieza de paquetes finalizada."))
  (message "Se requiere Emacs 29+ para auto-limpieza."))
ELISP

emacs --batch --load "$EMACS_UPDATE_EL" 2>&1 | tail -10
rm -f "$EMACS_UPDATE_EL"
ok "Paquetes MELPA actualizados"

# =============================================================================
# RESUMEN FINAL
# =============================================================================
echo ""
echo "=============================================="
echo -e "${GREEN}  Actualizacion completa${NC}"
echo "  Plataforma: $PLATFORM"
if [ -n "$PERFIL" ]; then
    echo "  Perfil: $PERFIL"
fi
echo "=============================================="
echo ""
echo "  Que se actualizo:"
echo "    - Sistema operativo ($PLATFORM)"
echo "    - Rust toolchain"
echo "    - Paquetes npm globales (LSPs)"
echo "    - Python LSP (pylsp, black, mypy)"

if forja_has_feature "aider"; then
    echo "    - Aider + aider.el"
fi
if forja_has_feature "picoclaw" && command -v picoclaw &>/dev/null; then
    echo "    - PicoClaw (agente IA)"
fi
if forja_has_feature "openclaw" && command -v openclaw &>/dev/null; then
    echo "    - OpenClaw (agente IA)"
fi
if command -v ollama &>/dev/null; then
    echo "    - Modelos Ollama"
fi

echo "    - Dotfiles + GNU Stow"
echo "    - Modulos .el re-tangled"
echo "    - Paquetes MELPA/ELPA"

if [ -n "$FORJA_MODEL_CODE" ] && [ "$FORJA_MODEL_CODE" != "ninguno" ]; then
    echo ""
    echo "  Modelos IA actuales:"
    echo "    - Codigo:  $FORJA_MODEL_CODE"
    echo "    - Espanol: $FORJA_MODEL_CHAT"
    echo "    - Cambiar: C-c M (en Emacs) o bash forja-menu.sh"
fi

echo ""
echo "  Tip: Reinicia Emacs para aplicar todos los cambios"
echo ""
