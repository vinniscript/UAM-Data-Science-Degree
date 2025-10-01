package aulas;

public class doWhile {

    public static void main(String[] args) {

        int contador = 0;
        do {
            System.out.println("Contador = " + contador);
            contador++;
            
        } while (contador < 5);

        System.out.println("Contador fora do while: " + contador);
    }
}
