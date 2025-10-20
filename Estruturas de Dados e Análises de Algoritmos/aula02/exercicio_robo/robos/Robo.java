package robos;

import areas.Area;

public abstract class Robo {
    private int posX, posY;
    private Area area;

    public Robo(int posX, int posY, Area area) {
        this.area = area;
        if (isValidPosX(posX) && isValidPosY(posY)) {
            this.posX = posX;
            this.posY = posY;
        }
    }

    public boolean isValidPosX(int posX) {
        return posX >= 0 && posX <= area.getMaxX();
    }

    public boolean isValidPosY(int posY) {
        return posY >= 0 && posY <= area.getMaxY();
    }

    public void setPosX(int posX) {
        if (isValidPosX(posX)) {
            this.posX = posX;
        }
    }

    public void setPosY(int posY) {
        if (isValidPosY(posY)) {
            this.posY = posY;
        }
    }

    @Override
    public String toString() {
        return "(" + posX + "," + posY + ")";
    }

    public int getPosX() {
        return posX;
    }

    public int getPosY() {
        return posY;
    }

    public Area getArea() {
        return area;
    }

    public abstract boolean moverNorte(int deslocamento);

    public abstract boolean moverSul(int deslocamento);

    public abstract boolean moverLeste(int deslocamento);

    public abstract boolean moverOeste(int deslocamento);
}
