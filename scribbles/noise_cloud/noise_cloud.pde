import themidibus.*; //Import the library
MidiBus bus; // The MidiBus
boolean record = false;
int frame;

final int raster = 80;
float noiseTime = 0;
float xOffset = 0;
float zoom = 0;

float [][] pixelIntensity = new float[raster][raster];

float cameraRotation;

float noiseIntensity = 150;
boolean intensityFlag = false;

void setup () {
  size(800,800,P3D);
  frameRate(30);
  
  MidiBus bus = new MidiBus(this, "Bus 1", -1);
  
  stroke(255);
  strokeWeight(3);
  fill(255);
  
  camera(1000, 1000, 400, 400, 400, 0.0,1, 1, 0);
}

void draw () {
  // NOISE
  if (intensityFlag && noiseIntensity<800) noiseIntensity*=1.013;
  if (!intensityFlag && noiseIntensity>100 ) noiseIntensity*=0.99;
  
  // CAMERA
  zoom += 0.003;
  cameraRotation += 0.004;
  camera(1000*sin(cameraRotation), 1000*cos(cameraRotation), 400+sin(zoom)*200, 400, 400, 0,1, 1, 0);
  
  // RASTER
  background(0);
  noiseTime += 0.006;
  xOffset += 0.002;
  drawRaster();
  
  if (record) {
    frame++;
    println("rec ***");
    save("frames/"+nf(int(frame),4)+".png");
  }
}

void noteOn(int channel, int pitch, int velocity) {
  println(pitch);
  if (pitch==0)
    record = true;
  else if (pitch>30 && pitch<45)
    intensityFlag = true;
  else {
    for (int i=0; i<3; i++) {
      int x = (int)random(raster);
      int y = (int)random(raster);
      pixelIntensity[x][y] = random(5,15);
    }
  }
}

void noteOff(int channel, int pitch, int velocity) {
  if (pitch==0)
    record = false;
  else if (pitch>30 && pitch<45)
    intensityFlag = false;
}

float getPixelIntensity (int x, int y) {
  if (x>=0 && x<raster && y>=0 && y<raster) return pixelIntensity[x][y];
  return 0.0;
}

void setPixelIntensity (int x, int y, float v) {
  if (v<0) pixelIntensity[x][y] = 0;
  else if (v>5) pixelIntensity[x][y] = 5;
  else pixelIntensity[x][y] = v;
}

void drawRaster () {
  float rasterSize = width/raster;
  float noiseScale = 0.02;
  for (int x=0; x<raster; x++) {
    for (int y=0; y<raster; y++) {
      
      float v = getPixelIntensity(x,y)*random(0.03,0.032) - random(0,0.01);
      v+=getPixelIntensity(x,y-1)*random(0.1,0.16);
      v+=getPixelIntensity(x+1,y)*random(0.1,0.16);
      v+=getPixelIntensity(x,y+1)*random(0.1,0.16);
      v+=getPixelIntensity(x-1,y)*random(0.1,0.16);
      v+=getPixelIntensity(x-1,y-1)*random(0.08,0.09);
      v+=getPixelIntensity(x+1,y-1)*random(0.08,0.09);
      v+=getPixelIntensity(x+1,y+1)*random(0.08,0.09);
      v+=getPixelIntensity(x-1,y+1)*random(0.08,0.09);
      
      setPixelIntensity(x,y,v);
      
      float z = noise(xOffset+x*noiseScale,y*noiseScale,noiseTime)*2 - 1 + getPixelIntensity(x,y);
      strokeWeight(map(z,-1,1,-0.25,4));
      point((0.5+x)*rasterSize,(0.5+y)*rasterSize,z*noiseIntensity);
    }
  }
}
