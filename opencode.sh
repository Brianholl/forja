#!/bin/bash
# opencode.sh — Lanzar OpenCode en el proyecto actual o en el path indicado
# Uso: ./opencode.sh [path/al/proyecto]

PROJECT="${1:-$PWD}"

if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
    if ! command -v proot-distro &>/dev/null; then
        echo "Error: proot-distro no instalado. Corré: pkg install proot-distro"
        exit 1
    fi
    exec proot-distro login ubuntu -- sh -c "cd '$PROJECT' && opencode"
else
    if ! command -v opencode &>/dev/null; then
        echo "Error: opencode no instalado. Corré: npm install -g opencode-ai"
        exit 1
    fi
    cd "$PROJECT" && exec opencode
fi
