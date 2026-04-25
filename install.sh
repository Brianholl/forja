#!/bin/bash
# =============================================================================
# install.sh — Instalador de dependencias para FORJA
# Autor: Brian Hollweg
# Soporta: Arch Linux (PC), Termux (Android) y WSL2 (Windows)
#
# Uso:
#   bash forja-menu.sh        (configura perfil interactivamente)
#   bash install.sh            (lee ~/.forja/profile.conf)
#   bash install.sh --perfil casa   (modo legacy, sin menu)
# =============================================================================

# No usar set -e: manejamos errores manualmente con || warn/err
# para que un paso fallido (ej: npm globals) no aborte el script entero

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

# Instala un paquete npm global solo si el binario no está en PATH
npm_install_if_missing() {
    local pkg="$1" bin="${2:-$1}"
    if command -v "$bin" &>/dev/null; then
        info "$bin ya instalado (omitiendo)"
    else
        if [ "$PLATFORM" = "wsl" ] || [ "$PLATFORM" = "arch" ]; then
            sudo npm install -g "$pkg" || warn "No se pudo instalar npm: $pkg"
        else
            npm install -g "$pkg" || warn "No se pudo instalar npm: $pkg"
        fi
    fi
}

# =============================================================================
# VERIFICACION DE HERRAMIENTAS (llamada al final o con --verify)
# =============================================================================
run_verification() {
    # mode: "post-install" (llamado al final de install.sh) o "standalone" (--verify)
    local mode="${1:-standalone}"
    local pass=() fail=()

    check_tool() {
        local label="$1" bin="${2:-$1}"
        if command -v "$bin" &>/dev/null; then
            pass+=("$label")
        else
            fail+=("$label")
        fi
    }

    echo ""
    echo "=============================================="
    echo "  FORJA — Verificacion de dependencias"
    echo "  Plataforma: $PLATFORM"
    echo "=============================================="

    # Base
    check_tool "Emacs"        emacs
    check_tool "Git"          git
    check_tool "Stow"         stow
    check_tool "Ripgrep"      rg
    # C/C++
    check_tool "GCC"          gcc
    check_tool "Clangd"       clangd
    check_tool "Make"         make
    check_tool "GDB"          gdb
    # Rust
    check_tool "Cargo"        cargo
    check_tool "rust-analyzer" rust-analyzer
    # Go
    check_tool "Go"           go
    check_tool "gopls"        gopls
    # Python
    check_tool "Python3"      python3
    check_tool "pylsp"        pylsp
    check_tool "ruff"         ruff
    # Node / Web
    check_tool "Node.js"      node
    check_tool "TypeScript LSP" typescript-language-server
    check_tool "Prettier"     prettier
    # Java / Kotlin
    # Maven no existe en pkg de Termux — solo se verifica en otras plataformas
    check_tool "Java"         java
    [ "$PLATFORM" != "termux" ] && check_tool "Maven"  mvn
    check_tool "Gradle"       gradle
    # Zig / Lua
    check_tool "Zig"          zig
    check_tool "Lua"          lua
    # Opcional segun plataforma
    if [ "$PLATFORM" != "termux" ]; then
        check_tool "Valgrind"  valgrind
        check_tool "Rclone"    rclone
    fi
    if [ "$PLATFORM" = "arch" ]; then
        check_tool "Ollama"    ollama
        check_tool "Aider"     aider
    fi

    echo ""
    if [ ${#pass[@]} -gt 0 ]; then
        echo -e "${GREEN}Instaladas (${#pass[@]}):${NC}"
        for t in "${pass[@]}"; do printf "  ${GREEN}✓${NC} %s\n" "$t"; done
    fi
    if [ ${#fail[@]} -gt 0 ]; then
        echo ""
        echo -e "${RED}Faltantes (${#fail[@]}):${NC}"
        for t in "${fail[@]}"; do printf "  ${RED}✗${NC} %s\n" "$t"; done
        echo ""
        if [ "$mode" = "post-install" ]; then
            warn "Algunas herramientas no se instalaron. Revisa las advertencias arriba."
            warn "Tip: corre 'forja doctor' para un diagnóstico detallado."
        else
            warn "Ejecuta ./install.sh para instalar las dependencias faltantes"
        fi
        echo ""
        return 1
    else
        echo ""
        ok "Todas las dependencias verificadas correctamente"
        echo ""
        return 0
    fi
}

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
# LEER CONFIGURACION (profile.conf o argumentos CLI)
# =============================================================================

FORJA_CONF_DIR="$HOME/.forja"
FORJA_CONF_FILE="$FORJA_CONF_DIR/profile.conf"

# Funcion: verificar si un feature esta habilitado en profile.conf
forja_has_feature() {
    local feature="$1"
    echo ",$FORJA_FEATURES," | grep -q ",$feature,"
    return $?
}

# --- Leer profile.conf si existe ---
PERFIL=""
FORJA_FEATURES=""
FORJA_MODEL_CODE=""
FORJA_MODEL_CHAT=""

if [ -f "$FORJA_CONF_FILE" ]; then
    source "$FORJA_CONF_FILE"
    PERFIL="${FORJA_PROFILE:-escuela}"
    info "Configuracion leida de $FORJA_CONF_FILE"
    info "  Perfil: $PERFIL | Features: $FORJA_FEATURES"
    if [ -n "$FORJA_MODEL_CODE" ] && [ "$FORJA_MODEL_CODE" != "ninguno" ]; then
        info "  Modelo codigo: $FORJA_MODEL_CODE | Modelo espanol: $FORJA_MODEL_CHAT"
    fi
fi

# --- Permitir override por CLI (modo legacy) ---
ONLY_VERIFY=0
while [[ $# -gt 0 ]]; do
    case $1 in
        --verify) ONLY_VERIFY=1; shift ;;
        --perfil) PERFIL="$2"; shift 2 ;;
        casa|escuela|minimal) PERFIL="$1"; shift ;;
        --menu)
            # Forzar ejecutar el menu interactivo
            bash "$SCRIPT_DIR/forja-menu.sh"
            # Recargar configuracion despues del menu
            if [ -f "$FORJA_CONF_FILE" ]; then
                source "$FORJA_CONF_FILE"
                PERFIL="${FORJA_PROFILE:-escuela}"
            fi
            shift
            ;;
        *) shift ;;
    esac
done

# --- Si no hay perfil definido, ofrecer el menu ---
if [ -z "$PERFIL" ]; then
    if [ -t 0 ] && [ -f "$SCRIPT_DIR/forja-menu.sh" ]; then
        echo ""
        echo -e "${YELLOW}No se encontro configuracion previa.${NC}"
        echo -e "Ejecutando el asistente de configuracion..."
        echo ""
        bash "$SCRIPT_DIR/forja-menu.sh"
        if [ -f "$FORJA_CONF_FILE" ]; then
            source "$FORJA_CONF_FILE"
            PERFIL="${FORJA_PROFILE:-escuela}"
        else
            PERFIL="escuela"
            warn "El asistente no genero configuracion. Usando perfil: escuela"
        fi
    else
        PERFIL="escuela"
        warn "Sin configuracion ni terminal interactiva. Usando perfil: escuela"
    fi
fi

# --- Si usaron --perfil sin forja-menu.sh, generar FORJA_FEATURES de compatibilidad ---
if [ -z "$FORJA_FEATURES" ]; then
    case "$PERFIL" in
        minimal)
            FORJA_FEATURES="sync-drive,multiusuario"
            ;;
        casa)
            FORJA_FEATURES="aider,godot,raylib,unreal,n8n,picoclaw,openclaw,latex,esp32,fasm,sync-drive,multiusuario"
            FORJA_MODEL_CODE="${FORJA_MODEL_CODE:-qwen2.5-coder:7b}"
            FORJA_MODEL_CHAT="${FORJA_MODEL_CHAT:-qwen2.5:7b}"
            ;;
        *)
            FORJA_FEATURES="aider,godot,raylib,n8n,latex,sync-drive,multiusuario"
            FORJA_MODEL_CODE="${FORJA_MODEL_CODE:-qwen2.5-coder:0.5b}"
            FORJA_MODEL_CHAT="${FORJA_MODEL_CHAT:-qwen2.5:0.5b}"
            ;;
    esac
fi

echo ""
echo "=============================================="
echo "  FORJA — Instalador"
echo "  Plataforma: $PLATFORM"
echo "  Perfil: $PERFIL"
echo "=============================================="
echo ""

# Si solo se pidio verificacion, ejecutar y salir
if [ "$ONLY_VERIFY" = "1" ]; then
    run_verification
    exit $?
fi

# =============================================================================
# 1. ACTUALIZAR SISTEMA
# =============================================================================
info "Actualizando el sistema..."
if [ "$PLATFORM" = "termux" ]; then
    pkg upgrade -y
    apt --fix-broken install -y 2>/dev/null || true
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
else
    sudo pacman -Syu --noconfirm
fi

# =============================================================================
# 2. SISTEMA BASE Y COMPILACION
# =============================================================================
info "[1/11] Sistema base y compilacion..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y git build-essential ripgrep fd unzip cmake ninja stow rsync tree-sitter
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y \
        software-properties-common apt-transport-https ca-certificates gnupg \
        git build-essential ripgrep fd-find unzip cmake ninja-build stow rsync curl wget \
        libtree-sitter-dev tree-sitter-cli
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
else
    sudo pacman -S --needed --noconfirm \
        git base-devel ripgrep fd unzip cmake ninja astyle stow rsync tree-sitter tree-sitter-cli
fi

# =============================================================================
# 3. EMACS Y FUENTES
# =============================================================================
info "[2/11] Emacs y fuentes..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y emacs
    ok "Emacs instalado (Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    if ! command -v emacs &>/dev/null || [[ "$(emacs --version 2>/dev/null | head -1 | grep -oP '\d+')" -lt 29 ]]; then
        info "Agregando PPA para Emacs 29+..."
        sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs 2>/dev/null \
            || warn "No se pudo agregar PPA, instalando Emacs del repo default"
        sudo apt-get update -y
    fi
    sudo apt-get install -y emacs
    ok "Emacs instalado (WSL)"
else
    sudo pacman -S --needed --noconfirm \
        emacs \
        ttf-jetbrains-mono-nerd \
        ttf-iosevka-nerd \
        inter-font
    ok "Emacs y fuentes instalados"
fi

# =============================================================================
# 4. TOOLCHAIN C/C++ Y LOW LEVEL
# =============================================================================
info "[3/11] Toolchain C/C++..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y clang binutils
    ok "Clang instalado (sin GDB/valgrind en Termux ARM)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y build-essential clang llvm gdb valgrind lcov
    ok "Toolchain C/C++ completo (WSL)"
else
    ARCH_CPP_PKGS="gcc clang llvm lldb gdb valgrind lcov benchmark binutils"
    if forja_has_feature "fasm"; then
        ARCH_CPP_PKGS="$ARCH_CPP_PKGS fasm"
    fi
    sudo pacman -S --needed --noconfirm $ARCH_CPP_PKGS
    ok "Toolchain C/C++ completo"
fi

# =============================================================================
# 5. LENGUAJES Y RUNTIMES
# =============================================================================
info "[4/11] Lenguajes: Rust, Go, Node.js..."

# Rust
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y rust
    ok "Rust instalado (Termux pkg)"
elif [ "$PLATFORM" = "wsl" ]; then
    if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    rustup default stable
    rustup component add rust-analyzer rust-src rustfmt clippy
    ok "Rust configurado (WSL)"
else
    sudo pacman -S --needed --noconfirm rustup
    rustup default stable
    rustup component add rust-analyzer rust-src rustfmt clippy
    ok "Rust configurado"
fi

# Go
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y golang gopls
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y golang
    go install golang.org/x/tools/gopls@latest 2>/dev/null || warn "No se pudo instalar gopls"
else
    sudo pacman -S --needed --noconfirm go gopls
fi
ok "Go instalado"

# Node.js
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y nodejs
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y nodejs npm
else
    sudo pacman -S --needed --noconfirm nodejs npm firefox
fi
ok "Node.js instalado"

# Python
info "Instalando Python y herramientas..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y python python-pip
    # pylsp: solo paquetes pure-Python — ruff tiene Rust nativo, no hay wheel ARM64
    # Se intenta pkg install ruff primero; si no está disponible, se omite (es opcional)
    pip install python-lsp-server pylsp-mypy 2>/dev/null \
        || warn "No se pudo instalar pylsp en Termux"
    pkg install -y ruff 2>/dev/null \
        || pip install --only-binary :all: ruff 2>/dev/null \
        || info "ruff no disponible en Termux — se omite (es opcional)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y python3 python3-pip python3-venv
    pip install --user --break-system-packages \
        python-lsp-server pylsp-mypy python-lsp-black ruff 2>/dev/null \
        || pip install --user python-lsp-server pylsp-mypy python-lsp-black ruff 2>/dev/null \
        || warn "No se pudieron instalar pip packages (pylsp/ruff)"
else
    sudo pacman -S --needed --noconfirm python python-pip python-black
    pip install --user --break-system-packages \
        python-lsp-server pylsp-mypy python-lsp-black ruff 2>/dev/null \
        || pip install --user python-lsp-server pylsp-mypy python-lsp-black ruff 2>/dev/null \
        || warn "No se pudieron instalar pip packages (pylsp/ruff)"
fi
ok "Python instalado"

# PHP
info "Instalando PHP y Composer..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y php composer
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y php php-cli php-mbstring php-xml
    if ! command -v composer &>/dev/null; then
        info "Instalando Composer..."
        php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" 2>/dev/null \
            && sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer 2>/dev/null \
            && rm -f /tmp/composer-setup.php \
            || warn "No se pudo instalar Composer (instalar manualmente)"
    fi
else
    sudo pacman -S --needed --noconfirm php composer
fi
ok "PHP instalado"

# Lua
info "Instalando Lua y lua-language-server..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y lua54
    pkg install -y lua-language-server 2>/dev/null \
        || warn "lua-language-server no disponible en pkg, LSP Lua desactivado"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y lua5.4 love
    sudo apt-get install -y lua-language-server 2>/dev/null \
        || warn "lua-language-server no disponible en apt, LSP Lua desactivado"
else
    sudo pacman -S --needed --noconfirm lua lua-language-server love
fi
ok "Lua + Löve2D instalados"

# Zig
info "Instalando Zig y zls..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y zig
    pkg install -y zig-zls 2>/dev/null || pkg install -y zls 2>/dev/null \
        || warn "zls no disponible en pkg, LSP Zig desactivado"
elif [ "$PLATFORM" = "wsl" ]; then
    # Zig no está en apt, descargar binario
    ZIG_VER="0.14.0"
    ZIG_TAR="zig-linux-x86_64-${ZIG_VER}.tar.xz"
    ZIG_URL="https://ziglang.org/download/${ZIG_VER}/${ZIG_TAR}"
    if ! command -v zig &>/dev/null; then
        curl -Lo "/tmp/${ZIG_TAR}" "$ZIG_URL" \
            && sudo tar -xf "/tmp/${ZIG_TAR}" -C /usr/local \
            && sudo ln -sf "/usr/local/zig-linux-x86_64-${ZIG_VER}/zig" /usr/local/bin/zig \
            && rm "/tmp/${ZIG_TAR}" \
            || warn "No se pudo instalar Zig automáticamente"
    fi
    # zls (Zig LSP) via descarga
    ZLS_URL="https://github.com/zigtools/zls/releases/download/${ZIG_VER}/zls-x86_64-linux.tar.gz"
    if ! command -v zls &>/dev/null; then
        curl -Lo /tmp/zls.tar.gz "$ZLS_URL" 2>/dev/null \
            && sudo tar -xf /tmp/zls.tar.gz -C /usr/local/bin --wildcards "*/zls" --strip-components=1 2>/dev/null \
            && rm /tmp/zls.tar.gz \
            || warn "zls no se pudo instalar, LSP Zig desactivado"
    fi
else
    sudo pacman -S --needed --noconfirm zig zls
fi
ok "Zig instalado"

# Java (JDK + Maven) y Kotlin
info "Instalando Java (JDK 17), Maven y Kotlin..."
if [ "$PLATFORM" = "termux" ]; then
    # Java siempre se instala en Termux — 44-java.org carga en todos los perfiles
    # Maven no existe en pkg de Termux; gradle sí
    pkg install -y openjdk-17
    pkg install -y gradle 2>/dev/null || warn "gradle no disponible en pkg de Termux"
    ok "Java (OpenJDK 17 + Gradle) instalado en Termux"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y openjdk-17-jdk maven gradle
    warn "Kotlin/WSL: instalar desde https://kotlinlang.org/docs/command-line.html"
else
    sudo pacman -S --needed --noconfirm jdk17-openjdk maven gradle kotlin
    # kotlin-language-server (LSP para kotlin-mode)
    if command -v yay &>/dev/null; then
        yay -S --needed --noconfirm kotlin-language-server 2>/dev/null \
            || warn "kotlin-language-server no disponible en AUR"
    fi
fi
ok "Java / Maven / Kotlin instalados"

# rclone (sincronizacion con Google Drive)
if forja_has_feature "sync-drive"; then
    info "Instalando rclone (sincronizacion Google Drive)..."
    if [ "$PLATFORM" = "termux" ]; then
        pkg install -y rclone
    elif [ "$PLATFORM" = "wsl" ]; then
        sudo apt-get install -y rclone
    else
        sudo pacman -S --needed --noconfirm rclone
    fi
    ok "rclone instalado"
fi

# =============================================================================
# 6. GAME DEV (CONDICIONAL)
# =============================================================================
info "[5/11] Game Dev..."
if [ "$PLATFORM" = "termux" ] || [ "$PLATFORM" = "wsl" ]; then
    info "Saltando Game Dev (no disponible en $PLATFORM)"
else
    GAMEDEV_PKGS=""

    if forja_has_feature "raylib"; then
        GAMEDEV_PKGS="$GAMEDEV_PKGS raylib sdl2 sdl2_image sdl2_mixer sdl2_ttf"
    fi

    if forja_has_feature "godot"; then
        GAMEDEV_PKGS="$GAMEDEV_PKGS godot"
    fi

    # zathura siempre util en PC
    GAMEDEV_PKGS="$GAMEDEV_PKGS zathura zathura-pdf-mupdf"

    if [ -n "$GAMEDEV_PKGS" ]; then
        sudo pacman -S --needed --noconfirm $GAMEDEV_PKGS
    fi

    if forja_has_feature "godot"; then
        pip install --user --break-system-packages gdtoolkit 2>/dev/null \
            || warn "No se pudo instalar gdtoolkit"
        ok "Godot + gdtoolkit instalados"
    fi

    ok "Game Dev configurado"
fi

# =============================================================================
# 7. IA Y TERMINAL (CONDICIONAL)
# =============================================================================
info "[6/11] IA y terminal..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y direnv
    info "Saltando Ollama y Alacritty (no disponibles en Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y direnv
    info "Saltando Ollama y Alacritty (no disponibles en WSL)"
else
    sudo pacman -S --needed --noconfirm alacritty direnv

    # Ollama: instalar si se eligio algun feature que lo necesite
    if forja_has_feature "aider" || forja_has_feature "picoclaw" || forja_has_feature "openclaw"; then
        sudo pacman -S --needed --noconfirm ollama

        if command -v ollama &>/dev/null; then
            if ! systemctl is-active --quiet ollama; then
                info "Iniciando servicio ollama..."
                sudo systemctl enable --now ollama
                for i in $(seq 1 10); do
                    sleep 2
                    ollama list &>/dev/null && break
                    info "Esperando que ollama este listo... ($i/10)"
                done
            fi

            # Descargar modelos seleccionados
            if [ -n "$FORJA_MODEL_CODE" ] && [ "$FORJA_MODEL_CODE" != "ninguno" ]; then
                info "Descargando modelo de codigo: $FORJA_MODEL_CODE..."
                ollama pull "$FORJA_MODEL_CODE" || warn "No se pudo descargar $FORJA_MODEL_CODE"
            fi

            if [ -n "$FORJA_MODEL_CHAT" ] && [ "$FORJA_MODEL_CHAT" != "ninguno" ]; then
                # No descargar si es el mismo que el de codigo
                if [ "$FORJA_MODEL_CHAT" != "$FORJA_MODEL_CODE" ]; then
                    info "Descargando modelo de espanol: $FORJA_MODEL_CHAT..."
                    ollama pull "$FORJA_MODEL_CHAT" || warn "No se pudo descargar $FORJA_MODEL_CHAT"
                fi
            fi
        fi
    fi
fi

# =============================================================================
# 8. PAQUETES ESPECIFICOS DE PLATAFORMA (AUR / Termux extras)
# =============================================================================
info "[7/11] Paquetes especificos de plataforma..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y libvterm termux-api
    ok "libvterm y termux-api instalados"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y libvterm-dev libtool-bin
    ok "libvterm instalado (WSL)"
else
    # AUR packages (yay)
    if ! command -v yay &>/dev/null; then
        warn "yay no encontrado — instalando..."
        BUILD_DIR=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
        (cd "$BUILD_DIR" && makepkg --noconfirm --noprogressbar)
        PKG=$(ls "$BUILD_DIR"/yay-*.pkg.tar.zst 2>/dev/null | grep -v debug | head -1)
        if [ -n "$PKG" ]; then
            sudo pacman -U --noconfirm "$PKG"
            ok "yay instalado"
        else
            err "No se encontro el paquete compilado de yay"
        fi
        rm -rf "$BUILD_DIR"
    fi

    AUR_PKGS="vterm-git cppman-git"
    if forja_has_feature "esp32"; then
        AUR_PKGS="$AUR_PKGS esp-idf"
    fi
    yay -S --needed --noconfirm $AUR_PKGS
    ok "Paquetes AUR instalados"
fi

# =============================================================================
# 9. HERRAMIENTAS DE DOCUMENTACION (modulos 50-53)
# =============================================================================
info "[8/11] Herramientas para modulos GTD y documentacion..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y graphviz gnuplot libsqlite
    ok "Herramientas de documentacion (Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y graphviz gnuplot sqlite3 libsqlite3-dev
    ok "Herramientas de documentacion (WSL)"
else
    sudo pacman -S --needed --noconfirm graphviz gnuplot sqlite man-pages

    # LaTeX (condicional)
    if forja_has_feature "latex"; then
        info "Instalando LaTeX..."
        sudo pacman -S --needed --noconfirm \
            texlive-basic texlive-latexrecommended \
            texlive-fontsrecommended texlive-langspanish
        ok "LaTeX instalado"
    fi

    # Diagnostico de redes (para modulo 53-soporte)
    sudo pacman -S --needed --noconfirm traceroute bind-tools

    ok "Dependencias de documentacion instaladas"
fi

# =============================================================================
# 10. LSPs Y HERRAMIENTAS NPM GLOBALES
# =============================================================================
info "[9/11] LSPs web y herramientas npm globales..."

npm_install_if_missing typescript                    tsc
npm_install_if_missing typescript-language-server   typescript-language-server
npm_install_if_missing vscode-langservers-extracted  vscode-css-language-server
npm_install_if_missing live-server                   live-server
npm_install_if_missing prettier                      prettier
npm_install_if_missing intelephense                  intelephense
npm_install_if_missing @prettier/plugin-php          prettier

if [ "$PLATFORM" = "arch" ]; then
    # mermaid-cli necesita Chromium — solo desktop
    sudo pacman -S --needed --noconfirm chromium
    if ! command -v mmdc &>/dev/null; then
        sudo PUPPETEER_SKIP_DOWNLOAD=true npm install -g @mermaid-js/mermaid-cli
        MMDC_DIR=$(npm root -g)/@mermaid-js/mermaid-cli
        if [ -d "$MMDC_DIR" ]; then
            sudo tee "$MMDC_DIR/.puppeteerrc.cjs" > /dev/null <<'PUPPETEER'
const { join } = require('path');
module.exports = { executablePath: '/usr/bin/chromium' };
PUPPETEER
            ok "mermaid-cli configurado con chromium del sistema"
        fi
    else
        info "mmdc ya instalado (omitiendo)"
    fi
fi

ok "LSPs web instalados"

# =============================================================================
# 11. AIDER (CONDICIONAL)
# =============================================================================
info "[10/11] Aider — Code Agent local..."
if [ "$PLATFORM" = "termux" ] || [ "$PLATFORM" = "wsl" ]; then
    info "Saltando Aider (requiere Ollama, no disponible en $PLATFORM)"
elif forja_has_feature "aider"; then
    sudo pacman -S --needed --noconfirm uv

    uv tool install --force --python python3.12 aider-chat@latest

    if [ -f "$HOME/.local/bin/aider" ]; then
        sudo ln -sf "$HOME/.local/bin/aider" /usr/local/bin/aider
        ok "Aider instalado: $(aider --version 2>/dev/null || echo 'verificar manualmente')"
    else
        warn "No se encontro aider en ~/.local/bin"
    fi

    # aider.el (integracion Emacs)
    mkdir -p ~/.emacs.d/site-lisp
    if [ ! -d ~/.emacs.d/site-lisp/aider.el ]; then
        git clone https://github.com/tninja/aider.el ~/.emacs.d/site-lisp/aider.el
        ok "aider.el clonado"
    else
        info "aider.el ya existe, actualizando..."
        git -C ~/.emacs.d/site-lisp/aider.el pull
    fi
else
    info "Saltando Aider (no seleccionado)"
fi

# =============================================================================
# 12. N8N — AUTOMATIZACION DE WORKFLOWS (CONDICIONAL)
# =============================================================================
info "[11/11] n8n — Automatizacion de workflows..."
if [ "$PLATFORM" = "termux" ]; then
    info "Saltando n8n (no disponible en Termux)"
elif forja_has_feature "n8n"; then
    if command -v n8n &>/dev/null; then
        info "n8n ya instalado: $(n8n --version 2>/dev/null)"
    else
        info "Instalando n8n via npm..."
        sudo npm install -g n8n

        if command -v n8n &>/dev/null; then
            ok "n8n instalado: $(n8n --version 2>/dev/null)"
        else
            warn "No se pudo instalar n8n (verificar npm)"
        fi
    fi
else
    info "Saltando n8n (no seleccionado)"
fi

# =============================================================================
# AGENTES IA (CONDICIONAL — PicoClaw + OpenClaw)
# =============================================================================
if [ "$PLATFORM" = "arch" ]; then
    # --- PicoClaw ---
    if forja_has_feature "picoclaw"; then
        info "Instalando PicoClaw (agente IA ligero)..."
        PICOCLAW_URL="https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw-linux-amd64"
        if ! command -v picoclaw &>/dev/null; then
            curl -fsSL "$PICOCLAW_URL" -o /tmp/picoclaw \
                && chmod +x /tmp/picoclaw \
                && sudo mv /tmp/picoclaw /usr/local/bin/picoclaw \
                && ok "PicoClaw instalado" \
                || warn "No se pudo instalar PicoClaw"
        else
            ok "PicoClaw ya instalado"
        fi
        mkdir -p ~/.picoclaw/{workspace,memory,skills,cron}
    fi

    # --- OpenClaw ---
    if forja_has_feature "openclaw"; then
        info "Instalando OpenClaw (agente IA completo)..."
        if ! command -v openclaw &>/dev/null; then
            sudo npm install -g openclaw@latest \
                && ok "OpenClaw instalado" \
                || warn "No se pudo instalar OpenClaw"
        else
            ok "OpenClaw ya instalado"
        fi
        mkdir -p ~/.openclaw/{agents/forja,memory,skills}
    fi
fi

# =============================================================================
# UNREAL ENGINE (CONDICIONAL)
# =============================================================================
if [ "$PLATFORM" = "arch" ] && forja_has_feature "unreal"; then
    info "Configurando Unreal Engine..."
    sudo pacman -S --needed --noconfirm \
        cmake extra-cmake-modules clang llvm

    if [ ! -f ~/.bashrc_unreal ]; then
        cat > ~/.bashrc_unreal <<'EOF'
# Unreal Engine
export UE4_DIR="$HOME/UnrealEngine"
export PATH="$UE4_DIR/Engine/Binaries/Linux:$PATH"
EOF
        ok "~/.bashrc_unreal creado"
    fi
    info "Agrega 'source ~/.bashrc_unreal' en tu ~/.bashrc"
fi

# =============================================================================
# CREAR ESTRUCTURA DE DIRECTORIOS
# =============================================================================
info "Creando estructura de directorios..."

mkdir -p ~/org/gtd \
         ~/org/docs/{sops,checklists,templates,kb,exports} \
         ~/org/procesos/diagramas \
         ~/org-alumnos \
         ~/projects

if [ "$PLATFORM" = "termux" ]; then
    if [ ! -d ~/storage ]; then
        info "Configurando acceso a almacenamiento de Android..."
        termux-setup-storage || warn "Ejecuta 'termux-setup-storage' manualmente"
    fi
fi

# Crear directorio de configuracion FORJA si no existe
mkdir -p "$FORJA_CONF_DIR"

# Si no existe profile.conf (modo legacy), crearlo ahora
if [ ! -f "$FORJA_CONF_FILE" ]; then
    cat > "$FORJA_CONF_FILE" << EOF
# FORJA -- Configuracion generada por install.sh (modo legacy)
FORJA_PLATFORM="$PLATFORM"
FORJA_PROFILE="$PERFIL"
FORJA_FEATURES="$FORJA_FEATURES"
FORJA_MODEL_CODE="${FORJA_MODEL_CODE:-qwen2.5-coder:0.5b}"
FORJA_MODEL_CHAT="${FORJA_MODEL_CHAT:-qwen2.5:0.5b}"
FORJA_CONFIG_DATE="$(date '+%Y-%m-%d')"
FORJA_CONFIG_VERSION="2"
EOF
    ok "profile.conf generado en $FORJA_CONF_FILE"
fi

ok "Directorios creados"

# =============================================================================
# STOW — aplicar dotfiles
# =============================================================================
if [ -d "$DOTFILES_DIR/emacs" ] || [ -d "$DOTFILES_DIR/shell" ]; then
    info "Aplicando configuracion con GNU Stow desde $DOTFILES_DIR..."

    cd "$DOTFILES_DIR"

    if [ -d emacs ]; then
        if [ -d ~/.emacs.d ] && [ ! -L ~/.emacs.d ]; then
            warn "~/.emacs.d existe y no es un symlink. Renombrando a ~/.emacs.d.bak..."
            mv ~/.emacs.d ~/.emacs.d.bak
        fi
        stow -v -t ~ emacs
        ok "emacs stowed"
    fi

    if [ -d shell ]; then
        stow -v -t ~ shell
        ok "shell stowed"
    fi

    if [ "$PLATFORM" = "termux" ] && [ -f termux/.termux/termux.properties ]; then
        mkdir -p ~/.termux
        cp -v termux/.termux/termux.properties ~/.termux/termux.properties
        ok "termux.properties copiado"
    fi
fi

# =============================================================================
# BOOTSTRAP DE PAQUETES EMACS
# =============================================================================
info "Pre-instalando todos los paquetes de Emacs en modo batch..."

EMACS_BOOTSTRAP_EL="$TMPDIR/emacs-bootstrap.el"
cat > "$EMACS_BOOTSTRAP_EL" << 'ELISP'
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)
(package-refresh-contents)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Lista completa de paquetes a garantizar
(defvar my/bootstrap-packages
  '(exec-path-from-shell
    doom-themes doom-modeline all-the-icons
    multiple-cursors paredit
    company company-box
    flycheck lsp-mode lsp-ui dap-mode
    yasnippet yasnippet-snippets
    gcmh midnight dashboard envrc minuet
    which-key ivy all-the-icons-ivy-rich ivy-rich
    counsel swiper avy ivy-prescient prescient
    treemacs treemacs-projectile treemacs-magit treemacs-all-the-icons
    projectile counsel-projectile
    compat seq transient magit diff-hl
    vterm multi-term
    prettier-js web-mode emmet-mode nodejs-repl
    rainbow-mode rainbow-delimiters
    cmake-mode cmake-font-lock clang-format
    rust-mode cargo flycheck-rust
    gptel hydra calfw calfw-org
    org-roam ob-mermaid org-kanban
    gdscript-mode
    php-mode
    org-bullets toc-org
    markdown-mode))

;; Paquetes solo para desktop nativo (no Termux ni WSL)
(unless (or (getenv "TERMUX_VERSION")
            (and (getenv "HOME")
                 (string-prefix-p "/data/data/com.termux" (getenv "HOME")))
            (and (file-readable-p "/proc/version")
                 (with-temp-buffer
                   (insert-file-contents "/proc/version")
                   (string-match-p "microsoft\\|WSL" (buffer-string)))))
  (setq my/bootstrap-packages
        (append my/bootstrap-packages
                '(nasm-mode disaster pdf-tools))))

(dolist (pkg my/bootstrap-packages)
  (unless (package-installed-p pkg)
    (condition-case err
        (package-install pkg)
      (error (message "WARNING: no se pudo instalar %s: %s" pkg err)))))

(message "Bootstrap completo. Paquetes instalados: %d"
         (length (seq-filter #'package-installed-p my/bootstrap-packages)))
ELISP

emacs --batch --load "$EMACS_BOOTSTRAP_EL" 2>&1 | tail -5
rm -f "$EMACS_BOOTSTRAP_EL"
ok "Paquetes de Emacs pre-instalados"

# =============================================================================
# CPPMAN (SOLO PC)
# SKIP_CPPMAN=1 cuando es llamado desde update.sh (cppman -c va al final)
# =============================================================================
if [ "$PLATFORM" = "arch" ] && [ -z "$SKIP_CPPMAN" ]; then
    info "Configurando cppman con cppreference..."
    cppman -s cppreference && cppman -c \
        || warn "cppman: revisa manualmente con: cppman -s cppreference && cppman -c"
    ok "cppman configurado"
fi

# =============================================================================
# TERMUX: EXTRA-KEYS Y CONFIGURACION ESPECIFICA
# =============================================================================
if [ "$PLATFORM" = "termux" ]; then
    info "Recargando configuracion de Termux..."
    if command -v termux-reload-settings &>/dev/null; then
        termux-reload-settings
        ok "Termux settings recargadas (cerrar y reabrir Termux para ver extra-keys)"
    fi
fi

# =============================================================================
# VERIFICACION FINAL
# =============================================================================
run_verification "post-install"
