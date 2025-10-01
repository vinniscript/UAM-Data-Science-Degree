package poo.exercicio;

public class Heroi extends Personagem {

    public Heroi(String nome, int vida, boolean atacavel) {
        super(nome, vida, atacavel);
    }
    
    

    public void conjura() {
        System.out.println("O mago conjura seus feitiços.");
    }

public class Guerreiro extends Heroi {

    int defesa = 25;

        public Guerreiro(String nome, int vida, boolean atacavel) {
            super(nome, vida, atacavel);
        }

    
    
    public void escudo() {
        System.out.println("O guerreiro brande seu escudo.");
    }

    public int getDefesa() {
        return defesa;
    }

}

public class Mago extends Heroi {

    int mana = 40;

        public Mago(String nome, int vida, boolean atacavel) {
            super(nome, vida, atacavel);
        }

    public int getMana() {
        return mana;
    }
    }

}
