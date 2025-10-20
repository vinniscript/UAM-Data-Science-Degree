import java.util.Scanner;

public class App {
    public static void main(String[] args) throws Exception {
        MyQueue<Person> fila = new MyQueue<>(3);
        Scanner scanner = new Scanner(System.in);
        int option;
        String name;
        int age;

        do{
            System.out.println("1. Chegada de paciente");
            System.out.println("2. Atender Paciente");
            System.out.println("3. Listar pacientes");
            System.out.println("4. Encerrar");
            System.out.print("opção--> ");
            option = Integer.parseInt(scanner.nextLine());

            switch (option) {
                case 1:
                    if(fila.isFull()) {
                        System.out.println("Consultório lotado.");
                        break;
                    }
                    System.out.println("Informe o nome do paciente");
                    name = scanner.nextLine();
                    System.out.println("Informe a idade do paciente:");
                    age = Integer.parseInt(scanner.nextLine());
                    fila.enqueue(new Person(name, age));
                    break;
                case 2:
                    if(fila.isEmpty()) {
                        System.out.println("Nenhum paciente esperando");
                        break;
                    }
                    System.out.print("Atendendo: " + fila.dequeue());
                    break;
                case 3:
                    System.out.println("Temos " + fila.size() + " paciente(s) aguardando");
                    System.out.println(fila.show());
                    break;
                case 4:
                    System.out.println("Até amanhã...");
                    break;
                default:
                    System.out.println("Opção inválida");
                    break;
            }

            
        } while(option != 4);
        scanner.close();
    }
}
