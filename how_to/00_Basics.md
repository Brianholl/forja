# FORJA: Conceptos Básicos y Primeros Pasos

Bienvenido a **FORJA**. Esta guía cubre los conceptos fundamentales para empezar a moverte eficientemente por el entorno.

## 1. El Concepto de Hydra (Menú Interactivo)

La principal forma de interactuar con el código en FORJA es a través de los menús interactivos **Hydra**. En lugar de tener que recordar decenas de atajos de teclado complejos, utilizas un atajo inicial para desplegar un panel con opciones en la parte inferior de la pantalla.

- Presiona `C-c x` (Control+C seguido de 'x') para abrir el **Hydra de Compilación**.

Una vez que el menú está visible, simplemente presionas **una sola tecla** para ejecutar la acción:
- `r` - **Run** (Ejecutar el programa/script actual)
- `b` - **Build** (Compilar o instalar dependencias)
- `t` - **Test** (Ejecutar pruebas unitarias asociadas)
- `f` - **Format** (Auto-formatear el código)

*(Recuerda: las combinaciones como `C-c` significan mantener presionada la tecla Control y luego presionar la 'c').*

## 2. Generación Rápida de Proyectos

No es necesario configurar estructuras de proyecto desde cero. FORJA cuenta con generadores (templates) incorporados.

- Presiona `C-c n` para abrir el menú de **Generadores de Proyectos**.

Desde aquí, eligiendo una de las opciones sugeridas (por ejemplo, `a` para API en Go, `p` para API en Python), se creará la carpeta del proyecto, generará los archivos boilerplates, inicializará Git y creará el `.gitignore` adecuado en menos de un segundo.

## 3. Teclas Funcionales (F-Keys) de Acceso Rápido

Para las acciones más comunes, FORJA estandariza el uso de las teclas F (en Android u otras resoluciones donde no tengas teclado físico, aparecerán en la barra extra de Termux):

- **F5 (Start/Play):** Ejecuta la acción más lógica dependiendo de tu código. Si estás en C++, compila y corre. Si estás en HTML, abre el Live Server.
- **F7 (Treemacs):** Alterna el explorador lateral de archivos (panel izquierdo) para navegar cómodamente por tu proyecto de forma visual.
- **F12 (LSP Go-To):** Si te posicionas sobre una función estructurada o variable, esta tecla te llevará directamente al archivo donde fue definida.

## 4. Un Entorno en Múltiples Plataformas

FORJA reacciona al sistema donde está instalado, asegurándose de que la experiencia sea fluida:

- **En PC (Arch Linux):** Tendrás acceso de alto rendimiento, incluyendo la IA Local Aider y herramientas de Game Dev pesadas visualmente como Godot o Unreal.
- **En Android (Termux):** Se optimizan los recursos. Se usan atajos en pantalla para suplir el teclado, y se recorta un poco de "peso" visual para que funcione bien en tu celular o tablet.
- **En Windows (WSL2):** Funciona como un entorno de servidor híbrido y ligero sin demandar interfaz gráfica intensiva para edición.

---

### ¿Cuál es el siguiente paso?

Abre tu instalación de FORJA y realiza este simple ejercicio:
1. Usa el árbol lateral (`F7`) o crea un nuevo archivo con `C-x C-f` y llámalo `hola.py` si sabes Python, o `hola.js` si sabes Javascript.
2. Escribe una línea de código sencilla como `print("Hola FORJA")` o `console.log("Hola FORJA")`.
3. Presiona **F5** y mira cómo se ejecuta automáticamente.
