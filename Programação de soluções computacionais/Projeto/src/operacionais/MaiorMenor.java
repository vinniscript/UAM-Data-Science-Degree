package atvoperacionais;

public class MaiorMenor {
    public static void main(String[] args) {
        int a = 3, b = 7, c= 4;
       
        System.out.println("A = " + a + "\n" +
                            "B = " + b + "\n" +
                            "C = " + c);
        System.out.println("\n"); 
        
        System.out.println("C + A é maior que B?");
        System.out.println(( c + a ) > b );
        System.out.println("\n"); //false
        
        System.out.println("B é maior ou igual a A + 2?");
        System.out.println( b >= (a + 2) );
        System.out.println("\n"); //true
     
     // a partir daqui
     
        System.out.println("C é igual a B - A?");
        System.out.println( c == (b-a) );
        System.out.println("\n"); //true
        
        System.out.println("B + A é menor ou igual a C?");
        System.out.println( (b + a ) <= c );
        System.out.println("\n"); //false
        
        System.out.println("C + A é maior que B");
        System.out.println( ( c + a ) > b );
        System.out.println("\n"); //false
    }
}
