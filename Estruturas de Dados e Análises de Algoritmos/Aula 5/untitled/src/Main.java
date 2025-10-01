//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {

        Pilha<Integer> p = new Pilha<>();
            System.out.println(p.show());

            p.push(30);
            p.push(20);
            p.push(10);
            p.push(15);

        System.out.println(p.show());
        System.out.println("O elemento do topo é: " + p.peek().getDado());
        System.out.println("Removendo: " + p.pop());
        System.out.println("Agora o topo é: " + p.peek().getDado());
        System.out.println(p.show());
        }
}
