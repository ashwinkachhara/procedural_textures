class Polygon extends Shape{
  PVector A,B,C,n;
  PVector Ca = new PVector();
  PVector Cd = new PVector();
  
  Polygon(PVector a, PVector b, PVector c, PVector ka, PVector kd){
    A = a;
    B = b;
    C = c;
    Ca = ka.copy();
    Cd = kd.copy();
    n = new PVector(0,0,0);
    PVector.cross(PVector.sub(B,A),PVector.sub(C,B), n);
    n.normalize();
  }
  
  float intersects(PVector d, PVector P){
    float a = n.x, b = n.y, c = n.z;
    float d1 = -a*A.x-b*A.y-c*A.z;
    float t = - (a*P.x+b*P.y+c*P.z+d1)/(a*d.x+b*d.y+c*d.z);
    
    PVector Pp = PVector.add(P,PVector.mult(d,t));
    
    //Point in triangle test - barycentric coordinates (REF: http://www.blackpawn.com/texts/pointinpoly/)
    PVector v0 = PVector.sub(C,A);
    PVector v1 = PVector.sub(B,A);
    PVector v2 = PVector.sub(Pp,A);
    
    float dot00 = PVector.dot(v0,v0);
    float dot01 = PVector.dot(v0,v1);
    float dot02 = PVector.dot(v0,v2);
    float dot11 = PVector.dot(v1,v1);
    float dot12 = PVector.dot(v1,v2);
    
    // Compute barycentric coordinates
    float invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * invDenom;
    float v = (dot00 * dot12 - dot01 * dot02) * invDenom;
    
    if (u>=0 && v>=0 && u+v<1)
      return t;
    
    return -1000;
  }
  PVector getNormal(PVector P){
    return n;
  }
  PVector calcDiffuse(PVector P, PVector n, int l){
    PVector col = new PVector(0,0,0);
    PVector L = PVector.sub(lights[l].pos,P);
    L.normalize();
    if (PVector.dot(L,n) < 0){
      n.x = -n.x;
      n.y = -n.y;
      n.z = -n.z;
    }
    col.x = Cd.x*(PVector.dot(L,n))*lights[l].lColor.x;
    col.y = Cd.y*(PVector.dot(L,n))*lights[l].lColor.y;
    col.z = Cd.z*(PVector.dot(L,n))*lights[l].lColor.z;
    return col;
  }
  PVector calcAmbient(int l){
    PVector col = new PVector(0,0,0);
    col.x = Ca.x*lights[l].lColor.x;
    col.y = Ca.y*lights[l].lColor.y;
    col.z = Ca.z*lights[l].lColor.z;
    return col;
  }
  
  void printval(){
    println("A: "+A.x+" "+A.y+" "+A.z);
    println("B: "+B.x+" "+B.y+" "+B.z);
    println("C: "+C.x+" "+C.y+" "+C.z);
  }
}