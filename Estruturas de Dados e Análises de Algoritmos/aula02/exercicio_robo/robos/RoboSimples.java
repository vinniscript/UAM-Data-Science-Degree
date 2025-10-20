package robos;

import areas.Area;

public class RoboSimples extends Robo {

    public RoboSimples(int posX, int posY, Area area){
        super(posX, posY, area);
    }

    @Override
    public boolean moverNorte(int deslocamento) {
        if(getPosY() >= deslocamento){
            setPosY( getPosY() - deslocamento);
            return true;
        }
        return false;
    }

    @Override
    public boolean moverSul(int deslocamento) {
        if(getPosY() + deslocamento <= getArea().getMaxY()){
            setPosY( getPosY() + deslocamento);
            return true;
        }
        return false;
    }

    @Override
    public boolean moverLeste(int deslocamento) {
       return false;
    }

    @Override
    public boolean moverOeste(int deslocamento) {
        return false;
    }
    
}
