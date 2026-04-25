# Escuela de FORJA — Curriculum

Cada clase tiene un **ejemplo lúdico compilable** que ejercita una parte real del entorno.
El objetivo es doble: aprender programación **y** verificar que FORJA funciona correctamente.

Criterios de cada clase:
- Código que compila y corre desde el primer momento
- Cubre el flujo completo: escribir → compilar → ejecutar → depurar
- Ejercita el LSP (autocompletado, errores en tiempo real)
- Usa los atajos de FORJA (`C-c x`, hydras, etc.)

---

## Nivel 0 — Orientación

| # | Nombre | Módulo | Ejemplo | Estado |
|---|--------|--------|---------|--------|
| 00 | El Primer Hechizo | core / dashboard | Navegar FORJA, abrir archivos, vterm | `[ ]` |

## Nivel 1 — Lenguajes de Sistema

| # | Nombre | Módulo | Ejemplo | Estado |
|---|--------|--------|---------|--------|
| 01 | El Oráculo de Números | C (30-cpp) | Adivina el número — `gcc`, LSP, GDB | `[ ]` |
| 02 | La Forja de la Espada | C++ (30-cpp) | RPG con structs y clases, Makefile | `[ ]` |
| 03 | Ferris el Explorador | Rust (31-rust) | Laberinto en terminal, `cargo run` | `[ ]` |
| 04 | El Mensajero Veloz | Go (32-go) | Servidor HTTP de cotizaciones, `go run` | `[ ]` |
| 07 | La Llave de Memoria | Zig (43-zig) | Asignador de arena, `zig build` | `[ ]` |

## Nivel 2 — Lenguajes de Alto Nivel

| # | Nombre | Módulo | Ejemplo | Estado |
|---|--------|--------|---------|--------|
| 05 | El Alquimista | Python (34-python) | Generador de pociones (CLI), pylsp, ruff | `[ ]` |
| 08 | El Bestiario | Java (44-java) | Bestiary con OOP, Maven | `[ ]` |
| 09 | El Inventario Mágico | Kotlin (44-java) | Inventario con data classes, Gradle | `[ ]` |

## Nivel 3 — Web y Frontend

| # | Nombre | Módulo | Ejemplo | Estado |
|---|--------|--------|---------|--------|
| 10 | El Grimorio Digital | Web (20-web) | Landing page HTML/CSS/JS, live-server | `[ ]` |
| 11 | La Tienda Mágica | TypeScript (20-web) | API de tienda con tipos, tsc | `[ ]` |

## Nivel 4 — Game Dev

| # | Nombre | Módulo | Ejemplo | Estado |
|---|--------|--------|---------|--------|
| 06 | Asteroides de la Mazmorra | Lua + Löve2D (42-lua) | Mini juego 2D, `love .` | `[ ]` |
| 12 | El Dragón de Píxeles | Godot 4 (41-godot) | Escena con personaje y colisiones | `[ ]` |
| 13 | Rogue de la Forja | Raylib + C (30-cpp) | Dungeon crawler 2D, compilación con flags | `[ ]` |

## Nivel 5 — Herramientas Pro

| # | Nombre | Módulo | Ejemplo | Estado |
|---|--------|--------|---------|--------|
| 14 | El Grimorio de Cambios | Git (10-git) | Workflow con Magit, ramas, merge | `[ ]` |
| 15 | El Oráculo de Código | Aider + Ollama (33-aider) | Refactorizar código con IA local | `[ ]` |
| 16 | El Cuartel General | GTD (50-gtd) | Captura, procesa y revisa con org-mode | `[ ]` |

---

## Convención de directorios

```
escuela/
├── CURRICULUM.md          ← este archivo
├── clase-00-entorno/
│   └── README.md
├── clase-01-c/
│   ├── README.md
│   ├── oraculo.c
│   └── Makefile
├── clase-02-cpp/
│   ├── README.md
│   ├── forja.cpp
│   └── Makefile
...
```

## Cómo usar una clase

1. Abrir FORJA: `emacs`
2. `C-c p p` → seleccionar la carpeta de la clase
3. Abrir el `README.md` para leer los objetivos
4. Abrir el archivo fuente y trabajar con LSP activo
5. `C-c x b` para compilar / `C-c x r` para ejecutar
6. Si hay error: `C-c x d` para GDB / leer diagnósticos del LSP
