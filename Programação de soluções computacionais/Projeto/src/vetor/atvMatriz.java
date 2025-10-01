package vetor;

import java.util.Arrays;

public class atvMatriz {

    public static void main(String[] args) {
        int[][] matriz = new int[2][2];

        matriz[0][0] = 1000; // Linha 0, coluna 0 equivale a 1000, || [1000, 0]
        matriz[0][1] = 20;
        matriz[1][0] = 30;
        matriz[1][1] = 40;

        System.out.println(Arrays.deepToString(matriz)); // Módulo justo para imprimir matrizes.

        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 2; j++) {
                matriz[i][j] = (int) (Math.random() * 100);
            }
        }
        System.out.println(Arrays.deepToString(matriz));
    }
}
