#!/bin/bash
# =============================================================================
# forja-menu.sh — Menu interactivo de instalacion para FORJA
# Autor: Brian Hollweg
# Uso: bash forja-menu.sh
#      (luego install.sh lee ~/.forja/profile.conf automaticamente)
# =============================================================================

# --- Colores y estilos ---
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BG_BLUE='\033[44m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_RED='\033[41m'
BG_MAGENTA='\033[45m'
BG_CYAN='\033[46m'

# --- Directorio de configuracion ---
FORJA_CONF_DIR="$HOME/.forja"
FORJA_CONF_FILE="$FORJA_CONF_DIR/profile.conf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# DETECCION DE HARDWARE
# =============================================================================

detect_platform() {
    if [ -n "$TERMUX_VERSION" ] || [[ "$HOME" == /data/data/com.termux* ]]; then
        PLATFORM="termux"
        PLATFORM_NAME="Termux (Android)"
        PLATFORM_ICON="[Android]"
        TOTAL_RAM_MB=0
    elif grep -qi 'microsoft\|WSL' /proc/version 2>/dev/null; then
        PLATFORM="wsl"
        PLATFORM_NAME="WSL2 (Windows)"
        PLATFORM_ICON="[WSL]"
        TOTAL_RAM_MB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print int($2/1024)}')
    else
        PLATFORM="arch"
        PLATFORM_NAME="Arch Linux"
        PLATFORM_ICON="[PC]"
        TOTAL_RAM_MB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print int($2/1024)}')
    fi
}

detect_ram_info() {
    if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null; then
        TOTAL_RAM_GB=$(echo "scale=1; $TOTAL_RAM_MB / 1024" | bc 2>/dev/null || echo "?")
        if [ "$TOTAL_RAM_MB" -le 4096 ]; then
            RAM_TIER="baja"
            RAM_COLOR="$RED"
            RAM_RECOMENDACION="minimal"
        elif [ "$TOTAL_RAM_MB" -le 8192 ]; then
            RAM_TIER="moderada"
            RAM_COLOR="$YELLOW"
            RAM_RECOMENDACION="moderado"
        elif [ "$TOTAL_RAM_MB" -le 16384 ]; then
            RAM_TIER="buena"
            RAM_COLOR="$GREEN"
            RAM_RECOMENDACION="full"
        else
            RAM_TIER="alta"
            RAM_COLOR="$GREEN"
            RAM_RECOMENDACION="full"
        fi
    else
        TOTAL_RAM_GB="?"
        RAM_TIER="desconocida"
        RAM_COLOR="$DIM"
        RAM_RECOMENDACION="moderado"
    fi
}

# =============================================================================
# UTILIDADES DE DIBUJO
# =============================================================================

clear_screen() { printf '\033[2J\033[H'; }

draw_line() {
    local len="${1:-60}"
    local i
    for ((i=0; i<len; i++)); do printf '-'; done
    echo ""
}

draw_header() {
    local text="$1"
    local step="$2"
    echo ""
    echo -e "  ${BG_BLUE}${WHITE}                                                          ${NC}"
    echo -e "  ${BG_BLUE}${WHITE}  $text$(printf '%*s' $((56 - ${#text})) '')${NC}"
    echo -e "  ${BG_BLUE}${WHITE}                                                          ${NC}"
    echo ""
}

# =============================================================================
# LECTURA DE TECLAS (robusto para flechas)
# =============================================================================

KEY_RESULT=""

read_key() {
    KEY_RESULT=""
    local key=""
    IFS= read -rsn1 key 2>/dev/null

    # Detectar secuencia de escape (flechas, etc.)
    if [[ "$key" == $'\033' ]]; then
        local seq1="" seq2=""
        IFS= read -rsn1 -t 0.1 seq1 2>/dev/null
        IFS= read -rsn1 -t 0.1 seq2 2>/dev/null
        case "${seq1}${seq2}" in
            "[A") KEY_RESULT="UP" ;;
            "[B") KEY_RESULT="DOWN" ;;
            "[C") KEY_RESULT="RIGHT" ;;
            "[D") KEY_RESULT="LEFT" ;;
            *)    KEY_RESULT="ESC" ;;
        esac
        return
    fi

    case "$key" in
        '')  KEY_RESULT="ENTER" ;;
        ' ') KEY_RESULT="SPACE" ;;
        *)   KEY_RESULT="$key" ;;
    esac
}

# =============================================================================
# PANTALLA 1: BIENVENIDA
# =============================================================================

# Muestra el estado actual de la configuración guardada
show_current_config() {
    [ ! -f "$FORJA_CONF_FILE" ] && return

    local saved_profile saved_features saved_platform
    saved_profile=$(grep "^FORJA_PROFILE=" "$FORJA_CONF_FILE"  | cut -d= -f2 | tr -d '"')
    saved_features=$(grep "^FORJA_FEATURES=" "$FORJA_CONF_FILE" | cut -d= -f2 | tr -d '"')
    saved_platform=$(grep "^FORJA_PLATFORM=" "$FORJA_CONF_FILE" | cut -d= -f2 | tr -d '"')

    # Colores por perfil
    local pc
    case "$saved_profile" in
        minimal)  pc="$GREEN" ;;
        moderado) pc="$YELLOW" ;;
        full)     pc="$MAGENTA" ;;
        *)        pc="$WHITE" ;;
    esac

    echo -e "  $(draw_line 56)"
    echo -e "  ${WHITE}Configuracion actual${NC}  ${DIM}(~/.forja/profile.conf)${NC}"
    echo ""
    echo -e "  Plataforma : ${WHITE}${saved_platform:-?}${NC}"
    echo -e "  Perfil     : ${pc}${saved_profile:-?}${NC}"
    echo ""

    # Features activos en esta plataforma vs. no disponibles
    local available_features=()
    local blocked_features=()

    IFS=',' read -ra FEAT_LIST <<< "$saved_features"
    for f in "${FEAT_LIST[@]}"; do
        local blocked=0
        # Features que no corren en Termux
        if [ "$PLATFORM" = "termux" ]; then
            case "$f" in
                unreal|n8n|picoclaw|openclaw|aider) blocked=1 ;;
            esac
        fi
        if [ "$blocked" -eq 1 ]; then
            blocked_features+=("$f")
        else
            available_features+=("$f")
        fi
    done

    if [ ${#available_features[@]} -gt 0 ]; then
        echo -e "  ${GREEN}Activos en ${PLATFORM}:${NC}"
        local line="    "
        for f in "${available_features[@]}"; do
            line+="${f}  "
            if [ ${#line} -gt 54 ]; then
                echo -e "$line"
                line="    "
            fi
        done
        [ ${#line} -gt 4 ] && echo -e "$line"
        echo ""
    fi

    if [ ${#blocked_features[@]} -gt 0 ]; then
        echo -e "  ${DIM}No disponibles en ${PLATFORM}:${NC}"
        echo -e "    ${DIM}$(IFS=','; echo "${blocked_features[*]}")${NC}"
        echo ""
    fi
}

screen_welcome() {
    clear_screen
    echo ""
    echo -e "  ${WHITE}  _____  ___  ____     _  _  ${NC}"
    echo -e "  ${WHITE} |  ___||   ||  _ \\   | |/ \\ ${NC}"
    echo -e "  ${WHITE} | |_   | | || |_) |  | |   |${NC}"
    echo -e "  ${WHITE} |  _|  | | ||    / __|   |  |${NC}"
    echo -e "  ${WHITE} | |    | |_|| |\\ \\|__| |  | |${NC}"
    echo -e "  ${WHITE} |_|    |___||_| \\_\\  |_/\\_/ ${NC}"
    echo ""
    echo -e "  ${CYAN}Entorno de Desarrollo Educativo Portable${NC}"
    echo ""
    echo -e "  $(draw_line 56)"
    echo ""
    echo -e "  ${PLATFORM_ICON}  Plataforma:  ${WHITE}${PLATFORM_NAME}${NC}"
    if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null; then
        echo -e "  [RAM]        Memoria:     ${RAM_COLOR}${TOTAL_RAM_GB} GB${NC} (${RAM_TIER})"
    fi
    echo ""

    # Mostrar config actual si existe
    if [ -f "$FORJA_CONF_FILE" ]; then
        show_current_config
        echo -e "  ${DIM}[Enter] Reconfigurar   [v] Ver y salir   [q] Salir${NC}"
        echo ""
        echo -ne "  > "
        read -r key
        case "$key" in
            q|Q) exit 0 ;;
            v|V)
                echo ""
                echo -e "  ${DIM}--- $FORJA_CONF_FILE ---${NC}"
                grep -v "^#" "$FORJA_CONF_FILE" | grep -v "^$" | while read -r line; do
                    echo -e "    ${CYAN}$line${NC}"
                done
                echo ""
                echo -ne "  Presiona Enter para salir..."
                read -r
                exit 0
                ;;
        esac
    else
        echo -e "  Este asistente configura que componentes instalar"
        echo -e "  segun tu hardware y necesidades."
        echo ""
        echo -e "  La configuracion se guardara en:"
        echo -e "  ${DIM}~/.forja/profile.conf${NC}"
        echo ""
        echo -e "  $(draw_line 56)"
        echo ""
        echo -ne "  Presiona ${WHITE}[Enter]${NC} para comenzar o ${WHITE}[q]${NC} para salir: "
        read -r key
        [ "$key" = "q" ] && exit 0
    fi
}

# =============================================================================
# PANTALLA 2: SELECTOR DE PERFIL
# =============================================================================

screen_profile() {
    # En Termux solo existe Minimal: Ollama/ESP32/Unreal/n8n no corren en ARM Android
    if [ "$PLATFORM" = "termux" ]; then
        PERFIL="minimal"
        clear_screen
        draw_header "PERFIL -- Termux (Android)"
        echo -e "  Plataforma movil detectada."
        echo ""
        echo -e "  Perfil: ${BG_GREEN}${WHITE}  MINIMAL  ${NC}  (unico disponible en Termux)"
        echo ""
        echo -e "  ${DIM}Incluye: Emacs, LSPs, C/Rust/Go/Python/PHP/JS,${NC}"
        echo -e "  ${DIM}         Git, GTD, Sync Drive, Multiusuario.${NC}"
        echo ""
        echo -e "  ${DIM}No disponible en Android ARM:${NC}"
        echo -e "  ${DIM}  x Ollama / Aider / agentes IA${NC}"
        echo -e "  ${DIM}  x ESP32 (toolchain Xtensa requiere x86)${NC}"
        echo -e "  ${DIM}  x Unreal Engine / n8n / FASM${NC}"
        echo ""
        echo -e "  $(draw_line 56)"
        echo ""
        echo -ne "  Presiona ${WHITE}[Enter]${NC} para continuar: "
        read -r
        return 0
    fi

    local selected=0
    local options=3

    # Pre-seleccionar segun RAM detectada
    case "$RAM_RECOMENDACION" in
        minimal)  selected=0 ;;
        moderado) selected=1 ;;
        full)     selected=2 ;;
    esac

    while true; do
        clear_screen
        draw_header "PASO 1/4 -- Elige tu perfil de instalacion"

        if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null; then
            echo -e "  ${DIM}Recomendado para tu hardware (${TOTAL_RAM_GB} GB RAM):${NC} ${WHITE}${RAM_RECOMENDACION^^}${NC}"
            echo ""
        fi

        # --- Opcion 1: Minimal ---
        if [ $selected -eq 0 ]; then
            echo -e "  ${BG_GREEN}${WHITE}  > 1. MINIMAL -- Celular / Tablet                       ${NC}"
        else
            echo -e "    ${DIM}1.${NC} MINIMAL -- Celular / Tablet"
        fi
        echo ""
        echo -e "       ${DIM}RAM: < 4 GB  |  Plataforma: Termux (Android)${NC}"
        echo -e "       ${GREEN}+${NC} Editor + autocompletado + Git"
        echo -e "       ${GREEN}+${NC} C, Rust, Go, Python, PHP, JS/HTML"
        echo -e "       ${GREEN}+${NC} GTD + Multiusuario + Sync Drive"
        echo -e "       ${RED}x${NC} Sin IA local | Sin Game Dev | Sin GDB"
        echo ""

        # --- Opcion 2: Moderado ---
        if [ $selected -eq 1 ]; then
            echo -e "  ${BG_YELLOW}${WHITE}  > 2. MODERADO -- PC / Notebook (RAM limitada)           ${NC}"
        else
            echo -e "    ${DIM}2.${NC} MODERADO -- PC / Notebook (RAM limitada)"
        fi
        echo ""
        echo -e "       ${DIM}RAM: 4-8 GB  |  Plataforma: Arch Linux / WSL2${NC}"
        echo -e "       ${GREEN}+${NC} Todo de Minimal +"
        echo -e "       ${GREEN}+${NC} IA local (Aider + Ollama)"
        echo -e "       ${GREEN}+${NC} GDB Debugger + Game Dev (Raylib, Godot)"
        echo -e "       ${GREEN}+${NC} n8n + LaTeX + ESP32"
        echo -e "       ${RED}x${NC} Sin agentes IA | Sin Unreal"
        echo ""

        # --- Opcion 3: Full ---
        if [ $selected -eq 2 ]; then
            echo -e "  ${BG_MAGENTA}${WHITE}  > 3. FULL -- Desktop / Estacion de trabajo              ${NC}"
        else
            echo -e "    ${DIM}3.${NC} FULL -- Desktop / Estacion de trabajo"
        fi
        echo ""
        echo -e "       ${DIM}RAM: 16+ GB  |  Plataforma: Arch Linux${NC}"
        echo -e "       ${GREEN}+${NC} Todo de Moderado +"
        echo -e "       ${GREEN}+${NC} Modelos IA grandes (mas precisos)"
        echo -e "       ${GREEN}+${NC} Agentes autonomos (PicoClaw + OpenClaw)"
        echo -e "       ${GREEN}+${NC} Unreal Engine + FASM (Assembly)"
        echo ""

        echo -e "  $(draw_line 56)"
        echo ""
        echo -e "  ${DIM}Controles: [1/2/3] Elegir  [j/k] Navegar  [Enter] Confirmar  [q] Salir${NC}"

        # --- Leer tecla ---
        read_key
        case "$KEY_RESULT" in
            UP|k)    selected=$(( (selected - 1 + options) % options )) ;;
            DOWN|j)  selected=$(( (selected + 1) % options )) ;;
            1) selected=0 ;;
            2) selected=1 ;;
            3) selected=2 ;;
            ENTER)
                case $selected in
                    0) PERFIL="minimal" ;;
                    1) PERFIL="moderado" ;;
                    2) PERFIL="full" ;;
                esac
                return 0
                ;;
            q) exit 0 ;;
        esac
    done
}

# =============================================================================
# PANTALLA 3: FEATURES OPCIONALES
# =============================================================================

screen_features() {
    # Definir features disponibles segun perfil y plataforma
    case "$PERFIL" in
        minimal)
            FEATURE_NAMES=("sync-drive" "multiusuario")
            FEATURE_DESC=(
                "Sincronizacion Google Drive (rclone)"
                "Sistema multiusuario (alumnos)"
            )
            FEATURE_RAM=(50 50)
            FEATURE_DEFAULTS=(1 1)
            ;;
        moderado)
            # ESP32 disponible en arch y wsl, no en termux
            FEATURE_NAMES=("aider" "godot" "raylib" "n8n" "latex" "esp32" "sync-drive" "multiusuario")
            FEATURE_DESC=(
                "Aider -- Asistente IA de codigo (Ollama)"
                "Godot + GDScript (game dev 2D/3D)"
                "Raylib (game dev C/C++)"
                "n8n -- Automatizacion de workflows"
                "LaTeX -- Exportar documentos a PDF"
                "ESP32 -- Microcontroladores (ESP-IDF)"
                "Sincronizacion Google Drive (rclone)"
                "Sistema multiusuario (alumnos)"
            )
            FEATURE_RAM=(800 100 50 300 100 50 50 50)
            FEATURE_DEFAULTS=(1 1 1 1 1 0 1 1)
            ;;
        full)
            FEATURE_NAMES=("aider" "godot" "raylib" "unreal" "n8n" "picoclaw" "openclaw" "latex" "esp32" "fasm" "sync-drive" "multiusuario")
            FEATURE_DESC=(
                "Aider -- Asistente IA de codigo (Ollama)"
                "Godot + GDScript (game dev 2D/3D)"
                "Raylib (game dev C/C++)"
                "Unreal Engine (C++, requiere mucha RAM)"
                "n8n -- Automatizacion de workflows"
                "PicoClaw -- Agente IA ligero (~20MB RAM)"
                "OpenClaw -- Agente IA completo (~1.5GB RAM)"
                "LaTeX -- Exportar documentos a PDF"
                "ESP32 -- Microcontroladores (ESP-IDF)"
                "FASM -- Assembly x86 nativo"
                "Sincronizacion Google Drive (rclone)"
                "Sistema multiusuario (alumnos)"
            )
            FEATURE_RAM=(800 100 50 2000 300 20 1500 100 50 10 50 50)
            FEATURE_DEFAULTS=(1 1 1 0 1 1 1 1 1 1 1 1)
            ;;
    esac

    local count=${#FEATURE_NAMES[@]}
    local selected=0

    # Copiar defaults al estado actual
    FEATURE_STATE=("${FEATURE_DEFAULTS[@]}")

    while true; do
        clear_screen
        draw_header "PASO 2/4 -- Componentes opcionales"

        echo -e "  Perfil: ${WHITE}${PERFIL^^}${NC}  |  Plataforma: ${WHITE}${PLATFORM_NAME}${NC}"
        echo ""
        echo -e "  ${DIM}Usa [Espacio] para marcar/desmarcar cada componente:${NC}"
        echo ""

        for i in $(seq 0 $((count - 1))); do
            local checkbox
            if [ "${FEATURE_STATE[$i]}" -eq 1 ]; then
                checkbox="${GREEN}[X]${NC}"
            else
                checkbox="${RED}[ ]${NC}"
            fi

            if [ $i -eq $selected ]; then
                echo -e "  ${WHITE}>${NC} $checkbox ${WHITE}${FEATURE_DESC[$i]}${NC}"
            else
                echo -e "    $checkbox ${FEATURE_DESC[$i]}"
            fi
        done

        echo ""
        echo -e "  $(draw_line 56)"

        # Calcular RAM estimada
        local ram_est=200  # Base Emacs + LSPs
        for i in $(seq 0 $((count - 1))); do
            if [ "${FEATURE_STATE[$i]}" -eq 1 ]; then
                ram_est=$((ram_est + FEATURE_RAM[$i]))
            fi
        done
        # Sumar RAM del modelo seleccionado (aun no elegido, estimar)
        local ram_est_gb
        ram_est_gb=$(echo "scale=1; $ram_est / 1024" | bc 2>/dev/null || echo "?")

        echo ""
        echo -ne "  RAM estimada (sin modelos IA): "
        if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null && [ "$ram_est" -gt "$TOTAL_RAM_MB" ]; then
            echo -e "${RED}~${ram_est_gb} GB${NC}  ${RED}(EXCEDE tus ${TOTAL_RAM_GB} GB)${NC}"
        elif [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null && [ "$ram_est" -gt $((TOTAL_RAM_MB * 80 / 100)) ]; then
            echo -e "${YELLOW}~${ram_est_gb} GB${NC}  ${YELLOW}(ajustado para ${TOTAL_RAM_GB} GB)${NC}"
        else
            echo -e "${GREEN}~${ram_est_gb} GB${NC}"
        fi

        echo ""
        echo -e "  ${DIM}[j/k] Navegar  [Espacio] Marcar  [Enter] Continuar  [q] Salir${NC}"

        # --- Leer tecla ---
        read_key
        case "$KEY_RESULT" in
            UP|k)    selected=$(( (selected - 1 + count) % count )) ;;
            DOWN|j)  selected=$(( (selected + 1) % count )) ;;
            SPACE)
                if [ "${FEATURE_STATE[$selected]}" -eq 1 ]; then
                    FEATURE_STATE[$selected]=0
                else
                    FEATURE_STATE[$selected]=1
                fi
                ;;
            ENTER) return 0 ;;
            q) exit 0 ;;
        esac
    done
}

# =============================================================================
# PANTALLA 4: SELECCION DE MODELOS IA
# =============================================================================

# Variables globales para modelos seleccionados
MODEL_CODE=""
MODEL_CHAT=""

screen_models() {
    # Ollama no corre en Android ARM — saltar siempre en Termux
    if [ "$PLATFORM" = "termux" ] || [ "$PERFIL" = "minimal" ]; then
        MODEL_CODE="ninguno"
        MODEL_CHAT="ninguno"
        return 0
    fi

    # Verificar si aider esta habilitado
    local has_ia=false
    for i in $(seq 0 $((${#FEATURE_NAMES[@]} - 1))); do
        if [[ "${FEATURE_NAMES[$i]}" == "aider" ]] && [ "${FEATURE_STATE[$i]}" -eq 1 ]; then
            has_ia=true
        fi
    done

    if [ "$has_ia" = false ]; then
        MODEL_CODE="ninguno"
        MODEL_CHAT="ninguno"
        return 0
    fi

    # =================================================================
    # MODELOS PARA CODIGO
    # Criterio: entrenados especificamente para programacion,
    # autocompletado (FIM), code review y generacion de codigo.
    # =================================================================
    local CODE_MODELS=()
    local CODE_LABELS=()
    local CODE_RAM=()

    # --- Siempre disponibles (< 4 GB RAM) ---
    CODE_MODELS+=("qwen2.5-coder:0.5b")
    CODE_LABELS+=("qwen2.5-coder:0.5b     Minimo, rapido          ~400 MB")
    CODE_RAM+=(400)

    CODE_MODELS+=("qwen2.5-coder:1.5b")
    CODE_LABELS+=("qwen2.5-coder:1.5b     Ligero, buen balance    ~1 GB")
    CODE_RAM+=(1000)

    # --- 6+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 6144 ]; then
        CODE_MODELS+=("qwen2.5-coder:3b")
        CODE_LABELS+=("qwen2.5-coder:3b       Bueno para code review  ~2 GB")
        CODE_RAM+=(2000)

        CODE_MODELS+=("deepseek-coder-v2:lite")
        CODE_LABELS+=("deepseek-coder-v2:lite Muy bueno, 16B MoE      ~3 GB")
        CODE_RAM+=(3000)
    fi

    # --- 10+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 10240 ]; then
        CODE_MODELS+=("qwen2.5-coder:7b")
        CODE_LABELS+=("qwen2.5-coder:7b       Preciso, recomendado    ~5 GB")
        CODE_RAM+=(5000)

        CODE_MODELS+=("codellama:7b")
        CODE_LABELS+=("codellama:7b           Meta, bueno para C/C++  ~4 GB")
        CODE_RAM+=(4000)
    fi

    # --- 16+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 16384 ]; then
        CODE_MODELS+=("qwen2.5-coder:14b")
        CODE_LABELS+=("qwen2.5-coder:14b      Avanzado, muy preciso   ~9 GB")
        CODE_RAM+=(9000)

        CODE_MODELS+=("codellama:13b")
        CODE_LABELS+=("codellama:13b          Meta, fuerte en C/Rust  ~8 GB")
        CODE_RAM+=(8000)
    fi

    # --- 32+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 32768 ]; then
        CODE_MODELS+=("qwen2.5-coder:32b")
        CODE_LABELS+=("qwen2.5-coder:32b      El mejor, pesado        ~20 GB")
        CODE_RAM+=(20000)

        CODE_MODELS+=("codellama:34b")
        CODE_LABELS+=("codellama:34b          Meta, casi nivel GPT-4  ~20 GB")
        CODE_RAM+=(20000)
    fi

    # =================================================================
    # MODELOS PARA ESPANOL / CHAT
    # Criterio: buen manejo de espanol, instrucciones, traduccion,
    # redaccion, GTD, documentacion y soporte tecnico.
    # =================================================================
    local CHAT_MODELS=()
    local CHAT_LABELS=()
    local CHAT_RAM=()

    # --- Siempre disponibles (< 4 GB RAM) ---
    CHAT_MODELS+=("qwen2.5:0.5b")
    CHAT_LABELS+=("qwen2.5:0.5b            Minimo, espanol basico  ~400 MB")
    CHAT_RAM+=(400)

    CHAT_MODELS+=("qwen2.5:1.5b")
    CHAT_LABELS+=("qwen2.5:1.5b            Ligero, buen espanol    ~1 GB")
    CHAT_RAM+=(1000)

    CHAT_MODELS+=("gemma3:1b")
    CHAT_LABELS+=("gemma3:1b               Google, multilingue     ~800 MB")
    CHAT_RAM+=(800)

    # --- 6+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 6144 ]; then
        CHAT_MODELS+=("qwen2.5:3b")
        CHAT_LABELS+=("qwen2.5:3b              Bueno para traduccion   ~2 GB")
        CHAT_RAM+=(2000)

        CHAT_MODELS+=("gemma3:4b")
        CHAT_LABELS+=("gemma3:4b               Google, buen espanol    ~3 GB")
        CHAT_RAM+=(3000)

        CHAT_MODELS+=("llama3.2:3b")
        CHAT_LABELS+=("llama3.2:3b             Meta, rapido y capaz    ~2 GB")
        CHAT_RAM+=(2000)

        CHAT_MODELS+=("mistral:7b")
        CHAT_LABELS+=("mistral:7b              Frances/Espanol, fluido ~4 GB")
        CHAT_RAM+=(4000)
    fi

    # --- 10+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 10240 ]; then
        CHAT_MODELS+=("qwen2.5:7b")
        CHAT_LABELS+=("qwen2.5:7b              Preciso, recomendado    ~5 GB")
        CHAT_RAM+=(5000)

        CHAT_MODELS+=("llama3.1:8b")
        CHAT_LABELS+=("llama3.1:8b             Meta, muy buen espanol  ~5 GB")
        CHAT_RAM+=(5000)

        CHAT_MODELS+=("gemma3:12b")
        CHAT_LABELS+=("gemma3:12b              Google, excelente       ~8 GB")
        CHAT_RAM+=(8000)
    fi

    # --- 16+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 16384 ]; then
        CHAT_MODELS+=("qwen2.5:14b")
        CHAT_LABELS+=("qwen2.5:14b             Avanzado, traduce bien  ~9 GB")
        CHAT_RAM+=(9000)
    fi

    # --- 32+ GB RAM ---
    if [ "$TOTAL_RAM_MB" -eq 0 ] || [ "$TOTAL_RAM_MB" -ge 32768 ]; then
        CHAT_MODELS+=("qwen2.5:32b")
        CHAT_LABELS+=("qwen2.5:32b             El mejor, excelente     ~20 GB")
        CHAT_RAM+=(20000)

        CHAT_MODELS+=("llama3.1:70b")
        CHAT_LABELS+=("llama3.1:70b            Meta, nivel GPT-4       ~40 GB")
        CHAT_RAM+=(40000)
    fi

    local code_count=${#CODE_MODELS[@]}
    local chat_count=${#CHAT_MODELS[@]}
    local total_items=$((code_count + chat_count))

    # Seleccion inicial: el modelo mas grande que quepa
    local code_sel=0
    local chat_sel=0

    # Pre-seleccionar modelo recomendado segun perfil
    if [ "$PERFIL" = "full" ]; then
        # Full: pre-seleccionar qwen2.5-coder:7b y qwen2.5:7b
        for i in $(seq 0 $((code_count - 1))); do
            [[ "${CODE_MODELS[$i]}" == "qwen2.5-coder:7b" ]] && code_sel=$i
        done
        for i in $(seq 0 $((chat_count - 1))); do
            [[ "${CHAT_MODELS[$i]}" == "qwen2.5:7b" ]] && chat_sel=$i
        done
    elif [ "$PERFIL" = "moderado" ]; then
        # Moderado: pre-seleccionar 1.5b (mejor balance para poca RAM)
        for i in $(seq 0 $((code_count - 1))); do
            [[ "${CODE_MODELS[$i]}" == "qwen2.5-coder:1.5b" ]] && code_sel=$i
        done
        for i in $(seq 0 $((chat_count - 1))); do
            [[ "${CHAT_MODELS[$i]}" == "qwen2.5:1.5b" ]] && chat_sel=$i
        done
    fi

    local cursor=0  # Posicion global del cursor (0..total_items-1)
    cursor=$code_sel

    while true; do
        clear_screen
        draw_header "PASO 3/4 -- Modelos de IA (Ollama local)"

        echo -e "  Los modelos corren ${WHITE}100% local${NC} en tu maquina."
        echo -e "  Nada se envia a la nube. Tu codigo es privado."
        echo ""
        if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null; then
            echo -e "  Tu hardware: ${RAM_COLOR}${TOTAL_RAM_GB} GB RAM${NC}"
            echo -e "  ${DIM}(solo se muestran modelos compatibles con tu RAM)${NC}"
            echo ""
        fi

        # --- Seccion: Modelo para CODIGO ---
        echo -e "  ${WHITE}MODELO PARA CODIGO${NC}"
        echo -e "  ${DIM}(Aider, autocompletado, code review, agentes)${NC}"
        echo ""

        for i in $(seq 0 $((code_count - 1))); do
            local radio
            if [ $i -eq $code_sel ]; then
                radio="${GREEN}(*)${NC}"
            else
                radio="${DIM}( )${NC}"
            fi

            if [ $cursor -eq $i ]; then
                echo -e "  ${WHITE}>${NC} $radio ${WHITE}${CODE_LABELS[$i]}${NC}"
            else
                echo -e "    $radio ${CODE_LABELS[$i]}"
            fi
        done

        echo ""

        # --- Seccion: Modelo para ESPANOL ---
        echo -e "  ${WHITE}MODELO PARA ESPANOL${NC}"
        echo -e "  ${DIM}(Traduccion, GTD, soporte, documentacion)${NC}"
        echo ""

        for i in $(seq 0 $((chat_count - 1))); do
            local radio
            if [ $i -eq $chat_sel ]; then
                radio="${GREEN}(*)${NC}"
            else
                radio="${DIM}( )${NC}"
            fi

            local global_pos=$((code_count + i))
            if [ $cursor -eq $global_pos ]; then
                echo -e "  ${WHITE}>${NC} $radio ${WHITE}${CHAT_LABELS[$i]}${NC}"
            else
                echo -e "    $radio ${CHAT_LABELS[$i]}"
            fi
        done

        echo ""
        echo -e "  $(draw_line 56)"

        # RAM estimada de los modelos
        local model_ram=$(( CODE_RAM[$code_sel] + CHAT_RAM[$chat_sel] ))
        # Si ambos modelos son iguales, no duplicar RAM
        if [ "${CODE_MODELS[$code_sel]}" = "${CHAT_MODELS[$chat_sel]}" ]; then
            model_ram=${CODE_RAM[$code_sel]}
        fi
        local model_ram_gb
        model_ram_gb=$(echo "scale=1; $model_ram / 1024" | bc 2>/dev/null || echo "?")

        echo ""
        echo -ne "  RAM para modelos IA: "
        if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null && [ "$model_ram" -gt "$((TOTAL_RAM_MB * 70 / 100))" ]; then
            echo -e "${RED}~${model_ram_gb} GB${NC}  ${RED}(puede ser lento en tu hardware)${NC}"
        else
            echo -e "${GREEN}~${model_ram_gb} GB${NC}"
        fi
        echo -e "  ${DIM}(los modelos se cargan bajo demanda, no permanecen en RAM)${NC}"

        echo ""
        echo -e "  ${DIM}[j/k] Navegar  [Espacio] Seleccionar  [c] Continuar  [q] Salir${NC}"

        # --- Leer tecla ---
        read_key
        case "$KEY_RESULT" in
            UP|k)    cursor=$(( (cursor - 1 + total_items) % total_items )) ;;
            DOWN|j)  cursor=$(( (cursor + 1) % total_items )) ;;
            SPACE)
                if [ $cursor -lt $code_count ]; then
                    code_sel=$cursor
                else
                    chat_sel=$((cursor - code_count))
                fi
                ;;
            ENTER)
                # Si el cursor esta sobre un item, seleccionarlo
                if [ $cursor -lt $code_count ]; then
                    if [ $cursor -eq $code_sel ]; then
                        # Ya seleccionado, continuar
                        MODEL_CODE="${CODE_MODELS[$code_sel]}"
                        MODEL_CHAT="${CHAT_MODELS[$chat_sel]}"
                        return 0
                    fi
                    code_sel=$cursor
                else
                    local ci=$((cursor - code_count))
                    if [ $ci -eq $chat_sel ]; then
                        # Ya seleccionado, continuar
                        MODEL_CODE="${CODE_MODELS[$code_sel]}"
                        MODEL_CHAT="${CHAT_MODELS[$chat_sel]}"
                        return 0
                    fi
                    chat_sel=$ci
                fi
                ;;
            c)
                # C = confirmar y continuar
                MODEL_CODE="${CODE_MODELS[$code_sel]}"
                MODEL_CHAT="${CHAT_MODELS[$chat_sel]}"
                return 0
                ;;
            q) exit 0 ;;
        esac
    done
}

# =============================================================================
# PANTALLA 5: CONFIRMACION
# =============================================================================

screen_confirm() {
    local count=${#FEATURE_NAMES[@]}

    clear_screen
    draw_header "PASO 4/4 -- Confirmar instalacion"

    echo -e "  ${WHITE}Plataforma:${NC}  $PLATFORM_ICON $PLATFORM_NAME"
    echo -e "  ${WHITE}Perfil:${NC}      ${PERFIL^^}"
    if [ "$TOTAL_RAM_MB" -gt 0 ] 2>/dev/null; then
        echo -e "  ${WHITE}RAM:${NC}         ${TOTAL_RAM_GB} GB"
    fi
    echo ""

    echo -e "  $(draw_line 56)"
    echo ""
    echo -e "  ${WHITE}Componentes base (siempre incluidos):${NC}"
    echo ""
    echo -e "    ${GREEN}+${NC} Emacs 29+ con configuracion modular"
    echo -e "    ${GREEN}+${NC} C/C++ (clang, gcc) + autocompletado LSP"
    [ "$PLATFORM" != "termux" ] && echo -e "    ${GREEN}+${NC} GDB Debugger"
    echo -e "    ${GREEN}+${NC} Rust (rust-analyzer, cargo)"
    echo -e "    ${GREEN}+${NC} Go (gopls)"
    echo -e "    ${GREEN}+${NC} Python (pylsp, black)"
    echo -e "    ${GREEN}+${NC} PHP (intelephense)"
    echo -e "    ${GREEN}+${NC} JavaScript / HTML / CSS (Live Server)"
    echo -e "    ${GREEN}+${NC} Git visual (Magit, Treemacs, Projectile)"
    echo -e "    ${GREEN}+${NC} GTD + Org-Mode (agenda, notas)"
    echo ""

    echo -e "  $(draw_line 56)"
    echo ""
    echo -e "  ${WHITE}Componentes opcionales:${NC}"
    echo ""

    local enabled_features=()

    for i in $(seq 0 $((count - 1))); do
        if [ "${FEATURE_STATE[$i]}" -eq 1 ]; then
            echo -e "    ${GREEN}+${NC} ${FEATURE_DESC[$i]}"
            enabled_features+=("${FEATURE_NAMES[$i]}")
        else
            echo -e "    ${RED}x${NC} ${DIM}${FEATURE_DESC[$i]}${NC}"
        fi
    done

    # Mostrar modelos si aplica
    if [ "$MODEL_CODE" != "ninguno" ]; then
        echo ""
        echo -e "  $(draw_line 56)"
        echo ""
        echo -e "  ${WHITE}Modelos de IA:${NC}"
        echo ""
        echo -e "    ${GREEN}+${NC} Codigo:  ${WHITE}${MODEL_CODE}${NC}"
        echo -e "    ${GREEN}+${NC} Espanol: ${WHITE}${MODEL_CHAT}${NC}"
    fi

    echo ""
    echo -e "  $(draw_line 56)"
    echo ""
    echo -ne "  Guardar configuracion?  [${GREEN}s${NC}] Si  [${RED}n${NC}] Volver  [${DIM}q${NC}] Salir: "
    read -rsn1 key
    echo ""

    case "$key" in
        s|S|'')
            ENABLED_FEATURES_STR=$(IFS=,; echo "${enabled_features[*]}")
            save_config "$ENABLED_FEATURES_STR"
            return 0
            ;;
        n|N)
            return 1
            ;;
        q)
            exit 0
            ;;
    esac
    return 1
}

# =============================================================================
# GUARDAR CONFIGURACION
# =============================================================================

save_config() {
    local features="$1"
    mkdir -p "$FORJA_CONF_DIR"

    cat > "$FORJA_CONF_FILE" << EOF
# =============================================================================
# FORJA -- Configuracion de instalacion
# Generado por forja-menu.sh el $(date '+%Y-%m-%d %H:%M:%S')
# Este archivo es leido por install.sh y update.sh automaticamente.
# Para reconfigurar: bash forja-menu.sh
# =============================================================================

# Plataforma detectada
FORJA_PLATFORM="$PLATFORM"

# Perfil elegido: minimal | moderado | full
FORJA_PROFILE="$PERFIL"

# Componentes opcionales habilitados (separados por coma)
FORJA_FEATURES="$features"

# Modelos de IA (Ollama)
# Modelo para programacion (Aider, autocompletado, code review, agentes)
FORJA_MODEL_CODE="$MODEL_CODE"
# Modelo para espanol (traduccion, GTD, soporte, documentacion)
FORJA_MODEL_CHAT="$MODEL_CHAT"

# Fecha de configuracion
FORJA_CONFIG_DATE="$(date '+%Y-%m-%d')"

# Version del configurador
FORJA_CONFIG_VERSION="2"
EOF

    echo ""
    echo -e "  ${GREEN}[OK]${NC} Configuracion guardada en:"
    echo -e "       ${WHITE}$FORJA_CONF_FILE${NC}"
}

# =============================================================================
# PANTALLA FINAL
# =============================================================================

screen_done() {
    echo ""
    echo -e "  $(draw_line 56)"
    echo ""
    echo -e "  ${GREEN}Configuracion completa.${NC}"
    echo ""
    echo -e "  Para instalar, ejecuta:"
    echo ""
    echo -e "    ${WHITE}bash install.sh${NC}"
    echo ""
    echo -e "  El instalador leera tu perfil (${WHITE}${PERFIL^^}${NC})"
    echo -e "  y los componentes que elegiste."
    echo ""
    echo -e "  Para reconfigurar en el futuro:"
    echo ""
    echo -e "    ${WHITE}bash forja-menu.sh${NC}"
    echo ""
    echo -e "  $(draw_line 56)"
    echo ""
    echo -e "  ${DIM}Contenido de $FORJA_CONF_FILE:${NC}"
    echo ""
    grep -v "^#" "$FORJA_CONF_FILE" | grep -v "^$" | while read -r line; do
        echo -e "    ${CYAN}$line${NC}"
    done
    echo ""
}

# =============================================================================
# FUNCION AUXILIAR: verificar si un feature esta habilitado
# Para usar desde install.sh / update.sh:
#   source forja-menu.sh
#   if forja_has_feature "aider"; then ... fi
# =============================================================================

forja_has_feature() {
    local feature="$1"
    if [ -f "$FORJA_CONF_FILE" ]; then
        source "$FORJA_CONF_FILE"
        echo ",$FORJA_FEATURES," | grep -q ",$feature,"
        return $?
    fi
    return 1
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    # Verificar que estamos en una terminal interactiva
    if [ ! -t 0 ]; then
        echo "Error: Este script requiere una terminal interactiva."
        exit 1
    fi

    detect_platform
    detect_ram_info

    # Pantalla 1: Bienvenida
    screen_welcome

    # Pantalla 2: Perfil
    screen_profile

    # Pantallas 3-5 con posibilidad de volver
    while true; do
        screen_features
        screen_models
        if screen_confirm; then
            break
        fi
    done

    # Pantalla final
    screen_done
}

# Solo ejecutar main si el script no esta siendo sourceado
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi
