# Clase 01 — El Oráculo de Números (C)

> El Oráculo eligió un número entre 1 y 100. ¿Podés descubrirlo?

## Objetivos

- Compilar un programa C con `gcc` desde FORJA (`C-c x b`)
- Ver errores del LSP (clangd) en tiempo real mientras escribís
- Ejecutar en vterm (`C-c x r`)
- Introducir un bug intencional y usar GDB para encontrarlo (`C-c x d`)

## Módulo FORJA

`30-cpp` — Hydra C/C++: `C-c x`

## Flujo de la clase

### 1. Abrir el proyecto

```
C-c p p → clase-01-c
C-x C-f → oraculo.c
```

### 2. Compilar

```
C-c x b    → gcc oraculo.c -o oraculo -Wall -g
```

### 3. Ejecutar

```
C-c x r    → ./oraculo
```

### 4. Ejercicio: introducir un bug

Cambiar `rand() % 100 + 1` por `rand() % 100` (el número puede ser 0).
Observar el warning del LSP. Corregirlo.

### 5. Depurar con GDB

```
C-c x d    → abre GDB
(gdb) break main
(gdb) run
(gdb) next
(gdb) print secreto
```

## Conceptos cubiertos

- Variables: `int`, inicialización
- Entrada de usuario: `scanf`
- Bucles: `while`
- Condicionales: `if / else if / else`
- Números aleatorios: `rand`, `srand`, `time`
- Compilación con flags: `-Wall`, `-g`
