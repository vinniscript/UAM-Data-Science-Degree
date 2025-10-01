
package classes;


// uma classe que recebe o maior número de um array inserido pelo usuário, outra que receba o menor numero do array inserido pelo usuário. Ambas precisam ser void.
// Tentar o código dentro de um try catch.

import java.util.InputMismatchException;
import java.util.Scanner;

public class atvMaiorMenor {

    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);
        int[] vetor = new int[5];
        boolean rodando = true;

        while (rodando) {
            System.out.print("Insira 5 números: ");
            try {
                for (int i = 0; i < vetor.length; i++) {
                    vetor[i] = kb.nextInt();
                    System.out.print(vetor[i] + " ");
                }

            } catch (InputMismatchException e) {
                System.out.println("Apenas números inteiros, por favor.");
            }
            rodando = false;
        }

        maior(vetor);
        menor(vetor);
    }

    public static void maior(int[] nums) {
        int maior = nums[0]; // Variável suporte para manter o maior valor que aparecer nos index do array.
        for (int i = 0; i < nums.length; i++) {

            if (nums[i] > maior) {
                maior = nums[i];
            }
        }
        System.out.println("\nMaior número do vetor: " + maior);
    }

    public static void menor(int[] nums) {
        int menor = nums[0]; // Variável suporte para manter o menor valor.

        for (int i = 0; i < nums.length; i++) {
            if (nums[i] < menor) {
                menor = nums[i];
            }
        }
        System.out.println("Menor número do vetor: " + menor);
    }

}