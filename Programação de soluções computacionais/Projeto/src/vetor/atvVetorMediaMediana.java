
package vetor;

import java.util.Scanner;

public class atvVetorMediaMediana {
    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);

        System.out.print("Quantidade de idades: ");

        int tamanho = kb.nextInt();
        int[] vetor = new int[tamanho];
        int soma = 0;
        System.out.println();

        System.out.print("Insira as idades: ");
        for (int i = 0; i < vetor.length; i++) {
            vetor[i] = kb.nextInt();
            soma += vetor[i];
        }
        System.out.println();

        for (int i = 0; i < vetor.length - 1; i++) {
            for (int j = 0; j < vetor.length - i - 1; j++) {

                if (vetor[j] > vetor[j + 1]) {
                    System.out.printf("O valor do Indice %d = %d é maior que o valor do indice a sua direita, %d = %d \n", j, vetor[j], j + 1, vetor[j + 1]);
                    int temp = vetor[j];
                    System.out.printf("variável temporária recebe o valor do maior == Indice atual %d, valor da temp %d\n", j, temp);
                    System.out.printf("Antes do swap: %d° = %d, %d° = %d, temp = %d\n", j, vetor[j], j + 1, vetor[j + 1], temp);
                    vetor[j] = vetor[j + 1]; // SWAP
                    vetor[j + 1] = temp;
                    System.out.printf("Após o swap: %d° = %d, %d° = %d, temp = %d\n", j, vetor[j], j + 1, vetor[j + 1], temp);
                    System.out.printf("O indice maior joga seu valor para a variável temporária e pega o valor do indice a direita para si, \nentão o indice da direita recebe o valor da variável temporária contendo o valor do indice anterior. Indice %d agora vale %d\n", j + 1, temp);
                    System.out.println();
                }
            }
        }
        System.out.println();
        System.out.print("Vetor formatado: ");
        for (int i = 0; i < vetor.length; i++) {
            System.out.print(vetor[i] + " ");

        }
        System.out.println();

        double media = soma / vetor.length;
        System.out.printf("A soma das %d idades fornecidas é %d, portanto, a média é %.2f", vetor.length, soma, media);
        System.out.println();


        double mediana;

        int length = vetor.length; // para evitar chamadas repitidas.

        if (vetor.length % 2 == 0) {
            mediana = (vetor[vetor.length / 2 - 1]) + (vetor[vetor.length / 2]) / 2; // pega o valor total do vetor, e divide o resultado indenpendente de qual por 2, o -1 é usado para o primeiro a esquerda do resultado e podermos calcular ambas as metades.
            System.out.printf("Como o numéro é par, devemos pegar a metade inferior: %d, e a metade superior: %d + a média entre elas.\n", (vetor.length / 2 - 1), (vetor[vetor.length / 2]));
        } else {
            mediana = (vetor[vetor.length / 2]);
            System.out.println("Como o número é impar, basta pegar o indice do meio, ele representa a mediana.");
        }

        System.out.println("Mediana: " + mediana);

        kb.close();
    }
}
