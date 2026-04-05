#!/bin/bash
# =============================================================================
# install-wsl.sh — Preparador de WSL2 para Emacs Modular Config
# Autor: Brian Hollweg
# Uso: Ejecutar DENTRO de WSL2 (Ubuntu/Debian)
#   wsl --install  (desde PowerShell primero)
#   Luego: bash install-wsl.sh
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

# --- Verificar que estamos en WSL ---
if ! grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    err "Este script es solo para WSL2. Ejecutalo dentro de Windows Subsystem for Linux."
fi

echo ""
echo "=============================================="
echo "  Emacs Modular Config — Preparador WSL2"
echo "=============================================="
echo ""

# --- Detectar directorio del repositorio ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# 1. ACTUALIZAR SISTEMA BASE
# =============================================================================
info "Actualizando sistema..."
sudo apt-get update -y
sudo apt-get upgrade -y
ok "Sistema actualizado"

# =============================================================================
# 2. INSTALAR PREREQUISITOS
# =============================================================================
info "Instalando prerequisitos..."
sudo apt-get install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gpg
ok "Prerequisitos instalados"

# =============================================================================
# 3. EMACS 29+ (Ubuntu puede traer version vieja)
# =============================================================================
info "Verificando version de Emacs..."
EMACS_VERSION=0
if command -v emacs &>/dev/null; then
    EMACS_VERSION=$(emacs --version 2>/dev/null | head -1 | grep -oP '\d+' | head -1)
fi

if [ "$EMACS_VERSION" -lt 29 ] 2>/dev/null; then
    info "Emacs $EMACS_VERSION encontrado (necesitamos 29+). Agregando PPA..."
    sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs 2>/dev/null
    if [ $? -eq 0 ]; then
        sudo apt-get update -y
        sudo apt-get install -y emacs
        ok "Emacs 29+ instalado desde PPA"
    else
        warn "No se pudo agregar PPA. Se instalara la version del repo default."
        sudo apt-get install -y emacs
        warn "Version instalada: $(emacs --version 2>/dev/null | head -1)"
    fi
else
    ok "Emacs $EMACS_VERSION ya instalado (>= 29)"
fi

# =============================================================================
# 4. GNU STOW Y HERRAMIENTAS BASICAS
# =============================================================================
info "Instalando stow, rsync, rclone..."
sudo apt-get install -y stow rsync rclone git
ok "Herramientas basicas instaladas"

# =============================================================================
# 5. EJECUTAR INSTALL.SH PRINCIPAL
# =============================================================================
echo ""
info "Ejecutando instalador principal (install.sh)..."
echo "  Este script detectara WSL automaticamente."
echo ""

bash "$SCRIPT_DIR/install.sh" "$@"

# =============================================================================
# INSTRUCCIONES FINALES
# =============================================================================
echo ""
echo "=============================================="
echo -e "${GREEN}  WSL2 configurado correctamente${NC}"
echo "=============================================="
echo ""
echo "  Para usar Emacs:"
echo "    emacs          (en la terminal WSL)"
echo ""
echo "  Sincronizacion con Google Drive:"
echo "    1. Abri Emacs"
echo "    2. C-c U D  →  Configurar rclone (primera vez)"
echo "    3. C-c U S  →  Descargar datos desde Drive"
echo "    4. C-c U s  →  Subir datos a Drive"
echo ""
echo "  Tip: Agrega un alias en ~/.bashrc:"
echo "    alias e='emacs -nw'"
echo ""
