import java.util.StringTokenizer;

public class Exercicio {

    public static void main(String[] args) {
        String text = "Esse exercicio eh muito facil";
        StringTokenizer tokenizer = new StringTokenizer(text, " "); 
        Pilha3<Character> p = new Pilha3<>();

        System.out.println("Invertido:");
        while (tokenizer.hasMoreTokens()) { // Pega cada palavra da frase
            // Pega caa letra da palavra, empilha
            for (char letra : tokenizer.nextToken().toCharArray()) {
                p.empilhar(letra);
            }
            while (!p.estaVazia()) {
                System.out.print(p.desempilhar());
            }
            System.out.println();
        }

        

    }

}
