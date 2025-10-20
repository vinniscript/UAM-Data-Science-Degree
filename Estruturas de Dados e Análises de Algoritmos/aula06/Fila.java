public class Fila<T> {
    private No<T> inicio, fim;
    private int qtde;

    public boolean estaVazia() {
        return inicio == null;
    }

    public int tamanho() {
        return qtde;
    }

    public No<T> primeiro() {
        if (estaVazia()) {
            return null;
        }
        No<T> copia = new No<T>(inicio.getDado());
        return copia;
    }

    public void inserir(T novoDado) {
        No<T> novoNo = new No<T>(novoDado);
        if (estaVazia()) {
            inicio = novoNo;
            fim = novoNo;
        } else {
            fim.setProximo(novoNo);
            fim = novoNo;
        }
        qtde++;
    }

    public T remover() {
        if (estaVazia()) {
            return null;
        }
        T aux = inicio.getDado();
        inicio = inicio.getProximo();
        if (inicio == null) { // se for o último NO removido
            fim = null;
        }
        return aux;
    }

    public String exibir() {
        String saida = "";
        if (estaVazia()) {
            return "Fila Vazia";
        }
        No<T> aux = inicio;
        saida += aux.getDado();
        aux = aux.getProximo();
        while (aux != null) {
            saida += "," + aux.getDado();
            aux = aux.getProximo();
        }
        return saida;
    }

}
