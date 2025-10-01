
package aulas;

import java.util.Scanner;

public class Farenheint {
    public static void main(String[] args) {
        Scanner tc = new Scanner(System.in);
        float tempCelsius, tempFarenheint;
        
        System.out.println("Entre com uma temperatura em Celsius: ");
        tempCelsius = tc.nextFloat();
        
        tempFarenheint = tempCelsius * (9.0f/5) + 32;
        
        System.out.printf("Temperatura de %.2f Graus Farenheint\n", tempFarenheint);
    }
}
