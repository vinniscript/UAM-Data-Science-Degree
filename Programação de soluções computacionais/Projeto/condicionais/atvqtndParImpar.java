package condicionais;

// 10 numero, conte os pares, conte os impares
import java.util.Scanner;

// if par, contadorPar, if contadorImpar
public class atvqtndParImpar {

    public static void main(String[] args) {

        Scanner kb = new Scanner(System.in);

        int par = 0, impar = 0;

        for (int i = 0; i <= 10; i++) {

            System.out.println("Numero: ");

            int num = kb.nextInt();

            int cond = (num % 2 == 0) ? par++ : impar++;
        }
        System.out.println("Foram " + par + " pares, e " + impar + " ímpares.");
    }

}
