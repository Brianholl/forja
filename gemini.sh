#!/bin/bash
# gemini.sh — Lanzar Gemini CLI en el proyecto actual o en el path indicado
# Uso: ./gemini.sh [path/al/proyecto]

PROJECT="${1:-$PWD}"

GEMINI_BIN="$(command -v gemini 2>/dev/null)"

if [ -z "$GEMINI_BIN" ]; then
    echo "Error: gemini no instalado. Corré: npm install -g @google/gemini-cli"
    exit 1
fi

cd "$PROJECT" && exec "$GEMINI_BIN"
