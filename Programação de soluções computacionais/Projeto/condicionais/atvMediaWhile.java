package condicionais;

import java.util.Scanner;

public class atvMediaWhile {

    public static void main(String[] args) {
        int contagem = 0;
        double nota = 0;

        Scanner kb = new Scanner(System.in);

        while (contagem < 3) {
            System.out.printf("Nota %d: ", contagem + 1);
            nota += kb.nextDouble();
            contagem++;
        }
        System.out.printf("Media: %.2f.", nota / contagem);
    }

}

// Depois tentar fazer com o do também...