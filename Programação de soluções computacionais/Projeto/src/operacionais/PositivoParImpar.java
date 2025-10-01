package atvoperacionais;

import java.util.Scanner;

public class PositivoParImpar {

    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);

        System.out.printf("Manda um número aí: ");

        int numero = kb.nextInt();

        if (numero % 2 == 0) {
            if (numero > 0) {
                System.out.println("Numero par e positivo.");
            } else {
                System.out.println("Numero par e negativo.");
            }
        } else {
            if (numero > 0) {
                System.out.println("Numero ímpar e positivo.");
            } else {
                System.out.println("Numero ímpar e negativo.");
            }
        }
    }
}
