#include <iostream>
#include <string>
#include <vector>

enum class Material { Hierro, Acero, Mithril, Adamantio };

std::string nombre_material(Material m) {
    switch (m) {
        case Material::Hierro:    return "Hierro";
        case Material::Acero:     return "Acero";
        case Material::Mithril:   return "Mithril";
        case Material::Adamantio: return "Adamantio";
    }
    return "Desconocido";
}

class Espada {
    std::string nombre_;
    Material    material_;
    int         dano_;

public:
    Espada(std::string nombre, Material material, int dano)
        : nombre_(std::move(nombre)), material_(material), dano_(dano) {}

    const std::string& nombre()   const { return nombre_; }
    Material           material() const { return material_; }
    int                dano()     const { return dano_; }

    bool es_legendaria() const { return dano_ > 90; }

    friend std::ostream& operator<<(std::ostream& os, const Espada& e) {
        os << "[" << e.nombre_ << "] "
           << nombre_material(e.material_)
           << " — Daño: " << e.dano_;
        if (e.es_legendaria()) os << " ★ LEGENDARIA";
        return os;
    }
};

int main() {
    std::vector<Espada> inventario = {
        {"Daga del Novato",  Material::Hierro,    15},
        {"Hoja del Guerrero",Material::Acero,     55},
        {"Filo de Mithril",  Material::Mithril,   82},
        {"Excalibur",        Material::Adamantio,  98},
    };

    std::cout << "=== La Forja de la Espada ===\n\n";
    for (const auto& e : inventario) {
        std::cout << e << "\n";
    }

    std::cout << "\n--- Espadas legendarias ---\n";
    for (const auto& e : inventario) {
        if (e.es_legendaria())
            std::cout << "  » " << e.nombre() << "\n";
    }

    return 0;
}
