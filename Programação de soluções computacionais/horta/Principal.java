/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package horta;

import java.util.Scanner;

/**
 *
 * @author 12523118487
 */
public class Principal {
    public static void main(String[] args) {
         
        
        Scanner tc = new Scanner(System.in);
        String planta;
        boolean temSemente;
        char possuiSementes;
        
        System.out.println("Bem vindo ao jogo da horta");
        
        System.out.println("O que você deseja plantar?");
        planta = tc.next();
        
        System.out.println("voce comprou sementes? [S/N]");
        possuiSementes = tc.next().toLowerCase().charAt(0);
        
        if (possuiSementes =='s'){
            temSemente = true;
          Horta arvore = new Horta(planta,temSemente);
          boolean plantei = arvore.plantar();
            System.out.println(arvore.getTipo()+ "foi plantada");
          if (plantei){
              boolean cresceu = arvore.crescer();
          }
        }else {
            System.out.println("Voce precisa de sementes para plantar");
        }
        
       
    }
}
   
