import java.util.Scanner;

public class Exercicio01 {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int numeroLampadas;

        System.out.println("Informe o número de lampadas:");
        numeroLampadas = input.nextInt();
        input.close();

        boolean lampadas[] = new boolean[numeroLampadas];

        for (int caminhada = 1; caminhada <= numeroLampadas; caminhada++) {
            
            for (int lampada = 1; lampada <= numeroLampadas; lampada++) {
                if(lampada % caminhada == 0) {
                    //inverte o estado
                    lampadas[lampada-1] = !lampadas[lampada-1];
                }
            }
        }

        for (boolean lampada : lampadas) {
            if(lampada)
                System.out.println("on ");
            else 
                System.out.println("off ");

            String resp = (lampada)?"on ":"off ";
            System.out.print(resp);
        }
    }
}
