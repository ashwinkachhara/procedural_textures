class Sphere extends Geometry{
  PVector pos = new PVector();
  PVector Ca = new PVector();
  PVector Cd = new PVector();
  float radius;
  boolean moving;
  PVector pos1, pos2;
  
  int noiseScale;
  int noiseType;
  
  WorleyNoise wn = new WorleyNoise();
  // -1: nothing, 0 - perlin noise, 1 - wood, 2 - marble, 3 - stone
  
  Sphere(PVector p, float r, PVector ka, PVector kd, int nscale, int type){
    pos = p.copy();
    radius = r;
    Ca = ka.copy();
    Cd = kd.copy();
    moving = false;
    noiseScale = nscale;
    noiseType = type;
    wn.init(pos,radius,5);
  }
  
  Sphere(PVector p, float r, PVector ka, PVector kd, boolean m, PVector p1, PVector p2){
    pos = p.copy();
    radius = r;
    Ca = ka.copy();
    Cd = kd.copy();
    moving = m;
    pos1 = p1.copy();
    pos2 = p2.copy();
  }
  
  Sphere(){
    
  }
  
  PVector getPMax(){
    return new PVector(pos.x+radius,pos.y+radius,pos.z+radius);
  }
  
  PVector getPMin(){
    return new PVector(pos.x-radius,pos.y-radius,pos.z-radius);
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
  
  float intersects(PVector d, PVector P, float t){
    
    PVector newpos = PVector.lerp(pos1,pos2,t);
    float b = -2*((newpos.x-P.x)*d.x+(newpos.y-P.y)*d.y+(newpos.z-P.z)*d.z);
    float a = d.magSq();
    float c = sq(P.x-newpos.x)+sq(P.y-newpos.y)+sq(P.z-newpos.z)-radius*radius;
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
  
  PVector getNormal(PVector P, float t){
    PVector newpos = PVector.lerp(pos1,pos2,t);
    return PVector.sub(P,newpos).normalize();
  }
  
  PVector calcDiffuse(PVector P, PVector n, int l){
    PVector col = new PVector(0,0,0);
    PVector L = lights[l].vec2Light(P);//PVector.sub(lights[l].pos,P);
    L.normalize();
    PVector lColor = lights[l].getColor();
    float perlinNoise;
    float turbPower;
    float turbSize;
    float sinValue;
    
    // INSPIRATION FROM http://lodev.org/cgtutor/randomnoise.html
    switch(noiseType){
      case -1:
        col.x = Cd.x*(PVector.dot(L,n))*lColor.x;
        col.y = Cd.y*(PVector.dot(L,n))*lColor.y;
        col.z = Cd.z*(PVector.dot(L,n))*lColor.z;
        return col;
      case 0:
        perlinNoise = noise_3d(P.x*noiseScale,P.y*noiseScale,P.z*noiseScale);
        perlinNoise = (perlinNoise + 1.0)/2.0;
        col.x = Cd.x*(PVector.dot(L,n))*lColor.x*perlinNoise;
        col.y = Cd.y*(PVector.dot(L,n))*lColor.y*perlinNoise;
        col.z = Cd.z*(PVector.dot(L,n))*lColor.z*perlinNoise;
        return col;
      case 1:
        turbPower = 0.1;
        turbSize = 8.0;
        float xyzPeriod = 8.0;
        float dist = sqrt(P.z*P.z+P.x*P.x) + turbPower*turbulence(P.x,P.y,P.z,turbSize);
        sinValue = 0.5 *abs(sin(2*xyzPeriod*dist*PI));
        PVector woodColor = new PVector(0.5078, 0.3203, 0.0039);
        
        
        
        col.x = (woodColor.x+sinValue)*(PVector.dot(L,n))*lColor.x;
        col.y = (woodColor.y+sinValue)*(PVector.dot(L,n))*lColor.y;
        col.z = woodColor.z*(PVector.dot(L,n))*lColor.z;
        return col;
        
      case 2:
        float xPeriod = 1, yPeriod = 5, zPeriod = 5;
        turbPower = 1; turbSize = 32;
        
        float xyzVal = (P.x)*xPeriod/(2*radius) + (P.y)*yPeriod/(2*radius) + (P.z)*zPeriod/(2*radius) + turbPower*turbulence(P.x,P.y,P.z,turbSize);
        sinValue = 0.5 * abs(sin(xyzVal*PI));
        //sinValue = turbPower*turbulence(P.x,P.y,P.z, turbSize);
        
        PVector marbleColor = new PVector(0.3078, 0.2203, 0.3039);
        
        col.x = (marbleColor.x)*(PVector.dot(L,n))*lColor.x;
        col.y = (marbleColor.y+sinValue)*(PVector.dot(L,n))*lColor.y;
        col.z = (marbleColor.z+sinValue)*(PVector.dot(L,n))*lColor.z;
        return col;
        
      case 3:
        PVector stoneColor = new PVector(0.82, 0.41, 0.12), cementColor = new PVector(1,1,1);
        
        float worley = wn.getNoise(P);
        
        //println(worley);
        
        if (worley > 0.05){
          int seed = wn.getMinIndex();
          perlinNoise = noise_3d(P.x,P.y,P.z);
          perlinNoise = (perlinNoise + 1.0)/2;
          col.x = (stoneColor.x)*(PVector.dot(L,n))*lColor.x;
          col.y = (stoneColor.y+0.25*perlinNoise)*(PVector.dot(L,n))*lColor.y*perlinNoise;
          col.z = (stoneColor.z)*(PVector.dot(L,n))*lColor.z*perlinNoise;
          return col;
        } else {
          perlinNoise = noise_3d(P.x*100,P.y*100,P.z*100);
          perlinNoise = (perlinNoise + 1.0)/2.0;
          col.x = cementColor.x*(PVector.dot(L,n))*lColor.x*perlinNoise;
          col.y = cementColor.y*(PVector.dot(L,n))*lColor.y*perlinNoise;
          col.z = cementColor.z*(PVector.dot(L,n))*lColor.z*perlinNoise;
          return col;
        }
          
        
        
    }
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
    println("pos: "+pos.x+" "+pos.y+" "+pos.z);
  }
  
  boolean isMoving(){
    return moving;
  }
}