public class Main {
//
//    public static void main(String[] args) {
//        ArrayList<String> exec = new ArrayList();
//        String frase = "Este exercício é muito fácil";
//
//        String[] palavras = frase.split(" ");
//
//        for (int i = 0; i < palavras.length; i++) {
//            String palavra  = palavras[i];
//            exec.add(palavra);
//        }
//
//        for (int i =  0; i < exec.size(); i++) {
//            String palavra = exec.get(i);
//            String palavraInvertida = new StringBuilder(palavra).reverse().toString();
//            //System.out.println(palavraInvertida);
//        }
//
//        // OUUUU
//
//        char[] resultado = InversaoMaluca();
//        for (char s: resultado) {
//            System.out.println(s);
//        }
//
//
//        }
//
//        public static char[] InversaoMaluca() {
//            ArrayList<Character> exec = new ArrayList<>();
//            String frase = "Este exercício é muito fácil";
//
//            String[] palavras = frase.split(" ");
//
//            for (int i = 0; i < palavras.length; i++) {
//                String palavra  = palavras[i];
//                char[] palavraInvertida = palavra.toCharArray();
//                for (int j = 0; j < palavraInvertida.length / 2; j++) {
//                    char temp = palavraInvertida[j];
//                    palavraInvertida[j] = palavraInvertida[palavraInvertida.length - 1 - j];
//                    palavraInvertida[palavraInvertida.length - 1 - j] = temp;
//                }
//                // Adiciona os caracteres invertidos à lista exec
//                for (char c: palavraInvertida) {
//                    exec.add(c);
//                }
//            }
//            // Converte a lista exec para um array de caracteres
//            char[] resultado = new char[exec.size()];
//            for (int i = 0; i < exec.size(); i++) {
//                resultado[i]  =  exec.get(i);
//            }
//            return resultado;
//        } Fiz completamente errado
}