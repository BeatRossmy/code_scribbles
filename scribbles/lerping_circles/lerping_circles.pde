class MovingDot {
  ArrayList<PVector> vList;
  color c = color(255,255,255);
  
  public MovingDot (int steps) {
    vList = new ArrayList<PVector> ();
    while (c==color(255,255,255))
      c = color(int(random(0,2))*255,int(random(0,2))*255,int(random(0,2))*255);
    for (int n=0; n<steps; n++) vList.add(new PVector(random(0.1*width,width-0.1*width),random(0.1*width,height-0.1*width),random(0.1*width,0.5*width)));
  }
  
  void move (float time) {
    /* time: 0-1 */
    float f = time*vList.size();
    int i = int(f);
    f = f-i;
    f = map(cos(f*PI),1,-1,0,1);
    PVector pos = PVector.lerp(vList.get(i),vList.get((i+1)%vList.size()),f);
    fill(c);
    ellipse(pos.x,pos.y,pos.z,pos.z);
  }
}

ArrayList<MovingDot> dots;
float time;
float frames = 150;

boolean export = false;

void setup () {
  size(800,1000);
  dots = new ArrayList<MovingDot>();
  for (int i=0; i<4; i++) dots.add(new MovingDot(int(random(4,6))));
  noStroke();
  blendMode(DIFFERENCE);
  
  frameRate(20);
}

void draw () {
  background(255);
  
  for (MovingDot d : dots) d.move(time/frames);
  
  time++;
  if (time==frames) {
    if (export) stop();
    time-=frames;
  }
  
  if (export) save("frames/"+nf(int(time),3)+".png");
}
