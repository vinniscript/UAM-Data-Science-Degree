public class Main {
    public static void main(String[] args) {
        // Fila<Integer> fila = new Fila<>();

        // System.out.println(fila.exibir());

        // fila.inserir(30);
        // fila.inserir(20);
        // fila.inserir(10);
        // fila.inserir(15);

        // System.out.println(fila.exibir());
        // System.out.println("O elemento do início é " + fila.primeiro());

        // System.out.println("Removendo: " + fila.remover());
        // System.out.println(fila.exibir());

        // while (!fila.estaVazia()) {
        //     System.out.println("Removendo: " + fila.remover());
        // }
        // System.out.println(fila.exibir());

        FilaPrioridade<String> fp = new FilaPrioridade<>();

        fp.inserir("Pedro - Normal", 1);
        fp.inserir("Marcia - Gravida", 2);
        fp.inserir("Ana - Normal", 1);
        fp.inserir("João - Idoso", 2);

        System.out.println(fp.exibir());
    }
}
