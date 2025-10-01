
package condicionais;

import java.util.Scanner;


public class atvMenosScanner {
    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);
        
        System.out.println("Digite seu primeiro numero.");
        int num1 = kb.nextInt();
        
        System.out.println("Agora o segundo numero.");
         int num2 = kb.nextInt();
        
        System.out.printf("%.2f, - %.2f = %.2f", num1, num2, num1 - num2);
        
    }
}
