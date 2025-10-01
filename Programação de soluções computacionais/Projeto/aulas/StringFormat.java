// Criação de projetos seguem um padrão de qualidade. Todas as primeiras letras de palavras são maiusculas, como "FuncaoCalculadora", por exemplo, e não "funcaocalculadora". Isso é necessário
// Packages são letras minúsculas apenas = "funcoesdacalc"

package aulas;

// Aqui que você importa as APIs

import java.util.Scanner;  // Fica laranja para avisar que você está importando algo que não está usando, quando você criar um método no código, que chama a biblioteca, o laranja sublinhado some.

public class StringFormat {
    public static void main(String[] args) {
      //System.out.print("Hello World \n");
        System.out.println("Hello World!");
        //olaMundo(); Da para chamar um método fora do main, apenas fazendo uma call dessa forma.
 // Declaração das variáveis
        Scanner teclado = new Scanner(System.in);
        String nome;
 // Atribuição dos valores
        System.out.print("Qual seu nome? ");
        nome = teclado.next();
 // Saída dos dados
        System.out.println("Ola, " + nome + ", como vai?");
        //System.out.printf("Ola, %s, como vai? \n", nome); -- Print formatado. Mexe com a formatação do output.
       
    /*
        System.out.println("Eu começo aqui,"    
                    + "Depois venho aqui"
                    + "Depois aqui."
                    + "Dai eu venho pra ca");  <-- não é assim que funciona, isso é apenas bom para quebrar o texto para nós programadores, o computador lê tudo em uma linha.
        
    */
    
 }
    
    /*
   # public static void olaMundo(){
   #     System.out.println("Ola muaindo.");
   # }

*/
}    