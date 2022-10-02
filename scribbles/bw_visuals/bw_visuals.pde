import themidibus.*; //Import the library
MidiBus bus; // The MidiBus

import java.util.*;

class Animation {
  int timer;
  boolean active;
  char triggerChar;
  int triggerNote;
  int velocity;
  
  public Animation (int n) {
    //triggerChar = c;
    triggerNote = n;
  }
  
  void on (int n, int v) {
    if (n==triggerNote && !active) {
      active = true;
      velocity = v;
      timer = 0;
    }
  }
  
  void off (int n) {
    if (n==triggerNote) {
      active = false;
    }
  }
  
  void handle (PGraphics canvas) {
    if (active) {
      timer++;
      show(canvas);
    }
  }
  
  void show (PGraphics canvas) {}
}

PGraphics canvas;
ArrayList<Animation> animations; 
PGraphics maskA, maskB;

void setup () {
  size(800,800);
  
  MidiBus bus = new MidiBus(this, "Bus 1", -1);
  
  maskA = createGraphics(width,height);
  maskA.beginDraw();
  maskA.background(0);
  maskA.noStroke();
  maskA.fill(255);
  maskA.rect(200,200,400,400);
  maskA.endDraw();
  
  maskB = createGraphics(width,height);
  maskB.beginDraw();
  maskB.background(255);
  maskB.noStroke();
  maskB.fill(0);
  maskB.rect(200,200,400,400);
  maskB.endDraw();
  
  canvas = createGraphics(width,height);
  
  animations = new ArrayList<Animation> ();
  
  // RANDAOM GLYPH
  animations.add(
    new Animation (36) {
      int r;
      int w = 100;
      
      void on (int c, int v) {
        if (c==triggerNote) {
          r = (int)random(65536);
          velocity = v;
          active = true;
          timer = 0;
        }
      }
      
      void show (PGraphics canvas) {
        for (int x=0; x<4; x++) {
          for (int y=0; y<4; y++) {
            int i=x+y*4;
            boolean b = ((r>>i) & 0x1)==1;
            if (b) canvas.rect(width/2+x*w-2*w,height/2+y*w-2*w,w,w);
          }
        }
      }
    }
  );
  // GLITCH
  animations.add(
    new Animation (39) {
      int segment_length, read_index,write_index;
      void on (int c, int v) {
        if (c==triggerNote) {
          segment_length = (int)random(canvas.pixels.length/4,canvas.pixels.length/2);
          read_index = (int)random(canvas.pixels.length-segment_length);
          write_index = read_index+(int)random(-canvas.pixels.length/4,canvas.pixels.length/4);
          if (write_index<0) write_index = 0;
          velocity = v;
          active = true;
          timer = 0;
        }
      }
      void show (PGraphics canvas) {
        canvas.loadPixels();
        color [] buf = Arrays.copyOfRange(canvas.pixels,read_index,read_index+segment_length);
        for (int i=0; i<segment_length && i+write_index<canvas.pixels.length; i++) canvas.pixels[i+write_index] = buf[i];
        canvas.updatePixels();
      }
    }
  );
  // ROTATING STRIPES
  animations.add(
    new Animation (42) {
      void show (PGraphics canvas) {
        
        PGraphics buffer = createGraphics(width,height);
        buffer.beginDraw();
        buffer.rectMode(CENTER);
        buffer.noStroke();
        buffer.translate(buffer.width/2,buffer.width/2);
        buffer.rotate(timer/100.0);
        for (int i=-10; i<10; i++) buffer.rect(2*i*25,0,map(velocity,0,127,1,25),1.5*buffer.width);
        buffer.endDraw();
        
        buffer.mask(maskA);
        //canvas.image(buffer,0,0);
        canvas.blend(buffer,0,0,buffer.width,buffer.height,0,0,canvas.width,canvas.height,ADD);
      }
    }
  );
  // ROTATING STRIPES REVERSE
  animations.add(
    new Animation (46) {
      void show (PGraphics canvas) {
        
        PGraphics buffer = createGraphics(width,height);
        buffer.beginDraw();
        buffer.rectMode(CENTER);
        buffer.noStroke();
        buffer.translate(buffer.width/2,buffer.width/2);
        buffer.rotate(-timer/100.0);
        for (int i=-12; i<12; i++) buffer.rect(2*i*25,0,map(velocity,0,127,1,25),1.5*buffer.width);
        buffer.endDraw();
        
        buffer.mask(maskB);
        canvas.blend(buffer,0,0,buffer.width,buffer.height,0,0,canvas.width,canvas.height,ADD);
      }
    }
  );
}

void draw () {
  canvas.beginDraw();
  canvas.smooth();
  canvas.fill(255);
  canvas.noStroke();
  canvas.stroke(255);
  canvas.background(0);
  for (Animation a : animations) a.handle(canvas);
  canvas.endDraw();
  image(canvas,0,0);
}

void noteOn(int channel, int pitch, int velocity) {
  println(pitch);
  for (Animation a : animations) a.on(pitch,velocity); 
}

void noteOff(int channel, int pitch, int velocity) {
  for (Animation a : animations) a.off(pitch); 
}
