package poo;

import java.util.Random;

public class Personagem {
    int vida;
    String nome;

    public Personagem(String nome, int vida) {
        this.vida = vida;
        this.nome = nome;
    }

    public void atacar(Personagem alvo) {
        Random rand = new Random();
        int dano;
        int miss = rand.nextInt(10) + 1;
        System.out.printf("%s Se prepara para atacar e: ", nome);
        if (miss <= 3) {
            System.out.printf("\nErrou...\n\n", nome);
        } else {
            dano = rand.nextInt(10) + 1;
            System.out.printf("%s atacou %s e causou %d de dano.\n", nome, alvo.nome, dano);
            alvo.perderVida(dano);
        }

    }

    public void perderVida(int dano) {
        vida -= dano;
        if (vida < 0 || vida == 0) {
            System.out.printf("%s morreu!\n", nome);
        } else {
            System.out.printf("O deixando com míseros %d pontos de vida.\n\n", vida);
        }
    }

    public int getVida() {
        return vida;
    }

    public void setVida(int vida) {
        this.vida = vida;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
}

