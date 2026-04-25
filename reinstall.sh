#!/bin/bash
# =============================================================================
# reinstall.sh — Reinstalacion limpia de FORJA
# Equivalente a: ./clear.sh && ./update.sh
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/clear.sh" || exit 1
echo ""
bash "$SCRIPT_DIR/update.sh"
