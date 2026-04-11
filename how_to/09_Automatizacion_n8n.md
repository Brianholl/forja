# Guia 09: Automatizacion de Workflows con n8n

> Transforma tareas repetitivas en automatizaciones visuales. Conecta Telegram, email, webhooks y tu sistema GTD sin escribir codigo.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Iniciar y detener n8n desde FORJA
- Crear tu primer workflow (webhook que genera un ticket de soporte)
- Conectar n8n con tu sistema GTD para automatizar tareas mecanicas
- Entender como se respaldan y portan los workflows entre dispositivos

## Prerequisitos

- Haber completado la [Guia 07: Multiusuario y Sync](07_Multiusuario_y_Sync.md) (entender el sistema de alumnos)
- Haber completado la [Guia 08: Productividad y Org](08_Productividad_y_Org.md) (entender GTD y SOPs)
- Estar en **PC (Arch Linux) o WSL2**. n8n no esta disponible en Termux
- Node.js instalado (ya incluido en FORJA)

---

## 1. Que es n8n

n8n es una herramienta visual para automatizar tareas. Funciona en el navegador y te permite conectar servicios (Telegram, email, Google Calendar, webhooks, archivos locales) arrastrando y conectando nodos, sin escribir codigo.

Pensalo como un "Si pasa X, entonces hace Y" configurable por vos.

### Ejemplos de lo que podes automatizar

| Trigger (cuando pasa esto) | Accion (hace esto) |
| :--- | :--- |
| Alguien envia un formulario web | Se crea un ticket en tu inbox GTD |
| Es viernes a las 17:00 | Se envia por Telegram un resumen de tareas pendientes |
| Llega un email con "urgente" | Se agrega como TODO prioritario en tu agenda |
| Alguien escribe al bot de Telegram | Se captura el mensaje en `inbox.org` |

## 2. Como funciona n8n en FORJA

### Aislamiento por alumno

Cada alumno tiene su **propia instancia de n8n**. Tus workflows, credenciales (tokens de Telegram, contraseñas de email) y datos se guardan en tu carpeta personal:

```
~/org-alumnos/garcia-juan/.n8n/    ← Tus datos de n8n (privados)
~/org-alumnos/garcia-juan/gtd/     ← Tus archivos GTD
~/org-alumnos/garcia-juan/docs/    ← Tus documentos
```

Esto significa que:
- **Ningun otro alumno puede ver tus credenciales ni workflows**
- Tus datos de n8n se respaldan junto con todo lo demas (USB y Google Drive)
- Al cambiar de alumno (`C-c U c`), n8n se reinicia con los datos del nuevo alumno

### Controles desde FORJA (`C-c U N`)

Presiona `C-c U` para abrir el menu multiusuario, luego `N` para el submenu de n8n:

| Tecla | Accion | Descripcion |
| :---: | :--- | :--- |
| `C-c U N s` | **Iniciar** | Arranca n8n con datos del alumno activo |
| `C-c U N x` | **Detener** | Para n8n |
| `C-c U N o` | **Abrir** | Abre n8n en el navegador |
| `C-c U N t` | **Estado** | Muestra si n8n esta corriendo y en que puerto |

## 3. Primer Acceso a n8n

### Paso 1: Iniciar n8n

Presiona `C-c U N s`. Espera unos segundos hasta que el servidor arranque.

### Paso 2: Abrir en el navegador

Presiona `C-c U N o`. Se abre el navegador en `http://localhost:5678`.

### Paso 3: Crear cuenta local

La primera vez, n8n te pide crear una cuenta. Esta cuenta es **local** — queda guardada en tu carpeta `.n8n/` y es solo tuya. No necesitas verificar email.

### Paso 4: Explorar el editor

Una vez dentro, veras el editor visual de workflows con un canvas vacio. Aqui es donde creas tus automatizaciones.

## 4. Tu Primer Workflow: Webhook a Soporte

Este ejemplo crea un endpoint web que recibe reportes de problemas y los agrega automaticamente a tu archivo `soporte.org`.

### Paso 1: Crear el workflow

1. En n8n, haz clic en "Add workflow" o "New workflow"
2. Ponle nombre: "Reportes de soporte"

### Paso 2: Agregar el trigger (Webhook)

1. Haz clic en el nodo "+" para agregar un trigger
2. Busca y selecciona **Webhook**
3. Configura:
   - Metodo: `POST`
   - Path: `/reporte`

### Paso 3: Agregar la accion (Execute Command)

1. Haz clic en "+" despues del webhook
2. Busca y selecciona **Execute Command**
3. En el campo "Command", escribe:
   ```bash
   echo "* INBOX [#B] {{ $json.titulo }}" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":PROPERTIES:" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":CREATED: $(date +'[%Y-%m-%d %a %H:%M]')" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":REPORTADO: {{ $json.quien }}" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":END:" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   ```
   (Reemplaza `TU-NOMBRE` por tu carpeta de alumno)

### Paso 4: Conectar y activar

1. Conecta los nodos (deberian estar conectados automaticamente)
2. Activa el workflow con el switch en la esquina superior derecha
3. Guarda

### Paso 5: Probar

Abre una terminal y ejecuta:
```bash
curl -X POST http://localhost:5678/webhook/reporte \
  -H "Content-Type: application/json" \
  -d '{"titulo": "No anda la impresora", "quien": "Prof. Martinez"}'
```

Ahora abre tu archivo `soporte.org` en FORJA — deberas ver el nuevo ticket como INBOX.

## 5. Mas Ideas de Workflows

| Workflow | Que automatiza | Nodos necesarios |
| :--- | :--- | :--- |
| **Resumen diario GTD** | Lee `inbox.org` y envia por Telegram las tareas pendientes | Schedule + Read File + Telegram |
| **Recordatorio de deadlines** | Revisa `calendario.org` y avisa por email si hay compromisos mañana | Schedule + Read File + Gmail |
| **Captura desde Telegram** | Un bot que recibe mensajes y los agrega a `inbox.org` | Telegram Trigger + Execute Command |
| **Sync Google Calendar** | Lee eventos de Google Calendar y los escribe en `calendario.org` | Schedule + Google Calendar + Execute Command |
| **Formulario web de soporte** | Recibe datos de un formulario HTML y crea tickets | Webhook + Execute Command |
| **Monitor de habitos** | Revisa `habitos.org` y envia recordatorio si no completaste la rutina | Schedule + Read File + Telegram |

### Ejemplo rapido: Bot de Telegram para capturar tareas

1. Crea un bot de Telegram hablando con @BotFather
2. En n8n, crea un workflow con trigger **Telegram**
3. Configura el token del bot
4. Agrega un nodo **Execute Command**:
   ```bash
   echo "* TODO {{ $json.message.text }}" >> ~/org-alumnos/TU-NOMBRE/gtd/inbox.org
   ```
5. Activa el workflow
6. Ahora cuando le escribas al bot "Comprar materiales para el proyecto", se agrega como TODO en tu inbox

## 6. Conexion con GTD (Modulo 50)

n8n no reemplaza tu sistema GTD: lo **potencia**. La captura, el procesamiento y la priorizacion siguen siendo decisiones tuyas en Emacs. Lo que n8n automatiza son las tareas mecanicas.

### Antes y despues

| Tarea | Sin n8n (manual) | Con n8n (automatizado) |
| :--- | :--- | :--- |
| Recibir reporte de soporte | Alguien te dice → abris Emacs → `C-c c s` → llenas el ticket | Alguien llena un formulario → n8n crea el ticket → vos solo lo procesas |
| Recordatorio de deadline | Tenes que acordarte de revisar la agenda | n8n te manda un mensaje por Telegram la noche anterior |
| Capturar idea mientras caminas | La olvidas o la anotas en el celular | Le escribis al bot de Telegram → aparece en tu inbox |

## 7. Conexion con SOPs (Modulo 51)

Si documentaste un procedimiento en `51-estandarizacion`, preguntate: "Puedo automatizar algun paso de esto?". Si la respuesta es si, n8n es la herramienta.

**Ejemplo:** Tu SOP dice "Cada viernes, revisar tickets abiertos y enviar resumen al coordinador". Con n8n:
- Un nodo Schedule se activa cada viernes a las 16:00
- Un nodo Read File lee los tickets abiertos de `soporte.org`
- Un nodo Gmail envia el resumen automaticamente

Vos solo supervisas que el resumen sea correcto.

## 8. Respaldo y Portabilidad

Tus workflows viajan con vos — estan incluidos en todos los mecanismos de backup:

| Metodo | Incluye n8n? | Comando |
| :--- | :---: | :--- |
| Sync a Google Drive | Si | `C-c U s` |
| Backup a USB | Si | `C-c U u` |
| Exportar .tar.gz | Si | `C-c U e` |

Al restaurar en otra PC, tus workflows y credenciales se recuperan automaticamente.

## 9. Seguridad

- n8n corre en `localhost` — solo es accesible desde tu maquina
- Cada alumno tiene su propia carpeta `.n8n/` aislada
- Las credenciales (tokens, API keys) se encriptan localmente dentro de `.n8n/`
- **Nunca compartas tu carpeta `.n8n/` con otros alumnos**

---

## Ejercicio Practico: Automatizar un Recordatorio

Crea un workflow que ejecute un comando todos los dias a las 8:00 AM:

1. **Inicia n8n:** `C-c U N s`
2. **Abre el editor:** `C-c U N o`
3. **Crea un workflow nuevo** llamado "Recordatorio diario"
4. **Agrega un trigger Schedule:**
   - Trigger every: Day
   - Hour: 8
   - Minute: 0
5. **Agrega un nodo Execute Command:**
   ```bash
   echo "=== Tareas pendientes para hoy ===" && \
   grep -h "TODO" ~/org-alumnos/TU-NOMBRE/gtd/inbox.org 2>/dev/null | head -10
   ```
6. **Activa el workflow**
7. **Prueba manualmente** haciendo clic en "Execute Workflow" para ver la salida

> **Bonus:** Agrega un nodo de Telegram o email despues del Execute Command para recibir el recordatorio en tu celular.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| n8n no arranca | Puerto 5678 ocupado | Verifica con `lsof -i :5678`. Detiene el proceso anterior con `C-c U N x` |
| "Cannot connect to n8n" en el navegador | n8n aun no termino de arrancar | Espera 10-15 segundos e intenta de nuevo |
| El webhook no recibe datos | El workflow no esta activado | Verifica que el switch en la esquina superior derecha este en ON |
| "Permission denied" al escribir archivos | Ruta incorrecta o permisos | Verifica que la ruta en el comando apunte a tu carpeta de alumno |
| Los datos de n8n desaparecieron | Se cambio de alumno | Los datos son por alumno. Cambia de vuelta con `C-c U c` |
| El bot de Telegram no responde | Token incorrecto o webhook no configurado | Verifica el token en n8n y que el workflow este activo |

## Resumen de Atajos de esta Guia

```
C-c U N s    → Iniciar n8n (datos del alumno activo)
C-c U N x    → Detener n8n
C-c U N o    → Abrir n8n en el navegador
C-c U N t    → Ver estado de n8n
C-c U s      → Sync a Drive (incluye datos de n8n)
C-c U u      → Backup a USB (incluye datos de n8n)
```

---

**Anterior:** [Guia 08: Productividad y Org](08_Productividad_y_Org.md) | **Siguiente:** [Guia 10: Depuracion y Diagnostico](10_Depuracion_y_Diagnostico.md) | [Volver al README](../README.md)
