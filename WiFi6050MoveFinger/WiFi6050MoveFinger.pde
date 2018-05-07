//安装库--从processingIDE的工具-添加工具-library中搜索即可
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;


float[] gravity = new float[3];
float[] euler = new float[3];
float[] ypr = new float[3];


float angleX, angleY, angleZ;

private BezTube btube;
private Tube tube;
int segs = 1, slices = 8;
float  k=0;
int dir = 1;
float pitch,yaw,roll;
void setup() {
  size(800, 600, P3D);
  //lights();
  //btube = makeBezTube();
  tube = new Tube(this,1,12);
  tube.setSize(18,18,22,22,80);
  
  textFont(createFont("Dialog-16", 16));
  angleX =0;
  angleY =0;
  angleZ =0;
pitch = 0;
yaw = 0;
roll = 0;
  tube.stroke(color(0,0,0), S3D.BOTH_CAP);
  tube.fill(color(255, 242, 204), S3D.BOTH_CAP);
  tube.strokeWeight(2.2f, S3D.BOTH_CAP);
  tube.setTexture("floor.jpg", 1,1);
  tube.drawMode(S3D.TEXTURE);
}

PVector V = new PVector (3,3,3);
void draw() {
  background(16);
  

  //directionalLight(255,255,255, 0,0,-1);
  lights();
  //normal(0,1,0);
  //ambientLight(102, 102, 102);
  pushMatrix();
  
  
camera(0, 0, 800, 0, 0, 0, 0, 1, 0);
  //rotateX(angleX);
  //rotateY(angleY);
  //rotateZ(angleZ);
  
  
  //btube.moveTo(1,1,1);
  //btube.rotateTo(2,2,2);
  //btube.draw();
  
  //directionalLight(255,255,255, 0,0,-1);
  //lights();
  k+=dir*0.3f;
  if(k>TWO_PI){
    dir = -1;
  }else if(k<0){
    delay(1500);
    dir = 1;
  }
    
  V.z +=0.05*dir;
  //V.y +=0.02*dir;
  //tube.moveTo(1,k,1);
  pitch = atan2(V.z,V.y);
  yaw = atan2(V.z,V.x);
roll = atan2(V.x,V.y);
  PVector up = new PVector(0,1 ,0);
  PVector centreOfRot = new PVector(0,-40,0);
  tube.shapeOrientation(up,centreOfRot);
  
  tube.rotateTo(-pitch, 0, roll);
  //tube.rotateTo(V.x,V.y,V.z);
  //tube.rotateTo(0,0,k/4);
  println(pitch*180/PI, yaw*180/PI,  roll*180/PI);
  //println(V.x,V.y,V.z);
  tube.draw();
  popMatrix();
  
  
  //lights();
  fill(0, 0, 96);
  rect(0, 0, width, 36);
  rect(0, height-36, width, 36);
  fill(255);
  text("SHUTTLE KEYS:  stop  [0]     [1]  speed  [9]", 4, 20);
  text("TUBE KEYS:  style  [T]     shape  [<]  change  [>]", 4, height - 10);
}




void 




void keyReleased() {
  if (key == '<' || key == ',')
    angleX += 0.1;
  else if (key == '>' || key == '.')
    angleX -= 0.1;
}
