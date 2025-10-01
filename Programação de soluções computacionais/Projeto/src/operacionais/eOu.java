
package atvoperacionais;

public class eOu {
    public static void main(String[] args) {
        int a = 5, b = 4, c = 3, d = 6;
       
        System.out.println("A = " + a + "\n" +
                            "B = " + b + "\n" +
                            "C = " + c + "\n" +
                            "D = " + d);
        System.out.println("\n"); 
        
        System.out.println("A maior que C E C menor ou igual a D?");
        System.out.println((a > c) && (c <= d));//true
        System.out.println("\n"); 
        
        System.out.println("A+B maior que 10 OU A+B é igual a c + 1 + d?");
        System.out.println((a + b) > 10 || (a + b) == (c + +d));//true
        System.out.println("\n"); 
        
        System.out.println("A maior ou igual a C E D maior ou igual a C");
        System.out.println(a >= c && d >= c);//true
        System.out.println("\n"); 
        
    }
}
