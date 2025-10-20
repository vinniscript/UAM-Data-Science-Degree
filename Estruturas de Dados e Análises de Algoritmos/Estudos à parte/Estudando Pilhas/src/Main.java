//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {

        Stack s = new Stack(5); // Cria uma pilha com capacidade para 5 elementos

        s.show(); // Deve exibir "Pilha Vazia"
        s.push(10);
        s.push(20);
        s.push(30);
        System.out.println(s.show()); // Deve exibir [10, 20, 30]

        System.out.println("Desempilhado: " + s.pop()); // Deve exibir 30
        System.out.println(s.show()); // Deve exibir [10, 20]

    }



}