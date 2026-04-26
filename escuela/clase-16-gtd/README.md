# Clase 16 — El Cuartel General (GTD + org-mode)

> Cada misión empieza con una captura. El Cuartel General procesa, organiza y ejecuta.

## Objetivos

- Capturar tareas al inbox con `C-c c`
- Procesar el inbox con la lógica GTD
- Navegar la agenda diaria y semanal
- Cerrar el ciclo: revisión semanal

## Módulo FORJA

`50-gtd` — Hydra GTD: `C-c g`

## Archivos del sistema GTD

```
inbox.org        → captura sin pensar
proyectos.org    → acciones con contexto
tickler.org      → recordatorios futuros
habitos.org      → hábitos recurrentes
seguimiento.org  → seguimiento de alumnos (TAO)
```

## Flujo de la clase

### 1. Capturar

```
C-c c   →  menú de captura
```

| Template | Descripción |
|----------|-------------|
| `t` | Tarea al inbox |
| `n` | Nota rápida |
| `h` | Hábito nuevo |
| `a` | Seguimiento de alumno |

### 2. Procesar el inbox

```
C-c g i    →  ver inbox
```

En cada ítem:
- `t` → cambiar estado (TODO → NEXT → DONE)
- `C-c C-w` → refile a proyectos o tickler
- `d` → deadline
- `s` → scheduled

### 3. Ver la agenda

```
C-c g a    →  agenda del día
C-c g w    →  vista semanal
```

### 4. Revisión semanal

```
C-c g r    →  iniciar revisión guiada
```

### 5. IA-GTD

```
C-c g g    →  asistente GTD con IA
```

Ejemplo: *"¿Qué tengo para esta semana?"*

## Ejercicio

1. Capturá 5 tareas ficticias al inbox
2. Procesá: refilea 2 a proyectos, agenda 2, descartá 1
3. Abrí la agenda del día
4. Marcá una tarea como DONE
5. Iniciá la revisión semanal (`C-c g r`)

## Conceptos cubiertos

- `org-capture`: templates y captura rápida
- Estados: `TODO → NEXT → WAITING → DONE → CANCELLED`
- Refile: reorganizar entre archivos org
- `org-agenda`: vistas filtradas por contexto
- Revisión semanal: proceso guiado de cierre
- IA-GTD: `gptel` integrado en el flujo GTD
