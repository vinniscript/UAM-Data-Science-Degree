package classes;

import java.util.Scanner;

public class atvEntradaSoma {
    // Não importa a posicão do main(), só importa ele existir como um void em algum lugar do código. Ele se vira para encontrar as outras classes, contanto que estejam com os nomes devidamente referenciados.
    public static double[] entrada() {

        Scanner scanner = new Scanner(System.in);
        double[] prompts = new double[2];

        System.out.println("Insira 2 números: ");

        for (int i = 0; i < prompts.length; i++) {
            prompts[i] = scanner.nextDouble();
        }

        scanner.close();
        return prompts;

    }

    public static double soma(double[] alibi) { // double[] indica que a classe só receberá vetores double, que no caso é a nossa classe "entrada()", demos um nome a ela "alibi" para se referenciar ao vetor dentro dessa clases


        double soma = 0;

        for (int i = 0; i < alibi.length; i++) {
            soma += alibi[i];
        }
        return soma;
    }

    public static void main(String[] args) {
        double[] inicial = entrada(); // Lembrando que soma só trabalha com vetores double, precisamos guardar a chamada da classe "entrada()" dentro de um vetor double, que chamamos de "inicial". Assim, podemos
        // Usa-lo como parâmetro na chamada da soma(), como visto abaixo.

        System.out.println("A soma dos números é: " + soma(inicial));

    }

}
