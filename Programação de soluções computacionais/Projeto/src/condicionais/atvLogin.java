package condicionais;

import java.util.Scanner;

public class atvLogin {

    public static void main(String[] args) {

//        Pegando usuário e senha.
        Scanner kb = new Scanner(System.in);

        System.out.print("Cadastre seu usuario: ");
        String user = kb.nextLine().toLowerCase();

        System.out.print("\nCadastre sua senha: ");
        String pass = kb.nextLine();
        System.out.println("\nUsuario cadastrado.\n");
        String tryPass; // vamos usar depois.

        String tryUser;
        int tentativasLogin = 3;
        int tentativasSenha = 3;

        for (int i = 0; i <= 10; i++) {
            
            // checagem se usuários.
            
            System.out.print("Redigite seu usuario: \n\n");
            tryUser = kb.nextLine().toLowerCase(); // Chamada tardío da variável.
            if (tryUser.equals(user)) {

                System.out.printf("Bem-vindo, %s, insira sua senha: ", user);
                tryPass = kb.nextLine();
                if (tryPass.equals(pass)) {
                    System.out.println("Login realizado.");
                    break; // Lembrar de quebrar o código.
                } else {
                    --tentativasLogin;
                    System.out.printf("Senha incorreta. Te restam %d tentativa(s) restantes.\n\n", tentativasLogin);
                }
            } else {
                --tentativasSenha;
                System.out.printf("Login incorreto. Te restam %d tentativa(s) restantes.\n\n", tentativasSenha);
            }
            if (tentativasLogin == 0 || tentativasSenha == 0) { 
                System.out.println("Excedeu o numero de tentativas. Tente novamente.");
                break;
            }
            if (i == 10) { // Matar o programa
                System.out.println("Tentativas de execução de software excedido.");
                break;
                
            }
        }
        kb.close(); // Fechar o Scanner
    }
}
