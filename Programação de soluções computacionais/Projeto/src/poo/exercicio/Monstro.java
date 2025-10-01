package poo.exercicio;

public class Monstro extends Personagem {

    int defesa = 40;
    int mana = 65;

    public Monstro(String nome, int vida, boolean atacavel) {
        super(nome, vida, atacavel);
    }

    public int getDefesa() {
        return defesa;
    }

    public int getMana() {
        return mana;
    }

    public void puloFoda(){
        System.out.println("O monstro deu um mortal muito foda.");
    }
    
}
