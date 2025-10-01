package atvoperacionais;

public class VivoMorto {

    public static void main(String[] args) {

        boolean vivo = true;

        String status;

        status = (!vivo == true) ? "vivo" : "morto";
        
        System.out.println(status);
    }
}
