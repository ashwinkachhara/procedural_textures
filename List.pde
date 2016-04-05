class List extends Geometry {
  AABB bbox;

  Geometry[] items;
  int numItems = 0;
  public int hitObIndex = 0;

  List(int start, int end) {
    items = new Geometry[end-start];
    for (int i = start; i<end; i++) {
      items[numItems] = objects[i];
      numItems++;
    }
    //compute box
    //println("Hello",items.length);
    PVector pmax = getPMax();
    PVector pmin = getPMin();
    //println(pmax,pmin);
    bbox = new AABB(pmin, pmax);
  }
  
  PVector getPMax(){
    PVector Pmax = new PVector (-MAX_FLOAT,-MAX_FLOAT,-MAX_FLOAT);
    PVector pp;
    for (int i = 0; i<numItems; i++){
      pp = items[i].getPMax();
      Pmax = new PVector(max(Pmax.x,pp.x), max(Pmax.y,pp.y), max(Pmax.z,pp.z));
    }
    return Pmax;
  }
  
  PVector getPMin(){
    PVector Pmin = new PVector (MAX_FLOAT,MAX_FLOAT,MAX_FLOAT);
    PVector pp;
    for (int i = 0; i<numItems; i++){
      pp = items[i].getPMin();
      Pmin = new PVector(min(Pmin.x,pp.x), min(Pmin.y,pp.y), min(Pmin.z,pp.z));
    }
    return Pmin;
  }
  
  float intersects(PVector d, PVector P) {
    float minT = MAX_INT; 
    boolean found = false;
    if (bbox.intersects(d, P) == -1000){
      //println("no box");
      return -1000;
    } else {
      //println("box");
      for (int i=0; i<numItems; i++) {
        float t;
        t = items[i].intersects(d, P);
        if (t > 0 && t<minT) {
          //println(t);
          found = true;
          minT = t;
          hitObIndex = i;
        }
      }
      return minT;
    }
  }
  PVector getNormal(PVector P) {
    return items[hitObIndex].getNormal(P);
  }
  PVector calcDiffuse(PVector P, PVector n, int l) {
    return items[hitObIndex].calcDiffuse(P, n, l);
  }
  PVector calcAmbient(int l) {
    return items[hitObIndex].calcAmbient(l);
  }

  void printval() {
  }
  PVector getM1d(PVector d, PVector P) {
    return d;
  }
  PVector getM1P(PVector P) {
    return P;
  }
  PVector getMP(PVector P) {
    return P;
  }
}