#!/bin/bash
# =============================================================================
# install.sh — Instalador de dependencias para Emacs Modular Config
# Autor: Brian Hollweg
# Soporta: Arch Linux (PC), Termux (Android) y WSL2 (Windows)
# Uso: bash install.sh [--perfil casa|escuela|minimal]
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

# --- Perfil (default: escuela) ---
PERFIL="escuela"
while [[ $# -gt 0 ]]; do
    case $1 in
        --perfil) PERFIL="$2"; shift 2 ;;
        casa|escuela|minimal) PERFIL="$1"; shift ;;
        *) shift ;;
    esac
done

echo ""
echo "=============================================="
echo "  Emacs Modular Config — Instalador"
echo "  Plataforma: $PLATFORM"
echo "  Perfil: $PERFIL"
echo "=============================================="
echo ""

# =============================================================================
# 1. ACTUALIZAR SISTEMA
# =============================================================================
info "Actualizando el sistema..."
if [ "$PLATFORM" = "termux" ]; then
    # Primero actualizar repositorios y resolver dependencias rotas
    apt update -y
    apt upgrade -y -o Dpkg::Options::="--force-confnew" || true
    # Reparar dependencias si quedan rotas (ej: ncurses/openssl version mismatch)
    apt --fix-broken install -y 2>/dev/null || true
    pkg upgrade -y
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
else
    sudo pacman -Syu --noconfirm
fi

# =============================================================================
# 2. SISTEMA BASE Y COMPILACION
# =============================================================================
info "[1/10] Sistema base y compilacion..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y git build-essential ripgrep fd unzip cmake ninja stow rsync tree-sitter
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y \
        software-properties-common apt-transport-https ca-certificates gnupg \
        git build-essential ripgrep fd-find unzip cmake ninja-build stow rsync curl wget \
        libtree-sitter-dev tree-sitter-cli
    
    # Prevenir conflicto en WSL con fdfind (muchos paquetes Emacs buscan la palabra literal 'fd')
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
else
    sudo pacman -S --needed --noconfirm \
        git base-devel ripgrep fd unzip cmake ninja astyle stow rsync tree-sitter tree-sitter-cli
fi

# =============================================================================
# 3. EMACS Y FUENTES
# =============================================================================
info "[2/10] Emacs y fuentes..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y emacs
    ok "Emacs instalado (Termux — sin fuentes GUI)"
elif [ "$PLATFORM" = "wsl" ]; then
    # WSL: instalar Emacs (Ubuntu puede traer 27, verificar si hay PPA para 29+)
    if ! command -v emacs &>/dev/null || [[ "$(emacs --version 2>/dev/null | head -1 | grep -oP '\d+')" -lt 29 ]]; then
        info "Agregando PPA para Emacs 29+..."
        sudo add-apt-repository -y ppa:ubuntuhandbook1/emacs 2>/dev/null \
            || warn "No se pudo agregar PPA, instalando Emacs del repo default"
        sudo apt-get update -y
    fi
    sudo apt-get install -y emacs
    ok "Emacs instalado (WSL — sin fuentes GUI)"
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
info "[3/10] Toolchain C/C++..."
if [ "$PLATFORM" = "termux" ]; then
    # Termux: clang viene con build-essential, sin GDB nativo ni FASM (x86)
    pkg install -y clang
    ok "Clang instalado (sin GDB/FASM en Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y clang llvm gdb
    ok "Clang + GDB instalados (WSL)"
else
    sudo pacman -S --needed --noconfirm \
        clang llvm lldb gdb benchmark fasm binutils
    ok "Toolchain C/C++ completo"
fi

# =============================================================================
# 5. LENGUAJES Y RUNTIMES
# =============================================================================
info "[4/10] Lenguajes: Rust, Go, Node.js..."

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
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y python3 python3-pip python3-venv
else
    sudo pacman -S --needed --noconfirm python python-pip python-black
fi
pip install --user --break-system-packages \
    python-lsp-server pylsp-mypy python-lsp-black 2>/dev/null \
    || pip install --user python-lsp-server pylsp-mypy python-lsp-black 2>/dev/null \
    || pip3 install --user python-lsp-server pylsp-mypy python-lsp-black 2>/dev/null \
    || warn "No se pudieron instalar pip packages (pylsp)"
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

# rclone (sincronizacion con Google Drive)
info "Instalando rclone (sincronizacion Google Drive)..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y rclone
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y rclone
else
    sudo pacman -S --needed --noconfirm rclone
fi
ok "rclone instalado"

# =============================================================================
# 6. GAME DEV Y MULTIMEDIA (SOLO PC)
# =============================================================================
info "[5/10] Game Dev..."
if [ "$PLATFORM" = "termux" ] || [ "$PLATFORM" = "wsl" ]; then
    info "Saltando Game Dev (no disponible en $PLATFORM)"
else
    sudo pacman -S --needed --noconfirm \
        raylib \
        sdl2 sdl2_image sdl2_mixer sdl2_ttf \
        godot \
        zathura zathura-pdf-mupdf

    # gdtoolkit: formatter/linter para GDScript
    pip install --user --break-system-packages gdtoolkit
    ok "Godot + gdtoolkit instalados"
fi

# =============================================================================
# 7. IA Y TERMINAL (SOLO PC — Ollama/Alacritty)
# =============================================================================
info "[6/10] IA y terminal..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y direnv
    info "Saltando Ollama y Alacritty (no disponibles en Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y direnv
    info "Saltando Ollama y Alacritty (no disponibles en WSL)"
else
    sudo pacman -S --needed --noconfirm alacritty ollama direnv

    # Bajar modelo de codigo para Aider/gptel
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

        info "Descargando modelo qwen2.5-coder:0.5b (liviano)..."
        ollama pull qwen2.5-coder:0.5b || warn "No se pudo descargar el modelo"

        if [ "$PERFIL" = "casa" ]; then
            info "Descargando modelo qwen2.5-coder:7b (casa)..."
            ollama pull qwen2.5-coder:7b || warn "Fallo al descargar 7b"
        fi
    fi
fi

# =============================================================================
# 8. PAQUETES ESPECIFICOS DE PLATAFORMA (AUR / Termux extras)
# =============================================================================
info "[7/10] Paquetes especificos de plataforma..."
if [ "$PLATFORM" = "termux" ]; then
    # Vterm requiere libvterm en Termux
    pkg install -y libvterm termux-api
    ok "libvterm y termux-api instalados"
elif [ "$PLATFORM" = "wsl" ]; then
    # WSL: libvterm para vterm, sin AUR
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
    yay -S --needed --noconfirm vterm-git cppman-git esp-idf
    ok "Paquetes AUR instalados"
fi

# =============================================================================
# 9. HERRAMIENTAS DE DOCUMENTACION (modulos 50-53)
# =============================================================================
info "[8/10] Herramientas para modulos GTD y Asistencia Operativa..."
if [ "$PLATFORM" = "termux" ]; then
    pkg install -y graphviz gnuplot libsqlite
    ok "Herramientas de documentacion (Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo apt-get install -y graphviz gnuplot sqlite3 libsqlite3-dev
    ok "Herramientas de documentacion (WSL)"
else
    # Diagramas
    sudo pacman -S --needed --noconfirm graphviz gnuplot

    # LaTeX
    sudo pacman -S --needed --noconfirm \
        texlive-basic texlive-latexrecommended \
        texlive-fontsrecommended texlive-langspanish

    # Diagnostico de redes
    sudo pacman -S --needed --noconfirm traceroute bind-tools

    # org-roam requiere sqlite
    sudo pacman -S --needed --noconfirm sqlite

    # man-pages para cppman
    sudo pacman -S --needed --noconfirm man-pages

    ok "Dependencias de documentacion instaladas"
fi

# =============================================================================
# 10. LSPs Y HERRAMIENTAS NPM GLOBALES
# =============================================================================
info "[9/10] LSPs web y herramientas npm globales..."
if [ "$PLATFORM" = "termux" ]; then
    npm install -g \
        typescript \
        typescript-language-server \
        vscode-langservers-extracted \
        live-server \
        prettier \
        intelephense \
        @prettier/plugin-php
    ok "LSPs web + PHP instalados (Termux)"
elif [ "$PLATFORM" = "wsl" ]; then
    sudo npm install -g \
        typescript \
        typescript-language-server \
        vscode-langservers-extracted \
        live-server \
        prettier \
        intelephense \
        @prettier/plugin-php
    ok "LSPs web + PHP instalados (WSL)"
else
    sudo npm install -g \
        typescript \
        typescript-language-server \
        vscode-langservers-extracted \
        live-server \
        prettier \
        intelephense \
        @prettier/plugin-php

    # mermaid-cli necesita Chromium
    sudo pacman -S --needed --noconfirm chromium
    sudo PUPPETEER_SKIP_DOWNLOAD=true npm install -g @mermaid-js/mermaid-cli

    MMDC_DIR=$(npm root -g)/@mermaid-js/mermaid-cli
    if [ -d "$MMDC_DIR" ]; then
        sudo tee "$MMDC_DIR/.puppeteerrc.cjs" > /dev/null <<'EOF'
const { join } = require('path');
module.exports = {
    executablePath: '/usr/bin/chromium',
};
EOF
        ok "mermaid-cli configurado con chromium del sistema"
    else
        warn "Directorio de mermaid-cli no encontrado"
    fi

    ok "LSPs web instalados"
fi

# =============================================================================
# 11. AIDER (SOLO PC)
# =============================================================================
info "[10/10] Aider — Code Agent local..."
if [ "$PLATFORM" = "termux" ] || [ "$PLATFORM" = "wsl" ]; then
    info "Saltando Aider (requiere Ollama, no disponible en $PLATFORM)"
else
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
fi

# =============================================================================
# PERFIL CASA: Unreal Engine tools (SOLO PC)
# =============================================================================
if [ "$PERFIL" = "casa" ] && [ "$PLATFORM" = "arch" ]; then
    echo ""
    info "Perfil CASA: configurando herramientas adicionales..."

    sudo pacman -S --needed --noconfirm \
        cmake extra-cmake-modules \
        clang llvm

    if [ ! -f ~/.bashrc_unreal ]; then
        cat > ~/.bashrc_unreal <<'EOF'
# Unreal Engine
export UE4_DIR="$HOME/UnrealEngine"
export PATH="$UE4_DIR/Engine/Binaries/Linux:$PATH"
EOF
        ok "~/.bashrc_unreal creado"
    fi

    info "Recorda agregar 'source ~/.bashrc_unreal' en tu ~/.bashrc"
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
    # Asegurar acceso a storage compartido de Android
    if [ ! -d ~/storage ]; then
        info "Configurando acceso a almacenamiento de Android..."
        termux-setup-storage || warn "Ejecuta 'termux-setup-storage' manualmente"
    fi
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

    # Copiar config de Termux directamente (no stow — Termux no sigue symlinks)
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
# =============================================================================
if [ "$PLATFORM" = "arch" ]; then
    info "Configurando cppman con cppreference..."
    cppman -s cppreference && cppman -c \
        || warn "cppman: revisa manualmente con: cppman -s cppreference && cppman -c"
    ok "cppman configurado"
fi

# =============================================================================
# TERMUX: EXTRA-KEYS Y CONFIGURACION ESPECIFICA
# =============================================================================
if [ "$PLATFORM" = "termux" ]; then
    info "Recargando configuración de Termux..."
    # Recargar config de Termux (extra-keys ya copiadas en la sección STOW)
    if command -v termux-reload-settings &>/dev/null; then
        termux-reload-settings
        ok "Termux settings recargadas (cerrar y reabrir Termux para ver extra-keys)"
    fi
fi

# =============================================================================
# RESUMEN FINAL
# =============================================================================
echo ""
echo "=============================================="
echo -e "${GREEN}  Instalacion completa${NC}"
echo "  Plataforma: $PLATFORM | Perfil: $PERFIL"
echo "=============================================="
echo ""
echo "  Proximos pasos:"

if [ "$PLATFORM" = "termux" ]; then
    echo "  1. Abri Emacs: emacs"
    echo "  2. El sistema multiusuario pedira seleccionar alumno"
    echo "  3. Espera que instale paquetes de MELPA (~2 min)"
    echo "  4. Usa las extra-keys del teclado para F5, F7, F12"
    echo ""
    echo "  Sincronizacion Google Drive (C-c U):"
    echo "    D = Configurar rclone (primera vez)"
    echo "    s = Subir datos a Drive | S = Descargar desde Drive"
    echo "    u = Backup a USB | c = Cambiar alumno"
elif [ "$PLATFORM" = "wsl" ]; then
    echo "  1. Abri Emacs: emacs"
    echo "  2. El sistema multiusuario pedira seleccionar alumno"
    echo "  3. Espera que instale paquetes de MELPA (~2 min)"
    echo ""
    echo "  Sincronizacion Google Drive (C-c U):"
    echo "    D = Configurar rclone (primera vez)"
    echo "    s = Subir datos a Drive | S = Descargar desde Drive"
    echo "    c = Cambiar alumno | t = Estado"
else
    echo "  1. Abri Emacs: emacs"
    echo "  2. Al iniciar, el sistema multiusuario pedira seleccionar alumno"
    echo "     (o detectara un USB con datos automaticamente)"
    echo "  3. Espera que instale los paquetes de MELPA (~2 min)"
    echo "  4. Ejecuta en Emacs:"
    echo "       M-x all-the-icons-install-fonts"
    echo "       M-x nerd-icons-install-fonts"
    echo ""
    echo "  Sistema multiusuario (C-c U):"
    echo "    u = Backup a USB | e = Exportar .tar.gz"
    echo "    s = Sync a Drive | S = Sync desde Drive"
    echo "    D = Configurar Drive | c = Cambiar alumno"
    if [ "$PERFIL" = "casa" ]; then
        echo ""
        echo "  5. Ajusta UE4_DIR en ~/.bashrc_unreal"
    fi
fi

echo ""
echo "  Happy Hacking!"
echo ""
