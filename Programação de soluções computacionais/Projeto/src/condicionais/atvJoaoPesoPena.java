package condicionais;

import java.util.Scanner;

public class atvJoaoPesoPena {

    public static void main(String[] args) {
//        Joao peso pena pesca e a cada peixe que passa de 50 kilos acrescenta 4 reais por kilo de multa.

    float multaQuilo = 4.0f, 
    pesoLimite = 50.0f;
    
    Scanner kb = new Scanner(System.in);
    
        System.out.print("Insira o peso do peixe: ");
        
        float pesoPeixe = kb.nextFloat();
        
        if (pesoPeixe > pesoLimite){
            float pesoExcedido = pesoPeixe - pesoLimite;
            float multa = pesoExcedido * multaQuilo;
            System.out.printf("A multa pelo excesso de %.2f quilos totaliza R$%.2f\n", pesoExcedido, multa);
        } else {
            System.out.printf("Nao ha multa para um peixe de %.2f quilos.\n", pesoPeixe);
        }
    }
}
