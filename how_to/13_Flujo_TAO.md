# Guia 13: Flujo del Taller de Asistencia Operativa (TAO)

> Guia docente para gestionar el TAO con FORJA: desde la captura de tickets hasta el cierre semanal, pasando por el seguimiento de alumnos y la sincronizacion con Google Calendar.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Capturar y procesar tickets de soporte desde Emacs
- Dar seguimiento individual a cada alumno del taller
- Ver todos los compromisos del TAO en la agenda y el calendario
- Sincronizar el calendario de Google con Emacs (org-caldav)
- Activar el modo examen para evaluaciones presenciales
- Ejecutar la revision semanal del taller

## Prerequisitos

- Haber completado la [Guia 08: Productividad y GTD](08_Productividad_y_Org.md)
- Haber completado la [Guia 11: Soporte y Extras](11_Soporte_y_Extras.md)
- Tener FORJA instalado con perfil Moderado o Full

---

## 1. El Sistema GTD del TAO

El TAO usa el sistema GTD de FORJA con tres archivos principales:

| Archivo | Proposito | Abrir con |
| :--- | :--- | :--- |
| `soporte.org` | Tickets de soporte de alumnos | `C-c g s` |
| `seguimiento.org` | Progreso individual de cada alumno | `C-c g A` |
| `calendario.org` | Compromisos con fecha fija (clases, entregas) | `C-c g k` |

El dashboard de Emacs muestra el estado del TAO en tiempo real:
- **tickets:** cantidad de tickets abiertos o en trabajo
- **alumnos activos:** alumnos con seguimiento NEXT
- **inbox:** items sin procesar en la bandeja de entrada

---

## 2. Flujo de un Ticket de Soporte

### Capturar un ticket (`C-c c s`)

Cuando un alumno reporta un problema:

1. Presiona `C-c c` para abrir el menu de captura
2. Elige `s` (Soporte)
3. Completa los campos que aparecen:
   - **Titulo del ticket:** descripcion breve del problema
   - **Quien reporta:** nombre del alumno
   - **PC/Equipo afectado:** maquina o usuario
   - **Prioridad:** Baja / Media / Alta / Critica
   - **SLA en horas:** tiempo de respuesta comprometido (24 / 8 / 4 / 1)
4. Escribe la descripcion del problema en la seccion `Descripcion`
5. `C-c C-c` para guardar

El ticket queda en `soporte.org` con estado **INBOX**.

### Procesar un ticket

En el dashboard de soporte (`C-c g d` → seleccionar vista `s`):

| Estado | Significado | Como avanzar |
| :---: | :--- | :--- |
| INBOX | Recibido, sin revisar | `t` → cambiar a NEXT |
| NEXT | En trabajo activo | `t` → WAITING o DONE |
| WAITING | Esperando al alumno o tercero | `t` → NEXT o DONE |
| DONE | Resuelto | ya esta cerrado |

Para cambiar el estado desde la agenda: posicionate en el ticket y presiona `t`.

### Ver todos los tickets

```
C-c g       → abre el menu GTD
s           → abre soporte.org directamente
```

O desde la agenda:
```
C-c a s     → dashboard de soporte (tickets por estado)
```

---

## 3. Seguimiento Individual de Alumnos

### Crear un seguimiento (`C-c c a`)

Para cada alumno del taller:

1. `C-c c` → `a` (Alumno)
2. Completa:
   - **Nombre del alumno**
   - **Modulo:** 1 / 2 / 3 / 4
   - **Estado:** inicio / desarrollo / evaluacion / completado
3. Escribe observaciones en la seccion correspondiente
4. `C-c C-c` para guardar

El alumno queda en `seguimiento.org` bajo "Activos" con estado **NEXT**.

### Ver el seguimiento

```
C-c g A     → abre seguimiento.org
```

Cada alumno tiene:
- **Observaciones:** notas del docente sobre su avance
- **Proxima accion:** que hacer en el siguiente encuentro

Cuando un alumno completa el modulo: `t` → DONE y refile a "Completados".

---

## 4. Calendario y Compromisos

### Agregar un compromiso con fecha (`C-c c c`)

Para una clase, entrega o evento del TAO:

1. `C-c c` → `c` (Compromiso con fecha)
2. Escribe el titulo (ej: "Clase TAO - Modulo 2")
3. `C-u C-c C-s` para ingresar fecha y hora
4. `C-c C-c` para guardar

### Ver la agenda del dia

```
C-c g d     → Dashboard GTD: agenda del dia + proximas acciones + inbox
```

La primera seccion muestra todos los compromisos de hoy y los proximos 7 dias con deadline.

### Calendario visual (calfw)

```
C-c g k     → abre calendario mensual visual
```

Muestra todos los eventos de `calendario.org` en formato mensual. Navegar con `b` (atras) y `f` (adelante).

---

## 5. Sincronizacion con Google Calendar (org-caldav)

> **Estado:** disponible si `my/caldav-calendar-id` esta configurado en `~/.emacs.d/local.el`.

### Configurar OAuth (una sola vez)

#### Paso 1: Crear credenciales en Google Cloud Console

1. Ir a [console.cloud.google.com](https://console.cloud.google.com)
2. Crear un proyecto nuevo (ej: "FORJA GTD")
3. Ir a **APIs y servicios → Biblioteca**
4. Buscar y activar la **API de Google Calendar**
5. Ir a **APIs y servicios → Credenciales → Crear credenciales → ID de cliente OAuth 2.0**
6. Tipo de aplicacion: **Aplicacion de escritorio**
7. Anotar el **Client ID** y el **Client Secret**

#### Paso 2: Configurar en FORJA

Crear o editar `~/.emacs.d/local.el`:

```elisp
;; Google Calendar sync
(setq my/caldav-calendar-id     "TU_EMAIL@gmail.com")
(setq my/caldav-client-id       "XXXXXXXX.apps.googleusercontent.com")
(setq my/caldav-client-secret   "GOCSPX-XXXXXXXXXX")
```

`local.el` se carga automaticamente si existe — es el lugar para credenciales que NO van al repo.

> Agregar `local.el` a `.gitignore` si no esta ya.

#### Paso 3: Primera sincronizacion

```
C-c g y     → sincronizar con Google Calendar
```

La primera vez: Emacs abrira el navegador para autorizar la app. Aceptar los permisos. Luego la sincronizacion corre automaticamente.

### Sincronizar manualmente

```
C-c g y     → sync con Google Calendar (desde hydra GTD)
C-c F g y   → mismo, desde hydra maestra FORJA
```

### Sincronizacion automatica (opcional)

Para sincronizar al guardar `calendario.org`, agregar en `local.el`:

```elisp
(add-hook 'org-mode-hook
          (lambda ()
            (when (string= (buffer-file-name) (expand-file-name my/gtd-calendar))
              (add-hook 'after-save-hook #'my/gtd-caldav-sync nil t))))
```

---

## 6. Modo Examen

El modo examen suspende la IA local para evaluaciones presenciales donde no se debe usar asistencia artificial.

### Activar / Desactivar

```
C-c F e     → alterna el modo examen (pide confirmacion al activar)
```

Cuando esta activo:
- La barra de estado muestra **[EXAMEN]** en rojo
- `gptel`, Aider y los agentes (PicoClaw, OpenClaw) quedan bloqueados
- Los atajos de compilacion y ejecucion siguen funcionando normalmente

### Flujo tipico en evaluacion

1. Pedir a los alumnos que abran Emacs
2. El docente activa `C-c F e` en cada maquina (o via script remoto)
3. Si un alumno intenta usar IA: aparece el mensaje `[MODO EXAMEN] IA deshabilitada`
4. Al terminar la evaluacion: `C-c F e` para desactivar

> El modo examen NO bloquea el acceso a internet ni a archivos locales — solo desactiva los comandos de IA dentro de Emacs.

---

## 7. Revision Semanal del TAO

La revision semanal cierra el ciclo: actualiza el estado de todos los alumnos, tickets y compromisos.

### Ejecutar la revision

```
C-c g R     → guia interactiva de revision semanal GTD
```

La guia pasa por 8 pasos uno a uno. Para el TAO, agregar despues de los pasos estandar:

**TAO Paso 9:** Revisar `seguimiento.org` — un alumno por alumno:
- ¿Avanzaron? Actualizar estado y observaciones
- ¿Alguien se estanco? Agregar NEXT con plan de accion
- ¿Alguien completo el modulo? `t` → DONE, refile a "Completados"

**TAO Paso 10:** Cerrar tickets resueltos:
- Abrir dashboard de soporte `C-c a s`
- Archivar tickets DONE mas viejos de 7 dias con `C-c C-w` (refile a archivo.org)

### Agenda semanal TAO

Para ver la semana completa con todos los compromisos:

```
C-c a r     → revision semanal (agenda 7 dias + inbox + next + waiting + proyectos estancados)
```

---

## Tabla de Errores Comunes

| Error | Causa probable | Solucion |
| :--- | :--- | :--- |
| `org-caldav no configurado` | Falta `my/caldav-calendar-id` en `local.el` | Agregar las variables y reiniciar Emacs |
| `[MODO EXAMEN] IA deshabilitada` | Modo examen activo | `C-c F e` para desactivar |
| Tickets no aparecen en agenda | `soporte.org` no en `org-agenda-files` | Reiniciar Emacs o `M-x eval-buffer` en `50-gtd.el` |
| Seguimiento no aparece en refile | `seguimiento.org` no en `org-refile-targets` | Idem |
| Calendario no sync | OAuth no configurado o expirado | Re-ejecutar `C-c g y` para reautorizar |
| Dashboard no muestra widget TAO | Modulo GTD no cargado al arrancar | Verificar perfil en `~/.forja/profile.conf` |
