public class Stack {

    private int top;
    private int[] data;

    public Stack(int tamanho) { // Esse construtor cria uma pilha com o tamanho especificado pelo usuário.
        data = new int[tamanho]; // Cria um array de inteiros com o tamanho especificado.
        top = 0;
    }

    public boolean isEmpty() { // Função: Verifica se a pilha está vazia
        return top == 0;
    } // Verifica se a pilha está vazia, o 0 indica que não há elementos na pilha.

    public boolean isFull() { // Função: Verifica se a pilha está cheia
        return top == data.length;
    } // Verifica se a pilha está cheia, ou seja, se a composição da pilha igual ao tamanho do array.

    public int Size() {
        return top; // top nesse contexto representa o número de elementos na pilha.
    }  // Retorna a composição atual da pilha.

    public int capacity() { //Função: Retorna a capacidade máxima da pilha
        return data.length;
    } // Retorna a capacidade máxima da pilha, que é o tamanho do array.

    public void push(int newData) { // Função: Adicionar um novo elemento ao topo | Parâmetro: O novo elemento a ser adicionado
        if (isFull()) { // Verifica se a pilha está cheia antes de adicionar um novo elemento.
            System.out.println("The stack is full."); // Se estiver cheia, imprime uma mensagem de erro.
            return; // Sai da função sem adicionar o novo elemento.
        }
            data[top] = newData; // Adiciona um novo elemento onde se encontra o topo da pilha.
            top++; // Incrementa o topo para que a próxima adição seja feita na próxima posição.
    }

    public int pop() { // Função: Remover o elemento do topo | Retorna: O elemento removido

        if (isEmpty()) { //Verifica se está vazia antes de tentar remover um elemento.
            System.out.println("The stack is empty. There's nothing to pop."); // Se estiver vazia, imprime uma mensagem de erro.
            return -1; // Retorna −1 para indicar que não há elementos para remover.
        }

        top--; // Essa decrementação precisa estar aqui, pois ao fazer um push, o push é incrementado para um valor que ainda não foi preenchido. Um null. Por isso é necessário decrementar antes de acessar o valor.
        return data[top]; // Retorna o elemento que estava no topo da pilha.
    }

    public String show() { // Função: Exibir os elementos da pilha | Retorna: Uma string representando os elementos da pilha de uma forma amigável.
        if (isEmpty()) {
            return "Stack is empty.";
        }
        String out = "[" + data[0];
        for(int i = 1; i < top ; i++) {
            out += ", " + data[i];
        }
        out += "]";

        return out;
    }
}
