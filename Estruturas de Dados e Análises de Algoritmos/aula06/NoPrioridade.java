public class NoPrioridade<T> {
    private T dado;
    private int prioridade;
    private NoPrioridade<T> proximo;
    
    public NoPrioridade(T dado, int prioridade) {
        this.dado = dado;
        this.prioridade = prioridade;
    }

    public NoPrioridade(T dado, int prioridade, NoPrioridade<T> proximo) {
        this.dado = dado;
        this.proximo = proximo;
        this.prioridade = prioridade;
    }

    public T getDado() {
        return dado;
    }

    public int getPrioridade() {
        return prioridade;
    }

    public NoPrioridade<T> getProximo() {
        return proximo;
    }

    public void setProximo(NoPrioridade<T> proximo) {
        this.proximo = proximo;
    }

    @Override
    public String toString() {
        return dado.toString();
    }
}
