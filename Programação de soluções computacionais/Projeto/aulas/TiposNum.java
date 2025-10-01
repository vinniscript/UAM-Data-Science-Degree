
package aulas;



public class TiposNum {
    public static void main(String[] args) {
        System.out.println(9/5); // Você esta lidando com inteiros, mas a resposta não trará um inteiro.
        // O casting funciona diferente agora.
        System.out.println((double)9/5);
        // ou
        System.out.println(9.0/5);
        
        float a = (float)3.14;
        // ou
        a = 3.14f;
        
        
        double num1, num2; // Não usar somente double quando lidar com números. Dá-lhe a cagada
        num1 = 0.1;
        num2 = 0.2;
        
        System.out.println(Double.sum(num1, num2)); // -> Tem um site com o resultado desse output.
        System.out.println((float)Double.sum(num1, num2)); // colocando float na frente do Double.sum, o problema se resolve.
    }
}
