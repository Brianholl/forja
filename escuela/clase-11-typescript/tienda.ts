type TipoArticulo = "pocion" | "arma" | "armadura" | "reliquia";

interface Articulo {
    id: number;
    nombre: string;
    tipo: TipoArticulo;
    precio: number;
    stock: number;
}

interface ItemCarrito {
    articulo: Articulo;
    cantidad: number;
}

class TiendaMagica {
    private catalogo: Articulo[] = [];
    private carrito: ItemCarrito[] = [];
    private nextId = 1;

    agregar(nombre: string, tipo: TipoArticulo, precio: number, stock: number): void {
        this.catalogo.push({ id: this.nextId++, nombre, tipo, precio, stock });
    }

    listarCatalogo(): void {
        console.log("\n── Catálogo ───────────────────────────────────────────");
        for (const a of this.catalogo) {
            console.log(
                `  [${String(a.id).padStart(2)}] ${a.nombre.padEnd(22)} ${a.tipo.padEnd(10)} ` +
                `${a.precio} oro  (stock: ${a.stock})`
            );
        }
        console.log("───────────────────────────────────────────────────────");
    }

    comprar(id: number, cantidad: number = 1): boolean {
        const art = this.catalogo.find(a => a.id === id);
        if (!art)                  { console.log(`  ✗ Artículo ${id} no encontrado.`);           return false; }
        if (art.stock < cantidad)  { console.log(`  ✗ Stock insuficiente para "${art.nombre}".`); return false; }

        art.stock -= cantidad;
        const existente = this.carrito.find(i => i.articulo.id === id);
        if (existente) {
            existente.cantidad += cantidad;
        } else {
            this.carrito.push({ articulo: art, cantidad });
        }
        console.log(`  ✓ Agregado: ${cantidad}x ${art.nombre}`);
        return true;
    }

    verCarrito(): void {
        console.log("\n── Carrito ────────────────────────────────────────────");
        if (this.carrito.length === 0) { console.log("  (vacío)"); return; }
        let total = 0;
        for (const item of this.carrito) {
            const subtotal = item.articulo.precio * item.cantidad;
            total += subtotal;
            console.log(`  ${item.cantidad}x ${item.articulo.nombre.padEnd(22)} ${subtotal} oro`);
        }
        console.log(`  ${"─".repeat(40)}`);
        console.log(`  Total: ${total} oro`);
        console.log("───────────────────────────────────────────────────────");
    }

    buscarPorTipo(tipo: TipoArticulo): Articulo[] {
        return this.catalogo.filter(a => a.tipo === tipo && a.stock > 0);
    }
}

const tienda = new TiendaMagica();
tienda.agregar("Poción de Vida",      "pocion",   50,  20);
tienda.agregar("Poción de Maná",      "pocion",   45,  15);
tienda.agregar("Espada Élfica",       "arma",    320,   3);
tienda.agregar("Hacha del Berserker", "arma",    280,   2);
tienda.agregar("Escudo de Roble",     "armadura", 180,  5);
tienda.agregar("Amuleto de la Luna",  "reliquia", 650,  1);

console.log("=== La Tienda Mágica ===");
tienda.listarCatalogo();

tienda.comprar(1, 3);
tienda.comprar(3, 1);
tienda.comprar(6, 1);
tienda.comprar(6, 1);

tienda.verCarrito();

const pociones = tienda.buscarPorTipo("pocion");
console.log(`\nPociones disponibles: ${pociones.length}`);
pociones.forEach(p => console.log(`  • ${p.nombre} (${p.stock} en stock)`));
