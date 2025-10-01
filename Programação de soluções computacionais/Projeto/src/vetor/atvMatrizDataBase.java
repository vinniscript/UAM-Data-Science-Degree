
/* Loja tem 4 vendedores: João, Fabiano, Flávio e Soraia

Cada vendedor tem seu salário, J= 1000, F= 1500, Fl= 800 e S= 2000.

meta de vendo do mês, J= 600 unidades, F= 650u, Fl= 250u e S= 60.

Criar uma matriz do tipo String com todos os valores dos vendedores.
Depois, o programa deve retornar quem bateu a meta, se bateu a meta e não chegou a 10%, 
o vendedor não ganha bônus e,não bateu a meta.
*/

package vetor;

public class atvMatrizDataBase {

    public static void main(String[] args) {


        String[][] func = {
                {"João", "1000.00", "600"},
                {"Fábiano", "1500.00", "650"},
                {"Flávio", "800.00", "250"},
                {"Soraia", "2000.00", "60"}
        };

        for (String[] row : func) {
            String nomes = row[0];
            int vendas = Integer.parseInt(row[2]);
            float salario = Float.parseFloat(row[1].replace(",", "."));
            float bonus = 0;

            if (vendas > 600) {
                bonus = salario * 1.1f;
                System.out.printf("%s, ganha %.2f, vendeu %d. Seu salario esse mês foi de %.2f.\n", nomes, salario, vendas, bonus);
                System.out.println();
            } else {
                System.out.printf("%s, ganha %.2f, vendeu %d. Não teve acréscimo esse mês, pois não bateu a meta de mais de 600 vendas.\n", nomes, salario, vendas);
                System.out.println();
            }
        }
    }


}



