# Guia 09: Automatizacion de Workflows (n8n)

FORJA no solo te enseña a organizar tareas (GTD) y documentar procesos (SOPs): te permite **automatizarlos**. El modulo n8n transforma los flujos que diseñaste en papel o en diagramas Mermaid en automatizaciones reales que corren en tu maquina, sin depender de servicios en la nube ni pagar suscripciones.

## Que es n8n

n8n es una herramienta visual de automatizacion de workflows. Funciona en el navegador y te permite conectar servicios (Telegram, email, Google Calendar, webhooks, archivos locales) arrastrando y conectando nodos, sin escribir codigo.

Pensalo como un "Si pasa X, entonces hace Y" configurable por vos.

## Requisitos

- PC con Arch Linux o WSL2 (no disponible en Termux)
- Node.js instalado (ya incluido en FORJA)
- n8n instalado (se instala automaticamente con `install.sh`)

## Como funciona en FORJA

Cada alumno tiene su **propia instancia de n8n**. Tus workflows, credenciales (tokens de Telegram, contraseñas de email) y datos se guardan en tu carpeta personal:

```
~/org-alumnos/garcia-juan/.n8n/    ← Tus datos de n8n (privados)
~/org-alumnos/garcia-juan/gtd/     ← Tus archivos GTD
~/org-alumnos/garcia-juan/docs/    ← Tus documentos
```

Esto significa que:
- **Ningun otro alumno puede ver tus credenciales ni workflows**
- Tus datos de n8n se respaldan junto con todo lo demas (USB y Google Drive)
- Al cambiar de alumno, n8n se reinicia con los datos del nuevo alumno

## Empezando con n8n

### 1. Iniciar n8n desde Emacs

Presiona `C-c U` para abrir el menu multiusuario, luego `N` para el submenu de n8n:

| Tecla | Accion |
| :--- | :--- |
| `C-c U N s` | **Iniciar** n8n (con datos del alumno activo) |
| `C-c U N x` | **Detener** n8n |
| `C-c U N o` | **Abrir** n8n en el navegador |
| `C-c U N t` | Ver **estado** de n8n |

### 2. Primer acceso

Al abrir n8n por primera vez (`C-c U N o`), te pedira crear una cuenta local. Esta cuenta queda guardada en tu carpeta `.n8n/` y es solo tuya.

Una vez dentro, veras el editor visual de workflows con un canvas vacio.

### 3. Tu primer workflow: Webhook a Soporte

Este ejemplo crea un endpoint web que recibe reportes de problemas y los agrega automaticamente a tu archivo `soporte.org`:

1. En n8n, crea un nuevo workflow
2. Agrega un nodo **Webhook** (trigger)
   - Metodo: POST
   - Path: `/reporte`
3. Agrega un nodo **Execute Command** (accion)
   - Comando:
   ```bash
   echo "* INBOX [#B] ${titulo}" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":PROPERTIES:" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":CREATED: $(date +'[%Y-%m-%d %a %H:%M]')" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":REPORTADO: ${quien}" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   echo ":END:" >> ~/org-alumnos/TU-NOMBRE/gtd/soporte.org
   ```
4. Conecta los nodos y activa el workflow

Ahora cualquiera puede enviar un reporte con:
```bash
curl -X POST http://localhost:5678/webhook/reporte \
  -H "Content-Type: application/json" \
  -d '{"titulo": "No anda la impresora", "quien": "Prof. Martinez"}'
```

Y aparece automaticamente en tu archivo de soporte como ticket INBOX.

### 4. Mas ideas de workflows

| Workflow | Que automatiza |
| :--- | :--- |
| **Resumen diario GTD** | Lee `inbox.org` y envia por Telegram las tareas pendientes |
| **Recordatorio de deadlines** | Revisa `calendario.org` y avisa por email si hay compromisos manana |
| **Captura desde Telegram** | Un bot que recibe mensajes y los agrega a `inbox.org` |
| **Sync Google Calendar** | Lee eventos de Google Calendar y los escribe en `calendario.org` |
| **Formulario web de soporte** | Recibe datos de un formulario HTML y crea tickets |
| **Monitor de habitos** | Revisa `habitos.org` y envia recordatorio si no completaste la rutina |

## Conexion con GTD (Modulo 50)

n8n no reemplaza tu sistema GTD: lo **potencia**. La captura, el procesamiento y la priorizacion siguen siendo decisiones tuyas en Emacs. Lo que n8n automatiza son las tareas mecanicas:

- **Antes** (manual): Alguien te dice "la impresora no anda" → abris Emacs → `C-c c s` → llenas el ticket
- **Despues** (n8n): Alguien llena un formulario web → n8n crea el ticket automaticamente → vos solo lo procesas

## Conexion con SOPs (Modulo 51)

Si documentaste un procedimiento en `51-estandarizacion`, podes preguntarte: "¿Puedo automatizar algun paso de esto?". Si la respuesta es si, n8n es la herramienta.

Ejemplo: Tu SOP dice "Cada viernes, revisar tickets abiertos y enviar resumen al coordinador". Con n8n, el resumen se genera y envia solo. Vos solo supervisas.

## Respaldo y portabilidad

Tus workflows viajan con vos:
- `C-c U s` (Sync a Drive) respalda tu carpeta `.n8n/` junto con todo lo demas
- `C-c U u` (Backup a USB) tambien incluye `.n8n/`
- Al restaurar en otra PC, tus workflows y credenciales se recuperan automaticamente

## Seguridad

- n8n corre en `localhost` (solo accesible desde tu maquina)
- Cada alumno tiene su propia carpeta `.n8n/` aislada
- Las credenciales (tokens, API keys) se encriptan localmente dentro de `.n8n/`
- Nunca compartas tu carpeta `.n8n/` con otros alumnos

---
[Volver al README](../README.md)
