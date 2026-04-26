import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Bestiario {
    public static void main(String[] args) {
        List<Bestia> bestiario = new ArrayList<>();
        bestiario.add(new Dragon("Ignis el Rojo",  420, 85, "fuego"));
        bestiario.add(new Dragon("Glacius",         380, 78, "hielo"));
        bestiario.add(new Grifo("Aeron el Veloz",   310, 92));
        bestiario.add(new Basilisco("Meduso",       260, 110));

        System.out.println("=== El Bestiario ===\n");
        System.out.println("Todas las bestias:");
        bestiario.forEach(System.out::println);

        System.out.println("\nOrdenadas por ataque (mayor a menor):");
        bestiario.stream()
                 .sorted(Comparator.comparingInt((Bestia b) -> b.ataque).reversed())
                 .forEach(System.out::println);

        System.out.println("\nBestias con ataque > 80:");
        bestiario.stream()
                 .filter(b -> b.ataque > 80)
                 .forEach(b -> System.out.println("  ★ " + b.nombre));
    }
}
