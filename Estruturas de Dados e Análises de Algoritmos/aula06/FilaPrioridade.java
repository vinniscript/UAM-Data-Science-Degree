public class FilaPrioridade<T> {
    private NoPrioridade<T> inicio, fim;
    private int qtde;

    public boolean estaVazia() {
        return inicio == null;
    }

    public int tamanho() {
        return qtde;
    }

    public NoPrioridade<T> primeiro() {
        if (estaVazia()) {
            return null;
        }
        NoPrioridade<T> copia = new NoPrioridade<T>(inicio.getDado(), inicio.getPrioridade());
        return copia;
    }

    public void inserir(T novoDado, int prioridade) {
        NoPrioridade<T> novoNoPrioridade = new NoPrioridade<T>(novoDado, prioridade);
        if (estaVazia()) {
            inicio = novoNoPrioridade;
            fim = novoNoPrioridade;
        } else {
            NoPrioridade<T> aux = inicio;
            NoPrioridade<T> anterior = inicio;
            while (aux != null && aux.getPrioridade() >= novoNoPrioridade.getPrioridade()) {
                anterior = aux;
                aux = aux.getProximo();
            }
            if (aux == null) { // vai inserir no final da fila
                fim.setProximo(novoNoPrioridade);
                fim = novoNoPrioridade;
            } else {
                if (aux == anterior) { // insere no início
                    novoNoPrioridade.setProximo(inicio);
                    inicio = novoNoPrioridade;
                } else { // inserir entre 2 Nos
                    anterior.setProximo(novoNoPrioridade);
                    novoNoPrioridade.setProximo(aux);
                }

            }
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
        NoPrioridade<T> aux = inicio;
        saida += aux.getDado();
        aux = aux.getProximo();
        while (aux != null) {
            saida += "," + aux.getDado();
            aux = aux.getProximo();
        }
        return saida;
    }

}
