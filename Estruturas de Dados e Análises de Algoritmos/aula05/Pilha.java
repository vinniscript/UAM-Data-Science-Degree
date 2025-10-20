public class Pilha<T> {
    private No<T> topo;

    public boolean estaVazia() {
        return topo == null;
    }

    public No<T> topo() {
        No<T> copia = new No<T>(topo.getDado());
        return copia;
    }

    public void empilhar(T novoDado) {
        No<T> novoNo = new No<T>(novoDado);
        novoNo.setProximo(topo);
        topo = novoNo;
    }

    public T desempilhar() {
        T aux = topo.getDado();
        topo = topo.getProximo();
        return aux;
    }

    public String exibir() {
        String saida = "";
        if(estaVazia()) {
            return "Pilha Vazia";
        }
        No<T> aux = topo;
        saida += aux.getDado();
        aux = aux.getProximo();
        while(aux != null) {
            saida += "," + aux.getDado();
            aux = aux.getProximo();
        }
        return saida;
    }

}
