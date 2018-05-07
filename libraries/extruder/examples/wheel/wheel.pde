// Import extruder library
import extruder.*;

// Frame tracker
int f = 0;

// Extruder object
extruder e;

// Rough circle shape
PShape roughCircle;

// List of pshapes for wheel
PShape[] wheel;

// Set up scene
void setup() {
  // Set size of image to 800px by 800px
  size(800, 800, P3D);
  // Set stroke to white
  stroke(255);
  // Set fill to green
  fill(0, 255, 0);
  // Instantiate extruder object
  e = new extruder(this);
  // Generate a "circle" with 10 sides and 100px radians
  roughCircle = e.genPlane(10, 100);
  // Extrude rough circle with a z-depth of 100 and with box edges
  // "Box" edges are rectangular edges connecting each point
  // extrude function return 3 objects currently: the top plane, the sides, and the bottom plane
  wheel = e.extrude(roughCircle, 100, "box");
}
void draw(){
  // Draw over current scene with black
  background(0);
  // Set origin of scene to center of image
  translate(width/2, height/2, 0);
  // Rotate 3 degrees per frame on the y-axis
  rotateY(radians(f*3));
  // Draw all returned pshapes
  for (PShape p:wheel){
    shape(p);
  }
  // Increment frame counter 
  f++;
}