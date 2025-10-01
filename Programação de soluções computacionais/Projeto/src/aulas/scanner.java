/*
 * Programa que printa um inteiro na tela
 */
package aulas;

import java.util.Scanner;

public class scanner {
    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);
        int numero;
        System.out.println("Digite um numero inteiro: ");
        numero = kb.nextInt();
        System.out.println("O numero digitado foi: " + numero);
    }
}
