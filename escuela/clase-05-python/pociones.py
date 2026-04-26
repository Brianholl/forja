#!/usr/bin/env python3
"""El Alquimista — generador de pociones."""

import random
import sys
from dataclasses import dataclass

INGREDIENTES = [
    "raíz de mandrágora",
    "polvo de dragón",
    "lágrimas de fénix",
    "musgo lunar",
    "cristal de tiempo",
    "seta del olvido",
    "escama de sirena",
    "ceniza de volcán",
]

EFECTOS = [
    "otorga visión nocturna por 1 hora",
    "duplica la velocidad de movimiento",
    "permite respirar bajo el agua",
    "hace invisible al portador",
    "cura todas las heridas menores",
    "confiere fuerza sobrehumana",
    "permite hablar con animales",
    "otorga resistencia al fuego",
]

COLORES = ["roja", "azul", "verde", "dorada", "plateada", "violeta", "turquesa", "carmesí"]
RAREZAS = ["común", "poco común", "rara", "épica", "legendaria"]


@dataclass
class Pocion:
    nombre: str
    color: str
    ingrediente: str
    efecto: str
    dosis: int
    rareza: str

    def __str__(self) -> str:
        estrellas = "★" * (RAREZAS.index(self.rareza) + 1)
        return (
            f"\n╔══ {self.nombre} [{estrellas}]\n"
            f"║  Color:       Poción {self.color}\n"
            f"║  Ingrediente: {self.ingrediente}\n"
            f"║  Efecto:      {self.efecto}\n"
            f"║  Dosis:       {self.dosis} uso(s)\n"
            f"╚══ Rareza:     {self.rareza}\n"
        )


def generar_pocion() -> "Pocion":
    ingrediente = random.choice(INGREDIENTES)
    rareza = random.choices(RAREZAS, weights=[40, 25, 20, 10, 5], k=1)[0]
    nombre_base = ingrediente.split()[-1].capitalize()
    return Pocion(
        nombre=f"Poción de {nombre_base}",
        color=random.choice(COLORES),
        ingrediente=ingrediente,
        efecto=random.choice(EFECTOS),
        dosis=random.randint(1, 5),
        rareza=rareza,
    )


def main() -> None:
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 3
    print("=== El Alquimista ===")
    print(f"Generando {n} poción(es)...\n")
    for _ in range(n):
        print(generar_pocion())


if __name__ == "__main__":
    main()
