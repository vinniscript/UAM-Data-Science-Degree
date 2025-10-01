package poo.exercicio;

public class Personagem {

    String nome;
    int vida;
    boolean atacavel;

    public Personagem(String nome, int vida, boolean atacavel) {
        this.nome = nome;
        this.vida = vida;
        this.atacavel = atacavel;
    }

    public String getNome() {
        return nome;
    }

    public int getVida() {
        return vida;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setVida(int vida) {
        this.vida = vida;
    }

}
