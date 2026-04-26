# Clase 11 — La Tienda Mágica (TypeScript)

> La tienda tiene catálogo, stock y carrito. Los tipos garantizan que nadie venda una espada como poción.

## Objetivos

- Compilar TypeScript con `tsc` y ejecutar con Node.js
- Usar `interface`, `type` union y clases tipadas
- Ver errores de tipos del LSP antes de compilar
- Entender la diferencia entre TypeScript en desarrollo y producción

## Módulo FORJA

`20-web` (TypeScript) — Hydra Web: `C-c x`

## Flujo de la clase

### 1. Instalar y ejecutar

```bash
npm install          # instala typescript
```

```
C-c x b    → npm run build   (tsc → compila a dist/)
C-c x r    → npm start       (node dist/tienda.js)
```

O con tsx directamente:
```
C-c x r    → npm run dev     (tsx tienda.ts)
```

### 2. Ejercicio LSP: error de tipo

En `tienda.ts`, intentar pasar un tipo incorrecto:
```typescript
tienda.agregar("Poción Extra", "bebida", 30, 5);
// "bebida" no es TipoArticulo → error inmediato del LSP
```

### 3. Ejercicio: nuevo método

Agregar `tienda.descuento(id: number, pct: number): void` que reduzca
el precio de un artículo según el porcentaje. El LSP verificará los tipos.

## Conceptos cubiertos

- `interface` para estructuras de datos
- `type` union: `"pocion" | "arma" | "armadura" | "reliquia"`
- Clases con propiedades privadas y métodos tipados
- `Array.find`, `Array.filter` con tipos genéricos
- `tsc`: `tsconfig.json`, `outDir`, `strict`
- `npm run build` vs `npm run dev` (tsx)
