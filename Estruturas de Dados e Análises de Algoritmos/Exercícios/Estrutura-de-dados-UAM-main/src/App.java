import java.util.Scanner;

public class App {
    public static void main(String[] args) throws Exception {
        System.out.println("Hello, World!");
    
        /*Exercicio do aristóteles dos corredores e lâmpadas... */

        Scanner sc = new Scanner(System.in);

        System.out.println("Digite o número de lâmpadas:");
        int lampadas = sc.nextInt();

        sc.close();

        boolean estados[] = new boolean[lampadas];

        for (int i = 1; i <= estados.length; i++) {
            
            for (int estado = 0; estado < estados.length; estado++) {
                    if ((estado + 1) % i == 0) {
                        estados[estado] = !estados[estado];
                }
            }
        }

        for (boolean b : estados) {
            System.out.println((b) ? "on ": "off");
        }
    }
}