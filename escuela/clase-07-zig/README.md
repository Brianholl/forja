# Clase 07 — La Llave de Memoria (Zig)

> En Zig, el programador controla cada byte. El Arena Allocator es la llave que abre y cierra la memoria de golpe.

## Objetivos

- Compilar y ejecutar con `zig build run`
- Entender el Arena Allocator como patrón de gestión de memoria
- Ver errores del compilador Zig en tiempo real (zls)
- Experimentar con allocaciones dinámicas sin `free` manual

## Módulo FORJA

`43-zig` — Hydra Zig: `C-c x`

## Flujo de la clase

### 1. Compilar y ejecutar

```
C-c x b    → zig build
C-c x r    → zig build run
```

### 2. Ejercicio: error de tipo

En `main.zig`, intentar pasar un `u32` donde se espera un `[]const u8`:
```zig
try stdout.print("{s}\n", .{ hechizos.items[0].poder });  // error: u32 no es string
```
El compilador y zls lo detectan inmediatamente.

### 3. Ejercicio: agregar un hechizo

Agregar un quinto hechizo al `ArrayList` con un nuevo prefijo en el array.
Usar autocompletado del LSP para los métodos de `ArrayList`.

## Conceptos cubiertos

- `std.heap.ArenaAllocator`: `init`, `deinit`, `allocator()`
- `defer` para limpieza determinista
- `std.ArrayList(T)`: lista dinámica con allocator explícito
- `std.fmt.allocPrint`: strings dinámicas en el arena
- `try` para propagación de errores (`!void`)
- `build.zig`: targets `build` y `run`
