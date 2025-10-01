

/* Criar um projeto chamado horta
Criar 2 classes: Principal e horta
Classe Horta deve ter:
Atributos:
-Contador - int
- Tipo de planta - String
- Semente - booleano
Métodos:
-Plantar - boolean 
- Crescer - boolean
- Colher - void

*/
package poo.horta;

/**
 *
 * @author 12523118487
 */
public class Horta {
//ATRIBUTO
    
    private int contador;
    private String tipo;
    private boolean semente;
    
    //CONTRUTOR

    public Horta(String tipo, boolean semente) {
        this.tipo = tipo;
        this.semente = semente;
        
        
    }
    //METODOS   
    public boolean plantar(){
        System.out.println("voce esta plantando a semente de" + this.tipo);
        return true;
        
    }
    public boolean crescer (){
        String [] mensagem = { "semente comecou a brotar","brotinho aparecendo ",
                "Apareceu a primeira folha", "agora esta pronta para colher"};
        for (contador = 0; contador < mensagem.length; contador++){
            System.out.println(contador);
        }
        return true;
        
    }
    
    public void colher(){
        if (contador == 0){
            System.out.println("voce nao esperou a planta crescer");
        }else {
            System.out.println("colheu com sucesso");
            contador = 0;
        }}
        public String getTipo(){
            return tipo;
        }
        public void setTipo(String tipo){
            this.tipo= tipo;
        }
    }
