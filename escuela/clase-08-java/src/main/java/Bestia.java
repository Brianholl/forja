public abstract class Bestia {
    protected final String nombre;
    protected final int    vida;
    protected final int    ataque;

    public Bestia(String nombre, int vida, int ataque) {
        this.nombre = nombre;
        this.vida   = vida;
        this.ataque = ataque;
    }

    public abstract String rugido();

    @Override
    public String toString() {
        return String.format("  %-18s  vida=%-4d  ataque=%-4d  \"%s\"",
                nombre, vida, ataque, rugido());
    }
}
