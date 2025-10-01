/*

Criar uma classe personagem que será mãe de outras 3 classses (Heroi, Monstro e NPC)
A classe Personagem terá os atributos:
String Nome e int Vida e Boolean atacavel

A classe Herói, por sua vez, terá 2 classes filhas (Guerreiro, Mago)
- Guerreiro deve ter defesa
- Mago deve ter Mana


A classe Monstro deve ter: Mana e Defesa
*/


package poo.exercicio;


import poo.exercicio.*;

public class Principal {
    public static void main(String[] args) {
        Heroi.Guerreiro p1 = new Heroi.Guerreiro(nome, 0, true);
        
        
                
//        Monstro leonardo = new Monstro("Leonardo", 99, true);
//        leonardo.puloFoda();
    }
}
