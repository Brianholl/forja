# Clase 09 — El Inventario Mágico (Kotlin)

> El inventario tiene capacidad limitada. Cada objeto pesa; cada oro importa.

## Objetivos

- Compilar y ejecutar con Gradle (`./gradlew run`)
- Usar `data class`, `enum class` y propiedades computadas
- Ver diagnósticos del LSP de Kotlin en tiempo real
- Usar extensiones de colección: `sumOf`, `filter`, `forEach`

## Módulo FORJA

`44-java` (Kotlin) — Hydra Kotlin: `C-c x`

## Flujo de la clase

### 1. Compilar y ejecutar

```
C-c x b    → ./gradlew build
C-c x r    → ./gradlew run
```

### 2. Ejercicio: `data class` y `copy`

Las `data class` generan `copy()` automáticamente:
```kotlin
val pocion2 = pociones[0].copy(nombre = "Poción Mayor de Vida", valor = 120)
println(pocion2)
```

### 3. Ejercicio: ordenar por valor

Usar `sortedByDescending` para listar los objetos del inventario por valor:
```kotlin
objetos.sortedByDescending { it.valor }.forEach { ... }
```

## Conceptos cubiertos

- `data class`: `equals`, `copy`, `toString` automáticos
- `enum class` para tipos seguros
- Propiedades computadas con `get()`
- `mutableListOf`, `sumOf`, `filter`, `forEach`
- Gradle Kotlin DSL: `build.gradle.kts`, `./gradlew run`
