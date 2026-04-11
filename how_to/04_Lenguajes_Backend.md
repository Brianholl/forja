# Guia 04: Lenguajes Backend y APIs

> Desarrolla servidores y APIs en Python, Go, Rust y PHP con autocompletado profesional, formateo automatico y ejecucion inteligente.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Escribir y ejecutar scripts en Python, Go, Rust y PHP
- Levantar servidores de desarrollo (FastAPI, Gin, Actix-web, Laravel) con F5
- Ejecutar tests unitarios desde el Hydra
- Formatear codigo automaticamente segun el estandar de cada lenguaje
- Entender como FORJA detecta el tipo de proyecto para adaptar su comportamiento

## Prerequisitos

- Haber completado la [Guia 01: Core y Entorno](01_Core_y_Entorno.md)
- Tener instalado al menos uno de los lenguajes (Python, Go, Rust, PHP)
- Opcional: haber completado la [Guia 03: Desarrollo Web](03_Desarrollo_Web.md) si te interesa crear APIs REST

---

## 1. Python (Modulo 34)

### Ejecutar un script simple

Para archivos Python independientes (ejercicios, scripts, calculos):

1. Crea un archivo `calculo.py`:
   ```python
   def factorial(n):
       if n <= 1:
           return 1
       return n * factorial(n - 1)

   for i in range(1, 11):
       print(f"{i}! = {factorial(i)}")
   ```
2. Presiona `F5` → se ejecuta con el interprete Python y ves la salida

### Proyectos FastAPI (deteccion automatica)

FORJA detecta automaticamente cuando estas en un proyecto FastAPI. Si la carpeta contiene archivos tipicos de FastAPI (`main.py` con `from fastapi import`):

| Tecla Hydra | Que ejecuta |
| :---: | :--- |
| `r` (Run) | `uvicorn main:app --reload` — inicia el servidor con recarga automatica |
| `b` (Build) | `pip install -r requirements.txt` — instala dependencias |
| `t` (Test) | `pytest` o `python -m unittest` — ejecuta tests |
| `f` (Format) | `black` — formatea segun PEP-8 estricto |

**Ejemplo: Crear una API FastAPI desde cero**

1. `C-c n` → `p` (Python REST API) → nombre: `mi-api-python`
2. El generador crea la estructura con FastAPI + uvicorn + venv
3. Presiona `F5` — se levanta el servidor
4. Abre tu navegador en `http://localhost:8000/docs` — veras Swagger con tus endpoints
5. Modifica el codigo, guarda, y el servidor se recarga automaticamente

### Proyectos Django

Si FORJA detecta un proyecto Django (`manage.py` presente):
- `F5` ejecuta `python manage.py runserver`
- `C-c x t` ejecuta `python manage.py test`

### Formateo con Black

Black es un formateador "sin opiniones" — siempre produce el mismo resultado:

1. Presiona `C-c x f` (Format en Hydra)
2. Tu codigo se reorganiza segun PEP-8:
   - Lineas de maximo 88 caracteres
   - Comillas dobles estandarizadas
   - Espacios consistentes

### Autocompletado con pylsp

El servidor de lenguaje `pylsp` te ofrece:
- Autocompletado de funciones, clases y modulos
- Informacion de parametros (que argumentos recibe una funcion)
- Deteccion de imports faltantes
- Navegacion a definiciones con `F12`

> **Tip:** Si usas un virtual environment (venv), FORJA lo detecta automaticamente si esta en la raiz del proyecto.

## 2. Go (Modulo 32)

### Ejecutar un programa Go

1. Crea un archivo `main.go`:
   ```go
   package main

   import "fmt"

   func main() {
       nombres := []string{"Ana", "Carlos", "Maria"}
       for i, nombre := range nombres {
           fmt.Printf("%d. Hola, %s!\n", i+1, nombre)
       }
   }
   ```
2. Presiona `F5` → ejecuta `go run .` y muestra la salida

### Comportamiento del Hydra en Go

| Tecla Hydra | Que ejecuta | Cuando usarlo |
| :---: | :--- | :--- |
| `r` (Run) | `go run .` | Ejecutar el programa |
| `b` (Build) | `go build` | Compilar sin ejecutar (generar binario) |
| `t` (Test) | `go test ./...` | Ejecutar todos los tests del proyecto |
| `f` (Format) | `gofmt` (via LSP) | Formatear — Go tiene formato canonico obligatorio |

### Proyectos con Gin (API REST)

1. `C-c n` → `a` (Go REST API) → nombre: `mi-api-go`
2. El generador crea un servidor con Gin + handlers + CORS
3. Presiona `F5` — el servidor arranca en `http://localhost:8080`
4. Prueba:
   ```bash
   curl http://localhost:8080/health
   # {"status": "ok"}

   curl http://localhost:8080/api/items
   # []

   curl -X POST http://localhost:8080/api/items \
     -H "Content-Type: application/json" \
     -d '{"name": "Item 1"}'
   # {"id": 1, "name": "Item 1"}
   ```

### Tests en Go

Go tiene testing integrado en el lenguaje. Los archivos de test terminan en `_test.go`:

```go
// math_test.go
package main

import "testing"

func TestSumar(t *testing.T) {
    resultado := sumar(2, 3)
    if resultado != 5 {
        t.Errorf("Esperaba 5, obtuve %d", resultado)
    }
}
```

Para ejecutarlos:
- Abre cualquier archivo del proyecto
- Presiona `C-c x t` → se ejecutan todos los `_test.go`
- Los resultados aparecen coloreados: verde (paso), rojo (fallo)

### Autocompletado con gopls

`gopls` es el LSP oficial de Go y es extremadamente potente:
- Autocompletado de funciones del paquete estandar y dependencias
- Inferencia de tipos — muestra el tipo de cada variable
- `F12` sobre `http.HandleFunc` te lleva al codigo fuente de la libreria estandar de Go
- Deteccion de variables no usadas, imports faltantes/sobrantes

> **Tip:** Go inserta imports automaticamente. Si escribes `fmt.Println` sin tener `"fmt"` importado, al guardar el archivo el import aparece automaticamente.

## 3. Rust (Modulo 31)

### Ejecutar un programa Rust

1. Crea un proyecto: `C-c n` → `r` (Rust generico) → nombre: `mi-rust`
2. Abre `src/main.rs`:
   ```rust
   fn main() {
       let numeros = vec![1, 2, 3, 4, 5];
       let suma: i32 = numeros.iter().sum();
       println!("La suma es: {}", suma);
   }
   ```
3. Presiona `F5` → ejecuta `cargo run`

### Comportamiento del Hydra en Rust

| Tecla Hydra | Que ejecuta | Descripcion |
| :---: | :--- | :--- |
| `r` (Run) | `cargo run` | Compilar y ejecutar |
| `b` (Build) | `cargo build` | Solo compilar (verificar errores sin ejecutar) |
| `t` (Test) | `cargo test` | Ejecutar tests definidos con `#[test]` |
| `f` (Format) | `rustfmt` (via LSP) | Formatear segun estilo canonico de Rust |

### El compilador de Rust en FORJA

Rust es famoso por sus mensajes de error extremadamente detallados. FORJA los aprovecha al maximo:

- **Errores en linea:** El linter (Flycheck) marca las lineas con errores directamente en el editor
- **Mensajes multilinea:** Los errores de Rust son largos y explicativos. FORJA los muestra completos en el panel de diagnosticos (`C-c x e`)
- **Tipos inferidos:** El LSP muestra los tipos inferidos como anotaciones fantasma en el codigo

**Ejemplo:** Si escribes:
```rust
let x = vec![1, 2, 3];
```
El LSP te mostrara algo como `Vec<i32>` al lado de la linea, ayudandote a entender que tipo infiere el compilador.

### Tests en Rust

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_suma() {
        assert_eq!(sumar(2, 3), 5);
    }

    #[test]
    fn test_suma_negativos() {
        assert_eq!(sumar(-1, 1), 0);
    }
}
```

Presiona `C-c x t` para ejecutarlos.

### Crear una API REST en Rust

1. `C-c n` → `R` (Rust REST API) → nombre: `mi-api-rust`
2. Genera un proyecto con Actix-web + serde + CORS
3. `F5` levanta el servidor

## 4. PHP (Modulo 35)

### Ejecutar un script PHP simple

1. Crea `prueba.php`:
   ```php
   <?php
   $nombre = "FORJA";
   $version = 1.0;
   echo "Bienvenido a $nombre v$version\n";

   for ($i = 1; $i <= 5; $i++) {
       echo "Iteracion $i\n";
   }
   ```
2. Presiona `F5` → ejecuta `php prueba.php`

### Comportamiento del Hydra en PHP

| Tecla Hydra | Que ejecuta | Descripcion |
| :---: | :--- | :--- |
| `r` (Run) | `php archivo.php` o `php artisan serve` | Depende del contexto |
| `b` (Build) | `composer install` | Instalar dependencias de Composer |
| `t` (Test) | `phpunit` o `php artisan test` | Ejecutar tests |
| `f` (Format) | Prettier | Formatear codigo PHP |

### Deteccion automatica de Laravel

FORJA detecta proyectos Laravel por la presencia de `artisan` en la raiz del proyecto. Cuando lo detecta:

- `F5` ejecuta `php artisan serve` en lugar de `php archivo.php`
- `C-c x t` ejecuta `php artisan test`
- `C-c x b` ejecuta `composer install`

**Ejemplo: Crear un proyecto Laravel**

1. `C-c n` → `P` (PHP REST API) → nombre: `mi-api-php`
2. El generador crea la estructura Laravel (o PHP manual si Laravel no esta instalado)
3. `C-c x b` para instalar dependencias con Composer
4. `F5` para levantar el servidor en `http://localhost:8000`

### Autocompletado con Intelephense

El LSP de PHP (`intelephense`) te ofrece:
- Autocompletado de funciones nativas de PHP y clases de tu proyecto
- Navegacion a definiciones con `F12`
- Deteccion de errores de sintaxis y tipos
- Soporte para PHPDoc

---

## Tabla Comparativa: Todos los Lenguajes Backend

| Aspecto | Python | Go | Rust | PHP |
| :--- | :--- | :--- | :--- | :--- |
| **LSP** | pylsp | gopls | rust-analyzer | intelephense |
| **Formateador** | black | gofmt | rustfmt | prettier |
| **Test runner** | pytest | go test | cargo test | phpunit |
| **F5 (script)** | `python archivo.py` | `go run .` | `cargo run` | `php archivo.php` |
| **F5 (API)** | `uvicorn` | `go run .` (con Gin) | `cargo run` (con Actix) | `artisan serve` |
| **Template API** | `C-c n p` | `C-c n a` | `C-c n R` | `C-c n P` |
| **Disponible en Termux** | Si | Si | Si | Si |

---

## Ejercicio Practico: Crear y Probar una API REST

Elige **uno** de los lenguajes y sigue estos pasos:

### Opcion A: API en Go
1. `C-c n a` → nombre: `ejercicio-api`
2. Abre `handlers.go` y agrega un nuevo endpoint:
   ```go
   func getHello(c *gin.Context) {
       c.JSON(200, gin.H{"message": "Hola desde FORJA!"})
   }
   ```
3. En `main.go`, agrega la ruta: `r.GET("/hello", getHello)`
4. Formatea: `C-c x f`
5. Ejecuta: `F5`
6. Prueba: `curl http://localhost:8080/hello`

### Opcion B: API en Python
1. `C-c n p` → nombre: `ejercicio-api`
2. Abre `main.py` y agrega:
   ```python
   @app.get("/hello")
   def hello():
       return {"message": "Hola desde FORJA!"}
   ```
3. Formatea: `C-c x f`
4. Ejecuta: `F5`
5. Prueba: abre `http://localhost:8000/docs` en el navegador

### Verificacion

En ambos casos, deberas obtener:
```json
{"message": "Hola desde FORJA!"}
```

Si funciono, ya sabes crear y extender APIs desde FORJA.

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| F5 dice "command not found: python" | Python no esta en el PATH | Verifica con `python3 --version`. En algunos sistemas se llama `python3` |
| `go run .` falla con "no Go files" | No hay `package main` en el directorio | Asegurate de que el archivo tenga `package main` y una funcion `main()` |
| `cargo run` muy lento la primera vez | Rust compila todas las dependencias | Es normal en la primera compilacion. Las siguientes seran rapidas |
| Intelephense no autocompletado | Falta la licencia o no inicio | Espera unos segundos. Si persiste, reinicia con `M-x lsp-restart-workspace` |
| "No module named fastapi" | Falta el venv o las dependencias | Ejecuta `C-c x b` (Build) para instalar dependencias |

## Resumen de Atajos de esta Guia

```
F5           → Ejecutar programa / levantar servidor
C-c x r      → Run (mismo que F5)
C-c x b      → Build (instalar dependencias)
C-c x t      → Test (ejecutar tests)
C-c x f      → Format (formatear codigo)
C-c x k      → Stop (detener servidor)
C-c n p      → Generar API Python (FastAPI)
C-c n a      → Generar API Go (Gin)
C-c n R      → Generar API Rust (Actix-web)
C-c n P      → Generar API PHP (Laravel)
F12          → Ir a definicion (LSP)
C-c x e      → Ver lista de errores
```

---

**Anterior:** [Guia 03: Desarrollo Web](03_Desarrollo_Web.md) | **Siguiente:** [Guia 05: Juegos y Sistemas](05_Juegos_y_Sistemas.md) | [Volver al README](../README.md)
