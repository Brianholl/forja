public class Basilisco extends Bestia {

    public Basilisco(String nombre, int vida, int ataque) {
        super(nombre, vida, ataque);
    }

    @Override
    public String rugido() {
        return "...sss... Mi mirada te petrifica...";
    }
}
