# Clase 03 — Ferris el Explorador (Rust)

> Ferris el cangrejo debe explorar un laberinto de texto. Cada sala tiene una descripción y posibles salidas. ¿Podés guiarlo hasta la salida?

## Objetivos

- Crear y correr un proyecto con `cargo`
- Ver el ownership/borrow checker del compilador en tiempo real (rust-analyzer)
- Usar `match`, `enum`, `struct` y `HashMap`
- Observar cómo Rust señala errores de ownership *antes* de compilar

## Módulo FORJA

`31-rust` — Hydra Rust: `C-c x`

## Flujo de la clase

### 1. Compilar y ejecutar

```
C-c x b    → cargo build
C-c x r    → cargo run
```

### 2. Ejercicio ownership

En `main.rs`, intentar usar una variable después de moverla:
```rust
let sala = mapa[&pos_actual];   // mueve el valor
println!("{:?}", sala);          // error: valor movido
```
rust-analyzer subraya el error instantáneamente. Corregirlo con `&`.

### 3. Ejercicio: agregar una sala

Agregar una sala "Cripta" con salidas propias. Verificar que el `match`
en `parse_input` cubre todas las variantes del enum.

## Conceptos cubiertos

- `enum` con variantes y `match` exhaustivo
- `struct` con métodos (`impl`)
- `HashMap` para el mapa de salas
- `String` vs `&str`, ownership básico
- `loop`, `break`, `continue`
- `cargo run`, `cargo build`, `cargo clippy`
