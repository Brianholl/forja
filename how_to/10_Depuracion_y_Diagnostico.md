# Guia 10: Depuracion, Diagnostico y Assembly

> Aprende a encontrar y corregir errores usando el depurador GDB, los diagnosticos del LSP, la vista de codigo Assembly y las herramientas de traduccion.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Usar el depurador GDB desde FORJA para inspeccionar programas C/C++ paso a paso
- Interpretar y navegar los diagnosticos del LSP (errores y advertencias)
- Visualizar el codigo Assembly generado por tu programa
- Usar la herramienta de traduccion integrada (`C-c T`)

## Prerequisitos

- Haber completado la [Guia 05: Juegos y Sistemas](05_Juegos_y_Sistemas.md) (para la parte de C/C++)
- Estar en **PC (Arch Linux)** o **WSL2** para usar GDB. No disponible en Termux
- Tener `gdb` instalado (ya incluido en FORJA para PC)

---

## 1. Depuracion con GDB (F9)

### Que es un depurador

Un depurador te permite ejecutar tu programa **paso a paso**, detenerte en cualquier linea y examinar el valor de las variables en ese momento exacto. Es la herramienta fundamental para encontrar bugs que no puedes resolver solo leyendo el codigo.

### Cuando usar el depurador

- Tu programa compila pero da resultados incorrectos
- Hay un crash (segmentation fault) y no sabes en que linea ocurre
- Necesitas entender que valor tiene una variable en un momento especifico
- Un loop se ejecuta mas veces de lo esperado

### Iniciar GDB

1. Abre tu archivo C o C++
2. Presiona `F9` (o `C-c x d` desde el Hydra)
3. FORJA compila tu programa con simbolos de depuracion (`-g`) y abre la interfaz de GDB

### La interfaz de GDB en FORJA

Al iniciar GDB, la pantalla se divide en varios paneles:

```
┌─────────────────────┬──────────────────────┐
│                     │   Variables locales   │
│   Tu codigo         │   x = 5              │
│   (con linea        │   suma = 15          │
│    actual marcada)  │   i = 3              │
│                     ├──────────────────────┤
│                     │   Stack (pila de     │
│                     │   llamadas)          │
├─────────────────────┴──────────────────────┤
│   Consola GDB                              │
│   (gdb) _                                  │
└────────────────────────────────────────────┘
```

### Breakpoints (puntos de interrupcion)

Un breakpoint es un marcador que le dice al depurador "detente aqui". Para colocar uno:

1. En tu codigo, posiciona el cursor en la linea donde quieres detenerte
2. Presiona `C-c C-b` (o haz clic en el margen izquierdo si estas en modo grafico)
3. Aparece un indicador rojo en esa linea
4. Al ejecutar, el programa se detiene ahi

Para quitar un breakpoint: repite `C-c C-b` en la misma linea.

### Controles de ejecucion

Una vez que el programa esta detenido en un breakpoint:

| Tecla / Comando | Accion | Descripcion |
| :---: | :--- | :--- |
| `n` o `F10` | **Next** | Ejecuta la linea actual y avanza a la siguiente (no entra en funciones) |
| `s` o `F11` | **Step** | Ejecuta la linea actual y **entra** dentro de la funcion si hay una |
| `c` | **Continue** | Continua la ejecucion hasta el siguiente breakpoint o el final |
| `r` | **Run** | Reinicia el programa desde el principio |
| `q` | **Quit** | Sale del depurador |
| `p variable` | **Print** | Muestra el valor actual de una variable |

> **Nota:** Estas teclas funcionan en la consola GDB (el panel inferior). En algunos modos, las teclas de funcion F10/F11 funcionan directamente.

### Ejemplo paso a paso: Depurar un programa

Supongamos que tienes este programa con un bug:

```c
#include <stdio.h>

int buscar(int arr[], int n, int objetivo) {
    for (int i = 0; i <= n; i++) {  // Bug: deberia ser i < n
        if (arr[i] == objetivo) {
            return i;
        }
    }
    return -1;
}

int main() {
    int numeros[] = {10, 20, 30, 40, 50};
    int pos = buscar(numeros, 5, 60);
    printf("Posicion: %d\n", pos);
    return 0;
}
```

El programa a veces crashea. Para encontrar el bug:

1. **Abre el archivo** y presiona `F9`
2. **Coloca un breakpoint** en la linea del `for`: `C-c C-b`
3. **Ejecuta** con `r` (Run) en la consola GDB
4. El programa se detiene en el `for`
5. **Avanza paso a paso** con `n` (Next) y observa:
   - En el panel de variables locales, veras `i` incrementandose: 0, 1, 2, 3, 4...
   - Cuando `i` llega a **5**, el programa sigue en el loop — ahi esta el bug
   - Con `i = 5`, accede a `arr[5]` que esta fuera del array (solo tiene indices 0-4)
6. **Diagnostico:** La condicion deberia ser `i < n`, no `i <= n`

### Inspeccionar variables

En la consola GDB puedes examinar cualquier variable:

```
(gdb) p i
$1 = 3

(gdb) p arr[i]
$2 = 40

(gdb) p numeros
$3 = {10, 20, 30, 40, 50}

(gdb) p sizeof(numeros)/sizeof(numeros[0])
$4 = 5
```

### Inspeccionar la pila de llamadas

Cuando tu programa crashea dentro de una funcion anidada, necesitas saber "como llego ahi":

```
(gdb) bt
#0  buscar (arr=0x7fff..., n=5, objetivo=60) at main.c:4
#1  main () at main.c:14
```

Esto te muestra que `main()` llamo a `buscar()` y el crash fue en la linea 4 de `main.c`.

## 2. Diagnosticos del LSP (Errores en Vivo)

El LSP detecta errores en tu codigo **mientras escribes**, sin necesidad de compilar. Esto funciona en todos los lenguajes soportados.

### Tipos de diagnosticos

| Indicador | Tipo | Significado |
| :---: | :--- | :--- |
| Rojo (subrayado) | **Error** | El codigo no compilara / no funcionara |
| Amarillo (subrayado) | **Advertencia** | Funciona pero hay un problema potencial |
| Azul (subrayado) | **Informacion** | Sugerencia de mejora |

### Navegar errores

#### Ver todos los errores del archivo

1. Presiona `C-c x e` (Errors en Hydra)
2. Se abre una lista con todos los diagnosticos:
   ```
   main.c:4:23: error: comparison of integers of different signs
   main.c:8:5: warning: unused variable 'resultado'
   main.c:15:1: error: expected ';' after expression
   ```
3. Haz clic o presiona `Enter` en un error para saltar a esa linea

#### Saltar entre errores

| Tecla | Accion |
| :---: | :--- |
| `C-c ! n` | Saltar al **siguiente** error |
| `C-c ! p` | Saltar al error **anterior** |
| `C-c x e` | Ver **lista completa** de errores |

### Ejemplos de errores comunes detectados por el LSP

**Python — import faltante:**
```python
resultado = json.loads(datos)  # Error: 'json' is not defined
```
Solucion: agregar `import json` al principio del archivo.

**Go — variable no usada:**
```go
x := 42  # Error: x declared and not used
```
En Go, las variables no usadas son un error de compilacion.

**Rust — tipo incompatible:**
```rust
let x: i32 = "hola";  # Error: expected i32, found &str
```

**C — punto y coma faltante:**
```c
int x = 5  // Error: expected ';' after expression
```

> **Tip para Termux:** En Termux, los diagnosticos se actualizan al guardar (`C-x C-s`) en lugar de en tiempo real, para ahorrar recursos. Si quieres ver errores, guarda el archivo primero.

## 3. Vista de Assembly (`C-c d a`)

Para estudiantes de arquitectura de computadoras o quienes quieren entender que hace el procesador realmente:

### Que es la vista de Assembly

Cuando escribes codigo en C, el compilador lo traduce a instrucciones de maquina (Assembly). FORJA te permite ver esa traduccion directamente.

### Como usarla

1. Abre un archivo C o C++
2. Presiona `C-c d a` (Disassembly / Assembly)
3. Se abre un panel mostrando el Assembly generado

### Ejemplo

Tu codigo C:
```c
int sumar(int a, int b) {
    return a + b;
}
```

El Assembly generado (x86-64):
```asm
sumar:
    push   rbp
    mov    rbp, rsp
    mov    DWORD PTR [rbp-4], edi    ; parametro a
    mov    DWORD PTR [rbp-8], esi    ; parametro b
    mov    edx, DWORD PTR [rbp-4]
    mov    eax, DWORD PTR [rbp-8]
    add    eax, edx                   ; a + b
    pop    rbp
    ret                               ; retornar resultado
```

### FASM (Flat Assembler)

> Solo disponible en PC (Arch Linux).

Si tu materia requiere programar directamente en Assembly x86, FORJA soporta FASM:

1. Crea un archivo `.asm`
2. Escribe tu codigo Assembly
3. `F5` para ensamblar y ejecutar

```asm
format ELF64 executable
entry _start

segment readable executable
_start:
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    mov rsi, mensaje    ; direccion del mensaje
    mov rdx, 13         ; longitud
    syscall

    mov rax, 60         ; syscall exit
    xor rdi, rdi        ; codigo 0
    syscall

segment readable
mensaje db "Hola mundo!", 10
```

## 4. Traduccion Integrada (`C-c T`)

FORJA incluye una herramienta de traduccion que usa Ollama localmente:

1. Selecciona el texto que quieres traducir (con `C-Space` + movimiento)
2. Presiona `C-c T`
3. El texto se traduce y aparece en un buffer aparte

Esto es util para:
- Traducir documentacion tecnica en ingles
- Entender mensajes de error en otros idiomas
- Traducir comentarios de codigo

> Requiere Ollama corriendo con un modelo de lenguaje. Solo disponible en PC.

---

## Ejercicio Practico: Encontrar un Bug con GDB

1. **Crea un proyecto C:** `C-c n c` → nombre: `practica-debug`
2. **Escribe este programa con un bug intencional:**
   ```c
   #include <stdio.h>

   void invertir(char str[], int len) {
       int i = 0;
       int j = len;  // Bug: deberia ser len - 1
       char temp;

       while (i < j) {
           temp = str[i];
           str[i] = str[j];
           str[j] = temp;
           i++;
           j--;
       }
   }

   int main() {
       char mensaje[] = "FORJA";
       printf("Original: %s\n", mensaje);

       invertir(mensaje, 5);
       printf("Invertido: %s\n", mensaje);

       return 0;
   }
   ```
3. **Compila y ejecuta:** `F5` — deberas ver que el resultado invertido esta mal (probablemente vacio o corrupto)
4. **Inicia el depurador:** `F9`
5. **Coloca un breakpoint** en la linea `temp = str[i];`
6. **Ejecuta** con `r`
7. **En la primera iteracion**, examina:
   ```
   (gdb) p i
   0
   (gdb) p j
   5
   (gdb) p str[j]
   '\0'    ← Este es el caracter nulo de fin de string!
   ```
8. **Diagnostico:** `j` empieza en 5, pero `str[5]` es el `\0` (terminador). Deberia empezar en `len - 1` (que es 4, la ultima letra 'A')
9. **Corrige** cambiando `int j = len;` por `int j = len - 1;`
10. **Ejecuta de nuevo** con `F5` — ahora deberas ver "AJROF"

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| F9 dice "gdb not found" | GDB no esta instalado | En Arch: `sudo pacman -S gdb`. En Termux: no disponible |
| "No debugging symbols" | El programa no se compilo con `-g` | Usa F9 en lugar de F5 — FORJA agrega `-g` automaticamente para debug |
| Los breakpoints no se activan | La linea no tiene codigo ejecutable | Coloca el breakpoint en una linea con una instruccion real, no en lineas vacias o comentarios |
| El panel de variables esta vacio | El programa no esta detenido en un breakpoint | Asegurate de haber colocado un breakpoint y que el programa llego a esa linea |
| La vista Assembly es ilegible | Compilacion con optimizaciones | Compila sin optimizaciones (`-O0`) para una correspondencia mas clara con el codigo fuente |
| `C-c T` no traduce | Ollama no esta corriendo | Ejecuta `ollama serve` en otra terminal |

## Resumen de Atajos de esta Guia

```
F9           → Iniciar depurador GDB
C-c x d      → Debug (mismo que F9, desde Hydra)
C-c C-b      → Colocar/quitar breakpoint
C-c x e      → Ver lista de errores (diagnosticos LSP)
C-c ! n      → Saltar al siguiente error
C-c ! p      → Saltar al error anterior
C-c d a      → Ver codigo Assembly
C-c T        → Traducir texto seleccionado

Dentro de GDB:
n / F10      → Next (siguiente linea, sin entrar en funciones)
s / F11      → Step (siguiente linea, entrando en funciones)
c            → Continue (continuar hasta el siguiente breakpoint)
r            → Run (reiniciar programa)
p variable   → Print (mostrar valor de variable)
bt           → Backtrace (ver pila de llamadas)
q            → Quit (salir del depurador)
```

---

**Anterior:** [Guia 09: Automatizacion n8n](09_Automatizacion_n8n.md) | **Siguiente:** [Guia 11: Soporte y Extras](11_Soporte_y_Extras.md) | [Volver al README](../README.md)
