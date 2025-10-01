public class RoboSimples extends Robo{


    public RoboSimples(Tela tela) {
        super(tela);
    }

    public RoboSimples(Tela tela, int x, int y) {
        super(tela, x, y);
    }

    @Override
    public void moverNorte(int distancia) {
        // TODO: verificar se tem obstáculos
        int novoY = getY() - distancia;
        if(novoY >= 0){
            setY(novoY);
        }
    }

    @Override
    public void moverSul(int distancia) {
        // TODO: verificar se tem obstáculos
        int novoX = getX() - distancia;
        if(novoX >= 0){
            setX(novoX);
        }
    }

    @Override
    public void moverLeste(int distancia) {

    }

    @Override
    public void moverOeste(int distancia) {

    }
}
