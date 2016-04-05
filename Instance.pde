class Instance extends Geometry {
  PMatrix3D tfMatrix;
  String name;
  
  Instance(PMatrix3D mat, String ob){
    tfMatrix = mat;
    tfMatrix.invert();
    name = ob;
  }
  
  PVector getPMax(){
    return getMP(named_objects.get(name).getPMax());
  }
  
  PVector getPMin(){
    return getMP(named_objects.get(name).getPMin());
  }
  
  PVector getM1d(PVector d, PVector P){
    PVector dd = new PVector(0,0,0), Pp = new PVector(0,0,0);
    tfMatrix.mult(PVector.add(P,d),dd);
    tfMatrix.mult(P,Pp);
    dd.sub(Pp);
    return dd;
  }
  
  PVector getM1P(PVector P){
    PVector Pp = new PVector(0,0,0);
    tfMatrix.mult(P,Pp);
    return Pp;
  }
  
  PVector getMP(PVector P){
    PVector Pp = new PVector(0,0,0);
    PMatrix3D mat = new PMatrix3D(tfMatrix);
    mat.invert();
    mat.mult(P,Pp);
    return Pp;
  }
  
  float intersects(PVector d, PVector P){
    PVector dd = new PVector(0,0,0), Pp = new PVector(0,0,0);
    tfMatrix.mult(PVector.add(P,d),dd);
    tfMatrix.mult(P,Pp);
    dd.sub(Pp);
    return named_objects.get(name).intersects(dd,Pp);
  }
  PVector getNormal(PVector P){
    PMatrix3D mat = new PMatrix3D(tfMatrix);
    //mat.invert();
    mat.transpose();
    
    PVector n = named_objects.get(name).getNormal(P);
    PVector nn = new PVector(0,0,0);
    mat.mult(n, nn);
    return nn;
  }

  PVector calcDiffuse(PVector P, PVector n, int l){
    return named_objects.get(name).calcDiffuse(P,n,l);
  }
  PVector calcAmbient(int l){
    return named_objects.get(name).calcAmbient(l);
  }
  void printval(){
    println(name);
  }
}