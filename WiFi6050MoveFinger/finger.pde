public class Finger {
  private Tube [] tube;
  PVector vector;
  int [] l;
  float [] angle;

  Finger(PVector Vector, int[] L, float[] Angle){
    vector = Vector;
    for(int i=0; i<3;i++){
      l[i] = L[i];
      angle[i] = Angle[i];
    }
  }
  
  
  
}
