#!/bin/bash
# =============================================================================
# clear.sh — Limpia la instalacion FORJA para reinstalar desde cero
#
# Elimina:
#   - Symlinks de stow (emacs, shell)
#   - ~/.emacs.d/        (config generada + paquetes MELPA)
#   - ~/.forja/          (perfil y configuracion)
#   - LSPs de pip        (pylsp, pylsp-mypy, python-lsp-black, ruff)
#   - LSPs de npm        (typescript-language-server, prettier, etc.)
#   - Config Termux      (opcional, solo en Android)
#
# NO toca:
#   - Paquetes del sistema (gcc, clang, rust, go, node, etc.)
#   - Ollama ni sus modelos
#   - El repositorio FORJA (este directorio)
#
# Despues de clear.sh, corre:  ./update.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
DIM='\033[2m'
WHITE='\033[1;37m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!!]${NC} $1"; }
info() { echo -e "${BLUE}[..]${NC} $1"; }

# --- Plataforma ---
if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    PLATFORM="termux"
elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    PLATFORM="wsl"
else
    PLATFORM="arch"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# ADVERTENCIA Y CONFIRMACION
# =============================================================================

echo ""
echo "=============================================="
echo -e "  ${WHITE}FORJA — Limpieza para reinstalacion${NC}"
echo "  Plataforma: $PLATFORM"
echo "=============================================="
echo ""
echo -e "  ${YELLOW}Se va a eliminar:${NC}"
echo ""
echo -e "    ${RED}x${NC} Symlinks de stow  (emacs, shell)"
echo -e "    ${RED}x${NC} ~/.emacs.d/        (config + paquetes MELPA)"
echo -e "    ${RED}x${NC} ~/.forja/          (perfil de configuracion)"
echo -e "    ${RED}x${NC} LSPs pip           (pylsp, ruff, black)"
echo -e "    ${RED}x${NC} LSPs npm           (typescript-ls, prettier, n8n, etc.)"
if [ "$PLATFORM" != "termux" ]; then
    echo -e "    ${RED}x${NC} Aider              (uv tool — Arch/WSL)"
fi
if [ "$PLATFORM" = "termux" ]; then
    echo -e "    ${YELLOW}?${NC} ~/.termux/termux.properties  (se preguntara)"
fi
echo ""
echo -e "  ${DIM}NO se tocan: gcc, clang, rust, go, node, Ollama, modelos.${NC}"
echo ""
echo -e "  Despues de esto, corre:  ${WHITE}./update.sh${NC}"
echo ""
echo -ne "  Escribe ${WHITE}si${NC} para confirmar: "
read -r respuesta

if [[ "$respuesta" != "si" ]]; then
    echo ""
    warn "Cancelado."
    echo ""
    exit 0
fi

echo ""

# =============================================================================
# 1. STOW: deshacer symlinks
# =============================================================================
info "[1/5] Deshaciendo symlinks (stow)..."
cd "$SCRIPT_DIR" || { warn "No se pudo acceder a $SCRIPT_DIR"; }

if command -v stow &>/dev/null; then
    for pkg in emacs shell emacs-gdt forja; do
        if [ -d "$pkg" ]; then
            stow -v -D -t ~ "$pkg" 2>&1 | grep -v 'BUG in find_stowed_path'
        fi
    done
    ok "Symlinks removidos"
else
    warn "stow no instalado — saltando (los symlinks pueden quedar huerfanos)"
fi

# =============================================================================
# 2. EMACS: borrar config y paquetes MELPA
# =============================================================================
info "[2/5] Borrando ~/.emacs.d/ ..."
if [ -d "$HOME/.emacs.d" ]; then
    rm -rf "$HOME/.emacs.d"
    ok "~/.emacs.d/ eliminado"
else
    ok "~/.emacs.d/ no existia"
fi

# Limpiar archivos sueltos de Emacs en HOME
for f in "$HOME/.emacs" "$HOME/.emacs.el"; do
    if [ -f "$f" ]; then
        rm -f "$f"
        ok "$f eliminado"
    fi
done

# =============================================================================
# 3. FORJA: borrar perfil y configuracion
# =============================================================================
info "[3/5] Borrando ~/.forja/ ..."
if [ -d "$HOME/.forja" ]; then
    rm -rf "$HOME/.forja"
    ok "~/.forja/ eliminado"
else
    ok "~/.forja/ no existia"
fi

# =============================================================================
# 4. PIP: desinstalar LSPs de Python
# =============================================================================
info "[4/5] Desinstalando LSPs de Python (pip)..."
PIP_PKGS="python-lsp-server pylsp-mypy python-lsp-black ruff gdtoolkit"

if command -v pip &>/dev/null || command -v pip3 &>/dev/null; then
    PIP_CMD="pip"
    command -v pip &>/dev/null || PIP_CMD="pip3"

    if [ "$PLATFORM" = "termux" ]; then
        $PIP_CMD uninstall -y $PIP_PKGS 2>/dev/null \
            && ok "pip LSPs desinstalados" \
            || ok "pip LSPs no estaban instalados"
    else
        $PIP_CMD uninstall -y $PIP_PKGS 2>/dev/null \
            || pip uninstall -y $PIP_PKGS 2>/dev/null \
            || ok "pip LSPs no estaban instalados"
        ok "pip LSPs desinstalados"
    fi
else
    ok "pip no encontrado — saltando"
fi

# =============================================================================
# 5. NPM: desinstalar globals de FORJA
# =============================================================================
info "[5/5] Desinstalando globals de npm..."
NPM_PKGS="typescript typescript-language-server vscode-langservers-extracted live-server prettier intelephense @prettier/plugin-php @mermaid-js/mermaid-cli n8n openclaw"

if command -v npm &>/dev/null; then
    if [ "$PLATFORM" = "arch" ] || [ "$PLATFORM" = "wsl" ]; then
        sudo npm uninstall -g $NPM_PKGS 2>/dev/null \
            && ok "npm globals desinstalados" \
            || ok "npm globals no estaban instalados"
    else
        npm uninstall -g $NPM_PKGS 2>/dev/null \
            && ok "npm globals desinstalados" \
            || ok "npm globals no estaban instalados"
    fi
else
    ok "npm no encontrado — saltando"
fi

# =============================================================================
# 6. AIDER: desinstalar via uv (solo Arch/WSL)
# =============================================================================
if [ "$PLATFORM" != "termux" ] && command -v uv &>/dev/null; then
    info "[6/6] Desinstalando Aider (uv tool)..."
    uv tool uninstall aider-chat 2>/dev/null \
        && ok "aider-chat desinstalado" \
        || ok "aider-chat no estaba instalado"
fi

# =============================================================================
# TERMUX: config especifica (opcional)
# =============================================================================
if [ "$PLATFORM" = "termux" ] && [ -f "$HOME/.termux/termux.properties" ]; then
    echo ""
    echo -ne "  Eliminar ~/.termux/termux.properties? [s/N]: "
    read -r resp
    if [[ "$resp" =~ ^[sS]$ ]]; then
        rm -f "$HOME/.termux/termux.properties"
        command -v termux-reload-settings &>/dev/null && termux-reload-settings
        ok "termux.properties eliminado"
    else
        ok "termux.properties conservado"
    fi
fi

# =============================================================================
# LISTO
# =============================================================================
echo ""
echo "=============================================="
echo -e "${GREEN}  Limpieza completa.${NC}"
echo ""
echo "  Para reinstalar desde cero:"
echo ""
echo -e "    ${WHITE}./update.sh${NC}"
echo ""
echo "  Si quieres reconfigurar el perfil antes:"
echo ""
echo -e "    ${WHITE}bash forja-menu.sh${NC}"
echo -e "    ${WHITE}./update.sh${NC}"
echo ""
echo "=============================================="
echo ""
