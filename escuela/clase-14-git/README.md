# Clase 14 — El Grimorio de Cambios (Git + Magit)

> Todo hechizo tiene historia. Git es el grimorio que recuerda cada incantación.

## Objetivos

- Usar Magit para el flujo completo de Git desde Emacs
- Crear commits, ramas y hacer merge
- Ver el log gráfico de commits
- Entender `.gitignore` para ignorar artefactos de build

## Módulo FORJA

`10-git` — Hydra Git: `C-c g`

## Flujo de la clase

### 1. Abrir Magit

```
C-c g g   →  abre Magit status
```

| Tecla | Acción |
|-------|--------|
| `s` | stage archivo/hunk |
| `c c` | crear commit |
| `b b` | cambiar de rama |
| `F u` | pull |
| `P u` | push |

### 2. Flujo básico

```
1. Editar un archivo del proyecto
2. C-c g g   →  ver cambios en Magit
3. s         →  stage los hunks deseados
4. c c       →  escribir mensaje de commit
5. C-c C-c   →  confirmar commit
```

### 3. Ramas

```
b c   →  crear rama nueva
b b   →  cambiar de rama
m m   →  merge de la rama actual en la actual
```

### 4. Log gráfico

```
l l   →  log lineal
l g   →  log gráfico con ramas
```

## Ejercicio

1. Inicializar un repo en `clase-01-c/`: `git init`
2. Editar `oraculo.c` (cualquier cambio)
3. Crear un commit con Magit
4. Crear rama `feature/mensaje-nuevo`
5. Cambiar el texto de bienvenida y hacer otro commit
6. Volver a `main` y hacer merge

## Conceptos cubiertos

- `git init`, stage, commit (desde Magit)
- Ramas: `git branch`, `git checkout`, `git merge`
- `git log`, `git diff`, `git status`
- Resolución de conflictos con `ediff`
- `.gitignore`: ignorar binarios y carpetas de build
