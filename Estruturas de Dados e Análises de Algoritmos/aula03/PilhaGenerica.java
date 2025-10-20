import java.lang.reflect.Array;

public class PilhaGenerica<T> {
    private T[] dados;
    private int topo;

    public PilhaGenerica(Class <T> classe, int tamanho) {
        dados = (T[]) Array.newInstance(classe, tamanho);
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

    public void empilhar(T dado) {
        if (estaCheia())
            return;

        dados[topo] = dado;
        topo++;
    }

    public T desempilhar() throws Exception {
        if (estaVazia()) {
            throw new Exception("A pilha está vazia");
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
