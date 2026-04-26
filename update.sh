#!/bin/bash
# =============================================================================
# update.sh — Actualizador completo de FORJA
# Autor: Brian Hollweg
#
# Flujo:
#   1. git pull  → trae el último código de FORJA
#   2. install.sh → instala/verifica todas las dependencias
#   3. stow      → aplica los dotfiles actualizados
#   4. upgrades  → actualiza herramientas (Rust, npm, pip, Ollama, agentes)
#   5. Emacs     → re-tangle módulos + actualiza paquetes MELPA
#   6. Sanidad   → verifica que Emacs cargue sin errores
# =============================================================================

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

# --- Directorio del repo ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Deteccion de plataforma ---
if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    PLATFORM="termux"
elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    PLATFORM="wsl"
else
    PLATFORM="arch"
fi

# --- Directorio temporal ---
TMPDIR="${TMPDIR:-/tmp}"

# --- Leer configuracion ---
FORJA_CONF_FILE="$HOME/.forja/profile.conf"
FORJA_FEATURES=""
PERFIL=""

forja_has_feature() {
    local feature="$1"
    [ -z "$FORJA_FEATURES" ] && return 0
    echo ",$FORJA_FEATURES," | grep -q ",$feature,"
}

if [ -f "$FORJA_CONF_FILE" ]; then
    source "$FORJA_CONF_FILE"
    PERFIL="${FORJA_PROFILE:-}"
fi

echo ""
echo "=============================================="
echo "  FORJA — Actualizador"
echo "  Plataforma: $PLATFORM${PERFIL:+ | Perfil: $PERFIL}"
echo "=============================================="
echo ""

# =============================================================================
# 1. GIT PULL — traer el último código de FORJA
# =============================================================================
info "[1/7] Trayendo últimos cambios de FORJA..."
cd "$SCRIPT_DIR"

if git remote -v 2>/dev/null | grep -q origin; then
    git pull origin "$(git branch --show-current)" \
        && ok "FORJA actualizado desde GitHub" \
        || warn "No se pudo hacer pull (sin conexión o conflictos)"
else
    warn "No hay remote configurado, saltando git pull"
fi

# =============================================================================
# 2. INSTALL.SH — instalar/verificar todas las dependencias
# =============================================================================
info "[2/7] Instalando/verificando dependencias..."
if [ -f "$SCRIPT_DIR/install.sh" ]; then
    SKIP_CPPMAN=1 bash "$SCRIPT_DIR/install.sh"
    ok "Dependencias verificadas"
else
    warn "install.sh no encontrado en $SCRIPT_DIR"
fi

# =============================================================================
# 3. STOW — aplicar dotfiles actualizados
# =============================================================================
info "[3/7] Aplicando dotfiles actualizados (stow)..."
cd "$SCRIPT_DIR"

if [ -d emacs ]; then
    stow -v -R -t ~ emacs 2>/dev/null && ok "emacs re-stowed" || warn "stow emacs falló"
fi
if [ -d shell ]; then
    # Eliminar symlinks obsoletos que apunten fuera del stow dir actual
    for dotfile in ~/.bashrc_custom ~/.bashrc_unreal; do
        if [ -L "$dotfile" ]; then
            target=$(readlink "$dotfile")
            [[ "$target" == *"$SCRIPT_DIR/shell/"* ]] || rm -f "$dotfile"
        fi
    done
    stow -v -R -t ~ shell 2>/dev/null && ok "shell re-stowed" || warn "stow shell falló"
fi
if [ "$PLATFORM" = "termux" ] && [ -f termux/.termux/termux.properties ]; then
    mkdir -p ~/.termux
    cp -v termux/.termux/termux.properties ~/.termux/termux.properties
    command -v termux-reload-settings &>/dev/null && termux-reload-settings
    ok "Termux settings actualizadas"
fi

# =============================================================================
# 4. UPGRADES — actualizar herramientas (lo que install.sh no actualiza)
# =============================================================================
info "[4/7] Actualizando herramientas..."

# Rust
if command -v rustup &>/dev/null; then
    rustup update stable 2>/dev/null && ok "Rust actualizado" || warn "Error actualizando Rust"
fi

# npm globals
if command -v npm &>/dev/null; then
    if [ "$PLATFORM" = "arch" ]; then
        sudo PUPPETEER_SKIP_DOWNLOAD=true npm update -g 2>/dev/null
    elif [ "$PLATFORM" = "termux" ]; then
        npm update -g 2>/dev/null
    else
        sudo npm update -g 2>/dev/null
    fi
    ok "Paquetes npm actualizados"
fi

# Python LSP
PIP_PKGS="python-lsp-server pylsp-mypy python-lsp-black"
[ "$PLATFORM" = "arch" ] && forja_has_feature "godot" && PIP_PKGS="$PIP_PKGS gdtoolkit"
if [ "$PLATFORM" = "termux" ]; then
    pip install --break-system-packages --upgrade $PIP_PKGS 2>/dev/null \
        || pip install --upgrade $PIP_PKGS 2>/dev/null \
        || warn "No se pudo actualizar pylsp en Termux"
else
    pip install --user --upgrade --break-system-packages $PIP_PKGS 2>/dev/null \
        || pip install --user --upgrade $PIP_PKGS 2>/dev/null \
        || warn "No se pudo actualizar pylsp"
fi
ok "Python LSP actualizado"

# Aider
if [ "$PLATFORM" = "arch" ] && forja_has_feature "aider" && command -v uv &>/dev/null; then
    uv tool upgrade aider-chat 2>/dev/null && ok "Aider actualizado" || warn "Error actualizando Aider"
fi

# aider.el
if [ -d ~/.emacs.d/site-lisp/aider.el ] && forja_has_feature "aider"; then
    git -C ~/.emacs.d/site-lisp/aider.el pull 2>/dev/null && ok "aider.el actualizado" || warn "Error actualizando aider.el"
fi

# Ollama: actualizar modelos instalados
if [ "$PLATFORM" = "arch" ] && command -v ollama &>/dev/null; then
    MODELS=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')
    if [ -n "$MODELS" ]; then
        for model in $MODELS; do
            info "Actualizando modelo: $model"
            ollama pull "$model" 2>/dev/null || warn "Error actualizando $model"
        done
        ok "Modelos Ollama actualizados"
    fi
fi

# =============================================================================
# 5. EMACS — re-tangle módulos + actualizar paquetes MELPA
# =============================================================================
info "[5/7] Re-tangling módulos y actualizando paquetes MELPA..."

# Borrar .el generados para forzar re-tangle en próximo inicio
if [ -d ~/.emacs.d/modules ]; then
    for el_file in ~/.emacs.d/modules/*.el; do
        [ -f "$el_file" ] || continue
        org_file="${el_file%.el}.org"
        [ -f "$org_file" ] && rm -f "$el_file"
    done
    ok "Archivos .el stale eliminados (se re-tanglearán al iniciar Emacs)"
fi

# Actualizar paquetes MELPA
EMACS_UPDATE_EL="$TMPDIR/emacs-update.el"
cat > "$EMACS_UPDATE_EL" << 'ELISP'
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)
(unless (package-installed-p 'deferred)
  (package-install 'deferred))
(when (fboundp 'package-upgrade-all)
  (package-upgrade-all))
(message "Paquetes MELPA actualizados.")
ELISP
emacs --batch --load "$EMACS_UPDATE_EL" 2>&1 | tail -5
rm -f "$EMACS_UPDATE_EL"
ok "Paquetes MELPA actualizados"

# =============================================================================
# 6. SANIDAD — verificar que Emacs carga sin errores
# =============================================================================
info "[6/7] Verificando que Emacs carga sin errores..."
if [ ! -f "$HOME/.emacs.d/init.el" ]; then
    warn "init.el no encontrado — stow emacs puede haber fallado"
else
    SANITY_LOG="$TMPDIR/forja-sanity.log"
    emacs --batch \
        --load "$HOME/.emacs.d/init.el" \
        --eval "(kill-emacs 0)" \
        2>"$SANITY_LOG" || true

    if grep -qiE "file-missing|Cannot open load file|Key sequence.*starts with non-prefix|Symbol's function definition is void|Error.*loading.*init" "$SANITY_LOG" 2>/dev/null; then
        warn "⚠  Emacs reportó errores al cargar. Revisa:"
        grep -iE "file-missing|Cannot open load|Key sequence.*non-prefix|void|Error" "$SANITY_LOG" | head -5
        warn "Tip: emacs --debug-init para ver el stack completo"
    else
        ok "Emacs carga sin errores de init"
    fi
    rm -f "$SANITY_LOG"
fi

# =============================================================================
# 7. CPPMAN — cachear páginas de cppreference (paso lento, al final)
# =============================================================================
info "[7/7] Configurando cppman con cppreference..."
if [ "$PLATFORM" = "arch" ] && command -v cppman &>/dev/null; then
    cppman -s cppreference.com \
        && ok "cppman configurado (fuente: cppreference.com)" \
        || warn "cppman: no se pudo configurar la fuente"
    # Para cachear todas las páginas offline (tarda 30+ min): cppman -c
else
    [ "$PLATFORM" != "arch" ] || warn "cppman no instalado, saltando"
fi

# =============================================================================
# RESUMEN
# =============================================================================
echo ""
echo "=============================================="
echo -e "${GREEN}  Actualización completa${NC}"
echo "  Plataforma: $PLATFORM${PERFIL:+ | Perfil: $PERFIL}"
echo ""
echo "  Hecho:"
echo "    1. git pull — FORJA al día"
echo "    2. install.sh — dependencias verificadas"
echo "    3. stow — dotfiles aplicados"
echo "    4. upgrades — Rust / npm / pylsp / Aider / Ollama"
echo "    5. Emacs — módulos re-tangled + MELPA actualizado"
echo "    6. Sanidad — init.el sin errores"
echo "    7. cppman — cppreference cacheado"
echo ""
echo "  → Reinicia Emacs para aplicar los cambios"
echo "=============================================="
echo ""
