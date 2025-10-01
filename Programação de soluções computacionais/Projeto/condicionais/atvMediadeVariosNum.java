package condicionais;

// Crie um programa que receb várias notas e calcule a média entre elas.
import java.util.Scanner;

public class atvMediadeVariosNum {

    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);

        int notas, media, acumulador = 0;

        for (int i = 1; i <= 10; i++) {
            System.out.printf("Insira até 10 notas ou digite -1 para encerrar a coleta: ");

            notas = kb.nextInt();
            acumulador += notas;
            media = acumulador / i;

            if (notas == -1) {
                System.out.println("a média é: " + media);
                break;
            }
            if (i == 10){
                System.out.println("a média é: " + media);
            }
        }

    }
}
