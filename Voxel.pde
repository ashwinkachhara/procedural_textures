class Voxel {
  public ArrayList<Integer> items;
  public int hitObIndex = 0;
  
  Voxel(){
    items = new ArrayList<Integer>();
  }
  
  void addGeometry(int g){
    //println("addGeo");
    items.add(g);
    //println("addGeoDone");
  }
  
  float intersects(PVector d, PVector P){
    //println("Jello");
    float minT = MAX_INT; 
    boolean found = false;
    for (int i=0; i<items.size(); i++) {
      float t;
      t = primitives[items.get(i)].intersects(d, P);
      if (t > 0 && t<minT) {
        //println(t);
        found = true;
        minT = t;
        hitObIndex = items.get(i);
      }
    }
    //println("Yello");
    if (found)
      return minT;
    else
      return -1000;
  }
}