# Clase 00 — El Primer Hechizo (Orientación)

> Antes de forjar, el aprendiz debe conocer su taller.

## Objetivos

- Navegar el dashboard de FORJA al arrancar Emacs
- Abrir proyectos y archivos con Projectile (`C-c p p`)
- Usar vterm para comandos de shell
- Conocer la Hydra Maestra (`C-c F`) y el LSP básico

## Módulo FORJA

`00-core` / `01-dashboard` — Hydra maestra: `C-c F`

## Flujo de la clase

### 1. El Dashboard

Al abrir Emacs aparece el dashboard con:
- Tu nombre y la fecha
- Proyectos recientes (Enter para abrir)
- Estado de Ollama / inbox GTD

### 2. Hydra Maestra

```
C-c F   →  abre el menú maestro de FORJA
```

| Tecla | Acción |
|-------|--------|
| `C-c F b` | Hydra de build |
| `C-c F e` | Modo examen |
| `C-c F v` | Ver versión |

### 3. Abrir un proyecto

```
C-c p p   →  lista de proyectos conocidos
C-c p f   →  buscar archivo dentro del proyecto actual
C-x C-f   →  abrir cualquier archivo
```

### 4. Terminal integrada

```
C-c t t   →  abre vterm (terminal bash)
```

Dentro de vterm:
```bash
forja doctor       # diagnóstico del entorno
ls ~/forja/        # ver la instalación
```

### 5. LSP básico

Con cualquier archivo de código abierto:

| Atajo | Acción |
|-------|--------|
| `TAB` o `M-/` | Autocompletado |
| `M-.` | Ir a definición |
| `M-,` | Volver |

## Ejercicio

Abrí la clase siguiente:
```
C-c p p → clase-01-c
C-x C-f → oraculo.c
C-c x b → compilar
C-c x r → ejecutar
```
