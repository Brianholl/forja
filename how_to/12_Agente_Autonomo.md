# Guia 12: Agentes IA Autonomos (PicoClaw y OpenClaw)

> Delega tareas a agentes inteligentes que leen tu codigo, ejecutan comandos y resuelven problemas — el ultimo nivel de automatizacion en FORJA.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Entender la diferencia entre automatizacion determinista (n8n) y agentes autonomos (IA)
- Iniciar y controlar PicoClaw (agente ligero) y OpenClaw (agente completo)
- Pedirle a un agente que diagnostique por que tu proyecto no compila
- Delegar la resolucion de tickets de soporte a un agente supervisado
- Evaluar criticamente las respuestas de un agente IA (aprendizaje por supervision)

## Prerequisitos

- Haber completado las guias [08 (GTD)](08_Productividad_y_Org.md) y [09 (n8n)](09_Automatizacion_n8n.md)
- Estar en **perfil Casa** (Arch Linux, usuario "casa"). No disponible en Escuela, Termux ni WSL
- Tener Ollama corriendo con el modelo `qwen2.5-coder:7b`
- Haber ejecutado `install.sh --perfil casa`

---

## 1. La Progresion: Manual → Automatico → Autonomo

FORJA construye una escalera de automatizacion. Cada nivel agrega inteligencia:

### Nivel 1 — Manual (GTD, Guia 08)

```
Vos capturás la tarea → Vos la procesás → Vos la ejecutás
```

Herramienta: `C-c c` (captura) + `C-c a` (agenda). Todo lo decidis vos.

### Nivel 2 — Semi-automatico (n8n, Guia 09)

```
Evento externo dispara regla → n8n ejecuta accion predefinida
```

Herramienta: n8n. "Si llega un webhook, crea un ticket." Es determinista: siempre hace lo mismo ante el mismo evento. No razona.

### Nivel 3 — Agente supervisado (PicoClaw / OpenClaw, esta guia)

```
Vos tenes un problema → El agente lo analiza y propone solucion → Vos revisas y aprendes
```

Herramientas: PicoClaw u OpenClaw. El agente **razona**: lee archivos, ejecuta comandos, interpreta errores y propone soluciones. Pero vos siempre tenes la ultima palabra.

### El valor pedagogico

El objetivo no es que el agente haga tu trabajo. Es que **observes como un agente razona** sobre un problema y luego evalues si su solucion es correcta. Es aprendizaje por supervision: vos sos el maestro del agente, no al reves.

## 2. Dos Agentes, Dos Filosofias

FORJA incluye dos agentes con perfiles diferentes:

| Aspecto | PicoClaw | OpenClaw |
| :--- | :--- | :--- |
| **Filosofia** | Minimalista, rapido | Completo, ecosistema rico |
| **RAM** | ~20 MB | ~1.5 GB |
| **Instalacion** | Binario unico (Go) | npm global (Node.js) |
| **Skills** | MCP nativo + skills propios | 5,400+ en ClawHub |
| **Web UI** | No | Si (interfaz visual) |
| **Ideal para** | Tareas rapidas, PCs modestas | Tareas complejas, analisis profundo |
| **Madurez** | Experimental (pre-v1.0) | Mas maduro pero inestable |

**Ambos usan Ollama** como cerebro (modelo `qwen2.5-coder:7b`). Tu codigo nunca sale de tu maquina.

### Cuando usar cada uno

| Situacion | Usa |
| :--- | :--- |
| "Por que no compila mi proyecto?" | PicoClaw (rapido, directo) |
| "Haceme un code review completo" | OpenClaw (mas profundo) |
| "Analiza este ticket de soporte" | Cualquiera |
| "Genera tests para esta funcion" | OpenClaw (mejor con tareas largas) |
| PC con 8 GB RAM | Solo PicoClaw |
| PC con 16+ GB RAM | Ambos |

## 3. Acceder a los Agentes

Desde el menu multiusuario:

1. Presiona `C-c U` (menu multiusuario)
2. Presiona `O` (agentes IA)
3. Aparece el submenu:
   ```
   AGENTES IA — Perfil Casa
   ─────────────────────────────────────
    p  PicoClaw (ligero, ~20MB RAM)
    o  OpenClaw (completo, ~1.5GB RAM)
   ```
4. Selecciona uno

## 4. PicoClaw: El Agente Ligero

### Iniciar PicoClaw

1. `C-c U` → `O` → `p` (abre submenu PicoClaw)
2. Presiona `s` (Start)
3. PicoClaw arranca con el workspace del alumno activo:
   ```
   🐾 PicoClaw iniciado (workspace: ~/org-alumnos/garcia-juan/.picoclaw/, puerto: 18790)
   ```

### Menu de PicoClaw

| Tecla | Accion | Descripcion |
| :---: | :--- | :--- |
| `s` | Iniciar | Arranca el gateway de PicoClaw |
| `x` | Detener | Para PicoClaw |
| `t` | Estado | Muestra si esta corriendo y con que modelo |
| `l` | Ver logs | Abre el buffer con la salida de PicoClaw |
| `m` | Enviar tarea | Escribe un mensaje libre para el agente |
| `r` | Resolver ticket | Analiza el ticket Org bajo el cursor |
| `d` | Diagnosticar proyecto | Ejecuta build y analiza errores |
| `v` | Revisar archivo | Hace code review del archivo actual |
| `i` | Instalar skills FORJA | Agrega skills prediseñados |

### Ejemplo: Diagnosticar un proyecto que no compila

1. Abre el archivo principal de tu proyecto (ej: `main.go`)
2. `C-c U` → `O` → `p` → `d` (diagnosticar)
3. PicoClaw:
   - Identifica que es un proyecto Go
   - Ejecuta `go build`
   - Lee la salida de error
   - Te dice exactamente que linea falla y por que
   - Sugiere el fix

**La salida aparece en el buffer `*picoclaw-output*`.** Presiona `l` en el menu para verla.

### Ejemplo: Resolver un ticket de soporte

1. Abre tu archivo `soporte.org`
2. Posiciona el cursor sobre un ticket:
   ```org
   * TODO [#B] El proyecto de Go del alumno Lopez no compila
   :PROPERTIES:
   :CREATED: [2026-04-10 jue 09:15]
   :REPORTADO: Prof. Martinez
   :END:
   Error: undefined variable en handlers.go linea 45
   ```
3. `C-c U` → `O` → `p` → `r` (resolver ticket)
4. PicoClaw lee el ticket, analiza el error mencionado y propone la solucion

### Instalar skills prediseñados

La primera vez, instala los skills de FORJA:

1. `C-c U` → `O` → `p` → `i`
2. Se crean dos skills en tu workspace:
   - **forja-diagnostico**: Diagnostica builds fallidos en cualquier lenguaje
   - **forja-soporte**: Analiza y resuelve tickets de soporte

## 5. OpenClaw: El Agente Completo

### Iniciar OpenClaw

1. `C-c U` → `O` → `o` (abre submenu OpenClaw)
2. Presiona `s` (Start)
3. OpenClaw arranca (tarda unos segundos mas que PicoClaw)

### Menu de OpenClaw

| Tecla | Accion | Descripcion |
| :---: | :--- | :--- |
| `s` | Iniciar | Arranca el gateway de OpenClaw |
| `x` | Detener | Para OpenClaw |
| `w` | Abrir WebUI | Abre la interfaz web en el navegador |
| `l` | Ver logs | Abre el buffer con la salida |
| `t` | Estado | Muestra estado, puerto y modelo |
| `m` | Enviar tarea | Escribe un mensaje libre |
| `r` | Resolver ticket | Analiza ticket Org bajo el cursor |
| `d` | Diagnosticar proyecto | Ejecuta build y analiza errores |
| `v` | Revisar archivo | Code review profundo del archivo |
| `g` | Generar tests | Genera tests para el archivo actual |

### OpenClaw tiene Web UI

A diferencia de PicoClaw, OpenClaw tiene una interfaz web visual:

1. Presiona `w` en el menu de OpenClaw
2. Se abre el navegador en `http://localhost:18789`
3. Podes chatear con el agente visualmente, ver el historial y gestionar skills

### La identidad del agente (SOUL.md)

OpenClaw usa un archivo `SOUL.md` que define la personalidad del agente. FORJA lo configura automaticamente con instrucciones en español:

- Explica cada paso para que el alumno aprenda
- Muestra diffs antes de aplicar cambios
- Nunca borra archivos sin confirmacion
- Prefiere soluciones simples

Podes editar `SOUL.md` en `~/org-alumnos/TU-NOMBRE/.openclaw/agents/forja/SOUL.md` para personalizar el agente.

### Ejemplo: Generar tests automaticos

1. Abre un archivo con funciones (ej: `validador.go`)
2. `C-c U` → `O` → `o` → `g` (generar tests)
3. OpenClaw:
   - Lee todas las funciones del archivo
   - Genera un archivo `validador_test.go` con tests completos
   - Incluye casos limite (strings vacios, numeros negativos, etc.)
   - Muestra el archivo generado en el output

## 6. Aislamiento por Alumno

Cada alumno tiene su propio agente aislado:

```
~/org-alumnos/garcia-juan/
├── .picoclaw/                 ← PicoClaw de este alumno
│   ├── config.json            ← Configuracion (modelo, seguridad)
│   ├── workspace/             ← Sandbox de archivos
│   ├── memory/                ← Memoria persistente (Markdown)
│   ├── skills/                ← Skills personalizados
│   │   ├── forja-diagnostico/ ← Skill: diagnosticar builds
│   │   └── forja-soporte/     ← Skill: resolver tickets
│   └── cron/                  ← Tareas programadas
├── .openclaw/                 ← OpenClaw de este alumno
│   ├── agents/forja/
│   │   ├── SOUL.md            ← Identidad del agente
│   │   └── config.yaml        ← Configuracion del agente
│   ├── memory/                ← Memoria persistente
│   └── skills/                ← Skills del ecosistema
├── .n8n/                      ← n8n de este alumno
├── proyectos/                 ← Codigo
├── gtd/                       ← Tareas
└── docs/                      ← Documentos
```

Los datos de los agentes se respaldan automaticamente con:
- `C-c U s` (sync a Drive)
- `C-c U u` (backup a USB)
- `C-c U e` (exportar .tar.gz)

## 7. Seguridad: Lo que Debes Saber

Los agentes IA pueden ejecutar comandos en tu sistema. Esto es poderoso pero requiere precaucion:

### Reglas de seguridad en FORJA

1. **Todo es local**: Ollama corre en tu maquina, no se envia nada a la nube
2. **Workspace restringido**: PicoClaw tiene `restrict_to_workspace: true` por defecto
3. **Solo perfil Casa**: Los agentes no estan disponibles en PCs compartidas (Escuela)
4. **Revision humana**: Los agentes proponen, vos decidis. Nunca apliques un cambio sin revisarlo
5. **Git como red de seguridad**: Si un agente modifica algo mal, revertis con Magit (`C-x g`)

### Lo que los agentes pueden hacer

- Leer y escribir archivos en el workspace
- Ejecutar comandos de shell (compilar, tests, git)
- Navegar la web (solo OpenClaw)
- Recordar contexto entre sesiones (memoria persistente)

### Lo que NO deberias permitir

- Darle acceso a archivos fuera del workspace del alumno
- Ejecutar agentes en PCs compartidas sin Docker
- Confiar ciegamente en las respuestas — siempre revisa

---

## Ejercicio Practico: Tu Primer Agente Resolviendo un Bug

### Paso 1: Crea un proyecto con un bug intencional

1. `C-c n G` → nombre: `practica-agente`
2. Abre `main.go` y escribe:
   ```go
   package main

   import "fmt"

   func dividir(a, b int) int {
       return a / b
   }

   func main() {
       numeros := []int{10, 5, 0, 8}
       for _, n := range numeros {
           resultado := dividir(100, n)
           fmt.Printf("100 / %d = %d\n", n, resultado)
       }
   }
   ```

Este programa tiene un bug: division por cero cuando `n = 0`.

### Paso 2: Pedi al agente que diagnostique

1. `C-c U` → `O` → `p` (PicoClaw)
2. Asegurate de que esta corriendo (`s` si no lo esta)
3. Presiona `d` (diagnosticar proyecto)
4. Observa la salida: el agente deberia detectar el panic por division por cero

### Paso 3: Pedi al agente que lo resuelva

1. Presiona `m` (enviar tarea)
2. Escribe:
   ```
   El programa hace panic por division por cero. Agrega validacion
   para saltar los divisores que sean 0 y mostrar un mensaje de warning.
   ```
3. Observa la respuesta: el agente propondra un fix

### Paso 4: Evalua la respuesta

Revisa lo que el agente propone:
- Es correcto el fix?
- Maneja bien el caso limite?
- El codigo es legible?
- Lo harias diferente?

**Este es el ejercicio real: no es que el agente resuelva el problema, sino que vos aprendas evaluando su razonamiento.**

### Paso 5: Aplica o descarta

Si la propuesta es buena, aplica los cambios manualmente. Si no, pedile al agente que intente de otra forma o corregilo vos mismo.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| "PicoClaw no encontrado" | No se instalo | Ejecuta `install.sh --perfil casa` |
| "OpenClaw no encontrado" | npm no lo instalo | Ejecuta `sudo npm install -g openclaw` |
| El agente no responde | Ollama no esta corriendo | Ejecuta `ollama serve` en otra terminal |
| Respuestas muy lentas | Modelo 7B en PC con poca RAM | Usa el modelo 0.5b (menos preciso pero rapido) |
| "No hay alumno activo" | Falta seleccionar usuario | `C-c U c` para seleccionar alumno |
| El agente propone cambios incorrectos | Es normal — los LLM no son perfectos | Revisa siempre. Usa Git para revertir si es necesario |
| `C-c U O` dice "no disponible" | No estas en perfil Casa | Estos agentes solo funcionan en el perfil Casa |
| OpenClaw usa mucha RAM | Es esperado (~1.5 GB) | Si tenes poca RAM, usa solo PicoClaw |

## Resumen de Atajos de esta Guia

```
C-c U O      → Menu de agentes IA
C-c U O p    → Submenu PicoClaw
C-c U O o    → Submenu OpenClaw

PicoClaw / OpenClaw (dentro del submenu):
  s          → Iniciar agente
  x          → Detener agente
  t          → Ver estado
  l          → Ver logs
  m          → Enviar tarea libre
  r          → Resolver ticket bajo cursor
  d          → Diagnosticar proyecto actual
  v          → Revisar archivo actual

Solo OpenClaw:
  w          → Abrir interfaz web
  g          → Generar tests para archivo

Solo PicoClaw:
  i          → Instalar skills de FORJA
```

---

**Anterior:** [Guia 11: Soporte y Extras](11_Soporte_y_Extras.md) | [Volver al README](../README.md)
