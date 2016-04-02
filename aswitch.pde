class aswitch{
  PImage base, circle;
  PVector loc;
  boolean state;
  aswitch(PVector l, PImage b, PImage c){
    loc = l.get();
    base = b;
    circle = c;
    state = false;
    }
  void draw(boolean s){
    state = s;
    image(base, loc.x, loc.y);
    if(state){
      image(circle, loc.x - 15, loc.y);
    }
    else
    {
      image(circle, loc.x + 15, loc.y);
    }
  }
}
