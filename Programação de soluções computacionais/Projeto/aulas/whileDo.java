
package aulas;


public class whileDo {

    public static void main(String[] args) {

        int contador = 3;
        boolean continua = true;

        do {
            if (contador == 0) {
                System.out.println("Entrei no if...");
                continua = false;
            } else {
                System.out.println("Contador = " + contador);
                contador--;
            }
        } while (continua);
        System.out.println("Contador: " + contador);
        System.out.println("Saí do programa.");
    }
}

    

