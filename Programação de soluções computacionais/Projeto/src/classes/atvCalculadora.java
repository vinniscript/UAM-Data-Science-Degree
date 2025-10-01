package classes;

import java.util.Scanner;

// 3 classes com nome ~area~, cada uma calculará diferentes tipos de operações, são elas: área, retângulo e trapézio.
// precisa ter uma classe de tela, onde vai trazer as opções de escolha por um char.
// Tudo precisa ser chamado no main.

public class atvCalculadora {

    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);
        boolean running = true;
        tela();
        while (running) {
            System.out.println("\nEscolha o calculo que deseja fazer [Q, R, T ou S]: ");
        String letra = kb.next().toLowerCase();


            switch (letra.charAt(0)) {
                case 'q':
                    System.out.print("Digite o lado do quadrado: ");
                    int lados = kb.nextInt();
                    int calcQ = area(lados);
                    System.out.println("\nÁrea do quadrado: " + calcQ);
                    break;

                case 'r':
                    System.out.print("Digite a base do retângulo: ");
                    int base = kb.nextInt();
                    System.out.print("A altura: ");
                    int altura = kb.nextInt();

                    int calcR = area(base, altura);

                    System.out.println(area(calcR));
                    break;
                case 't':
                    String[] vetor = {"Base maior: ", "Base menor: ", "Altura: "};

                    int[] valores = new int[3];

                    for (int i = 0; i < vetor.length; i++) {
                        System.out.println(vetor[i]);
                        valores[i] = kb.nextInt();
                    }

                    System.out.println("Área do trapézio: " + ((valores[0] + valores[1]) * valores[2] / 2));
                    break;
                case 's':
                    System.out.println("Obrigado por usar o programa.");
                    running = false;
                default:
                    System.out.println("Comando inválido.");
            }
        }
    }

    //Calculos...

    public static int area(int lado) {
        return lado * lado;
    }

    public static int area(int base, int altura) {
        return base * altura;
    }

    public static int area(int Bmaior, int Bmenor, int altura) {
        return (Bmaior + Bmenor) * altura / 2;

    }

    public static void tela() {

        System.out.print("Calculos matemáticos: " +
                "'Q' para calcular a área de um quadrado\n" +
                "`R` para calcular a área de um retângulo\n" +
                "'T` para calcular a área de um trapézio\n" +
                "'S' para sair do programa.\n");

    }
}
