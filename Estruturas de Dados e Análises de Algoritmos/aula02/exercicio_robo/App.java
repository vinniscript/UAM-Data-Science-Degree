import areas.Area;
import robos.Robo;
import robos.RoboSimples;

public class App {

    public static void main(String[] args) {
        Area area = new Area(100, 100);
        Robo robo = new RoboSimples(10, 10, area);

        System.out.println("Robo está em: " + robo);
        if(robo.moverNorte(5)){
            System.out.println("Moveu para: " + robo);
        } else {
            System.out.println("Erro ao mover");
        }


    }
}