public class Main {
    public static void main(String[] args) {
        Pilha3 minhaPilha3 = new Pilha3(5);

        System.out.println("Pilha vazia? "  + minhaPilha3.estaVazia());
        System.out.println("Pilha cheia? "  + minhaPilha3.estaCheia());
        System.out.println("Capacidade: " + minhaPilha3.capacidade());

        System.out.println(minhaPilha3.exibirPilha());
        minhaPilha3.empilhar(2);
        minhaPilha3.empilhar(3);
        minhaPilha3.empilhar(5);
        System.out.println(minhaPilha3.exibirPilha());
        System.out.println("Removeu: " + minhaPilha3.desempilhar());
        System.out.println(minhaPilha3.exibirPilha());
        System.out.println("Qtde elementos na pilha: " + minhaPilha3.numElementos());

        PilhaGenerica<Integer> p = new PilhaGenerica<>(Integer.class, 10);

        // p.empilhar(10);
        System.out.println(p.capacidade());
        System.out.println(p.exibirPilha());
        
        try {
            System.out.println("Removeu: " + p.desempilhar());
        } catch (Exception e) {
           e.printStackTrace();
           System.out.println("Erro: " + e.getMessage());
        }


        PilhaGenerica<String> p2 = new PilhaGenerica<>(String.class, 10);
        p2.empilhar("Emerson");
        p2.empilhar(null);

    }
}
