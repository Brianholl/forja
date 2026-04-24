#!/bin/bash
# =============================================================================
# test.sh — FORJA: Test de integración por lenguaje
# Crea un "hello world" mínimo por lenguaje, lo compila/ejecuta y reporta.
# No modifica el sistema. Limpia /tmp al salir.
#
# Uso:
#   bash test.sh           (prueba todos los lenguajes disponibles)
#   bash test.sh --lang c  (prueba solo un lenguaje)
# =============================================================================

# --- Colores ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- Resultados ---
PASS=()
FAIL=()
SKIP=()

pass() { PASS+=("$1");          echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { FAIL+=("$1 — $2");    echo -e "${RED}[FAIL]${NC} $1 — $2"; }
skip() { SKIP+=("$1");          echo -e "${YELLOW}[SKIP]${NC} $1 — $2"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# --- Plataforma ---
if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    PLATFORM="termux"
elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
    PLATFORM="wsl"
else
    PLATFORM="arch"
fi

# --- Directorio temporal ---
WORK_DIR=$(mktemp -d /tmp/forja-test-XXXXXX)
trap "rm -rf '$WORK_DIR'" EXIT

# --- Filtro de lenguaje (--lang) ---
ONLY_LANG=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --lang) ONLY_LANG="$2"; shift 2 ;;
        *) shift ;;
    esac
done

should_run() { [ -z "$ONLY_LANG" ] || [ "$ONLY_LANG" = "$1" ]; }

echo ""
echo "=============================================="
echo "  FORJA — Test Suite de Lenguajes"
echo "  Plataforma: $PLATFORM"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "=============================================="
echo ""

# =============================================================================
# Tests
# =============================================================================

# --- C ---
test_c() {
    should_run c || return
    if ! command -v gcc &>/dev/null; then skip "C" "gcc no instalado"; return; fi
    local d="$WORK_DIR/c" out
    mkdir -p "$d"
    cat > "$d/main.c" << 'EOF'
#include <stdio.h>
int main() { printf("hello\n"); return 0; }
EOF
    out=$(gcc -o "$d/main" "$d/main.c" 2>&1 && "$d/main" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "C (gcc)"; else fail "C" "$out"; fi
}

# --- C++ ---
test_cpp() {
    should_run cpp || return
    if ! command -v g++ &>/dev/null; then skip "C++" "g++ no instalado"; return; fi
    local d="$WORK_DIR/cpp" out
    mkdir -p "$d"
    cat > "$d/main.cpp" << 'EOF'
#include <iostream>
int main() { std::cout << "hello" << std::endl; return 0; }
EOF
    out=$(g++ -o "$d/main" "$d/main.cpp" 2>&1 && "$d/main" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "C++ (g++)"; else fail "C++" "$out"; fi
}

# --- Rust (rustc directo — evita los 30s de cargo build) ---
test_rust() {
    should_run rust || return
    if ! command -v rustc &>/dev/null; then skip "Rust" "rustc no instalado"; return; fi
    local d="$WORK_DIR/rust" out
    mkdir -p "$d"
    cat > "$d/main.rs" << 'EOF'
fn main() { println!("hello"); }
EOF
    out=$(rustc -o "$d/main" "$d/main.rs" 2>&1 && "$d/main" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Rust (rustc)"; else fail "Rust (rustc)" "$out"; fi
    # Verificar cargo por separado (sin compilar)
    if command -v cargo &>/dev/null; then pass "Rust (cargo disponible)";
    else fail "Rust" "cargo no encontrado"; fi
}

# --- Go ---
test_go() {
    should_run go || return
    if ! command -v go &>/dev/null; then skip "Go" "go no instalado"; return; fi
    local d="$WORK_DIR/go" out
    mkdir -p "$d"
    cat > "$d/main.go" << 'EOF'
package main
import "fmt"
func main() { fmt.Println("hello") }
EOF
    out=$(go run "$d/main.go" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Go (go run)"; else fail "Go" "$out"; fi
}

# --- Python ---
test_python() {
    should_run python || return
    local py
    py=$(command -v python3 || command -v python)
    if [ -z "$py" ]; then skip "Python" "python3 no instalado"; return; fi
    local out
    out=$(echo 'print("hello")' | "$py" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Python ($py)"; else fail "Python" "$out"; fi
    # Verificar pylsp
    if command -v pylsp &>/dev/null; then pass "Python (pylsp disponible)";
    else fail "Python" "pylsp no encontrado"; fi
}

# --- Node.js ---
test_node() {
    should_run node || return
    if ! command -v node &>/dev/null; then skip "Node.js" "node no instalado"; return; fi
    local out
    out=$(echo 'console.log("hello")' | node 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Node.js"; else fail "Node.js" "$out"; fi
}

# --- TypeScript ---
test_typescript() {
    should_run typescript || return
    if ! command -v tsc &>/dev/null; then skip "TypeScript" "tsc no instalado"; return; fi
    local d="$WORK_DIR/ts" out
    mkdir -p "$d"
    cat > "$d/index.ts" << 'EOF'
const msg: string = "hello";
console.log(msg);
EOF
    out=$(tsc --target ES2020 --outDir "$d" "$d/index.ts" 2>&1 && node "$d/index.js" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "TypeScript (tsc + node)"; else fail "TypeScript" "$out"; fi
}

# --- PHP ---
test_php() {
    should_run php || return
    if ! command -v php &>/dev/null; then skip "PHP" "php no instalado"; return; fi
    local out
    out=$(php -r 'echo "hello\n";' 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "PHP"; else fail "PHP" "$out"; fi
}

# --- Lua ---
test_lua() {
    should_run lua || return
    local lua
    lua=$(command -v lua || command -v lua5.4 || command -v lua5.3)
    if [ -z "$lua" ]; then skip "Lua" "lua no instalado"; return; fi
    local out
    out=$(echo 'print("hello")' | "$lua" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Lua ($lua)"; else fail "Lua" "$out"; fi
}

# --- Zig ---
test_zig() {
    should_run zig || return
    if ! command -v zig &>/dev/null; then skip "Zig" "zig no instalado"; return; fi
    local d="$WORK_DIR/zig" out
    mkdir -p "$d"
    cat > "$d/main.zig" << 'EOF'
const std = @import("std");
pub fn main() !void { std.debug.print("hello\n", .{}); }
EOF
    out=$(zig run "$d/main.zig" 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Zig (zig run)"; else fail "Zig" "$out"; fi
}

# --- Java (javac directo — sin Maven para evitar descargas) ---
test_java() {
    should_run java || return
    if ! command -v javac &>/dev/null; then skip "Java" "javac no instalado"; return; fi
    local d="$WORK_DIR/java" out
    mkdir -p "$d"
    cat > "$d/Main.java" << 'EOF'
public class Main {
    public static void main(String[] args) { System.out.println("hello"); }
}
EOF
    out=$(javac -d "$d" "$d/Main.java" 2>&1 && java -cp "$d" Main 2>&1) || true
    if echo "$out" | grep -q "hello"; then pass "Java (javac + java)"; else fail "Java" "$out"; fi
    # Verificar Maven por separado
    if command -v mvn &>/dev/null; then pass "Java (Maven disponible)";
    else fail "Java" "mvn no encontrado"; fi
    # Verificar Gradle por separado
    if command -v gradle &>/dev/null; then pass "Java (Gradle disponible)";
    else skip "Kotlin/Gradle" "gradle no instalado"; fi
}

# --- LSP servers (solo verificar presencia, no arrancarlos) ---
test_lsp() {
    should_run lsp || return
    info "Verificando LSP servers..."
    command -v clangd                    &>/dev/null && pass "LSP clangd"        || fail "LSP" "clangd no encontrado"
    command -v rust-analyzer             &>/dev/null && pass "LSP rust-analyzer" || fail "LSP" "rust-analyzer no encontrado"
    command -v gopls                     &>/dev/null && pass "LSP gopls"         || fail "LSP" "gopls no encontrado"
    command -v pylsp                     &>/dev/null && pass "LSP pylsp"         || fail "LSP" "pylsp no encontrado"
    command -v typescript-language-server &>/dev/null && pass "LSP tsserver"     || fail "LSP" "typescript-language-server no encontrado"
    if [ "$PLATFORM" != "termux" ]; then
        command -v zls &>/dev/null && pass "LSP zls" || skip "LSP zls" "opcional"
    fi
}

# =============================================================================
# Ejecutar tests según plataforma
# =============================================================================

test_c
test_cpp
test_rust
test_go
test_python
test_node
test_typescript
test_php
test_lua
test_zig
test_java
test_lsp

# =============================================================================
# Resumen
# =============================================================================

echo ""
echo "=============================================="
echo "  FORJA — Resumen"
echo "=============================================="
echo ""

if [ ${#PASS[@]} -gt 0 ]; then
    echo -e "${GREEN}Pasaron (${#PASS[@]}):${NC}"
    for t in "${PASS[@]}"; do printf "  ${GREEN}✓${NC} %s\n" "$t"; done
fi

if [ ${#SKIP[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Saltados (${#SKIP[@]}):${NC}"
    for t in "${SKIP[@]}"; do printf "  ${YELLOW}-${NC} %s\n" "$t"; done
fi

if [ ${#FAIL[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}Fallaron (${#FAIL[@]}):${NC}"
    for t in "${FAIL[@]}"; do printf "  ${RED}✗${NC} %s\n" "$t"; done
    echo ""
    echo -e "${RED}Ejecuta ./install.sh para instalar las dependencias faltantes.${NC}"
    echo -e "${YELLOW}O usa ./install.sh --verify para ver qué falta sin reinstalar.${NC}"
    echo ""
    exit 1
fi

echo ""
echo -e "${GREEN}Todos los lenguajes disponibles funcionan correctamente.${NC}"
echo ""
exit 0
