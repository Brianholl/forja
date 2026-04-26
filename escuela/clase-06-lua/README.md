# Clase 06 — Asteroides de la Mazmorra (Lua + Löve2D)

> Rocas caen del cielo. Tu héroe debe esquivarlas. Cada segundo es más rápido.

## Objetivos

- Crear y ejecutar un juego 2D con Löve2D (`love .`)
- Entender el ciclo `load` / `update` / `draw` / `keypressed`
- Implementar colisiones simples círculo–rectángulo
- Explorar autocompletado del LSP para la API de Löve2D

## Módulo FORJA

`42-lua` — Hydra Lua: `C-c x`

## Flujo de la clase

### 1. Ejecutar

```
C-c x r    → love .
```

Controles: `←` / `→` (o A / D) para mover. `R` para reiniciar. `Esc` para salir.

### 2. Ejercicio: cambiar colores

Buscar `love.graphics.setColor(0.20, 0.80, 0.40)` y cambiar los valores RGB.
Löve2D usa valores 0.0–1.0 para R, G, B.

### 3. Ejercicio: agregar vidas

Agregar `Heroe.vidas = 3`. Al colisionar, reducir en 1.
Morir solo cuando `vidas == 0`. Mostrar las vidas en el HUD.

## Conceptos cubiertos

- Löve2D: `love.load`, `love.update(dt)`, `love.draw`
- Tablas Lua como objetos
- Colisión círculo–rectángulo con distancia euclidiana
- `math.random`, `table.insert`, `table.remove`
- `love.keyboard.isDown` (continuo) vs `love.keypressed` (evento puntual)
