# Clase 04 — El Mensajero Veloz (Go)

> El Mensajero nunca descansa. Cada segundo trae nuevas cotizaciones desde los reinos del mercado.

## Objetivos

- Compilar y ejecutar un servidor HTTP con `go run`
- Ver autocompletado y diagnósticos de gopls (LSP)
- Entender structs, struct tags JSON y `map`
- Modificar endpoints y la respuesta JSON

## Módulo FORJA

`32-go` — Hydra Go: `C-c x`

## Flujo de la clase

### 1. Ejecutar el servidor

```
C-c x r    → go run main.go
```

Luego en otra terminal:
```bash
curl http://localhost:8080/cotizaciones | python3 -m json.tool
```

### 2. Ejercicio LSP: error de tipos

En `main.go`, cambiar:
```go
Precio: base + variacion,
```
por:
```go
Precio: "mucho",    // string en lugar de float64
```
gopls subraya el error antes de compilar. Deshacerlo con `C-/`.

### 3. Ejercicio: nuevo endpoint

Agregar `http.HandleFunc("/estado", ...)` que responda
`{"estado": "activo", "hora": "..."}`.

## Conceptos cubiertos

- `net/http`: servidor, handlers, `ResponseWriter`
- `encoding/json`: `json.NewEncoder`, struct tags `` `json:"..."` ``
- `map[string]float64` para datos base
- `math/rand` con semilla personalizada
- `go run` vs `go build`
