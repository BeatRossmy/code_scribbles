import themidibus.*; //Import the library
MidiBus bus; // The MidiBus
boolean record = false;
int frame;

float str = 0.4;
float nf = 0.05;
float s = 0;

int dots_width = 20;
ArrayList<ArrayList<PVector>> dots;

float zoom = 0;

void setup () {
  size(800,800,P3D);
  
  MidiBus bus = new MidiBus(this, "Bus 1", -1);
  
  background(0);
  stroke(255,200);
  strokeWeight(3);

  dots = new ArrayList<ArrayList<PVector>>();
  s = width/(dots_width+1);
  
  for (int l=0; l<100; l++) {
    dots.add(new ArrayList<PVector>());
  }
  
  frameRate(30);
  
  camera(400, 400, 1400, 400, 400, 0, 0, 1, 0);
}

void draw () {
  background(0);
  
  zoom += 3;
  if (zoom>=s) {
    zoom = 0;
    dots.remove(dots.size()-1);
    dots.add(0,new ArrayList<PVector>());
  }
  
  for (int l=0; l<dots.size(); l++) {
    ArrayList<PVector> layer = dots.get(l);
    for (PVector v : layer) {
      if (v.z>0) v.z*=0.99;
      strokeWeight(map(sq(v.z),0,4,2,20));
      point((1+v.x)*s,(1+v.y)*s,(1+l)*s+zoom);
    }
  }
  
  if (record) {
    frame++;
    save("frames/"+nf(int(frame),4)+".png");
  }
}

void noteOn(int channel, int pitch, int velocity) {
  println(pitch);
  if (pitch==0)
    record = true;
  else {ArrayList<PVector> layer = dots.get(0);
    for (int n=0; n<map(velocity,0,127,1,6); n++) {
      PVector pos = new PVector (dots_width/2,dots_width/2);
      PVector rand_dir = PVector.random2D();
      pos.add(rand_dir.mult(map(pitch,45,70,0,dots_width/2)));
      float z = map(velocity+127-pitch,0,256,1,4);
      layer.add(new PVector(int(pos.x),int(pos.y),z));
    }
  }
}

void noteOff(int channel, int pitch, int velocity) {
  if (pitch==0)
    record = false;
}
