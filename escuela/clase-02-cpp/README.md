# Clase 02 — La Forja de la Espada (C++)

> En la Forja, los herreros crean armas con distintos materiales. Cada espada tiene nombre, material y nivel de daño. ¿Podés crear la más poderosa?

## Objetivos

- Usar clases C++ con constructor, métodos y operador de salida
- Ver autocompletado del LSP (clangd) para métodos de objeto
- Compilar con `g++` y un `Makefile`
- Introducir un error de tipo y leer el diagnóstico del LSP antes de compilar

## Módulo FORJA

`30-cpp` — Hydra C/C++: `C-c x`

## Flujo de la clase

### 1. Compilar y ejecutar

```
C-c x b    → make
C-c x r    → ./forja
```

### 2. Ejercicio LSP: error de tipos

En `forja.cpp`, cambiar:
```cpp
Espada e("Excalibur", Material::Acero, 95);
```
por:
```cpp
Espada e("Excalibur", "acero", 95);   // tipo incorrecto
```
El LSP subraya el error *antes* de compilar. Deshacerlo con `C-/`.

### 3. Ejercicio: agregar un método

Agregar `bool es_legendaria() const` que retorne `true` si el daño > 90.
Usar autocompletado del LSP (escribir `e.` y esperar sugerencias).

## Conceptos cubiertos

- `class` con atributos privados, constructor, métodos `const`
- `enum class` para tipos seguros
- `std::string`, `std::vector`, rango-for
- Operador `<<` para impresión
- Compilación con `g++` y flags `-std=c++17`
