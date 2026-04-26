public class Grifo extends Bestia {

    public Grifo(String nombre, int vida, int ataque) {
        super(nombre, vida, ataque);
    }

    @Override
    public String rugido() {
        return "¡SKREEEE! ¡Vuelo a las alturas!";
    }
}
