import hypermedia.net.*;
import processing.opengl.*;
import toxi.geom.*;
import toxi.processing.*;

import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

ToxiclibsSupport gfx;
 UDP udp; 
int num = 0;
char[] teapotPacket = new char[16];  // InvenSense Teapot packet
int serialCount = 0;                 // current packet byte position
int synced = 0;
int interval = 0;
float[] q = new float[4];
int[] countMPU = new int[4];

Quaternion quat = new Quaternion(1, 0, 0, 0);

float[] gravity = new float[3];
float[] euler = new float[3];
float[] ypr = new float[3];


 void setup() {
 udp = new UDP( this, 1234 ); 
 //udp.log( true );        
 udp.listen( true ); 
 
 size(300, 300, OPENGL);
    gfx = new ToxiclibsSupport(this);

    // setup lights and antialiasing
    lights();
    smooth();
 }

 void draw()
 {

    
    // black background
    background(0);
    
    // translate everything to the middle of the viewport
    pushMatrix();
    translate(width / 2, height / 2);

    // 3-step rotation from yaw/pitch/roll angles (gimbal lock!)
    // ...and other weirdness I haven't figured out yet
    //rotateY(-ypr[0]);
    //rotateZ(-ypr[1]);
    //rotateX(-ypr[2]);

    // toxiclibs direct angle/axis rotation from quaternion (NO gimbal lock!)
    // (axis order [1, 3, 2] and inversion [-1, +1, +1] is a consequence of
    // different coordinate system orientation assumptions between Processing
    // and InvenSense DMP)
    float[] axis = quat.toAxisAngle();
    rotate(axis[0], -axis[1], axis[3], axis[2]);

    // draw main body in red
    fill(255, 0, 0, 200);
    box(10, 10, 200);
    
    // draw front-facing tip in blue
    fill(0, 0, 255, 200);
    pushMatrix();
    translate(0, 0, -120);
    rotateX(PI/2);
    drawCylinder(0, 20, 20, 8);
    popMatrix();
    
    // draw wings and tail fin in green
    fill(0, 255, 0, 200);
    beginShape(TRIANGLES);
    vertex(-100,  2, 30); vertex(0,  2, -80); vertex(100,  2, 30);  // wing top layer
    vertex(-100, -2, 30); vertex(0, -2, -80); vertex(100, -2, 30);  // wing bottom layer
    vertex(-2, 0, 98); vertex(-2, -30, 98); vertex(-2, 0, 70);  // tail left layer
    vertex( 2, 0, 98); vertex( 2, -30, 98); vertex( 2, 0, 70);  // tail right layer
    endShape();
    beginShape(QUADS);
    vertex(-100, 2, 30); vertex(-100, -2, 30); vertex(  0, -2, -80); vertex(  0, 2, -80);
    vertex( 100, 2, 30); vertex( 100, -2, 30); vertex(  0, -2, -80); vertex(  0, 2, -80);
    vertex(-100, 2, 30); vertex(-100, -2, 30); vertex(100, -2,  30); vertex(100, 2,  30);
    vertex(-2,   0, 98); vertex(2,   0, 98); vertex(2, -30, 98); vertex(-2, -30, 98);
    vertex(-2,   0, 98); vertex(2,   0, 98); vertex(2,   0, 70); vertex(-2,   0, 70);
    vertex(-2, -30, 98); vertex(2, -30, 98); vertex(2,   0, 70); vertex(-2,   0, 70);
    endShape();
    
    popMatrix();
 }

 void keyPressed() {
 String ip       = "192.168.4.1"; 
 int port        = 8266;       
 String msg = "" +  key;
 
 udp.send(msg, ip, port );    
 num = 0;
 
 }
   
 void receive( byte[] data ) { 
   interval = millis();
   int kk[] = int(data);
   if(kk.length == 15 && kk[0]=='$'){
     num++;
     //println("start" + int(kk[2]));
     for(int i=0; i < 15; i++){
         int ch = kk[i];
         if (synced == 0 && ch != '$') return;   // initial synchronization - also used to resync/realign if needed
        synced = 1;
        //print (int(ch));
        
        if ((serialCount == 1 && ch != 2)
            || (serialCount == 13 && ch != '\r')
            || (serialCount == 14 && ch != '\n'))  {
            serialCount = 0;
            synced = 0;
            return;
        }
        
        if (serialCount > 0 || ch == '$') {
            teapotPacket[serialCount++] = (char) ch;
            //println("serialCount" + serialCount);
            if (serialCount == 15) {
              serialCount = 0; 
                q[0] = ((teapotPacket[2] << 8) | teapotPacket[3]) / 16384.0f;
                q[1] = ((teapotPacket[4] << 8) | teapotPacket[5]) / 16384.0f;
                q[2] = ((teapotPacket[6] << 8) | teapotPacket[7]) / 16384.0f;
                q[3] = ((teapotPacket[8] << 8) | teapotPacket[9]) / 16384.0f;
                //for (int j = 0; j < 4; j++) { if(q[j] > 1010){q[j] = -1020.0 + q[j];}
                // if (q[j] >= 2) {q[j] = -4 + q[j];}}
                
                for (int j = 0; j < 4; j++) if (q[j] >= 2) q[j] = -4 + q[j];
                
                //print(q[0]+" "+q[1]+" "+q[2]+" "+q[3]);
                
                println("q:\t"+float(Math.round((q[0])*1000))/1000+"\t"
                + float(Math.round((q[1])*1000))/1000+"\t"
                + float(Math.round((q[2])*1000))/1000+"\t"
                + float(Math.round((q[3])*1000))/1000);
                
                 quat.set(q[0], q[1], q[2], q[3]);
                 
               gravity[0] = 2 * (q[1]*q[3] - q[0]*q[2]);
                gravity[1] = 2 * (q[0]*q[1] + q[2]*q[3]);
                gravity[2] = q[0]*q[0] - q[1]*q[1] - q[2]*q[2] + q[3]*q[3];
    
                // calculate Euler angles
                euler[0] = atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1);
                euler[1] = -asin(2*q[1]*q[3] + 2*q[0]*q[2]);
                euler[2] = atan2(2*q[2]*q[3] - 2*q[0]*q[1], 2*q[0]*q[0] + 2*q[3]*q[3] - 1);
    
                // calculate yaw/pitch/roll angles
                ypr[0] = atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1);
                ypr[1] = atan(gravity[0] / sqrt(gravity[1]*gravity[1] + gravity[2]*gravity[2]));
                ypr[2] = atan(gravity[1] / sqrt(gravity[0]*gravity[0] + gravity[2]*gravity[2]));
    
                // output various components for debugging
                //println("q:\t" + round(q[0]*100.0f)/100.0f + "\t" + round(q[1]*100.0f)/100.0f + "\t" + round(q[2]*100.0f)/100.0f + "\t" + round(q[3]*100.0f)/100.0f);
                println("euler:\t" + euler[0]*180.0f/PI + "\t" + euler[1]*180.0f/PI + "\t" + euler[2]*180.0f/PI);
                println("ypr:\t" + ypr[0]*180.0f/PI + "\t" + ypr[1]*180.0f/PI + "\t" + ypr[2]*180.0f/PI);
               
                
                //countMPU[teapotPacket[12]] ++;
                //println("\tMPU-" + int(teapotPacket[12]) +"\t0xFF-"+ byte(teapotPacket[11])
                //+ "\tnum" + num + "\tmillis: "+ millis() +"\tMPU0: " +countMPU[0]+"\tMPU1: " +countMPU[1]
                //+"\tMPU2: " +countMPU[2]+"\tMPU3: " +countMPU[3]);
            }
        }
     }
   }
}



void drawCylinder(float topRadius, float bottomRadius, float tall, int sides) {

}
