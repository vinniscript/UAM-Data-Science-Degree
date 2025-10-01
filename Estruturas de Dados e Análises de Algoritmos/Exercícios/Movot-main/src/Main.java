//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {
    public static void main(String[] args) {
        Tela tela = new Tela(100, 100);

        RoboSimples robo = new RoboSimples(tela, 10, 10);

        System.out.println(robo);
        robo.moverNorte(10);
        System.out.println(robo);
        robo.moverNorte(10);
        System.out.println(robo);

    }
}