package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

type Cotizacion struct {
	Par    string  `json:"par"`
	Precio float64 `json:"precio"`
	Hora   string  `json:"hora"`
}

var rng = rand.New(rand.NewSource(time.Now().UnixNano()))

var bases = map[string]float64{
	"USD/ARS": 1050.0,
	"EUR/ARS": 1130.0,
	"BTC/USD": 62000.0,
	"ETH/USD": 3200.0,
}

func cotizaciones(w http.ResponseWriter, r *http.Request) {
	hora := time.Now().Format("15:04:05")
	datos := make([]Cotizacion, 0, len(bases))
	for par, base := range bases {
		variacion := (rng.Float64() - 0.5) * base * 0.02
		datos = append(datos, Cotizacion{
			Par:    par,
			Precio: base + variacion,
			Hora:   hora,
		})
	}
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	json.NewEncoder(w).Encode(datos)
}

func main() {
	http.HandleFunc("/cotizaciones", cotizaciones)
	fmt.Println("=== El Mensajero Veloz ===")
	fmt.Println("Servidor en http://localhost:8080")
	fmt.Println("Visitá: http://localhost:8080/cotizaciones")
	fmt.Println("(Ctrl-C para detener)")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Println("Error:", err)
	}
}
