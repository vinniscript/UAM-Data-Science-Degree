package atvoperacionais;

import java.util.Scanner;

public class atvFatorial {

    public static void main(String[] args) {

        System.out.print("Introduza um número: ");

        Scanner kb = new Scanner(System.in);
        
        long fatorial = 1;

        int numero = kb.nextInt();

        for (int i = numero; i > 0; i--) {

            fatorial *= i;
        }
        System.out.printf("O fatorial de %d é %d\n", numero, fatorial);
    }
}

