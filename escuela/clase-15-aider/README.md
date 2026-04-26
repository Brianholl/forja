# Clase 15 — El Oráculo de Código (Aider + Ollama)

> El Oráculo lee tu código, entiende tu intención y forja la solución.

## Objetivos

- Usar Aider desde FORJA para refactorizar código existente
- Pedir nuevas funciones en lenguaje natural
- Revisar y aprobar los diffs generados por la IA
- Entender la diferencia entre PicoClaw y OpenClaw

## Módulo FORJA

`33-aider` / `55-picoclaw` / `56-openclaw` — Hydra IA: `C-c a`

## Flujo de la clase

### 1. Verificar Ollama

```
C-c a s    →  estado de Ollama
```

```bash
ollama ps       # modelos cargados en memoria
ollama list     # modelos instalados
```

### 2. Abrir Aider sobre una clase anterior

```
C-c a a    →  abre Aider en el proyecto actual
```

### 3. Pedidos de ejemplo sobre `oraculo.c`

```
/add oraculo.c
```

```
Refactoriza: extraer la lógica del juego a una función jugar().
```

```
Agregá un modo difícil con solo 5 intentos.
```

```
Traducí todos los mensajes al inglés.
```

### 4. PicoClaw vs OpenClaw

| | PicoClaw | OpenClaw |
|---|---|---|
| Modelo | ~0.5b | ~7b |
| Velocidad | Muy rápido | Lento |
| Calidad | Básica | Completa |
| Uso ideal | Completar, snippets | Refactorizar, explicar |

```
C-c a p    →  PicoClaw (chat rápido)
C-c a o    →  OpenClaw (análisis profundo)
```

## Ejercicio

Tomá `forja.cpp` de la clase 02 y pedile a Aider:
1. Agregar una clase `Escudo` que extienda la lógica existente
2. Ordenar el inventario por daño antes de imprimirlo
3. Agregar un método `descripcion_completa()` que retorne un `string`

## Conceptos cubiertos

- Aider: flujo `/add`, prompts en lenguaje natural, diff review
- Modelos locales via Ollama, lazy-load en FORJA
- PicoClaw (ligero) vs OpenClaw (completo)
- Revisión y aprobación de cambios generados por IA
- Límites del refactoring automático
