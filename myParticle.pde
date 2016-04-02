class myParticle{
  PVector loc;
  PVector vel;
  PVector acc;
  float lifespan;
  color c;
  PImage texture;
  boolean sw;
  myParticle(PVector l, PImage tex, color glow){
    acc = new PVector(0.0, 0.0);
    float veloX = randomGaussian()*.3;
    float veloY = randomGaussian()*.1 - 1.0;
    vel = new PVector(veloX, veloY);
    loc = l.get();
    lifespan = 100.0;
    texture =tex;
    c = glow;
    sw = true;
  }
  
  void run(){
    update();
    render();
  }
  
 
  
  void applyForce(PVector f)
  {
    acc.add(f);
  }
  
  void update(){
    vel.add(acc);
    loc.add(vel);
    lifespan -=2.5;
    acc.mult(0);
  }
  void render(){
    imageMode(CENTER);
    rectMode(CENTER);
  
  //  tint(c, lifespan);
  //  image(texture, loc.x, loc.y);
    noStroke();
    fill(c, lifespan);
    rect(loc.x, loc.y, 4, 4);
 
  }
  
  boolean isDead(){
    if(lifespan <= 0.0)
      return true;
    else
      return false;
  }
}
