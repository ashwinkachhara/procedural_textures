abstract class Shape{
  public abstract float intersects(PVector d, PVector P);
  public abstract PVector getNormal(PVector P);
  public abstract PVector calcDiffuse(PVector P, PVector n, int l);
  public abstract PVector calcAmbient(int l);
  public abstract void printval();
}