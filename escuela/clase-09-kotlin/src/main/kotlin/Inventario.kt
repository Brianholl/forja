enum class Tipo { ARMA, ARMADURA, POCION, TESORO }

data class Objeto(
    val nombre: String,
    val tipo: Tipo,
    val peso: Double,
    val valor: Int,
)

class Inventario(val capacidad: Double = 50.0) {
    private val objetos = mutableListOf<Objeto>()

    val pesoTotal: Double get() = objetos.sumOf { it.peso }
    val valorTotal: Int   get() = objetos.sumOf { it.valor }

    fun agregar(obj: Objeto): Boolean {
        if (pesoTotal + obj.peso > capacidad) {
            println("  ✗ No entra '${obj.nombre}' (${obj.peso} kg, capacidad llena)")
            return false
        }
        objetos.add(obj)
        println("  ✓ Agregado: ${obj.nombre}")
        return true
    }

    fun listar() {
        println("\n┌─ Inventario (${pesoTotal}/${capacidad} kg | ${valorTotal} oro) ──────────")
        if (objetos.isEmpty()) {
            println("│  (vacío)")
        } else {
            objetos.forEach { o ->
                println("│  [${o.tipo.name.padEnd(8)}]  ${o.nombre.padEnd(22)}  ${o.peso} kg  ${o.valor} oro")
            }
        }
        println("└─────────────────────────────────────────────────────────────")
    }

    fun filtrarPorTipo(tipo: Tipo) = objetos.filter { it.tipo == tipo }
}

fun main() {
    println("=== El Inventario Mágico ===\n")

    val inv = Inventario(capacidad = 30.0)

    inv.agregar(Objeto("Espada de Acero",   Tipo.ARMA,     3.5,  150))
    inv.agregar(Objeto("Cota de Malla",     Tipo.ARMADURA, 12.0, 300))
    inv.agregar(Objeto("Poción de Vida",    Tipo.POCION,   0.5,   50))
    inv.agregar(Objeto("Poción de Maná",    Tipo.POCION,   0.5,   45))
    inv.agregar(Objeto("Rubí del Dragón",   Tipo.TESORO,   0.1,  800))
    inv.agregar(Objeto("Armadura Completa", Tipo.ARMADURA, 18.0, 600))

    inv.listar()

    val pociones = inv.filtrarPorTipo(Tipo.POCION)
    println("\nPociones disponibles: ${pociones.size}")
    pociones.forEach { println("  • ${it.nombre} (${it.valor} oro)") }
}
