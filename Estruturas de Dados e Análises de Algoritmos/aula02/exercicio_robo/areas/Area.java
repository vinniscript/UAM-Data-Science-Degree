package areas;

public class Area {
    private int maxX, maxY;

    public Area(int maxX, int maxY){
        if(maxX >= 0 && maxY >= 0) {
            this.maxX = maxX;
            this.maxY = maxY;
        }
    }

    public int getMaxX() {
        return maxX;
    }

    public int getMaxY() {
        return maxY;
    }
}
