public class Main {
    public static void main(String[] args) {
        Pilha<Integer> p = new Pilha<>();

        System.out.println(p.exibir());

        p.empilhar(30);
        p.empilhar(20);
        p.empilhar(10);
        p.empilhar(15);

        System.out.println(p.exibir());
        System.out.println("O elemento do Topo é " + p.topo());

        System.out.println("Removendo: " + p.desempilhar());
        System.out.println(p.exibir());
        
    }
}
