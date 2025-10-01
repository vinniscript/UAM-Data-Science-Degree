package poo;

import java.util.Scanner;

public class Principal {
    public static void main(String[] args) {
        Scanner kb = new Scanner(System.in);

        System.out.println("Qual o nome do seu personagem?");
        String charName = kb.nextLine();

        Personagem mcvv = new Personagem(charName, 45);

        System.out.println("O nome do guerreiro é " + mcvv.getNome());
        System.out.println("E sua vida " + mcvv.getVida() + "\n");

        Personagem satanas2 = new Personagem("Satanás 2", 11);
        System.out.println("Óh não, não pode ser, é o " + satanas2.getNome());
        System.out.println("Com seus inacreditáveis " + satanas2.getVida() + " Pontos de vida!\n");

        System.out.println("Vai rolar um combate?\n");
        System.out.printf("%s vai atacar, hein?... OLHA COMO ELE V... MINHA NOSSAAAAA!! INÁCREDITAAAAAAAAAAAAVEL..\n", mcvv.getNome());

        System.out.println("-----------------------");
            System.out.printf("%s Veio porradar com violência o %s.\n\n", mcvv.getNome(), satanas2.getNome());

        while (mcvv.getVida() > 0 || satanas2.getVida() > 0) {
            mcvv.atacar(satanas2);
            satanas2.atacar(mcvv);
        }
        System.out.println("-----------------------");
        kb.close();
    }
}
