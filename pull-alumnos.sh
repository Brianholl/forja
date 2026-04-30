#!/bin/bash
# =============================================================================
# pull-alumnos.sh — Descarga todos los backups de alumnos desde Google Drive
#
# Uso:
#   ./pull-alumnos.sh                        # descarga todos los alumnos
#   ./pull-alumnos.sh garcia-juan            # solo ese alumno
#   ./pull-alumnos.sh --list                 # listar alumnos disponibles en Drive
#   ./pull-alumnos.sh --dry-run              # simular sin descargar
#
# Variables de entorno (opcionales):
#   RCLONE_REMOTE    nombre del remote rclone  (default: gdrive)
#   RCLONE_BASE      carpeta base en Drive      (default: emacs-sync)
#   ORG_ALUMNOS_DIR  directorio local destino   (default: ~/forja-org/cloud)
#
# Requiere: rclone configurado con el remote 'gdrive'
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
DIM='\033[2m'
WHITE='\033[1;37m'
NC='\033[0m'

ok()   { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[!!]${NC} $1"; }
err()  { echo -e "${RED}[XX]${NC} $1"; }
info() { echo -e "${BLUE}[..]${NC} $1"; }

# --- Configuración (sincronizada con 49-multiusuario.el) ---
REMOTE="${RCLONE_REMOTE:-gdrive}"
BASE_PATH="${RCLONE_BASE:-emacs-sync}"
LOCAL_DIR="${ORG_ALUMNOS_DIR:-$HOME/forja-org/cloud}"
TMPDIR="${TMPDIR:-/tmp}"

# --- Flags ---
DRY_RUN=0
LIST_ONLY=0
ALUMNO_FILTRO=""

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --list)    LIST_ONLY=1 ;;
        --help|-h)
            echo "Uso: $0 [alumno] [--list] [--dry-run]"
            exit 0 ;;
        --*)
            err "Opción desconocida: $arg"
            exit 1 ;;
        *)
            ALUMNO_FILTRO="$arg" ;;
    esac
done

# =============================================================================
# VERIFICACIONES PREVIAS
# =============================================================================

if ! command -v rclone &>/dev/null; then
    err "rclone no está instalado."
    echo "  Arch:  sudo pacman -S rclone"
    echo "  WSL:   sudo apt install rclone"
    echo "  Termux: pkg install rclone"
    exit 1
fi

if ! rclone listremotes 2>/dev/null | grep -q "^${REMOTE}:"; then
    err "El remote '${REMOTE}' no está configurado en rclone."
    echo "  Ejecutá: rclone config"
    echo "  O configurá la variable RCLONE_REMOTE con el nombre correcto."
    exit 1
fi

# =============================================================================
# LISTAR ALUMNOS EN DRIVE
# =============================================================================

info "Buscando alumnos en ${REMOTE}:${BASE_PATH}/ ..."

# rclone lsf lista directorios con / al final
ALUMNOS_DRIVE=$(rclone lsf "${REMOTE}:${BASE_PATH}/" \
    --dirs-only 2>/dev/null \
    | sed 's|/$||' \
    | sort)

if [ -z "$ALUMNOS_DRIVE" ]; then
    warn "No se encontraron alumnos en ${REMOTE}:${BASE_PATH}/"
    warn "Verificá que rclone esté autenticado: rclone lsd ${REMOTE}:${BASE_PATH}"
    exit 1
fi

TOTAL=$(echo "$ALUMNOS_DRIVE" | wc -l | tr -d ' ')

if [ "$LIST_ONLY" = "1" ]; then
    echo ""
    echo "Alumnos disponibles en ${REMOTE}:${BASE_PATH}/ ($TOTAL):"
    echo ""
    while IFS= read -r alumno; do
        # Verificar si tiene backup.tar.gz
        if rclone lsf "${REMOTE}:${BASE_PATH}/${alumno}/" 2>/dev/null | grep -q "backup.tar.gz"; then
            echo -e "  ${GREEN}✓${NC} ${alumno}"
        else
            echo -e "  ${YELLOW}○${NC} ${alumno}  ${DIM}(sin backup.tar.gz)${NC}"
        fi
    done <<< "$ALUMNOS_DRIVE"
    echo ""
    exit 0
fi

# Filtrar si se especificó un alumno
if [ -n "$ALUMNO_FILTRO" ]; then
    if ! echo "$ALUMNOS_DRIVE" | grep -q "^${ALUMNO_FILTRO}$"; then
        err "Alumno '${ALUMNO_FILTRO}' no encontrado en Drive."
        echo "  Alumnos disponibles: $(echo "$ALUMNOS_DRIVE" | tr '\n' ' ')"
        exit 1
    fi
    ALUMNOS_DRIVE="$ALUMNO_FILTRO"
    TOTAL=1
fi

# =============================================================================
# CABECERA
# =============================================================================

echo ""
echo "=============================================="
echo -e "  ${WHITE}FORJA — Pull de alumnos desde Drive${NC}"
echo "  Remote : ${REMOTE}:${BASE_PATH}/"
echo "  Destino: ${LOCAL_DIR}/"
[ "$DRY_RUN" = "1" ] && echo -e "  ${YELLOW}Modo: --dry-run (simulación, sin cambios)${NC}"
echo "=============================================="
echo ""

mkdir -p "$LOCAL_DIR"

# =============================================================================
# DESCARGA
# =============================================================================

OK=0
FAIL=0
SIN_BACKUP=0
IDX=0

while IFS= read -r alumno; do
    IDX=$((IDX + 1))
    REMOTE_FILE="${REMOTE}:${BASE_PATH}/${alumno}/backup.tar.gz"
    TMP_TAR="${TMPDIR}/forja-pull-${alumno}.tar.gz"

    echo -ne "  [${IDX}/${TOTAL}] ${WHITE}${alumno}${NC} ... "

    # Verificar que existe backup.tar.gz
    if ! rclone lsf "${REMOTE}:${BASE_PATH}/${alumno}/" 2>/dev/null | grep -q "backup.tar.gz"; then
        echo -e "${YELLOW}sin backup${NC}"
        SIN_BACKUP=$((SIN_BACKUP + 1))
        continue
    fi

    if [ "$DRY_RUN" = "1" ]; then
        echo -e "${DIM}(dry-run — se descargaría ${REMOTE_FILE})${NC}"
        OK=$((OK + 1))
        continue
    fi

    # Descargar
    if ! rclone copyto "$REMOTE_FILE" "$TMP_TAR" 2>/dev/null; then
        echo -e "${RED}error al descargar${NC}"
        FAIL=$((FAIL + 1))
        rm -f "$TMP_TAR"
        continue
    fi

    # Extraer (sobreescribe la carpeta local del alumno)
    if ! tar -xzf "$TMP_TAR" -C "$LOCAL_DIR" 2>/dev/null; then
        echo -e "${RED}error al extraer${NC}"
        FAIL=$((FAIL + 1))
        rm -f "$TMP_TAR"
        continue
    fi

    rm -f "$TMP_TAR"
    echo -e "${GREEN}ok${NC}"
    OK=$((OK + 1))

done <<< "$ALUMNOS_DRIVE"

# =============================================================================
# RESUMEN
# =============================================================================

echo ""
echo "=============================================="
if [ "$DRY_RUN" = "1" ]; then
    echo -e "${YELLOW}  Simulación completada (--dry-run)${NC}"
else
    echo -e "${GREEN}  Descarga completada${NC}"
fi
echo ""
echo "  ✓ Descargados  : ${OK}"
[ "$FAIL" -gt 0 ]       && echo -e "  ${RED}✗ Errores       : ${FAIL}${NC}"
[ "$SIN_BACKUP" -gt 0 ] && echo -e "  ${YELLOW}○ Sin backup    : ${SIN_BACKUP}${NC}"
echo ""
echo "  Alumnos en ${LOCAL_DIR}/:"
ls -1 "$LOCAL_DIR" 2>/dev/null | sed 's/^/    /'
echo ""
if [ "$DRY_RUN" = "0" ] && [ "$OK" -gt 0 ]; then
    echo "  Abrí la Vista Docente en Emacs:"
    echo -e "  ${WHITE}C-c U V${NC}  (o M-x my/mu-vista-docente)"
fi
echo "=============================================="
echo ""

[ "$FAIL" -gt 0 ] && exit 1
exit 0
