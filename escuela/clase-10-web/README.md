# Clase 10 — El Grimorio Digital (Web)

> La Academia de los Elementos abre sus puertas online. Una landing page para magos modernos.

## Objetivos

- Servir una página web con live-server desde FORJA
- Editar HTML/CSS/JS con diagnósticos del LSP
- Manipular el DOM con JavaScript puro
- Entender el ciclo: editar → guardar → hot reload

## Módulo FORJA

`20-web` — Hydra Web: `C-c x`

## Flujo de la clase

### 1. Abrir con live-server

```
C-c x r    → live-server .
```

El navegador abre en `http://localhost:8080`.
Cada vez que guardás un archivo, la página se recarga sola.

### 2. Ejercicio: agregar un curso

En `main.js`, agregar un objeto al array `cursos`:
```javascript
{ nombre: "Necromancia Arcana", icono: "💀", nivel: "Experto", duracion: "12 semanas" },
```

### 3. Ejercicio: validar el formulario

En `inscribir()`, validar que el nombre tenga al menos 3 caracteres.
Mostrar un mensaje de error si no cumple.

## Conceptos cubiertos

- HTML semántico: `header`, `section`, `nav`, `footer`
- CSS: variables (`--color-*`), grid layout, animaciones con `@keyframes`
- DOM: `document.createElement`, `appendChild`, `classList`
- Eventos: `onclick`, `onsubmit`, `event.preventDefault()`
- `live-server`: hot reload en desarrollo
