package poo.veiculo;

public class Veiculo {
    boolean temPorta;
    int qtdRodas;
    
    boolean frente;

    public void andar(boolean frente) {
        if (frente) {
            System.out.println("Estou acelerando.");
        } else {
            System.out.println("engatei marcha ré.");
        }
    }
}
