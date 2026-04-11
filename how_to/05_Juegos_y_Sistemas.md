# Guia 05: Game Dev y Sistemas Embebidos

> Desarrolla juegos con Raylib, Godot y Unreal Engine. Programa microcontroladores ESP32. Domina C/C++ con compilacion inteligente.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Compilar y ejecutar programas en C/C++ con deteccion automatica de Makefile/CMake
- Crear juegos con Raylib usando los templates de FORJA
- Trabajar con GDScript en Godot desde Emacs
- Flashear y monitorear un ESP32 con una sola tecla (F6)
- Entender las consideraciones especiales para Unreal Engine

## Prerequisitos

- Haber completado la [Guia 01: Core y Entorno](01_Core_y_Entorno.md)
- Tener `gcc` o `clang` instalado (ya incluido en FORJA)
- Para ESP32: tener ESP-IDF instalado
- Para Godot: tener Godot instalado (solo PC)
- Para Unreal: solo disponible en perfil "Casa"

---

## 1. C y C++ (Modulo 30)

### El problema que FORJA resuelve

Un estudiante que esta aprendiendo estructuras de datos en C no deberia tener que pelear con Makefiles y flags de compilacion. FORJA simplifica esto: escribes tu codigo y presionas F5.

### Ejecutar un archivo C simple

1. Crea `main.c`:
   ```c
   #include <stdio.h>

   int main() {
       int numeros[] = {10, 20, 30, 40, 50};
       int suma = 0;

       for (int i = 0; i < 5; i++) {
           suma += numeros[i];
           printf("Acumulado: %d\n", suma);
       }

       printf("Suma total: %d\n", suma);
       return 0;
   }
   ```
2. Presiona `F5`
3. FORJA detecta que es un archivo C aislado, lo compila con `gcc` y lo ejecuta

### Proyectos con Makefile o CMake

Cuando tu proyecto tiene un `Makefile` o `CMakeLists.txt`, FORJA lo detecta automaticamente:

| Tecla Hydra | Con Makefile | Con CMake |
| :---: | :--- | :--- |
| `r` (Run) | `make run` o `make && ./programa` | `cmake --build build && ./build/programa` |
| `b` (Build) | `make` | `cmake --build build` |
| `f` (Format) | `clang-format` | `clang-format` |

**No necesitas recordar que sistema de build usa tu proyecto.** Presiona `F5` y FORJA se encarga.

### Crear un proyecto C/C++ desde template

| Comando | Que genera |
| :--- | :--- |
| `C-c n c` | Proyecto C con `main.c` + `Makefile` + `.gitignore` |
| `C-c n C` | Proyecto C++ con `main.cpp` + `CMakeLists.txt` + `.gitignore` |

**Ejemplo: Proyecto C con Makefile**

1. `C-c n c` → nombre: `estructuras`
2. Se crea:
   ```
   estructuras/
   ├── main.c          ← Tu codigo
   ├── Makefile         ← Compilacion automatica
   ├── .gitignore       ← Ignora binarios
   └── .git/            ← Repositorio inicializado
   ```
3. Abre `main.c`, escribe tu programa
4. `F5` para compilar y ejecutar
5. `C-c x f` para formatear con `clang-format`

### Formateo con clang-format

`clang-format` reorganiza tu codigo C/C++ segun un estilo estandar:

Antes:
```c
int main(){int x=5;if(x>3){printf("Hola");printf("Mundo");}return 0;}
```

Despues de `C-c x f`:
```c
int main() {
    int x = 5;
    if (x > 3) {
        printf("Hola");
        printf("Mundo");
    }
    return 0;
}
```

### Autocompletado con clangd

El LSP `clangd` te ofrece:
- Autocompletado de funciones de la libreria estandar (`stdio.h`, `stdlib.h`, `string.h`)
- Deteccion de errores de compilacion en tiempo real (sin necesidad de compilar)
- Informacion de tipos y parametros de funciones
- `F12` para ir a la definicion de cualquier funcion, incluso las del sistema

## 2. Game Dev con Raylib

Raylib es una libreria para crear juegos 2D/3D en C/C++. Es ideal para aprender programacion de juegos porque es simple y directa.

### Crear un proyecto de juego

| Comando | Que genera |
| :--- | :--- |
| `C-c n g` | Juego Raylib en C con Makefile |
| `C-c n +` | Juego Raylib en C++ con CMake |

### Ejemplo: Tu primer juego con Raylib

1. `C-c n g` → nombre: `mi-juego`
2. Abre `main.c` — el template viene con un ejemplo basico:
   ```c
   #include "raylib.h"

   int main(void) {
       InitWindow(800, 450, "Mi Juego - FORJA");
       SetTargetFPS(60);

       int pelota_x = 400;
       int pelota_y = 225;
       int velocidad = 5;

       while (!WindowShouldClose()) {
           // Logica
           if (IsKeyDown(KEY_RIGHT)) pelota_x += velocidad;
           if (IsKeyDown(KEY_LEFT))  pelota_x -= velocidad;
           if (IsKeyDown(KEY_DOWN))  pelota_y += velocidad;
           if (IsKeyDown(KEY_UP))    pelota_y -= velocidad;

           // Dibujo
           BeginDrawing();
               ClearBackground(RAYWHITE);
               DrawCircle(pelota_x, pelota_y, 20, RED);
               DrawText("Usa las flechas para mover", 10, 10, 20, DARKGRAY);
           EndDrawing();
       }

       CloseWindow();
       return 0;
   }
   ```
3. Presiona `F5` — se compila y se abre la ventana del juego
4. Usa las flechas del teclado para mover la pelota

### Flujo de desarrollo de juegos

```
Escribir codigo → F5 (compilar y ver) → Cerrar ventana → Modificar → F5 de nuevo
```

El ciclo es rapido: no necesitas salir de Emacs para probar tu juego.

## 3. ESP32: Sistemas Embebidos (Modulo 30)

> Solo disponible en PC (Arch Linux). No funciona en Termux ni WSL.

Si trabajas con microcontroladores ESP32 usando ESP-IDF (el framework oficial de Espressif):

### La tecla dorada: F6

`F6` ejecuta la cadena completa de desarrollo embebido en un solo paso:

1. **Build:** Compila tu firmware (`idf.py build`)
2. **Flash:** Lo graba en el ESP32 conectado por USB (`idf.py flash`)
3. **Monitor:** Abre un monitor serial para ver la salida del chip (`idf.py monitor`)

Todo esto sucede automaticamente. No necesitas recordar los comandos de ESP-IDF.

### Flujo tipico de trabajo con ESP32

1. Conecta tu ESP32 por USB
2. Abre tu proyecto ESP-IDF en FORJA
3. Edita tu codigo en `main/main.c`
4. Presiona `F6`
5. Observa la salida en el monitor serial:
   ```
   I (325) cpu_start: Starting scheduler.
   I (330) main: Hola desde ESP32!
   I (1330) main: Temperatura: 24.5°C
   ```
6. Para detener el monitor: `C-c x k` (Stop)

### Autocompletado para ESP-IDF

FORJA configura `clangd` para que reconozca las librerias de ESP-IDF. Esto significa que obtienes:
- Autocompletado de funciones como `gpio_set_direction()`, `esp_wifi_init()`, etc.
- Navegacion con `F12` al codigo fuente de ESP-IDF
- Deteccion de errores antes de compilar

## 4. Godot y GDScript (Modulo 41)

> Solo disponible en PC (Arch Linux). Requiere Godot instalado.

FORJA se conecta al motor Godot para darte autocompletado nativo de GDScript.

### Como funciona la conexion

Cuando abres un archivo `.gd`, FORJA:
1. Detecta que es GDScript
2. Se conecta al LSP de Godot via TCP (el motor debe estar corriendo, aunque sea minimizado)
3. Te ofrece autocompletado de clases, metodos y propiedades de Godot

### Flujo de trabajo

1. Abre tu proyecto de Godot normalmente (desde Godot)
2. En FORJA, navega a los archivos `.gd` del proyecto
3. Edita con autocompletado de clases de Godot (`Node2D`, `CharacterBody2D`, etc.)
4. Formatea con `C-c x f` (usa `gdformat`)
5. Prueba directamente desde Godot

### Ejemplo de codigo GDScript con autocompletado

```gdscript
extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = direction * speed
    move_and_slide()
```

Al escribir `Input.get_`, el autocompletado te mostrara todos los metodos disponibles de la clase `Input`.

## 5. Unreal Engine (Modulo 40)

> Solo disponible en perfil "Casa" (PC dedicado). No funciona en Escuela, Termux ni WSL.

Los proyectos de Unreal Engine son extremadamente grandes (millones de archivos de headers). FORJA aplica optimizaciones especiales:

### Optimizaciones automaticas

- **Treemacs desactivado:** No intenta indexar millones de archivos
- **LSP selectivo:** Solo analiza los archivos que tienes abiertos, no todo el proyecto
- **Indexador suprimido:** Evita lecturas masivas de disco que saturarian la RAM
- **Mismos atajos de C++:** Build, Run y Format funcionan igual que con CMake

### Flujo de trabajo recomendado

1. Abre los archivos `.cpp` y `.h` especificos que necesitas editar
2. Usa `C-c p f` (Projectile) para buscar archivos por nombre en lugar de navegar carpetas
3. `F12` funciona para ir a definiciones, pero puede tardar unos segundos en proyectos grandes
4. Compila desde el Hydra (`C-c x b`) o desde el editor de Unreal

---

## Tabla Resumen: Disponibilidad por Plataforma

| Funcionalidad | PC (Arch) | Termux | WSL2 |
| :--- | :---: | :---: | :---: |
| C/C++ (gcc/clang) | Si | Si (solo clang) | Si |
| GDB Debugger | Si | No | Si |
| ESP32 (F6) | Si | No | No |
| Raylib (juegos) | Si | No | No |
| Godot (GDScript) | Si | No | No |
| Unreal Engine | Solo perfil Casa | No | No |
| FASM (Assembly x86) | Si | No | No |

---

## Ejercicio Practico: Compilar y Ejecutar C

1. **Genera un proyecto C:** `C-c n c` → nombre: `ejercicio-c`
2. **Abre `main.c`** y escribe:
   ```c
   #include <stdio.h>
   #include <string.h>

   typedef struct {
       char nombre[50];
       int edad;
       float promedio;
   } Alumno;

   void mostrar(Alumno a) {
       printf("Nombre: %s | Edad: %d | Promedio: %.1f\n",
              a.nombre, a.edad, a.promedio);
   }

   int main() {
       Alumno alumnos[3] = {
           {"Ana Garcia", 17, 8.5},
           {"Carlos Lopez", 18, 9.2},
           {"Maria Torres", 16, 7.8}
       };

       printf("=== Lista de Alumnos ===\n");
       for (int i = 0; i < 3; i++) {
           mostrar(alumnos[i]);
       }

       return 0;
   }
   ```
3. **Guarda:** `C-x C-s`
4. **Formatea:** `C-c x f` — observa como `clang-format` alinea el codigo
5. **Ejecuta:** `F5` — deberas ver la lista de alumnos en el panel inferior
6. **Prueba el autocompletado:** Escribe `printf(` y observa como el LSP te muestra los parametros que acepta
7. **Navega con F12:** Posicionate sobre `printf` y presiona `F12` — te llevara a la definicion en `stdio.h`

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| F5 dice "gcc: command not found" | gcc no esta instalado | En Arch: `sudo pacman -S gcc`. En Termux: `pkg install clang` |
| "No rule to make target" | Makefile con error o no existe | Usa un template (`C-c n c`) o verifica que el Makefile tenga un target `run` |
| F6 no detecta el ESP32 | El puerto USB no se asigno | Verifica con `ls /dev/ttyACM*` o `/dev/ttyUSB*` en terminal |
| Godot no autocompletado | El motor no esta corriendo | Abre Godot primero (puede estar minimizado), luego edita en FORJA |
| Raylib no encuentra headers | Falta instalar Raylib | En Arch: `sudo pacman -S raylib` |
| Compilacion lenta en Unreal | Es normal en proyectos UE | La primera vez es lenta. Usa builds incrementales |

## Resumen de Atajos de esta Guia

```
F5           → Compilar y ejecutar (C/C++/Raylib)
F6           → Flash + Monitor ESP32
F9           → Iniciar GDB Debugger (ver Guia 10)
C-c x b      → Build (make / cmake)
C-c x r      → Run
C-c x f      → Format (clang-format / gdformat)
C-c n c      → Template C (Makefile)
C-c n C      → Template C++ (CMake)
C-c n g      → Template Raylib C
C-c n +      → Template Raylib C++
```

---

**Anterior:** [Guia 04: Lenguajes Backend](04_Lenguajes_Backend.md) | **Siguiente:** [Guia 06: Inteligencia Artificial](06_Inteligencia_Artificial.md) | [Volver al README](../README.md)
