package vetor;

import java.util.Random;

public class atvMatrizRandom2x2 {

    public static void main(String[] args) {
        Random random = new Random();

        int[][] matriz = new int[2][2];

        for (int i = 0; i < matriz.length; i++) {
            for (int j = 0; j < matriz[i].length; j++) {
               
            matriz[i][j] = random.nextInt(10) + 1;
                System.out.print(matriz[i][j] + " ");
            }
            System.out.println("");
        }

    }
}
