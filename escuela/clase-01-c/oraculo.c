#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
    srand(time(NULL));
    int secreto = rand() % 100 + 1;
    int intento = 0;
    int intentos = 0;

    printf("=== El Oraculo de Numeros ===\n");
    printf("He elegido un numero entre 1 y 100.\n");
    printf("Adivina cual es.\n\n");

    do {
        printf("Tu intento: ");
        if (scanf("%d", &intento) != 1) {
            printf("Numero invalido. Intenta de nuevo.\n");
            while (getchar() != '\n');
            continue;
        }
        intentos++;

        if (intento < secreto) {
            printf("Demasiado bajo. Sigue buscando...\n");
        } else if (intento > secreto) {
            printf("Demasiado alto. Baja un poco...\n");
        } else {
            printf("\n¡Lo lograste! El numero era %d.\n", secreto);
            printf("Lo encontraste en %d intento(s).\n", intentos);
        }
    } while (intento != secreto);

    return 0;
}
