package vetor;

import java.util.Random;
import java.util.Scanner;

/*

Criar um programa com 2 matrizes 3x3, o usuário define a primeira matriz, a segunda é random de 1 a 10,
retorne a matriz soma.

 */
public class atvSomaMatriz3x3 { // Matriz promptada

    public static void main(String[] args) {
        int matriz1[][] = new int[3][3];
        int matriz2[][] = new int[3][3]; // Matriz randômica.
        int matrizSoma[][] = new int[3][3];
        
        Scanner scanner = new Scanner(System.in);
        Random random = new Random();

        System.out.println("Digite a matriz:");
        
        System.out.println("\n");
        
        // Matriz do usuário
        
        for (int i = 0; i < matriz1.length; i++) {
            for (int j = 0; j < matriz1[i].length; j++) {
                matriz1[i][j] = scanner.nextInt();
            }
        }
        System.out.println("Sua matriz: ");
        for (int i = 0; i < matriz1.length; i++) {
            for (int j = 0; j < matriz1[i].length; j++) {
                System.out.print(matriz1[i][j] + " ");
            }
            System.out.println(); // Quebra a linha para formatar devidamente a matriz.
        }
        
        System.out.println("\n");

        // Matriz random
        
        for (int i = 0; i < matriz2.length; i++) {
            for (int j = 0; j < matriz2[i].length; j++) {
                matriz2[i][j] = (int)(Math.random() * 9 + 1);
            }
        }
        
        
        System.out.println("Matriz randômica: ");
        for (int i = 0 ; i < matriz2.length ; i++){
            for (int j = 0 ; j < matriz2.length ; j++){
                System.out.print(matriz2[i][j] + " ");
        }
            System.out.println("");
        }
        
        System.out.println("\n");
        
        // Matriz de soma
        
        System.out.println("Matriz de soma: ");
        for (int i = 0; i < matrizSoma.length; i++) {
            for (int j = 0; j < matrizSoma.length; j++) {
                matrizSoma[i][j] = matriz1[i][j] + matriz2[i][j];
                System.out.print(matrizSoma[i][j] + " ");
            }
            System.out.println();
        }
        scanner.close();
    }
}
