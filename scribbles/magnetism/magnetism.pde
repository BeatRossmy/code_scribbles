import java.util.Map;

import themidibus.*;

class Particle {
  PVector pos;
  PVector speed;
  int size;
  
  public Particle () {
    pos = new PVector (random(width),random(height));
    speed = new PVector (0,0);
    size = int(random(4,9));
  }
  
  void handle (ArrayList<Force> forces) {
    speed.mult(random(0.85,0.95));
    PVector accel = new PVector(0,0);
    for (Force f : forces) {
      if (f.strength!=0) {
        float dist = abs(PVector.dist(pos,f.pos)/100.0);
        float str = map(log(1+dist),0,1.5,1,0);
        PVector dir = PVector.sub(pos,f.pos).normalize().rotate(random(-0.1,0.1)).mult(f.strength*str);
        accel.add(dir);
      }
    }
    speed.add(accel);
    pos.add(speed);
    if (pos.x>width || pos.x<0) pos.x = (pos.x>width)?width:0;
    if (pos.y>height || pos.y<0) pos.y = (pos.y>height)?height:0;
  }
  
  void show () {
    circle(pos.x,pos.y,size);
  }
}

class Force {
  PVector pos;
  float strength;
  
  public Force (float x, float y, float s) {
    pos = new PVector(x,y);
    strength = s;
  }
  
  void show () {
    circle(pos.x,pos.y,10);
  }
  
  void setStrength (float s) {
    strength = s;
  }
}

MidiBus bus;
HashMap<Integer,int[]> midiMap;
ArrayList<Particle> particles;
ArrayList<Force> forces;

void setup () {
  size(800,800);
  
  MidiBus.list();
  bus = new MidiBus(this, "Bus 1", "Bus 1"); 
  
  midiMap = new HashMap<Integer,int[]>();
  midiMap.put(36,new int []{0,1});
  midiMap.put(37,new int []{1,1});
  midiMap.put(38,new int []{2,1});
  midiMap.put(40,new int []{3,1});
  midiMap.put(41,new int []{4,1});
  midiMap.put(42,new int []{5,1});
  midiMap.put(44,new int []{6,1});
  midiMap.put(45,new int []{7,1});
  midiMap.put(46,new int []{8,1});
  midiMap.put(52,new int []{0,-1});
  midiMap.put(53,new int []{1,-1});
  midiMap.put(54,new int []{2,-1});
  midiMap.put(56,new int []{3,-1});
  midiMap.put(57,new int []{4,-1});
  midiMap.put(58,new int []{5,-1});
  midiMap.put(60,new int []{6,-1});
  midiMap.put(61,new int []{7,-1});
  midiMap.put(62,new int []{8,-1});
  
  fill(0);
  noStroke();
  
  forces = new ArrayList<Force> ();
  float d = 3;
  for (int x=1; x<d+1; x++) {
    for (int y=1; y<d+1; y++) {
      forces.add(new Force(width*x/(d+1),height*y/(d+1),0));    
    }
  }
  
  particles = new ArrayList<Particle> ();
  for (int i=0; i<7000; i++) particles.add(new Particle ());
}

void draw () {
  background(255);
  for (Particle p : particles) {
    p.handle(forces);
    p.show();
  }
}
void noteOn(int channel, int pitch, int velocity) {
  int [] d = midiMap.get(pitch);
  forces.get(d[0]).setStrength(d[1]*map(velocity,0,127,0,20));
}

void noteOff(int channel, int pitch, int velocity) {
  int [] d = midiMap.get(pitch);
  forces.get(d[0]).setStrength(0);
}
