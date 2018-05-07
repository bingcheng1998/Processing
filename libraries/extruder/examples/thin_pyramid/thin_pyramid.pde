// Import extruder library
import extruder.*;

// Frame tracker
int f = 0;

// Extruder object
extruder e;

// Triangle shape
PShape triangle;

// List of pshapes for pyramid
PShape[] tpyramid;

// Set up scene
void setup() {
  // Set size of image to 800px by 800px
  size(800, 800, P3D);
  // Set stroke to white
  stroke(255);
  // Set fill to goldenrod
  fill(#daa520);
  // Instantiate extruder object
  e = new extruder(this);
  // Generate a triangle with 200px radians
  triangle = e.genPlane(3, 200);
  // Extrude triangle with a z-depth of 100 and with triangle edges
  // "Triangle" edges mean that all points are extruded to the same center point (the first point in the PShape)
  // extrude function return 3 objects currently: the top plane, the sides, and the bottom plane
  tpyramid = e.extrude(triangle, 100, "triangle");
}
void draw(){
  // Draw over current scene with black
  background(0);
  // Set origin of scene to center of image
  translate(width/2, height/2, 0);
  // Rotate 3 degrees per frame on the y-axis
  rotateY(radians(f*3));
  // Draw all returned pshapes
  for (PShape p:tpyramid){
    shape(p);
  }
  // Increment frame counter 
  f++;
}