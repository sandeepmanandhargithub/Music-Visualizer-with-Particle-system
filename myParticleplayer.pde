/*
The MIT License (MIT)
Copyright (c) 2013 Sandeep Manandhar
This code has been prepared for the assessment for Coursera's course on
Creative Programming for Digital Media & Mobile Apps. To be used for educational
purpose only.
Project colorbug
This is an audio visulaizer. I have used minim library for FFT and getting metadata from the song. 
The interface has two buttons/switches. The one is at top right and one is at mid bottom. 
The UI has features like play/pause button, progress bar, play time, song's title name, album name, artist name. 
The UI can be made visible/invisible by switching the button on top right corner. 
The play/pause button will be fairly visible only after the mouse is over it.
The texture used here is a retangular slab with glowing edges (gaussian blurred in photoshop). 
These rectangular slabs comprise the smoke effect that is raised by the average power of particular frequency band.
These smoke elements will always be under effect of gravity vector that pulls them  downward. 
I have tried both custom texture and rectangles using inbuilt function, but the former seems faster 
though I really wanted to use later. The frequency bands are considerably lower to mid ones because most of the spices seem to remain in these domain. Besides, I would have to either increase width to ridiculous amount or decrese the width of slab to minute level to constitute all the bands.
The metadata is easy to embed and extract from mp3 songs. One can use softwares like Audacity,
Sound forge to do that. But wav files seem to have problem with metadata. So the demo has mp3 song in it.  

*/
  import ddf.minim.analysis.*;
  import ddf.minim.*;
  
  Minim minim;
  AudioPlayer juke;
  AudioMetaData metaD;
  FFT fftlinear;
  myParticleSystem[] ps;
  aswitch swt;
  boolean playing = false, flagSw = true;
  

  
  PVector force, gravity;
  int size = 152;
  
  PImage playset, playBtn, pauseBtn;
  int progressB = 0;
  PFont fonty;
  int time;
  int min;
  int sec;
  int tintVal = 200;
  int tintPlayset =25;
  
  
  void setup()
  {
    size(640, 360, P3D);
    PImage img = loadImage("texture.png");        //required for the rectangular smoke effect
    PImage switcher = loadImage("switch.png");    //switch at top right corner
    PImage cir = loadImage("switchCir.png");      //switch at top right corner
   
    playBtn = loadImage("playbtn.png");           
    pauseBtn = loadImage("pause.png");
    playset = loadImage("playset.png");
   
    colorMode(HSB);
    color c = color(150, 150, 255);
    fonty = loadFont("DigitalSansEFMedium-48.vlw");
    
    swt = new aswitch(new PVector(width - 50, 15), switcher, cir);    //switch to vanish UI
    minim = new Minim(this);
    juke = minim.loadFile("7nationremix.mp3");          //song to be played 
    metaD = juke.getMetaData();                  //get metadata/info about the song(wav format song don't seem to have it)
    
    force = new PVector(0, -0.2);                //for that will cause smoke texture to rise up / (-)ve y direction
 
  
    fftlinear = new FFT(juke.bufferSize(), juke.sampleRate());
    
    fftlinear.linAverages(size);                //size is necessary because program doesn't require all band of frequencies
                                                //size has be averaged to 60 and only lower to mid band will be analysed
   
    ps = new myParticleSystem[size];            
    textFont(fonty);
    gravity = new PVector(0, 0.08);            //gravity that will pull the particle of not so powerful frequenies to (+)ve y direction
  
   
   //initializing the particles
    for(int f=0; f<size; f++)
    {
            ps[f] = new myParticleSystem(0, new PVector((width - 120- 30*15)/2 + f*4, height/2+20), img, c);
    }
    
    textSize(24);
    time = juke.length();
    min = time/60;
    sec = time%60;
  }
  
  void draw(){
    background(0);
        
    fill(0,0,255);
    textAlign(LEFT);
    //tinitPlayset will be lowered when mouse is not over playset button causing it to be less opaque
    tint(255, tintPlayset);
    image(playset, width/2, height/2 + 100);
   
    //flagSw is controlled by switch on top right of the screen to disable or enable UI features
    if(flagSw)
    if(playing) 
    {
      textSize(24);
      text("Now Playing", 32, height/2 +45);
      textSize(22);
      text(metaD.title(), 32, height/2+67);
      textSize(18);
      text(metaD.author(), 32, height/2+84);
    }
    else
    {
      textSize(24);
      text("waiting", 32, height/2 + 45);
    }
      
  
    //tintVal will be increased wheh mouse is over switch
    imageMode(CENTER);
    tint(255,tintVal);
    swt.draw(flagSw);
    
    textSize(16);
   
   if(mouseX > width - 50 - 25 && mouseX < width - 50 + 25 &&
        mouseY > 15 - 10  && mouseY < 15+10)
    {
        tintVal = 200;    
                   
    }
    else
        tintVal = 25;
   
    //mapping the progress bar
    float markerX = map(juke.position(), 0, juke.length(), width/2 - 100, width/2 + 100);
    
    if(flagSw){
    rectMode(CORNERS);
    fill(140, 235, 200, 200);
    noStroke();
    rect(width/2-100, height - 40, markerX, height - 44);
    rectMode(CENTER);
    noStroke();
    rect(markerX, height - 42, 4, 10);
    noFill();
    stroke(250,200);
    rect(width/2, height - 42, 200,6);
    
    if(mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
        mouseY > height - 50  && mouseY < height - 30)
        {
          rectMode(CENTER);
          noFill();
          stroke(255);
          rect(mouseX, height - 42, 2, 10);
          
        }
    
    
    }
    
    //begin fft and particle system
    fftlinear.forward(juke.mix);
    for(int p = 0; p<size; p++){
      ps[p].runSys(); 
    }
    
    float sZ = fftlinear.avgSize(); //we need lower frequencies where most of the effect will be dominant
    
    for(int i = 0; i <sZ ; i++)
    {
      stroke(250);
      noFill();
      rectMode(CORNERS);
      
      float d = fftlinear.getAvg(i)*16;
     
      force.y = -d/450;
       
      if(force.y < -0.4) force.y = -0.4;
       //color configuration will be different in 3 zones of the spectrum
      if(i >=0 && i<sZ/9){
        ps[i].setColor(color(215 - (i+5), 150 - d/2, 255));
        ps[i].applyForce(force);
        ps[i].addParticle();
      }
      else if(i >= sZ/9 &&  i < sZ/3){
        force.y *=2;
        ps[i].setColor(color(215 - i, 180 - 3*d/2 , 255));
        ps[i].applyForce(force);
        ps[i].addParticle();
      }
      else if(i >= sZ/3 &&  i <= sZ){
        force.y *=3;
        ps[i].setColor(color(215 - i, 180 - 3*d/4, 255));
        ps[i].applyForce(force);
        ps[i].addParticle();
      }
      ps[i].applyForce(gravity);
      PVector cd = ps[i].origin.get();
      if(cd.x >= mouseX - 5 && cd.x <= mouseX + 5 && mouseY <= cd.y + 10 && mouseY >= cd.y-10)
      {
        ps[i].addParticle();
        ps[i].addParticle();
        ps[i].applyForce(new PVector(random(-0.09, 0.09),-.16));
        
      }
      ps[i].addParticle();
    }
    
   if(flagSw){
   textSize(20);
   fill(0,0,255);
   
   min = juke.position()/(60*1000);
   sec = (juke.position()/1000)%(60);
  
   textAlign(RIGHT);
   text(min+":", width/2 + 75, height-55);
   textAlign(LEFT);
   if(sec < 10)
    text("0"+sec, width/2 + 76, height - 55);
   else
    text(sec, width/2 + 76, height - 55);
   }
         
  if(mouseX > width/2 - 24 && mouseX < width/2 + 24 &&
        mouseY > height/2 + 100 - 24  && mouseY < height/2 + 100 + 24)
        {
                   
            tintPlayset = 200;
            tint(255, tintPlayset);
            if(!playing || juke.position() == juke.length())
              image(playBtn, width/2, height/2 + 100);
            else
              image(pauseBtn, width/2, height/2 +100);
        }
      else
      {
             tintPlayset = 35;
      }
   
         
   
  }
  
  void mouseClicked()
  {
    
      if(mouseX > width/2 - 24 && mouseX < width/2 + 24 &&
        mouseY > height/2 + 100 - 24  && mouseY < height/2 + 100 + 24)
        {
          playing = !playing;
          if(playing) 
          { 
            
            juke.play();
           
          }
          
                else 
                {
                  if(!juke.isPlaying())  
                    juke.rewind();
                  else
                  juke.pause();
                }
         
           
        }
    
    else if(mouseX > width - 50 - 25 && mouseX < width - 50 + 25 &&
        mouseY > 15 - 10  && mouseY < 15+10)
        {
          flagSw = !flagSw;
         
        }
    else if(mouseX > width/2 - 100 && mouseX < width/2 + 100 &&
        mouseY > height - 50  && mouseY < height - 30)
        {
          if(juke.isPlaying() && flagSw){
          float mark = map(mouseX, width/2 - 100 , width/2 + 100, 0, juke.length() );
          println(mouseY);
          println(mark);
          juke.cue(int(mark));
          }
        }    
    
    
  //  println(mouseX);
  //  println(mouseY);
  }
  
  
