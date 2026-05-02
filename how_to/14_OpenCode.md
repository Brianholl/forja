# Guia 14: OpenCode — Asistente IA en la Nube

> Usa OpenCode para sesiones agenticas completas, consultas inline y procesamiento automatico de archivos — con modelos en la nube via OpenRouter.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Abrir una sesion TUI de OpenCode en tu proyecto
- Hacer consultas inline sobre el archivo que estas editando
- Mandar un archivo completo para que el agente lo analice y proponga cambios
- Entender la diferencia entre OpenCode (nube) y Aider/PicoClaw (local)
- Configurar OpenCode en Linux nativo y en Termux (Android)

## Prerequisitos

- Tener `OPENROUTER_API_KEY` configurada (ejecutar `connect.sh`)
- **Linux nativo / WSL2:** `opencode` instalado (`npm install -g opencode-ai`)
- **Termux:** `proot-distro` instalado con Ubuntu (~500MB)
- Haber activado el modulo en `~/.forja/profile.conf`: `FORJA_FEATURES="...,opencode"`
- Haber completado la [Guia 06: Inteligencia Artificial](06_Inteligencia_Artificial.md)

---

## 1. OpenCode vs Aider vs PicoClaw

| Aspecto | Aider | PicoClaw | OpenCode |
| :--- | :--- | :--- | :--- |
| Donde corre | Nube (OpenRouter/Nemotron) | Local (Ollama) | Nube (OpenRouter) |
| Necesita internet | Si | No | Si |
| Necesita API key | Si (gratis con OpenRouter) | No | Si (gratis con OpenRouter) |
| Modelos disponibles | Nemotron-3-Super-120B | Solo Ollama local | 200+ modelos (GPT-4, Claude, Gemini, etc.) |
| Interface | Emacs buffer | Emacs buffer | TUI independiente |
| Modo agentico | Si | Si | Si |
| Disponible en Termux | No | No | Si (via proot-distro) |
| Privacidad | Codigo va a OpenRouter | 100% local | Datos van al modelo externo |

**Cuando usar OpenCode:**
- Cuando necesitas una sesion interactiva TUI larga con historial visual
- En Termux (tablet/celular) donde Ollama y Aider no estan disponibles
- Para sesiones largas de diseno o arquitectura con modelos distintos a Nemotron
- Cuando necesitas consultas inline rapidas sin abrir el chat de Aider

---

## 2. Activar OpenCode

### Verificar que esta disponible

En Emacs, abre `C-c F` (menu FORJA). Si ves `_A_ Agentes IA`, el modulo esta cargado.

```
FORJA — Centro de Control
──────────────────────────────────────────────────────
_x_  Compilar / Ejecutar   _n_  Nuevo Proyecto
_g_  GTD / Agenda          _S_  Docs / Estandares
_M_  Modelos IA            _U_  Multiusuario
_A_  Agentes IA            _d_  Dashboard
```

Desde ahi: `_A_` → `_c_` abre el menu de OpenCode.

### Habilitar en profile.conf

Si el modulo no esta cargado, agregar al archivo `~/.forja/profile.conf`:

```bash
FORJA_FEATURES="aider,opencode"
```

Reiniciar Emacs. Si el archivo no existe, crearlo:

```bash
mkdir -p ~/.forja
echo 'FORJA_FEATURES="opencode"' > ~/.forja/profile.conf
```

---

## 3. Instalacion

### Linux nativo / WSL2

```bash
npm install -g opencode-ai
opencode --version   # debe mostrar 1.14.31 o mayor
```

Ejecutar `connect.sh` para configurar la API key automaticamente.

### Termux (Android) — Opcion con proot-distro

> Requiere ~500MB de espacio libre.

```bash
# 1. Instalar proot-distro
pkg install proot-distro

# 2. Instalar Ubuntu dentro de Termux
proot-distro install ubuntu

# 3. Entrar a Ubuntu y instalar Node + OpenCode
proot-distro login ubuntu
apt update && apt install -y nodejs npm
npm install -g opencode-ai
opencode --version
exit

# 4. Configurar API key (ejecutar desde Termux, no desde Ubuntu)
./connect.sh
```

---

## 4. Los Tres Flujos de Trabajo

### Flujo 1 — Sesion TUI Completa (`C-c O o`)

Para sesiones largas: diseno de arquitectura, refactoring grande, programacion de principio a fin.

1. Abre un archivo de tu proyecto
2. Presiona `C-c O o`
3. Se abre el TUI de OpenCode en la raiz del proyecto
4. Conversa en lenguaje natural: pedi que cree funciones, refactorice, diagnostique bugs

Para volver a Emacs sin cerrar OpenCode: `C-x o` (cambiar ventana) o `C-c O s` para volver al TUI.

**Ejemplo de sesion:**
```
> Revisa el archivo src/api/routes.js y encontra todos los endpoints que no
  validan los parametros de entrada. Corregalos con zod.
```

### Flujo 2 — Consulta Inline (`C-c O p` y `C-c O r`)

Para preguntas puntuales sin salir del buffer de trabajo.

**Consulta sobre el archivo actual (`C-c O p`):**
1. Estar editando cualquier archivo de codigo
2. Presionar `C-c O p`
3. Escribir la pregunta cuando lo pida: `"Como mejoro el manejo de errores de esta funcion?"`
4. El resultado aparece en un panel inferior (`*opencode-output*`)

**Consulta sobre una region seleccionada (`C-c O r`):**
1. Seleccionar un bloque de codigo con el mouse o `C-SPC`
2. Presionar `C-c O r`
3. Escribir la pregunta: `"Que hace este algoritmo? Hay una forma mas eficiente?"`
4. OpenCode analiza solo el fragmento seleccionado

### Flujo 3 — Procesamiento Agentico (`C-c O f`)

Para delegar el analisis completo de un archivo al agente.

1. Estar en el archivo que queres procesar
2. Presionar `C-c O f`
3. OpenCode analiza bugs, performance, seguridad y propone diffs concretos
4. El resultado aparece en `*opencode-output*`

**Otros comandos agenticos:**

| Atajo | Funcion |
| :--- | :--- |
| `C-c O t` | Generar tests para el archivo actual |
| `C-c O e` | Corregir errores Flycheck detectados |

---

## 5. Menu Completo (`C-c F A c`)

Acceso desde el menu maestro:

```
OPENCODE — Asistente Agentico
Estado TUI: cerrado
─────────────────────────────────────
TUI completo
_o_ Abrir sesion interactiva
_s_ Cambiar al buffer TUI
─────────────────────────────────────
Inline / Chat
_p_ Pregunta sobre archivo actual
_r_ Pregunta sobre region
─────────────────────────────────────
Agentico completo
_f_ Procesar archivo (analisis+diff)
_t_ Generar tests
_e_ Corregir errores Flycheck
─────────────────────────────────────
_q_ Volver
```

---

## 6. Cambiar el Modelo

OpenCode usa `nvidia/nemotron-3-super-120b-a12b:free` por defecto (gratis, sin costo).

Para cambiar a otro modelo, editar `~/.config/opencode/opencode.json` o correr `connect.sh` con el modelo modificado.

Modelos gratuitos disponibles en OpenRouter: https://openrouter.ai/models?q=free

**Ejemplo — cambiar a Google Gemini Flash (gratis):**
```json
"model": "openrouter/google/gemini-flash-1.5"
```

> Nota: Los modelos gratuitos requieren desactivar "Always enforce ZDR" en https://openrouter.ai/settings/privacy

---

## 7. Errores Comunes

| Error | Causa | Solucion |
| :--- | :--- | :--- |
| `No endpoints available matching guardrail restrictions` | Privacy settings de OpenRouter muy restrictivos | Ir a openrouter.ai/settings/privacy y desactivar "Always enforce ZDR" |
| `OpenCode no disponible` | Modulo no activo o binario no encontrado | Verificar `FORJA_FEATURES` en profile.conf y que `opencode` este en el PATH |
| `[MODO EXAMEN] OpenCode deshabilitado` | El modo examen esta activo | Desactivar con `C-c F e` |
| En Termux: `cannot execute: required file not found` | Binario para arquitectura incorrecta | Usar la instalacion via proot-distro (ver seccion 3) |
| Output vacio en `*opencode-output*` | La API key no esta configurada | Correr `connect.sh` |

---

## 8. Ejercicios Practicos

### Ejercicio 1 — Primera consulta inline

1. Abre cualquier archivo `.js`, `.py` o `.c` de un proyecto tuyo
2. Presiona `C-c O p`
3. Pregunta: "Explica que hace este archivo en dos oraciones"
4. Verifica que la respuesta aparece en el panel inferior

### Ejercicio 2 — Analisis agentico

1. Crea un archivo `test_bugs.py` con este contenido:
```python
def dividir(a, b):
    return a / b

def procesar_lista(lista):
    total = 0
    for i in range(len(lista) + 1):
        total += lista[i]
    return total
```
2. Presiona `C-c O f`
3. Verifica que OpenCode identifica el division por cero y el index out of range

### Ejercicio 3 — Sesion TUI completa

1. Abre un proyecto con al menos 3 archivos
2. Presiona `C-c O o`
3. En el TUI, escribe: "Lista los archivos del proyecto y describeme la arquitectura general"
4. Vuelve a Emacs con `C-x o` y continua editando mientras el TUI esta abierto

---

## Siguientes Pasos

- [Guia 06: Inteligencia Artificial (Aider + Minuet)](06_Inteligencia_Artificial.md) — agente de codigo con Nemotron y autocompletado inline con Minuet
- [Guia 12: Agentes Autonomos](12_Agente_Autonomo.md) — PicoClaw y OpenClaw con Ollama local
