#!/bin/bash
# =============================================================================
# doctor.sh — Diagnóstico de instalación FORJA
# Uso: bash doctor.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
DIM='\033[2m'
NC='\033[0m'

# --- Plataforma ---
if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    PLATFORM="termux"
elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    PLATFORM="wsl"
else
    PLATFORM="arch"
fi

# --- Perfil ---
FORJA_FEATURES=""
FORJA_PROFILE=""
[ -f "$HOME/.forja/profile.conf" ] && source "$HOME/.forja/profile.conf"

has_feature() { echo ",$FORJA_FEATURES," | grep -q ",$1,"; }

ERRORS=0

line() { printf '%.0s─' {1..52}; printf '\n'; }

check() {
    local bin="$1" desc="$2" kind="$3"   # kind: required | optional
    local path
    path=$(command -v "$bin" 2>/dev/null)
    if [ -n "$path" ]; then
        printf "  ${GREEN}✓${NC} %-26s %s\n" "$desc:" "$path"
    elif [ "$kind" = "required" ]; then
        printf "  ${RED}✗${NC} %-26s NO ENCONTRADO\n" "$desc:"
        ((ERRORS++))
    else
        printf "  ${DIM}·${NC} %-26s no instalado (opcional)\n" "$desc:"
    fi
}

# =============================================================================
echo ""
echo "FORJA Doctor — Diagnóstico de instalación"
line
printf "  Plataforma : %s\n" "$PLATFORM"
[ -n "$FORJA_PROFILE"  ] && printf "  Perfil     : %s\n" "$FORJA_PROFILE"
[ -n "$FORJA_FEATURES" ] && printf "  Features   : %s\n" "$FORJA_FEATURES"
echo ""

# --- Lenguajes (siempre requeridos) ---
echo "[ Herramientas de lenguaje ]"
check gcc              "C/C++"           required
check make             "C (Make)"        required
check clangd           "C/C++ LSP"       required
check rustc            "Rust"            required
check cargo            "Rust (Cargo)"    required
check rust-analyzer    "Rust LSP"        required
check go               "Go"              required
check gopls            "Go LSP"          required
check python3          "Python"          required
check pylsp            "Python LSP"      required
check node             "Node.js"         required
check npm              "npm"             required
check lua              "Lua"             required
check lua-language-server "Lua LSP"      required
check zig              "Zig"             required
check zls              "Zig LSP"         required
if [ "$PLATFORM" != "termux" ]; then
    check java             "Java"            required
    check mvn              "Maven"           required
    check kotlin           "Kotlin"          required
    check gradle           "Gradle"          required
    check love             "Löve2D"          optional
fi
if [ "$PLATFORM" = "arch" ]; then
    check cppman           "cppman (C++ docs)" optional
fi

# --- Juego / embebido ---
echo ""
echo "[ Herramientas de juego ]"
if has_feature "godot"; then
    check godot  "Godot 4"  required
else
    check godot  "Godot 4"  optional
fi
if has_feature "esp32"; then
    _esp_kind="required"
else
    _esp_kind="optional"
fi
# idf.py no está en PATH — se activa con source export.sh; verificamos la instalación del paquete
if [ -f "/opt/esp-idf/export.sh" ]; then
    printf "  ${GREEN}✓${NC} %-26s %s\n" "ESP-IDF:" "/opt/esp-idf"
elif [ -d "$HOME/esp/esp-idf" ]; then
    printf "  ${GREEN}✓${NC} %-26s %s\n" "ESP-IDF:" "$HOME/esp/esp-idf"
elif [ "$_esp_kind" = "required" ]; then
    printf "  ${RED}✗${NC} %-26s NO ENCONTRADO\n" "ESP-IDF:"
    ((ERRORS++))
else
    printf "  ${DIM}·${NC} %-26s no instalado (opcional)\n" "ESP-IDF:"
fi

# --- Infraestructura ---
echo ""
echo "[ Infraestructura ]"
check git   "Git"       required
check emacs "Emacs"     required
check stow  "GNU Stow"  required

if [ "$PLATFORM" != "termux" ]; then
    check docker   "Docker"           optional
    check valgrind "Valgrind"         optional
    check lcov     "lcov (cobertura)" optional
fi

if has_feature "aider" || has_feature "picoclaw" || has_feature "openclaw"; then
    check ollama "Ollama (IA local)"   required
else
    check ollama "Ollama (IA local)"   optional
fi
if has_feature "aider"; then
    check aider  "Aider (IA terminal)" required
else
    check aider  "Aider (IA terminal)" optional
fi
if has_feature "sync-drive"; then
    check rclone "rclone (Drive)"      required
else
    check rclone "rclone (Drive)"      optional
fi
if has_feature "latex"; then
    check pdflatex "LaTeX (pdflatex)"  required
fi
if has_feature "fasm"; then
    check fasm "FASM" required
fi

# --- Versiones ---
echo ""
echo "[ Versiones ]"
for cmd in emacs rustc go python3 node; do
    path=$(command -v "$cmd" 2>/dev/null) || continue
    case "$cmd" in
        emacs)   ver=$(emacs --version 2>/dev/null | head -1) ;;
        rustc)   ver=$(rustc --version 2>/dev/null) ;;
        go)      ver=$(go version 2>/dev/null) ;;
        python3) ver=$(python3 --version 2>/dev/null) ;;
        node)    ver="node $(node --version 2>/dev/null)" ;;
    esac
    printf "  ${GREEN}✓${NC} %-26s %s\n" "$cmd:" "$ver"
done

# --- Resumen ---
echo ""
line
if [ "$ERRORS" -eq 0 ]; then
    printf "${GREEN}  Todo OK — 0 errores${NC}\n"
else
    printf "${RED}  %d herramienta(s) requerida(s) faltante(s)${NC}\n" "$ERRORS"
fi
echo "  ✓ instalado   · opcional   ✗ requerido faltante"
echo ""
