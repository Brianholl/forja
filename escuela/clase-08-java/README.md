# Clase 08 — El Bestiario (Java)

> El Bestiario registra todas las bestias del reino. Dragones, grifos y basiliscos, cada uno con su rugido único.

## Objetivos

- Compilar y ejecutar con Maven (`mvn compile exec:java`)
- Usar herencia y clases abstractas
- Ver diagnósticos de eclipse.jdt.ls (LSP) en tiempo real
- Filtrar y ordenar con Streams de Java

## Módulo FORJA

`44-java` — Hydra Java: `C-c x`

## Flujo de la clase

### 1. Compilar y ejecutar

```
C-c x b    → mvn compile
C-c x r    → mvn exec:java
```

### 2. Ejercicio LSP: clase abstracta

Intentar instanciar la clase abstracta en `Bestiario.java`:
```java
Bestia b = new Bestia("Test", 100, 50);   // error: clase abstracta
```
El LSP subraya el error inmediatamente.

### 3. Ejercicio: nueva bestia

Crear `Hidra.java` extendiendo `Bestia`. Implementar `rugido()`.
Agregarla al bestiario y verificar que el Stream la incluye.

## Conceptos cubiertos

- `abstract class` y método abstracto
- Herencia con `extends`, polimorfismo en runtime
- `@Override` y `toString()`
- `List<T>`, `ArrayList`, `forEach`
- Java Streams: `stream()`, `filter()`, `sorted()`, `Comparator`
- Maven: `pom.xml`, `mvn compile`, `mvn exec:java`
