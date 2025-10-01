package aulas;

public class MaxMin {
    public static void main(String[] args){
            int minimo, maximo;
            
            minimo = 1; // Big bang dos inteiros
            maximo = Integer.MAX_VALUE;
            
            System.out.println(minimo);
            System.out.println(maximo);
            System.out.println(Integer.sum(minimo, maximo)); // Estouro de memória.
    }
    
}
