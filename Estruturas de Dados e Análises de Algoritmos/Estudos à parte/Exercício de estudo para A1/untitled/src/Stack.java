public class Stack <T>{

   private T[] data;
   private int top;

    @SuppressWarnings("unchecked")
    public Stack(int size){
        data = (T[]) new Object[size];
        top = 0;
    }



}
