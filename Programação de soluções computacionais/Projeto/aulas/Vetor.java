package aulas;

import java.util.Scanner;

public class Vetor {

    public static void main(String[] args) {
        int[] vetor = new int[3];
        var kb = new Scanner(System.in);

        for (int i = 0; i < vetor.length; i++) {
            vetor[i] = kb.nextInt();
        }
        System.out.println("");

        for (int i = 0; i < vetor.length; i++) {
            System.out.println(vetor[i]);
        }
    }
}

// 50 numeros aleatorios

