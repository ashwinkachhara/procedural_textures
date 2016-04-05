class AABB extends Geometry {
  public PVector Pmin, Pmax;
  PVector Ca = new PVector();
  PVector Cd = new PVector();
  
  AABB(PVector pmin, PVector pmax, PVector ka, PVector kd){
    Pmin = pmin.copy();
    Pmax = pmax.copy();
    //println(Pmin,Pmax);
    Ca = ka.copy();
    Cd = kd.copy();
  }
  
  AABB(PVector pmin, PVector pmax){
    Pmin = pmin.copy();
    Pmax = pmax.copy();
  }
  
  PVector getPMax(){
    return Pmax;
  }
  
  PVector getPMin(){
    return Pmin;
  }
  
  boolean isPtOnBox(PVector P){
    return (P.y>=Pmin.y && P.y<=Pmax.y && P.z>=Pmin.z && P.z<=Pmax.z && P.x>=Pmin.x && P.x<=Pmax.x);
  }
  
  float intersects(PVector d, PVector P){
    float t[] = new float[6];
    t[0] = (Pmin.x-P.x)/d.x;
    t[1] = (Pmax.x-P.x)/d.x;
    t[2] = (Pmin.y-P.y)/d.y;
    t[3] = (Pmax.y-P.y)/d.y;
    t[4] = (Pmin.z-P.z)/d.z;
    t[5] = (Pmax.z-P.z)/d.z;
    
    float sol = MAX_FLOAT;
    for (int i=0;i<6;i++){
      if (t[i]>0){
        PVector pt = PVector.add(P,PVector.mult(d,t[i]));
        boolean ptonbox = isPtOnBox(pt);
        //if (d.x==0 && d.y==0)
          //println("HELLO", ptonbox,t[i],pt);
        if (ptonbox){
          if (sol > t[i])
            sol = t[i];
        }
      }
    }
    if (sol == MAX_FLOAT)
      return -1000;
    else{
      //println(sol);
      return sol;
    }
    //float tmin, tmax;
    //tmin = min(txm, txM);
    //tmax = max(txm, txM);
    
    //if (tym > tyM){
    //  float buf = tym;
    //  tym = tyM;
    //  tyM = buf;
    //}
    
    //if ((tmin > tyM) || (tym > tmax))
    //  return -1000;

    //tmin = min(tmin, tym);
    //tmax = max(tmax, tyM);
    
    //if (tzm > tzM){
    //  float buf = tzm;
    //  tzm = tzM;
    //  tzM = buf;
    //}
    
    //if ((tmin > tzM) || (tzm > tmax))
    //  return -1000;

    //tmin = min(tmin, tzm);
    //tmax = max(tmax, tzM);
    
    ////println(tmax+ " " + tmin);
    //if (tmin>0)
    //  return tmin;
    //return -1000;
  }
  PVector getNormal(PVector P){
    PVector n = new PVector(0,0,0);
    if (P.x == Pmin.x && P.y>=Pmin.y && P.y<=Pmax.y && P.z>=Pmin.z && P.z<=Pmax.z)
      n = new PVector(-1,0,0);
    if (P.x == Pmax.x && P.y>=Pmin.y && P.y<=Pmax.y && P.z>=Pmin.z && P.z<=Pmax.z)
      n = new PVector(1,0,0);
    if (P.y == Pmin.y && P.x>=Pmin.x && P.x<=Pmax.x && P.z>=Pmin.z && P.z<=Pmax.z)
      n = new PVector(0,-1,0);
    if (P.y == Pmax.y && P.x>=Pmin.x && P.x<=Pmax.x && P.z>=Pmin.z && P.z<=Pmax.z)
      n = new PVector(0,1,0);
    if (P.z == Pmin.z && P.y>=Pmin.y && P.y<=Pmax.y && P.x>=Pmin.x && P.x<=Pmax.x)
      n = new PVector(0,0,-1);
    if (P.z == Pmax.z && P.y>=Pmin.y && P.y<=Pmax.y && P.x>=Pmin.x && P.x<=Pmax.x)
      n = new PVector(0,0,1);
    return n;
  }
  PVector calcDiffuse(PVector P, PVector n, int l){
    PVector col = new PVector(0,0,0);
    PVector L = lights[l].vec2Light(P);//PVector.sub(lights[l].pos,P);
    L.normalize();
    if (PVector.dot(L,n) < 0){
      n.x = -n.x;
      n.y = -n.y;
      n.z = -n.z;
    }
    PVector lColor = lights[l].getColor();
    col.x = Cd.x*(PVector.dot(L,n))*lColor.x;
    col.y = Cd.y*(PVector.dot(L,n))*lColor.y;
    col.z = Cd.z*(PVector.dot(L,n))*lColor.z;
    return col;
  }
  PVector calcAmbient(int l){
    PVector col = new PVector(0,0,0);
    PVector lColor = lights[l].getColor();
    col.x = Ca.x*lColor.x;
    col.y = Ca.y*lColor.y;
    col.z = Ca.z*lColor.z;
    return col;
  }
  void printval(){
    
  }
  PVector getM1d(PVector d, PVector P){
    return d;
  }
  PVector getM1P(PVector P){
    return P;
  }
  PVector getMP(PVector P){
    return P;
  }
}