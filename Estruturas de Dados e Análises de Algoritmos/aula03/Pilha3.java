public class Pilha3 {
    private int dados[];
    private int topo;

    public Pilha3(int tamanho) {
        dados = new int[tamanho];
        topo = 0;
    }

    public boolean estaVazia() {
        return topo == 0;
    }

    public boolean estaCheia() {
        return topo == dados.length;
    }

    public int numElementos() {
        return topo;
    }

    public int capacidade() {
        return dados.length;
    }

    public void empilhar(int dado) {
        if (estaCheia())
            return;

        dados[topo] = dado;
        topo++;
    }

    public int desempilhar() {
        if (estaVazia()) {
            return -1;
        }
        topo--;
        return dados[topo];
    }

    public String exibirPilha() {
        if (estaVazia()) {
            return "Pilha Vazia";
        }
        String out = "[" + dados[0];
        for (int i = 1; i < topo; i++) {
            out += "," + dados[i];
        }
        out += "]";
        return out;
    }
}
