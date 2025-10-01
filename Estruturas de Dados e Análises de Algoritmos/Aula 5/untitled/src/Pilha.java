public class Pilha<T> {
    private No<T> topo;

    public boolean isEmpty() {
        return topo == null;
    }

    public No<T> getTopo() {
        return topo;
    }

    public No<T> peek() {
        No<T> copia = new No<T>(topo.getDado());

        return copia;
    }

    public void push(T newData) {
        No<T> newNo = new No<T>(newData);
        newNo.setNext(topo);
        topo = newNo;
    }

    public T pop() {
         T aux = topo.getDado();
         topo = topo.getNext();
         return aux;
    }

    public String show() {
        String out = "";
        if (isEmpty()) {
            return "Pilha vazia";
        }
        No<T> aux = topo;
        out += aux.getDado();
        aux = aux.getNext();

        while(aux != null) {
            out += "," + aux.getDado();
            aux = aux.getNext();
        }
        return out;
    }

}
