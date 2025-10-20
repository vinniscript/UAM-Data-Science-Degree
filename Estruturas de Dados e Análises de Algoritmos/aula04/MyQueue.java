public class MyQueue<T> {
    private T data[];
    private int last;

    @SuppressWarnings("unchecked")
    public MyQueue(int size) {
        data = (T[]) new Object[size];
        last = 0;
    }

    public boolean isEmpty() {
        return last == 0;
    }

    public boolean isFull() {
        return last == data.length;
    }

    public int size() {
        return last;
    }

    
    public T peek() throws Exception{
        if(isEmpty()) {
            throw new Exception("Fila Vazia");
        }
        return data[0];
    }

    public boolean enqueue(T value) {
        if(isFull()) {
            return false;
        }
        data[last++] = value;
        // last++;
        return true;
    }

    public T dequeue() throws Exception{
        if(isEmpty()){
            throw new Exception("Fila Vazia");
        }

        T aux = data[0];
        for (int i = 0; i < last-1; i++) {
            data[i] = data[i+1];
        }
        last--;
        return aux;
    }

    public String show() {
        String out= "[";
        if(isEmpty()) {
            return "Fila vazia";
        }
        out += data[0];
        for (int i = 1; i < last; i++) {
            out += "," + data[i];
        }
        out += "]";
        return out;
    }
}
