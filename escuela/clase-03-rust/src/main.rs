use std::collections::HashMap;
use std::io::{self, Write};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
enum Sala {
    Entrada,
    Pasillo,
    Bodega,
    TorreSur,
    Salida,
}

#[derive(Debug, Clone)]
struct Descripcion {
    texto:  &'static str,
    norte:  Option<Sala>,
    sur:    Option<Sala>,
    este:   Option<Sala>,
    oeste:  Option<Sala>,
}

fn construir_mapa() -> HashMap<Sala, Descripcion> {
    let mut m = HashMap::new();
    m.insert(Sala::Entrada, Descripcion {
        texto: "La entrada del castillo. Un largo pasillo se extiende al norte.",
        norte: Some(Sala::Pasillo), sur: None, este: None, oeste: None,
    });
    m.insert(Sala::Pasillo, Descripcion {
        texto: "Un pasillo oscuro. Al este hay una bodega; al norte, una torre; al sur, la entrada.",
        norte: Some(Sala::TorreSur), sur: Some(Sala::Entrada),
        este:  Some(Sala::Bodega),  oeste: None,
    });
    m.insert(Sala::Bodega, Descripcion {
        texto: "Una bodega húmeda llena de barriles. Solo puedes salir al oeste.",
        norte: None, sur: None, este: None, oeste: Some(Sala::Pasillo),
    });
    m.insert(Sala::TorreSur, Descripcion {
        texto: "La cima de la torre. Al este brilla la salida del laberinto.",
        norte: None, sur: Some(Sala::Pasillo), este: Some(Sala::Salida), oeste: None,
    });
    m.insert(Sala::Salida, Descripcion {
        texto: "¡La salida! Ferris respira aire fresco. ¡Misión cumplida!",
        norte: None, sur: None, este: None, oeste: None,
    });
    m
}

fn parse_input(input: &str) -> Option<&'static str> {
    match input.trim().to_lowercase().as_str() {
        "n" | "norte" => Some("norte"),
        "s" | "sur"   => Some("sur"),
        "e" | "este"  => Some("este"),
        "o" | "oeste" => Some("oeste"),
        "salir" | "q" => Some("salir"),
        _             => None,
    }
}

fn main() {
    let mapa = construir_mapa();
    let mut pos = Sala::Entrada;

    println!("=== Ferris el Explorador ===");
    println!("Comandos: norte (n), sur (s), este (e), oeste (o), salir (q)\n");

    loop {
        let sala = &mapa[&pos];
        println!("\n[{}]", format!("{:?}", pos).to_uppercase());
        println!("{}", sala.texto);

        if pos == Sala::Salida {
            break;
        }

        let mut salidas = Vec::new();
        if sala.norte.is_some() { salidas.push("norte"); }
        if sala.sur.is_some()   { salidas.push("sur"); }
        if sala.este.is_some()  { salidas.push("este"); }
        if sala.oeste.is_some() { salidas.push("oeste"); }
        println!("Salidas: {}", salidas.join(", "));

        print!("> ");
        io::stdout().flush().unwrap();

        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();

        match parse_input(&input) {
            Some("salir") => { println!("¡Hasta la próxima, explorador!"); break; }
            Some("norte") => pos = sala.norte.unwrap_or_else(|| { println!("No hay salida al norte."); pos }),
            Some("sur")   => pos = sala.sur.unwrap_or_else(||   { println!("No hay salida al sur.");   pos }),
            Some("este")  => pos = sala.este.unwrap_or_else(||  { println!("No hay salida al este.");  pos }),
            Some("oeste") => pos = sala.oeste.unwrap_or_else(|| { println!("No hay salida al oeste."); pos }),
            _ => println!("No entendí '{}'. Usá: norte, sur, este, oeste.", input.trim()),
        }
    }
}
