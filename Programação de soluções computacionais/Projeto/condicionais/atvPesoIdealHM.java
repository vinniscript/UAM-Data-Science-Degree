package condicionais;

import java.util.Scanner;

public class atvPesoIdealHM {

    public static void main(String[] args) {

//        Exemplo de parsing:
        System.out.println("Exemplo de parsing. \n");
        String a = "2";

        int b = 2;

        int c = Integer.parseInt(a); // Esse é o tal parsing (ou casting, como prefeirir) que o professor passou, que é converter váriaveis de tipos primitivos, como um float para um double. 
        // Nesse exemplo, como um exemplo, fizemos uma String virar um int.

        System.out.println(c == b); // vai retornar true

//          Agora o exercicio usando Case e Switch com o equalCaseSensetive e o operador condicional "OU"
        System.out.println("\nExercicio de peso ideal Masculino ou feminino. \n");

        Scanner teclado = new Scanner(System.in);

        float altura, pesoIdeal;
        String sexo;
        
        // Valores das variaveis e suas atribuicoes
        
        System.out.println("[M]asculino ou [F]eminino: ");
        sexo = teclado.next().toUpperCase(); // .toUpperCase() Faz o retorno ser totalmente em letra maiúscula, não importa como o usuário digite, dentro do código ele esta em caixa alta.
        System.out.println("Qual sua altura?");
        altura = teclado.nextFloat();

        // Metodo convencional
        
//        if (sexo.equalsIgnoreCase("m") || sexo.equalsIgnoreCase("f")) {
//            if (sexo.equals("m")) {
//                pesoIdeal = (72.7f * altura) - 58; //Quando ta usando um float, tem que colocar o 'f' depois de um numero decimal.
//                System.out.printf("o Peso ideal M, é: %.2f", pesoIdeal);
//            } else {
//                pesoIdeal = (62.1f * altura) - 44.7f;
//                System.out.printf("O peso ideal F, é: %.2f", pesoIdeal);
//            }
//        }

        // Switch e case
        
        switch(sexo.charAt(0)){ // o chatAt() Pega a primeira letra do que foi passado quando questionado sobre o sexo.
        
            case 'M': 
                
                pesoIdeal = (72.7f * altura) - 58; //Quando ta usando um float, tem que colocar o 'f' depois de um numero decimal.
                System.out.printf("o Peso ideal M, equivale: %.2f\n", pesoIdeal);
                
                break; // Sempre utilizar o break, se não código abaixo continuará a ser executado, deixando o output (resultado do código) muito confuso.
            
            case 'F': 
                
               pesoIdeal = (62.1f * altura) - 44.7f;
                System.out.printf("O peso ideal F, equivale: %.2f\n", pesoIdeal);
                
                break;
                
            default: // o default é obrigatório quando usando o "Switch", ele é chamado quando nenhum dos "case" são atendido, daí quem atua é o default, é tipo o else.
                
                System.out.println("opção inválida.");
            
        }
        
        
        teclado.close(); // Sempre fechar o Scanner quando o abrir para poupar a memoria do computador.
    }
}
