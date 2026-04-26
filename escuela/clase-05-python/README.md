# Clase 05 — El Alquimista (Python)

> El Alquimista mezcla ingredientes y rareza para crear pociones únicas en cada invocación.

## Objetivos

- Ejecutar un script Python con argumentos CLI
- Ver diagnósticos de pylsp y ruff en tiempo real
- Usar `@dataclass` y `random.choices` con pesos
- Explorar hover del LSP sobre funciones de la stdlib

## Módulo FORJA

`34-python` — Hydra Python: `C-c x`

## Flujo de la clase

### 1. Ejecutar

```
C-c x r    → python3 pociones.py        (3 pociones por defecto)
             python3 pociones.py 5      (5 pociones)
```

### 2. Ejercicio LSP: anotaciones de tipo

Agregar `from __future__ import annotations` al inicio.
Observar cómo el LSP infiere los tipos de retorno y marca inconsistencias.

### 3. Ejercicio: nueva rareza

Agregar `"mítica"` a `RAREZAS` con peso `1`.
Actualizar la cantidad de estrellas en `__str__`.

## Conceptos cubiertos

- `@dataclass`: definición compacta de clases de datos
- `random.choices` con pesos (`weights=`)
- `sys.argv` para argumentos CLI
- Tipado básico: `-> str`, `-> None`, `-> "Pocion"`
- `f-strings` multilínea con Unicode
