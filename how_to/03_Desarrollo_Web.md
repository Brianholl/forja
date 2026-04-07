# Guía 03: HTML, CSS, JS y Desarrollo Web

El módulo **20-web** contiene el ecosistema que maneja Front-end nativo con ecosistemas basados en JS puro, React / TypeScript, WebComponents, etc.

## Estructura Visual con HTML/CSS
- Al trabajar sobre `.html` ó `.css`, FORJA inicializa extensiones LSP similares a las de editores nativos como VSCode; esto te provee de sugerencias para etiquetas de estilo (como autocompletar `#ffff00` mostrando el color o autocompletando propiedades `flexbox`).
- **Formateo Seguro Intenso:** `C-c x f` formateará sin problemas bloques masivos anidados de divs que estén mal identados bajo las pautas oficiales de `Prettier`.

## Integración de JS / TS / Node.js
- **Ejecución Local (`Node`):** Si estás editando algoritmos llanos o aprendiendo lógica en `ejercicio.js`. Al tener dicho documento abierto...
  Simplemente presiona `F5`, y se inyectará tu ejecución contra Node.js, donde por debajo los `console.log()` aparecerán en el *panel lateral terminal de logs*.
- **Manejo de Paquetes (NPM) via Hydra:** Forja es sensible al entorno, `C-c x b` (Build) dentro de una carpeta de repositorio que aloja un `package.json` es interpretado de golpe como un mandato inteligente de ejecutar `npm install` instalándote la biblioteca en la raíz de donde pertenece.
- **Correr Tests (`Jest`, `Vitest`):** Si estás en un archivo de tests (generalmente de notación `.spec.js`), presionar `C-c x t` llamará localmente a `npm test`.

## Hot Reload: Live Server Inteligente
Típico dilema de enseñanza secundaria de diseño web: aburrido escribir HTML, mover de tab y machacar el botón de actualizar navegador. FORJA trae una solución de una sola vía.
1. Abre tu portafolio base, el `index.html`.
2. Presiona `F5` directamente en el teclado.
3. Se enciende el **Live Server**:  
   - En **PC**, tu navegador por defecto salta encendiéndose apuntando hacia tu IP Local (Ej: `127.0.0.1`).  
   - En **Termux (Android)** asume que NO hay firefox y suprime ese error; inicializando limpiamente en los headers para que si enciendes Chrome mobile apuntando a *localhost*, visualices la web, modifiques el teclado por debajo y el refresh sea automático on-save de tu archivo `.html`.

---
[⬅️ Volver al README](../README.md)
