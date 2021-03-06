// IMA NYU Shanghai
// Kinetic Interfaces
// MOQN
// Apr 3 2018


import KinectPV2.*;
import controlP5.*;


ControlP5 cp5;

KinectPV2 kinect2;
PImage depthImg;

int thresholdMin = 0;
int thresholdMax = 4499;


void setup() {
  size(512, 424, P2D);

  kinect2 = new KinectPV2(this);
  kinect2.enableDepthImg(true);
  kinect2.init();

  // Allocate a blank image
  depthImg = new PImage(KinectPV2.WIDTHDepth, KinectPV2.HEIGHTDepth, ARGB);

  // add gui
  int sliderW = 100;
  int sliderH = 20;
  cp5 = new ControlP5( this );
  cp5.addSlider("thresholdMin")
    .setPosition(10, 40)
    .setSize(sliderW, sliderH)
    .setRange(1, 4499)
    .setValue(0)
    ;
  cp5.addSlider("thresholdMax")
    .setPosition(10, 70)
    .setSize(sliderW, sliderH)
    .setRange(1, 4499)
    .setValue(4499)
    ;
}


void draw() {
  int[] rawDepth = kinect2.getRawDepthData();

  depthImg.loadPixels();
  for (int i=0; i < rawDepth.length; i++) {
    int depth = rawDepth[i];
    
    if (depth >= thresholdMin
      && depth <= thresholdMax
      && depth != 0) {

      int x = i % KinectPV2.WIDTHDepth;
      int y = floor(i / KinectPV2.WIDTHDepth);

      float r = map(depth, thresholdMin, thresholdMax, 255, 0);
      float b = map(depth, thresholdMin, thresholdMax, 0, 255);

      depthImg.pixels[i] = color(r, 0, b);
    } else {
      depthImg.pixels[i] = color(0, 0);
    }
    
  }
  depthImg.updatePixels();

  background(0);
  image(kinect2.getDepthImage(), 0, 0);
  image(depthImg, 0, 0);

  fill(255);
  text(frameRate, 10, 20);
}
