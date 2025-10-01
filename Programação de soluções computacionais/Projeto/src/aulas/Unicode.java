/*
 * retorne o caractere UNICODE.
 */
package aulas;

import java.util.Scanner;

public class Unicode {
    public static void main(String[] args) {
    
        int a = 1;
        double b = a;
       
       // casting
       
       double a1 = 1.0;
       // int b1 = a1; -- não pode, pois o java não deixa você perder valores. Para fazer essa conversão, é necessário o casting.
       int b1 = (int)a1;
        
        System.out.println(b);
        System.out.println(b1);
        
        char letra, auxiliar, novaLetra;
        int numero;
        String letra1;
        
        Scanner tc = new Scanner(System.in);
        
        System.out.println("Digite um caractere: ");
        letra1 = tc.next();
        auxiliar = letra1.charAt(0);
        //letra = "b"; -- Letra não é texto, caractere é apenas aspas simples.
        letra = 'b';  // char não recebe scan, por o o next() não tem módulo próprio para o método char.
        numero = (int)letra + 3;
        novaLetra = (char)numero;
        
        //Principio básico da sifra de Cesar.
        
        System.out.println(novaLetra); // no ASCII 2, 101 é a letra 'e'
    }
}