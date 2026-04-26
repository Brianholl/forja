# Clase 12 — El Dragón de Píxeles (Godot 4)

> El dragón azul despierta en el castillo. Explorá el mundo con las flechas.

## Objetivos

- Abrir un proyecto Godot 4 e importarlo en el editor
- Entender la escena: Node2D → CharacterBody2D → CollisionShape2D
- Ver autocompletado de gdscript-language-server en FORJA
- Implementar movimiento con `CharacterBody2D` y `move_and_slide()`

## Módulo FORJA

`41-godot` — Hydra Godot: `C-c x`

## Flujo de la clase

### 1. Abrir el proyecto

```
C-c x r    → godot4 --editor .
```

En el editor de Godot: **Importar Proyecto → seleccionar esta carpeta**.
La escena `main.tscn` debería abrirse automáticamente.

### 2. Ejecutar

```
F5 en el editor de Godot
```

Controles: flechas para mover el cuadrado azul. `Esc` para salir.

### 3. Ejercicio: gravedad

En `player.gd`, agregar gravedad al movimiento vertical:
```gdscript
const GRAVITY: float = 980.0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y += GRAVITY * delta
    # ... resto del movimiento
```

Agregar un `StaticBody2D` como suelo para que el personaje aterrice.

### 4. Ejercicio: cambiar color

En `main.tscn`, seleccionar el nodo `ColorRect` del Player en el editor.
Cambiar `color` desde el Inspector.

## Conceptos cubiertos

- Escena de Godot: jerarquía de nodos
- `CharacterBody2D`: `velocity`, `move_and_slide()`
- `Input.get_axis`: movimiento analógico con un solo eje
- `_physics_process(delta)` vs `_process(delta)`
- GDScript: tipos estáticos, `const`, `func`, `@onready`
- `project.godot`: configuración mínima del proyecto
