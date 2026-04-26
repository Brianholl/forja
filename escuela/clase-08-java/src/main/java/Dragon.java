public class Dragon extends Bestia {
    private final String elemento;

    public Dragon(String nombre, int vida, int ataque, String elemento) {
        super(nombre, vida, ataque);
        this.elemento = elemento;
    }

    @Override
    public String rugido() {
        return "¡RAAWR! Escupo " + elemento + "!";
    }
}
