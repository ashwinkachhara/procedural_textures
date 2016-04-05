class GridAccel extends Geometry{
  ArrayList<Integer> items;
  int numItems = 0;
  Voxel[] voxels;
  
  AABB bounds;
  PVector nVoxels = new PVector(0,0,0);
  PVector voxWidth = new PVector(0,0,0);
  PVector invVoxWidth = new PVector(0,0,0);
  int nv;
  
  int hitObjectIndex;
  
  GridAccel(int start, int end){
    items = new ArrayList<Integer>();
    for (int i = start; i<end; i++) {
      items.add(i);
      primitives[i] = objects[i];
      numItems++;
    }
    println("Num Items:",numItems);
    //println("Hello");
    PVector pmin = getPMin();
    PVector pmax = getPMax();
    //println("Hello2");
    //println(pmin,pmax);

    bounds = new AABB(pmin, pmax);
    calcBoundsResolution();
    
    voxels = new Voxel[nv];
    
    addGeometryToVoxels();

    println(nv,nVoxels);
  }
  
  float intersects(PVector d, PVector P){
    float minT = MAX_INT; 
    boolean found = false;
    
    // check ray vs overall grid bounds
    if (bounds.intersects(d, P) == -1000){
      //println("no box");
      return -1000;
    } else {
      minT = bounds.intersects(d, P);
      PVector gridIntersect = PVector.add(P,PVector.mult(d,minT));
      
      // Set up 3D DDA for this ray
      PVector nextCrossingT = new PVector(0,0,0), deltaT = new PVector(0,0,0);
      PVector step = new PVector(0,0,0), out = new PVector(0,0,0), pos = new PVector(0,0,0);
      pos = posToVoxel(gridIntersect);
      
      if (d.x>=0){
        nextCrossingT.x = minT + (voxelToPos(PVector.add(pos,new PVector(1,1,1))).x - gridIntersect.x)/d.x;
        deltaT.x = voxWidth.x/d.x;
        step.x = 1;
        out.x = nVoxels.x;
      } else {
        nextCrossingT.x = minT + (voxelToPos(pos).x - gridIntersect.x)/d.x;
        deltaT.x = -voxWidth.x/d.x;
        step.x = -1;
        out.x = -1;
      }
      if (d.y>=0){
        nextCrossingT.y = minT + (voxelToPos(PVector.add(pos,new PVector(1,1,1))).y - gridIntersect.y)/d.y;
        deltaT.y = voxWidth.y/d.y;
        step.y = 1;
        out.y = nVoxels.y;
      } else {
        nextCrossingT.y = minT + (voxelToPos(pos).y - gridIntersect.y)/d.y;
        deltaT.y = -voxWidth.y/d.y;
        step.y = -1;
        out.y = -1;
      }
      if (d.z>=0){
        nextCrossingT.z = minT + (voxelToPos(PVector.add(pos,new PVector(1,1,1))).z - gridIntersect.z)/d.z;
        deltaT.z = voxWidth.z/d.z;
        step.z = 1;
        out.z = nVoxels.z;
      } else {
        nextCrossingT.z = minT + (voxelToPos(pos).z - gridIntersect.z)/d.z;
        deltaT.z = -voxWidth.z/d.z;
        step.z = -1;
        out.z = -1;
      }
      
      // Walk ray through voxel grid
      Voxel currentVox;
      minT = -1000;
      int b2,b1,b0;
      float[] NextCrossingT = new float[3];
      while(true){
        //println("or else...");
        currentVox = voxels[offset(int(pos.x),int(pos.y),int(pos.z))];
        float t;
        if (currentVox == null){
          //println("is null");
          t = -1000;
        } else {
          t = currentVox.intersects(d,P);
          //println("vox intersect");
        }
        //println("I dare you, I double dare you");
        if (t!=-1000){
          found = true;
          minT = t;
          hitObjectIndex = currentVox.hitObIndex;
          //println(minT);
          return minT;
        }
        
        // Find step axis
        NextCrossingT = nextCrossingT.array();
        b2 = (NextCrossingT[0] < NextCrossingT[1])? 1:0;
        b1 = (NextCrossingT[0] < NextCrossingT[2])? 1:0;
        b0 = (NextCrossingT[1] < NextCrossingT[2])? 1:0;
        int bits = (b2 << 2) +
                   (b1 << 1) +
                   (b0);
        int cmpToAxis[] = { 2, 1, 2, 1, 2, 2, 0, 0 };
        int stepAxis = cmpToAxis[bits];
        //println(stepAxis);
        
        if (stepAxis == 0){
          pos.x += step.x;
          if (pos.x == out.x)
            break;
          nextCrossingT.x += deltaT.x;
        } else if (stepAxis == 1){
          pos.y += step.y;
          if (pos.y == out.y)
            break;
          nextCrossingT.y += deltaT.y;
        } else if (stepAxis == 2){
          pos.z += step.z;
          if (pos.z == out.z)
            break;
          nextCrossingT.z += deltaT.z;
        }
      }
      return minT;
    }
      
  }
  PVector getNormal(PVector P){
    //println(hitObjectIndex);
    return primitives[hitObjectIndex].getNormal(P);
  }
  PVector calcDiffuse(PVector P, PVector n, int l){
    return primitives[hitObjectIndex].calcDiffuse(P,n,l);
  }
  PVector calcAmbient(int l){
    return primitives[hitObjectIndex].calcAmbient(l);
  }
  void printval(){}
  PVector getM1d(PVector d, PVector P){
    return d;
  }
  PVector getM1P(PVector P){
    return P;
  }
  PVector getMP(PVector P){
    return P;
  }
  PVector getPMax(){
    PVector Pmax = new PVector (-MAX_FLOAT,-MAX_FLOAT,-MAX_FLOAT);
    PVector pp;
    for (int i = 0; i<numItems; i++){
      pp = primitives[items.get(i)].getPMax();
      Pmax = new PVector(max(Pmax.x,pp.x), max(Pmax.y,pp.y), max(Pmax.z,pp.z));
    }
    return Pmax;
  }
  PVector getPMin(){
    PVector Pmin = new PVector (MAX_FLOAT,MAX_FLOAT,MAX_FLOAT);
    PVector pp;
    for (int i = 0; i<numItems; i++){
      pp = primitives[items.get(i)].getPMin();
      Pmin = new PVector(min(Pmin.x,pp.x), min(Pmin.y,pp.y), min(Pmin.z,pp.z));
    }
    return Pmin;
  }
  
  void calcBoundsResolution(){
    PVector pMax, pMin;
    pMax = getPMax();
    pMin = getPMin();
    
    PVector delta = PVector.sub(pMax,pMin);
    
    float maxdelta = max(delta.x,delta.y,delta.z);
    float invMaxWidth = 1.0/maxdelta;
    float cubeRoot = 3.0 * pow(float(numItems),1.0/3.0);
    float voxelsPerUnitDist = cubeRoot * invMaxWidth;
    
    nVoxels.x = int(delta.x*voxelsPerUnitDist);
    if (nVoxels.x > 64) nVoxels.x = 64;
    if (nVoxels.x < 1) nVoxels.x = 1;
    
    nVoxels.y = int(delta.y*voxelsPerUnitDist);
    if (nVoxels.y > 64) nVoxels.y = 64;
    if (nVoxels.y < 1) nVoxels.y = 1;
    
    nVoxels.z = int(delta.z*voxelsPerUnitDist);
    if (nVoxels.z > 64) nVoxels.z = 64;
    if (nVoxels.z < 1) nVoxels.z = 1;
    
    voxWidth.x = delta.x/nVoxels.x;
    voxWidth.y = delta.y/nVoxels.y;
    voxWidth.z = delta.z/nVoxels.z;
                
    invVoxWidth.x = (voxWidth.x == 0)? 0.0: 1.0/voxWidth.x;
    invVoxWidth.y = (voxWidth.y == 0)? 0.0: 1.0/voxWidth.y;
    invVoxWidth.z = (voxWidth.z == 0)? 0.0: 1.0/voxWidth.z;
    
    nv = int(nVoxels.x*nVoxels.y*nVoxels.z);
  }
  
  PVector voxelToPos(PVector V){
    PVector P = new PVector(0,0,0);
    
    P.x = bounds.Pmin.x + V.x*voxWidth.x;
    P.y = bounds.Pmin.y + V.y*voxWidth.y;
    P.z = bounds.Pmin.z + V.z*voxWidth.z;
    
    return P;
  }
  
  PVector posToVoxel(PVector P){
    PVector v = new PVector(0,0,0);
    
    v.x = int((P.x - bounds.Pmin.x)*invVoxWidth.x);
    if (v.x > nVoxels.x-1) v.x = nVoxels.x-1;
    if (v.x < 0) v.x = 0;
    
    v.y = int((P.y - bounds.Pmin.y)*invVoxWidth.y);
    if (v.y > nVoxels.y-1) v.y = nVoxels.y-1;
    if (v.y < 0) v.y = 0;
    
    v.z = int((P.z - bounds.Pmin.z)*invVoxWidth.z);
    if (v.z > nVoxels.z-1) v.z = nVoxels.z-1;
    if (v.z < 0) v.z = 0;
    
    return v;
  }
  
  void addGeometryToVoxels(){
    PVector pMax, pMin;
    for (int i = 0; i<numItems; i++){
      // voxel extent of geometry
      //println(i);
      pMax = posToVoxel(primitives[items.get(i)].getPMax());
      pMin = posToVoxel(primitives[items.get(i)].getPMin());
      //println(pMax,pMin);
      // add geometry to overlapping voxels
      for (int z = int(pMin.z); z <= int(pMax.z); z++){
        for (int y = int(pMin.y); y <= int(pMax.y); y++){
          for (int x = int(pMin.x); x <= int(pMax.x); x++){
            int o = offset(x,y,z);
            //println("Vello1");
            if (voxels[o] == null)
              voxels[o] = new Voxel();
            voxels[o].addGeometry(items.get(i));
            //println(voxels[o].items.size());
            //println("Vello2");
          }
        }
      }
    }
    //println("Done");
  }
  
  int offset(int x, int y, int z){
    return int(z*nVoxels.x*nVoxels.y + y*nVoxels.x + x);
  }
}