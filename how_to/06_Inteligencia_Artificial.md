# Guia 06: Inteligencia Artificial Local (Aider + Ollama)

> Usa IA para escribir, refactorizar, testear y corregir codigo directamente desde el editor — 100% local, sin API keys ni internet.

## Objetivos de Aprendizaje

Al completar esta guia seras capaz de:
- Iniciar una sesion de IA en tu proyecto y conversar en lenguaje natural
- Dar contexto a la IA agregando archivos relevantes
- Refactorizar codigo, generar tests y corregir errores con comandos directos
- Entender como funciona la IA local (Ollama + qwen2.5-coder)

## Prerequisitos

- Estar en **PC** (Arch Linux o perfil Casa/Escuela). Aider **no esta disponible** en Termux ni WSL
- Tener Ollama instalado con el modelo `qwen2.5-coder` descargado
- Haber completado la [Guia 01: Core y Entorno](01_Core_y_Entorno.md)

### Verificar que Ollama esta listo

En terminal:
```bash
ollama list
# Deberia mostrar algo como:
# qwen2.5-coder:latest    2.3 GB
```

Si no aparece, descarga el modelo:
```bash
ollama pull qwen2.5-coder
```

---

## 1. Que es Aider

Aider no es un chatbot que copia y pega codigo. Es un **agente de codigo** que:

- **Lee** tus archivos del proyecto
- **Entiende** el contexto (funciones, dependencias, imports)
- **Modifica** el codigo directamente en tus archivos
- **Hace commits** automaticos de cada cambio que realiza

Todo esto ocurre en tu maquina local. Tu codigo nunca sale de tu computadora.

### Diferencia con ChatGPT/Copilot

| Aspecto | ChatGPT/Copilot | Aider en FORJA |
| :--- | :--- | :--- |
| Donde corre | En la nube (servidores de terceros) | En tu maquina (100% local) |
| Necesita internet | Si | No |
| Necesita API key / pago | Si | No |
| Lee tu proyecto completo | No (copias y pegas fragmentos) | Si (accede a tus archivos directamente) |
| Modifica archivos | No (te da texto para copiar) | Si (edita directo y hace commits) |
| Privacidad | Tu codigo se envia a servidores externos | Tu codigo queda en tu maquina |

## 2. El Menu de IA (`C-c i`)

Todas las funciones de IA se acceden desde el menu `C-c i` (la "i" es de "Inteligencia"):

| Tecla | Accion | Descripcion |
| :---: | :--- | :--- |
| `C-c i o` | **Open** | Abrir el chat de IA en el proyecto actual |
| `C-c i a` | **Add** | Agregar archivos al contexto de la IA |
| `C-c i c` | **Change** | Refactorizar/modificar codigo seleccionado |
| `C-c i t` | **Test** | Generar tests automaticos para una funcion |
| `C-c i f` | **Fix** | Corregir errores detectados por el linter |

## 3. Iniciar una Sesion de Chat (`C-c i o`)

Esta es la forma principal de interactuar con la IA:

1. Abre tu proyecto (asegurate de estar en la carpeta correcta)
2. Presiona `C-c i o` (Open)
3. La pantalla se divide en dos:
   - **Arriba:** Tu codigo
   - **Abajo:** El chat con la IA
4. Escribe tu peticion en lenguaje natural

### Ejemplo de conversacion

```
Tu: Agrega validacion de email a la funcion de registro
```

La IA:
1. Lee los archivos de tu proyecto
2. Identifica la funcion de registro
3. Agrega la validacion directamente en el archivo
4. Hace un commit automatico: `feat: agregar validacion de email en registro`
5. Te muestra exactamente que cambio

### Otro ejemplo

```
Tu: Convierte esta API de JavaScript a TypeScript
```

La IA renombra archivos, agrega tipos, actualiza imports y hace commit de todo.

## 4. Dar Contexto a la IA (`C-c i a`)

La IA solo puede trabajar con los archivos que conoce. Por defecto, solo ve el archivo que tienes abierto. Para que entienda mas de tu proyecto:

1. Abre el archivo que quieres agregar al contexto
2. Presiona `C-c i a` (Add)
3. El archivo queda registrado en la memoria de corto plazo de la IA

### Cuando agregar contexto

- Cuando quieres que la IA modifique **multiples archivos** relacionados
- Cuando la IA necesita entender **como interactuan** distintas partes del codigo
- Cuando le pides algo que depende de **otro archivo** (como "haz que los estilos de main.css combinen con layout.html")

### Ejemplo practico

Tienes un proyecto con:
```
src/
├── database.go     ← Conexion a la base de datos
├── handlers.go     ← Endpoints de la API
├── models.go       ← Estructuras de datos
```

Quieres que la IA agregue un nuevo endpoint que use la base de datos:

1. Abre `database.go` → `C-c i a` (agregar al contexto)
2. Abre `models.go` → `C-c i a` (agregar al contexto)
3. Abre `handlers.go` → `C-c i a` (agregar al contexto)
4. Abre el chat: `C-c i o`
5. Escribe: "Agrega un endpoint GET /api/users que consulte todos los usuarios de la base de datos"

La IA ahora tiene contexto completo y puede generar codigo que realmente funcione con tus funciones y estructuras existentes.

## 5. Refactorizar Codigo (`C-c i c`)

Para cambios puntuales sin abrir el chat completo:

1. Selecciona un bloque de codigo (con `C-Space` + movimiento del cursor) o posicionate sobre una funcion
2. Presiona `C-c i c` (Change)
3. Aparece un mini-prompt donde escribes la instruccion:
   ```
   Cambiar todas las variables a camelCase
   ```
4. La IA aplica el cambio directamente

### Ejemplos de refactorizaciones utiles

| Instruccion | Que hace |
| :--- | :--- |
| "Cambiar a camelCase" | Renombra variables al estilo camelCase |
| "Agregar manejo de errores" | Envuelve el codigo en try/catch o if err != nil |
| "Simplificar esta funcion" | Reduce complejidad manteniendo funcionalidad |
| "Agregar comentarios explicativos" | Documenta el codigo |
| "Convertir for loop a map/filter" | Moderniza el estilo del codigo |

## 6. Generar Tests Automaticos (`C-c i t`)

Esta es una de las funciones mas utiles de Aider:

1. Abre el archivo con la funcion que quieres testear
2. Posicionate sobre la funcion (por ejemplo, `validarEmail`)
3. Presiona `C-c i t` (Test)
4. La IA genera un archivo de tests completo

### Ejemplo

Si tienes esta funcion en `validador.go`:
```go
func validarEmail(email string) bool {
    return strings.Contains(email, "@") && strings.Contains(email, ".")
}
```

Al presionar `C-c i t`, Aider genera `validador_test.go`:
```go
func TestValidarEmail(t *testing.T) {
    tests := []struct {
        email    string
        esperado bool
    }{
        {"user@example.com", true},
        {"invalido", false},
        {"@sin-nombre.com", true},
        {"sin-arroba.com", false},
        {"user@sin-punto", false},
        {"", false},
    }

    for _, tt := range tests {
        resultado := validarEmail(tt.email)
        if resultado != tt.esperado {
            t.Errorf("validarEmail(%q) = %v, esperaba %v",
                tt.email, resultado, tt.esperado)
        }
    }
}
```

La IA incluye **casos limite** (string vacio, falta de arroba, etc.) que probablemente no habrias pensado.

## 7. Auto-Corregir Errores (`C-c i f`)

Cuando el linter (Flycheck) detecta errores marcados en rojo:

1. Asegurate de que hay errores visibles (lineas rojas/amarillas)
2. Presiona `C-c i f` (Fix)
3. La IA:
   - Lee la salida del compilador/linter
   - Analiza el error
   - Intenta repararlo automaticamente
   - Hace commit del fix

### Ejemplo

Tu codigo tiene este error:
```python
import json

def procesar(datos):
    resultado = jsom.loads(datos)  # Error: 'jsom' no existe
    return resultado
```

El linter marca "undefined name 'jsom'". Al presionar `C-c i f`, la IA:
1. Ve el error del linter
2. Identifica que `jsom` es un typo de `json`
3. Corrige automaticamente a `json.loads(datos)`
4. Hace commit: `fix: corregir typo jsom → json`

---

## Ejercicio Practico: Tu Primera Sesion con IA

1. **Crea un proyecto Go:** `C-c n G` → nombre: `practica-ia`
2. **Abre `main.go`** y escribe:
   ```go
   package main

   import "fmt"

   func main() {
       fmt.Println("Hola")
   }
   ```
3. **Agrega el archivo al contexto:** `C-c i a`
4. **Abre el chat:** `C-c i o`
5. **Escribe esta peticion:**
   ```
   Agrega una funcion que reciba una lista de numeros enteros
   y retorne solo los numeros pares. Usala en main para
   filtrar los numeros del 1 al 20.
   ```
6. **Observa** como la IA modifica `main.go` directamente
7. **Ejecuta:** `F5` — deberas ver los numeros pares del 1 al 20
8. **Genera tests:** Posicionate sobre la funcion nueva y presiona `C-c i t`
9. **Ejecuta los tests:** `C-c x t`

## Buenas Practicas con la IA

1. **Se especifico:** "Agrega validacion de email con regex" es mejor que "mejora el codigo"
2. **Da contexto:** Agrega los archivos relevantes con `C-c i a` antes de pedir cambios complejos
3. **Revisa los cambios:** La IA hace commits automaticos, pero siempre revisa el diff con `C-x g` (Magit)
4. **Usa Git como red de seguridad:** Si la IA genera algo incorrecto, puedes revertir el commit desde Magit
5. **Empieza con funciones pequenas:** La IA es mas precisa con tareas especificas que con "reescribe todo"

## Errores Comunes

| Problema | Causa | Solucion |
| :--- | :--- | :--- |
| "Ollama not running" | El servicio de Ollama no esta activo | Ejecuta `ollama serve` en otra terminal |
| Chat muy lento | El modelo es grande para tu RAM | Usa un modelo mas pequeño o cierra otras aplicaciones |
| La IA modifica archivos incorrectos | Falta contexto | Agrega los archivos correctos con `C-c i a` |
| "No model found" | El modelo no esta descargado | Ejecuta `ollama pull qwen2.5-coder` |
| La IA no entiende el proyecto | Solo ve el archivo actual | Agrega mas archivos con `C-c i a` |
| Los cambios de la IA rompen algo | Ocurre a veces | Revierte el commit con Magit: `C-x g`, busca el commit, presiona `x` |

## Resumen de Atajos de esta Guia

```
C-c i        → Menu completo de IA (Aider)
C-c i o      → Abrir chat de IA en el proyecto
C-c i a      → Agregar archivo al contexto de la IA
C-c i c      → Refactorizar/cambiar codigo seleccionado
C-c i t      → Generar tests automaticos
C-c i f      → Corregir errores del linter con IA
```

---

**Anterior:** [Guia 05: Juegos y Sistemas](05_Juegos_y_Sistemas.md) | **Siguiente:** [Guia 07: Multiusuario y Sync](07_Multiusuario_y_Sync.md) | [Volver al README](../README.md)
