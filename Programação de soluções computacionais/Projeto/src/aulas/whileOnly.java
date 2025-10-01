package aulas;

public class whileOnly {

    public static void main(String[] args) {
        int contador = 0;
        boolean continua = true;

        while (contador < 5 && continua) {

            System.out.println("Contador = " + contador);
            contador++;
        }
        System.out.println("Contador fora do while: " + contador);
    }
}

