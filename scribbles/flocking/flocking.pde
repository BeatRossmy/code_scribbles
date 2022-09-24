class Particle {
  ArrayList<Particle> guides;
  PVector pos,speed;
  float accel = 0.005;
  float angle = -1;
  float size = 10;
  float max_speed = 1;
  
  public Particle () {
    guides = new ArrayList<Particle>();
    speed = new PVector(0,0);
    pos = new PVector(random(width*0.15,width*0.85), random(height*0.15,height*0.85));
  }
  
  void addGuide (Particle g) {
    guides.add(g);
  }
  
  void move () {
    PVector dir = new PVector(0,0);
    for (Particle guide : guides) dir.add(PVector.sub(guide.pos,pos)); 
    dir.normalize();
    
    speed.add(PVector.mult(dir,accel));
    // ADD WALL FARCES
    float f = 0.025;
    speed.add(PVector.mult(new PVector(-1,0),constrain(map(width-pos.x,0,width/4,f,0),0,f)));
    speed.add(PVector.mult(new PVector(1,0),constrain(map(pos.x,0,width/4,f,0),0,f)));
    speed.add(PVector.mult(new PVector(0,-1),constrain(map(height-pos.y,0,height/4,f,0),0,f)));
    speed.add(PVector.mult(new PVector(0,1),constrain(map(pos.y,0,height/4,f,0),0,f)));
    
    if (speed.mag()>max_speed) speed.normalize().mult(max_speed);
    pos.add(speed);
  }
  
  void plot () {
    ellipse(pos.x,pos.y,size,size);
  }
}

ArrayList<Particle> flock;

boolean export = false;
int time;
int frames = 999;

void setup () {
  size(800,800);
  noStroke();
  background(50);
  smooth();
  
  flock = new ArrayList<Particle>();
  for (int i=0; i<33; i++) flock.add(new Particle());
  for (Particle bird : flock) {
    for (int i=0; i<3; i++) bird.addGuide(flock.get((int)random(flock.size())));
  }
}

void draw () {
  fill(0,5);
  rect(0,0,width,height);
  
  fill(255);
  for (Particle bird : flock) {
    bird.move();
    bird.plot();
  }
  
  time++;
  if (time==frames) {
    if (export) stop();
    time-=frames;
  }
  
  if (export) save("frames/"+nf(int(time),3)+".png");
}
