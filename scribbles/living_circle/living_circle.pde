int subdiv = 64;
int whiteLevel = 10;

int time = 0;
int frames = 600;
boolean export = false;

void setup () {
  size(800,800);
  
  noFill();
  strokeWeight(40);
  strokeJoin(ROUND);
  blendMode(DIFFERENCE);
}

void draw () {
  time++;
  
  background(255-whiteLevel);
  
  stroke(255,whiteLevel,whiteLevel);
  noiseCircle(width/2, height/2, 200, subdiv, 0, sin(time/50.0)*2*PI);
  
  stroke(whiteLevel,255,whiteLevel);
  noiseCircle(width/2, height/2, 200, subdiv, 1, sin(time/100.0)*2*PI);
  
  stroke(whiteLevel,whiteLevel,255);
  noiseCircle(width/2, height/2, 200, subdiv, 2, sin(time/150.0)*2*PI);
}

void noiseCircle (float x, float y, float r, int div, float offset, float z) {
  PVector center = new PVector(x,y);
  PVector hand = new PVector(0,r);
  float scale = 1;
  beginShape();
  for (float i=0; i<div; i++) {
    float angle = 2*PI*i/div;
    float lx = sin(angle);
    float ly = cos(angle);
    float o = noise(scale*(0.5+offset)+lx*scale,scale*(0.5+offset)+ly*scale, z*scale*0.1);
    PVector pos = PVector.add(center,PVector.mult(hand,1+o*0.4).rotate(angle));
    vertex(pos.x,pos.y);
  }
  endShape(CLOSE);
  
  if (time==frames) {
    if (export) stop();
  }
  if (export) {
    println(time);
    save("frames/"+nf(int(time),3)+".png");
  }
  println(frameRate);
}
