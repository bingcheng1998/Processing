import processing.serial.*;
import processing.opengl.*;

Serial myserial;
float value[]=new float[4];
String rf[]=new String[4];
PGraphics graphics1;
PGraphics graphics2;
PGraphics graphics3;
PGraphics graphics4;
void setup()
{
  size(600,600,P2D);
  String name="COM5";
  myserial=new Serial(this, Serial.list()[1], 57600);
  smooth();
  for(int i=0;i<4;++i) value[i]=0;
  
   
   graphics1=createGraphics(298,298,OPENGL);
   graphics2=createGraphics(298,298,OPENGL);
   graphics3=createGraphics(298,298,OPENGL);
   graphics4=createGraphics(298,298,OPENGL);
   textMode(MODEL);
   textSize(32);
}
long lasttime=0;

void draw() 
{
  frameRate(60);
  drawRect(graphics1,0,0,1,0); //FONT
  drawRect(graphics2,90,0,1,0);//lLEFT
  drawRect(graphics3,-90,1,0,0);//TOP
  drawRect(graphics4,90,1,1,0);//RANDOM
  
  image(graphics1,0,0);
  image(graphics2,300,0);
  image(graphics3,0,300);
  image(graphics4,300,300);
  fill(248,147,147);
  text("FONT VIEW",10,50);
  text("LEFT VIEW",310,50);
  text("TOP VIEW",10,350);
  text("RANDOM VIEW",310,350);
  lasttime=millis();
}

void drawRect(PGraphics pg,float rot,int x,int y,int z)
{
  pg.beginDraw();
  pg.lights();
  pg.background(126);
  pg.textSize(20);
  pg.fill(3,60,244);
  long framerate=1000/(millis()-lasttime);
  pg.text("fps:"+framerate,200,20);
  
  pg.fill(246,225,65);
  pg.translate(100,100,-100);
  pg.rotate(rot*PI/180,x,y,z);
  pg.rotateY(value[2]*PI/180);
  pg.rotateZ(-value[1]*PI/180);
  pg.rotateX(value[0]*PI/180);
  pg.box(50,50,100);
  pg.endDraw();
}
String st;
void serialEvent(Serial p)
{
    st=p.readStringUntil(10);
    if(st==null) return;
    if(st.indexOf("x=")!=-1)
    {
      value[0]=float(st.substring(2));
    }
    else if(st.indexOf("y=")!=-1)
    {
      value[1]=float(st.substring(2));
    }
    else if(st.indexOf("z=")!=-1)
    {
      value[2]=float(st.substring(2));
    }
}
