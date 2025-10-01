// 1 a 100, fale se for divisivel por 3 ou por 5, ou pelos 2
package condicionais;

public class atvDivisiveis {

    public static void main(String[] args) {
        for (int i = 0; i <= 100; i++) { // pegar a condição mais restritiva em primeiro.
            System.out.println(i);
            if (i % 3 == 0 && i % 5 == 0) {
                System.out.println("Fizz Buzz");
            } else if (i % 3 == 0) {
                System.out.println("Fizz");
            } else if (i % 5 == 0) {
                System.out.println("Buzz");
            }
        }
    }
}
