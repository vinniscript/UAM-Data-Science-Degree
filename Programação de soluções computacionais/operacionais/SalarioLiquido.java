
package aula1603;

public class SalarioLiquido {
    
    public static void main(String[] args) {
        
        float salario = 100.00f;
        float ir = 0.00f;
        float saliq = 100.00f;
 
        System.out.println("Salário: R$" + salario);
        System.out.println("Salário é maior ou igual a R$100,00?");
        System.out.println(saliq >= 100);
        System.out.println("\n");
        
        salario = 200.00f;
        ir = 20.0f;
        saliq = 190.00f;
        
        System.out.println("Salário líquido: R$" + saliq);
        System.out.println("Salário líquido é menor que R$190,00?");
        System.out.println(saliq < 190);
        System.out.println("\n");
        
        salario = 300.00f;
        ir = 15.00f;
        saliq = 285.00f;
        
        System.out.println("Salário: R$" + salario + "\n"
        + "Ir: R$" + ir + "\n"
        + "Salário líquido: R$" + saliq + "\n");
        
        System.out.println("Sálario líquido é igual a IR + salário?");
        System.out.println("total = R$315,00.");
        System.out.println(saliq == ir + salario);
        System.out.println("\n");
        
    }
}
