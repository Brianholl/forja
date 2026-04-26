# Clase 13 — Rogue de la Forja (Raylib + C)

> El dungeon se extiende ante vos. La salida `E` brilla al fondo. ¿Podés llegar?

## Objetivos

- Compilar un juego 2D con Raylib y gcc (`make`)
- Usar el game loop de Raylib: `BeginDrawing` / `EndDrawing`
- Implementar movimiento en grilla sobre un mapa de strings
- Modificar el mapa y agregar elementos

## Módulo FORJA

`30-cpp` — Hydra C/C++: `C-c x`

## Flujo de la clase

### 1. Compilar y ejecutar

```
C-c x b    → make
C-c x r    → ./dungeon
```

### 2. Controles

| Tecla | Acción |
|-------|--------|
| `↑↓←→` | Mover el héroe (`@`) |
| `R` | Reiniciar |
| `Esc` | Salir |

### 3. Ejercicio: agregar una trampa

En `dungeon.c`, cambiar un `.` del `MAP` por `T`.
En el loop, si `MAP[py][px] == 'T'`, sumar 10 pasos de penalización.

### 4. Ejercicio: cambiar colores

Cambiar `DARKGRAY` por `DARKBLUE` para las paredes.
Raylib define: `PURPLE`, `MAROON`, `LIME`, `VIOLET`, etc.

## Conceptos cubiertos

- Raylib: `InitWindow`, `BeginDrawing`, `DrawRectangle`, `DrawText`
- Game loop: `WindowShouldClose()`, `SetTargetFPS`
- Mapa como `const char[ROWS][COLS+1]`
- Colisión por tile: `MAP[y][x] != '#'`
- `snprintf` para HUD dinámico
- Compilación: `-lraylib -lm`
