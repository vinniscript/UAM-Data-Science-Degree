public class Stack <T> {
    private String expr;
    private int top;
    private T[] data;

    @SuppressWarnings("unchecked")
    public Stack(String expr) {
        this.expr = expr;
        top = 0;
        data = (T[]) new Object[expr.length()]; //Aloca o array genérico com o tamanho da expressão
    }

    public boolean isEmpty() {
        return top == 0;
    }

    public boolean isFull() {
        return top == expr.toCharArray().length;
    }

    public void push(T newData) {
        if (isFull()) {
            System.out.println("Stack is full, addition is not possible.");
            return;
        }

        data[top] = newData;
        top++;
    }

    public T pop() {
        if (isEmpty()) {
            System.out.println("Stack is empty, removal is not possible.");
            return null;
        }
        top--;
        return data[top];
    }

    public String show() {
        String out = "[ ";
        for (int i = 0; i <= top - 1; i++) {
            out += "," + data[i];
        }
        return out + "]";
    }

    public String verifyPair(String expr) {
        for (int i =0; i < expr.length(); i++) {

        }
    }

}
