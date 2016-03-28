class Sphere extends Shape{
  PVector pos = new PVector();
  PVector Ca = new PVector();
  PVector Cd = new PVector();
  float radius;
  
  Sphere(PVector p, float r, PVector ka, PVector kd){
    pos = p.copy();
    radius = r;
    Ca = ka.copy();
    Cd = kd.copy();    
  }
  
  Sphere(){
    
  }
  
  //float intersects(PVector d){
  //  float b = -2*(pos.x*d.x+pos.y*d.y+pos.z*d.z);
  //  float a = d.magSq();
  //  float c = pos.x*pos.x+pos.y*pos.y+pos.z*pos.z-radius*radius;
  //  //print(a+" "+b+" "+c+" ");
  //  if (b*b < 4*a*c){
  //    //println(-1);
  //    return -1000;
  //  }
  //  float t1 = (-b+sqrt(1.0*b*b-4.0*a*c))/(2.0*a);
  //  float t2 = (-b-sqrt(1.0*b*b-4.0*a*c))/(2.0*a);
  //  //println(t1," ",t2);
    
  //  if (t1<0 && t2<0){
  //    return -1000;
  //  } else if (t1>0 && t2>0){
  //    return min(t1,t2);
  //  } else if (t1>0){
  //    return t1;
  //  } else {
  //    return t2;
  //  }
  //}
  
  float intersects(PVector d, PVector P){
    float b = -2*((pos.x-P.x)*d.x+(pos.y-P.y)*d.y+(pos.z-P.z)*d.z);
    float a = d.magSq();
    float c = sq(P.x-pos.x)+sq(P.y-pos.y)+sq(P.z-pos.z)-radius*radius;
    //print(a+" "+b+" "+c+" ");
    if (b*b < 4*a*c){
      //println(-1);
      return -1000;
    }
    float t1 = (-b+sqrt(1.0*b*b-4.0*a*c))/(2.0*a);
    float t2 = (-b-sqrt(1.0*b*b-4.0*a*c))/(2.0*a);
    //println(t1," ",t2);
    
    if (t1<0 && t2<0){
      return -1000;
    } else if (t1>0 && t2>0){
      return min(t1,t2);
    } else if (t1>0){
      return t1;
    } else {
      return t2;
    }
  }
  
  PVector getNormal(PVector P){
    return PVector.sub(P,pos).normalize();
  }
  
  PVector calcDiffuse(PVector P, PVector n, int l){
    PVector col = new PVector(0,0,0);
    PVector L = PVector.sub(lights[l].pos,P);
    L.normalize();
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
    println("pos: "+pos.x+" "+pos.y+" "+pos.z);
  }
}