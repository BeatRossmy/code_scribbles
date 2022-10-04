PImage perlin_noise;

boolean record = false;
int frame = 0;

void setup () {
  size(800,800);
  
  noiseDetail(12,0.5);
  perlin_noise = createImage(width,height,RGB);
  perlin_noise.loadPixels();
  for (int i=0; i<perlin_noise.pixels.length; i++) {
    int x = i%perlin_noise.width;
    int y = i/perlin_noise.width;
    perlin_noise.pixels[i] = color(noise(x*0.01,y*0.01)*255);
  }
  perlin_noise.loadPixels();
}

void draw_line (float x, float y, float z, PImage noise_field, PVector d) {
  PVector pos = new PVector (x,y);
  PVector dir = d.copy();
  float f = 0.01;
  
  while (pos.x>=0 && pos.x<=width && pos.y>=0 && pos.y<=height) {
    PVector lPos = pos.copy();
    pos.add(dir);
    dir = d.copy();
    dir.rotate(map(noise(pos.x*f,pos.y*f,z*f),0,1,-PI*1.5,PI*1.5));
    line(lPos.x,lPos.y,pos.x,pos.y);
  }
}

void draw () {
  background(0);
  fill(0);
  ellipse(width/2,height/2,200,200);
  stroke(255,10);
  
  PVector center = new PVector (width/2,height/2);
  int rep = 1200;
  for (int n=0; n<rep; n++) {
    PVector dir = new PVector(0,-1).rotate(map(n,0,rep,0,2*PI));
    PVector start = PVector.add(center,dir.copy().mult(100));
    draw_line(start.x,start.y,frame,perlin_noise, dir);
  }
  
  if (record) {
    frame++;
    save("frames/"+nf(int(frame),4)+".png");
  }
  if (frame>1200) stop();
}
