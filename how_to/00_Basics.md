# Guia 00: Conceptos Basicos y Primeros Pasos

> Tu primer contacto con FORJA. Aprende a moverte, ejecutar codigo y entender la filosofia del entorno.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Abrir y navegar por el entorno FORJA sin perderte
- Ejecutar tu primer programa con una sola tecla
- Entender que es un Hydra y para que sirve
- Identificar en que plataforma estas trabajando (PC, Android, WSL)

## Prerequisitos

- Tener FORJA instalado (ver `README.md` > Instalacion Rapida)
- Saber abrir una terminal y ejecutar `emacs`

---

## 1. Que es FORJA

FORJA es un entorno de desarrollo completo construido sobre Emacs. Piensa en el como un "Visual Studio Code" pero que funciona en tu PC, en tu celular Android (via Termux) y en Windows (via WSL2), todo con la misma configuracion.

La diferencia principal con otros editores: en FORJA **todo se controla desde el teclado** usando menus visuales que te muestran las opciones disponibles. No necesitas memorizar nada al principio.

## 2. Abriendo FORJA por Primera Vez

Cuando abres FORJA (`emacs` en la terminal), lo primero que veras es el **Dashboard**: una pantalla de inicio con:
- Tus **proyectos recientes** (al principio estara vacio)
- Accesos rapidos a funciones comunes
- Informacion del estado del sistema

Para navegar por el Dashboard:
- Usa `Tab` para saltar entre opciones
- Usa `Enter` para seleccionar
- Usa el mouse si estas en PC con interfaz grafica

## 3. Tu Primera Interaccion: Crear y Ejecutar un Archivo

Vamos paso a paso:

### Paso 1: Crear un archivo nuevo
Presiona `C-x C-f` (esto significa: manten `Control`, presiona `x`, suelta, manten `Control`, presiona `f`).

Aparecera un campo en la parte inferior de la pantalla. Escribe la ruta del archivo:
```
~/prueba/hola.py
```
Presiona `Enter`. FORJA creara la carpeta y el archivo automaticamente.

### Paso 2: Escribir codigo
Escribe esto en el archivo:
```python
print("Hola, estoy usando FORJA!")
print("2 + 2 =", 2 + 2)
```

### Paso 3: Guardar
Presiona `C-x C-s` (Control+X, Control+S). Veras un mensaje en la parte inferior confirmando que se guardo.

### Paso 4: Ejecutar
Presiona `F5`. Tu programa se ejecutara y veras la salida en un panel inferior:
```
Hola, estoy usando FORJA!
2 + 2 = 4
```

**Eso es todo.** Con `F5` puedes ejecutar codigo en Python, JavaScript, Go, Rust, C, HTML y muchos mas. FORJA detecta el lenguaje automaticamente.

## 4. El Concepto de Hydra (Menu Interactivo)

El Hydra es la pieza central de FORJA. Es un **menu flotante** que aparece en la parte inferior de la pantalla mostrandote todas las acciones disponibles.

### Como funciona

1. Presiona `C-c x` (Control+C, luego la letra X)
2. Aparece un panel con opciones como:
   ```
   [r] Run  [b] Build  [t] Test  [f] Format  [k] Stop  [d] Debug
   ```
3. Presiona **una sola letra** para ejecutar la accion
4. El menu desaparece automaticamente despues de ejecutar

### Las acciones principales del Hydra

| Tecla | Accion | Que hace |
| :---: | :--- | :--- |
| `r` | **Run** | Ejecuta el programa actual (igual que F5) |
| `b` | **Build** | Compila el proyecto o instala dependencias |
| `t` | **Test** | Ejecuta las pruebas (tests) del proyecto |
| `f` | **Format** | Auto-formatea el codigo (indentacion, espacios) |
| `k` | **Stop** | Detiene un proceso que esta corriendo |
| `d` | **Debug** | Inicia el depurador (solo en PC) |
| `e` | **Errors** | Muestra la lista de errores detectados |
| `.` | **Definicion** | Salta a donde se definio una funcion (igual que F12) |
| `,` | **Referencias** | Muestra donde se usa una funcion |

**Tip importante:** El Hydra detecta el lenguaje del archivo que tienes abierto. Si estas en un `.py`, "Run" ejecuta Python. Si estas en un `.go`, "Run" ejecuta Go. No necesitas configurar nada.

## 5. Teclas Funcionales (F-Keys): Acceso Rapido

Para las acciones que usaras todo el tiempo, FORJA asigna teclas de funcion:

| Tecla | Nombre | Que hace |
| :---: | :--- | :--- |
| **F5** | Play/Run | Ejecuta el programa. Es la tecla mas importante. |
| **F6** | Flash | Solo para ESP32: flashea el microcontrolador |
| **F7** | Explorador | Abre/cierra el arbol de archivos a la izquierda |
| **F9** | Debug | Inicia el depurador GDB (C/C++) |
| **F12** | Ir a Definicion | Salta al codigo fuente de una funcion |

> **En Android (Termux):** Estas teclas aparecen en una barra extra en la parte superior del teclado. Si no las ves, ejecuta `install.sh` y reinicia Termux.

## 6. Navegacion Basica en Emacs

Si nunca usaste Emacs, estas son las unicas combinaciones que necesitas al principio:

| Accion | Teclas | Descripcion |
| :--- | :--- | :--- |
| Abrir archivo | `C-x C-f` | Abre o crea un archivo |
| Guardar | `C-x C-s` | Guarda el archivo actual |
| Cerrar buffer | `C-x k` | Cierra la pestaña actual |
| Deshacer | `C-/` | Deshace el ultimo cambio |
| Copiar | `M-w` | Copia el texto seleccionado |
| Cortar | `C-w` | Corta el texto seleccionado |
| Pegar | `C-y` | Pega el texto copiado/cortado |
| Seleccionar | `C-Space` | Inicia seleccion, mueve el cursor para seleccionar |
| Cancelar | `C-g` | **Cancela cualquier operacion en curso** |

> **M-w** significa `Alt+W` (la tecla Alt se llama "Meta" en Emacs). Si `Alt` no funciona, usa `ESC` seguido de `w`.

> **`C-g` es tu mejor amigo.** Si en algun momento te pierdes o algo no funciona como esperabas, presiona `C-g` para cancelar y volver al estado normal.

## 7. Las Plataformas de FORJA

FORJA funciona en tres entornos diferentes. Se adapta automaticamente:

| Plataforma | Ideal para | Limitaciones |
| :--- | :--- | :--- |
| **PC (Arch Linux)** | Todo: desarrollo completo, IA, Game Dev | Ninguna |
| **Android (Termux)** | Programar en el celular/tablet, estudiar en el colectivo | Sin IA local, sin Godot/Unreal, sin GDB |
| **Windows (WSL2)** | Usar FORJA en Windows sin instalar Linux nativo | Sin IA local, sin GUI nativa |

No necesitas hacer nada especial para cambiar entre plataformas. FORJA detecta donde esta corriendo y ajusta todo automaticamente.

---

## Ejercicio Practico: Tu Primer Proyecto Completo

Ahora que conoces lo basico, hagamos un ejercicio completo:

1. **Abre el explorador lateral:** Presiona `F7`
2. **Crea un archivo:** Presiona `C-x C-f`, escribe `~/prueba/calculadora.js` y presiona `Enter`
3. **Escribe este codigo:**
   ```javascript
   function sumar(a, b) {
       return a + b;
   }

   function restar(a, b) {
       return a - b;
   }

   console.log("5 + 3 =", sumar(5, 3));
   console.log("10 - 4 =", restar(10, 4));
   console.log("100 + 200 =", sumar(100, 200));
   ```
4. **Guarda:** `C-x C-s`
5. **Ejecuta:** `F5` — deberas ver la salida con los resultados
6. **Formatea:** Presiona `C-c x` para abrir el Hydra, luego `f` para formatear
7. **Cierra el explorador:** `F7` de nuevo

Si todo funciono, ya dominas las operaciones fundamentales de FORJA.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| F5 no hace nada | No hay archivo abierto o no se reconoce el lenguaje | Verifica que el archivo tenga la extension correcta (.py, .js, .go) |
| El Hydra no aparece | Presionaste las teclas muy rapido o en orden incorrecto | Presiona `C-g` para cancelar, luego intenta `C-c x` de nuevo |
| "File not found" al ejecutar | El archivo no esta guardado | Guarda con `C-x C-s` antes de ejecutar |
| Letras raras en pantalla | Fuentes no instaladas | Ejecuta `M-x all-the-icons-install-fonts` (solo la primera vez en PC) |
| En Termux no aparecen F-keys | Falta configuracion de extra-keys | Ejecuta `~/forja/install.sh` y reinicia Termux |

## Resumen de Atajos de esta Guia

```
C-x C-f    → Abrir/crear archivo
C-x C-s    → Guardar
C-g        → Cancelar cualquier cosa
F5         → Ejecutar programa
F7         → Explorador de archivos
F12        → Ir a definicion
C-c x      → Menu Hydra (compilacion)
C-c x r    → Run (desde Hydra)
C-c x f    → Format (desde Hydra)
C-c x t    → Test (desde Hydra)
```

---

**Siguiente:** [Guia 01: Core y Entorno](01_Core_y_Entorno.md) | [Volver al README](../README.md)
