public class No<T>{ // Nó
    private T dado;
    private No<T> next;

    public No(T dado) {
        this.dado = dado;
    }

    public No(T dado, No<T> next) {
        this.dado = dado;
        this.next = next;

    }

    // getters e setters

    public T getDado() {
        return dado;
    }

    public void setDado(T dado) {
        this.dado = dado;
    }

    public No<T> getNext() {
        return next;
    }

    public void setNext(No<T> next) {
        this.next = next;
    }

}
