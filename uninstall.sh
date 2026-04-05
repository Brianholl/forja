#!/bin/bash
# =============================================================================
# uninstall.sh — Desinstalador de dotfiles (GNU Stow)
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

# --- Deteccion de plataforma ---
if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    PLATFORM="termux"
elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    PLATFORM="wsl"
else
    PLATFORM="arch"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

echo ""
echo "=============================================="
echo "  Desinstalador de Dotfiles"
echo "  Plataforma: $PLATFORM"
echo "=============================================="
echo ""

cd "$DOTFILES_DIR" || err "No se pudo acceder a $DOTFILES_DIR"

if ! command -v stow &> /dev/null; then
    warn "stow no esta instalado. No se pueden remover enlaces."
    exit 1
fi

info "Removiendo enlaces simbolicos con GNU Stow..."

# Lista de directorios que pueden estar aplicados con stow
for config_dir in emacs shell emacs-gdt forja; do
    if [ -d "$config_dir" ]; then
        info "Desvinculando $config_dir..."
        stow -v -D -t ~ "$config_dir" 2>&1 | grep -v 'BUG in find_stowed_path'
        ok "$config_dir procesado"
    fi
done

if [ "$PLATFORM" = "termux" ]; then
    info "Eliminando config especifica de Termux..."
    if [ -f ~/.termux/termux.properties ]; then
        rm -i ~/.termux/termux.properties
        ok "termux.properties procesado"
    fi
fi

# Restaurar backups si existen
if [ -d ~/.emacs.d.bak ] && [ ! -e ~/.emacs.d ]; then
    info "Restaurando backup de ~/.emacs.d.bak..."
    mv ~/.emacs.d.bak ~/.emacs.d
    ok "Backup restaurado"
fi

echo ""
ok "Desvinculacion completada. Ahora puedes instalar tu nuevo repo forja."
echo ""
