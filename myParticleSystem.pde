class myParticleSystem{
  ArrayList<myParticle> particles;
  PVector origin;
  PImage image;
  color c;
    myParticleSystem(int num, PVector provenance, PImage tex, color glow)
  {
    particles = new ArrayList<myParticle>();
    origin = provenance.get();
    image = tex;
    c = glow;
    
    for(int i = 0; i < num; i++)
      particles.add(new myParticle(origin, image, c));
  }
  
  void runSys(){
    for(int i = particles.size() -1 ; i >= 0; i--){
      myParticle p = particles.get(i);
      p.run();
      if(p.isDead())
       particles.remove(i); 
    }
  }
  
  void location(int x, int y){
    origin.x = x;
    origin.y = y;
  }
  
  void applyForce(PVector dir){
    for(myParticle p: particles)
      p.applyForce(dir);
  }
  
   void setColor(color glow)
  {
    c = glow;
  }
  
   void switchSmoke(boolean s)
  {
    for(myParticle p: particles)
      p.sw = s;
  }
  
  void addParticle(){
    particles.add(new myParticle(origin, image, c));
  }
}
