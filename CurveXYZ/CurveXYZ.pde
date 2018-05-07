import processing.serial.*;
Serial port;
int datanum = 4;
PrintWriter output;
PImage bg;
float[] num = new float[10];//原始数据：num[0] 是验证用, num[1]--x, num[2]--Y, num[3]--Z
//float[] calinum = new float[10];
float[] measnum = new float[10];//通过验证的num转移到此处
//curve 是连接多个点形成的曲线，移动方向从右到左，最右边是最新数据。默认一开始全是零。
float[] curveXnum = new float[100];
float[] curveYnum = new float[100];
float[] curveZnum = new float[100];
int curverate = 10;//修改这个数改变显示曲线，越大曲线越紧密，取正整数。
int curvenow = 0;
static float curveMax = 1000;//绘图时最大坐标系高度
static float testNum = 10010.1;//接收到的第一个数据作为验证值
float curveX, curveY, curveZ;
//--------------------------------------------------------------------------------

void setup() {
  size(1000, 563);
  output = createWriter("testnum.txt");//程序文件夹内形成数据的TXT文件。
  output.println("year: " + str(year()) + "\tmonth: " + str(month()) + "\tday: " + str(day()) + "\thour: " + str(hour()) + "\tminute: " + str(minute()) + "\n\n");
  output.println("\nx\t"+"y\t"+"z\t");
  println(Serial.list());
  String portName = Serial.list()[1];
  port = new Serial(this, portName, 9600);//调整波特率
  port.bufferUntil('\n');
  textFont(createFont("PingFangSC-Regular-48.wvm", 10));
  bg = loadImage("bg.png");
}

//--------------------------------------------------------------------------------

void draw() {
  repeat();
  originalNum();
  Curve(107, curveXnum, 30, 144, 255);
  Curve(294, curveYnum, 0,128, 0);
  Curve(481, curveZnum, 255, 0, 0);
  //sketchZ();
  sketchXYZ();
  sketchAxis();
  //cylinder(850, 500, 50,30, curveXnum[0],curveXnum[0],curveZnum[0]*3);
  cylinder(850, 500, 80,30, 80/2,80/2,200);
  
}

//--------------------------------------------------------------------------------
void cylinder(int x, int y, int R, int r, float Fx, float Fy, float Fz){
  float h = Fz*260/curveMax, ly=Fy*r/R, lx=Fx*r/R;
  noStroke();
  fill(240,248,255);
  ellipse(x, y, R*2, r*2);
  ellipse(x, y-h, R*2, r*2);
  rect(x-R, y-h, R*2, h);
  stroke(220);
  fill(0,0,0,0);
  ellipse(x, y, R*2, r*2);
  
  fill(255,20,147, 100);
  stroke(255,20,147, 100);
  quad(x,y,x,y-h,x+lx, y-h+ly, x+lx, y+ly);
  
  stroke(120);
  fill(0,0,0,0);
  ellipse(x, y-h, R*2, r*2);
}

//--------------------------------------------------------------------------------
void sketchXYZ(){
  //curveXnum[0];
  noStroke();
  fill(220,20,60);
  ellipse(850+curveXnum[0], 140+curveYnum[0], 10,10);
  fill(0,255,255);
  ellipse(850+curveXnum[0], 140+curveYnum[0], curveZnum[0], curveZnum[0]);
  //fill(65,105,225);
  stroke(65,105,225);
  line(850, 140+curveYnum[0], 850+curveXnum[0], 140+curveYnum[0]);
  line(850+curveXnum[0], 140, 850+curveXnum[0], 140+curveYnum[0]);
}
//--------------------------------------------------------------------------------
void sketchAxis(){
  stroke(255);
  line(750, 140, 950, 140);
  line(850, 40, 850, 240);
}

//--------------------------------------------------------------------------------
void originalNum(){
  fill(255,255,255);
  textSize(30);
  text("X:", 40, 97);
  text("Y:", 40, 284);
  text("Z:", 40, 471);
  textSize(20);
  text(measnum[1], 5, 137);
  text(measnum[2], 5, 324);
  text(measnum[3], 5, 501);
  
}

//--------------------------------------------------------------------------------

void repeat(){
  background(bg);
  textSize(18);
  fill(255);
  text("Three dimensional force sensor", 150, 23);
  noStroke();
  fill(255,255,255,200);
  rect(100+6,27,600-6,160);
  rect(100+6,214,600-6,160);
  rect(100+6,401,600-6,160);
  //fill(255,255,255,100);
  //rect(800, 300, 100, 260);
  //fill(220, 20, 60, 100);
  //ellipse(850, 140, 200, 200);
  //fill(255,255,255, 100);
  //ellipse(850, 140, 180, 180);
  //fill(255,100,0, 100);
  //ellipse(850, 140, 10,10);
}


//--------------------------------------------------------------------------------
void serialEvent(Serial port) {
    while (port.available() > 0) {
     
        String inString = port.readString();

        print(inString);

        String[] list = split(inString, '\t');

        for(int i=0; i<datanum; i++){
        num[i] = float(list[i]);
        }
        if(num[0] == testNum){
          for(int i=1; i<datanum; i++){
            measnum[i] = num[i];
          }
          output.print(measnum[1]+"\t"+measnum[2]+"\t"+measnum[3]+"\t\n");
        }
        datamap();
    }
}


//--------------------------------------------------------------------------------
void keyPressed() { // Press a key to save the data
  output.flush(); // Write the remaining data
  output.close(); // Finish the file
  exit(); // Stop the program
}


//--------------------------------------------------------------------------------
void datamap(){//这儿将得到的数据measnum[i]映射到曲线
curvenow ++; 
if(curvenow == curverate){
curvenow =0;
  float X, Y, Z;
  X = measnum[1]*80/curveMax;
  if(X<80){
    curveX = X;
  }
  Y = measnum[2]*80/curveMax;
  if(Y<80){
    curveY = Y;
  }
  Z = measnum[3]*80/curveMax;
  if(Z<80){
    curveZ = Z;
  }
  
  pushXnum(curveX);
  pushYnum(curveY);
  pushZnum(curveZ);
  
}
}




//--------------------------------------------------------------------------------
void Curve(int y, float[] data, int r, int g, int b){
  stroke(r, g, b);
  for(int i = 0; i<99; i++){
  int x1 = 6*(i+1)+100;
  float y1 = y+data[99-i];
  int x2 = 6*(i+2)+100;
  float y2 = y+data[98-i];
  line(x1,y1,x2,y2);
  }
}



//--------------------------------------------------------------------------------
void pushXnum(float numX){
  for(int i = 99; i>0; i--){
    curveXnum[i] = curveXnum[i-1];
  };
  curveXnum[0] = numX;
}


//--------------------------------------------------------------------------------
void pushYnum(float numY){
  for(int i = 99; i>0; i--){
    curveYnum[i] = curveYnum[i-1];
  };
  curveYnum[0] = numY;
}


//--------------------------------------------------------------------------------

void pushZnum(float numZ){
  for(int i = 99; i>0; i--){
    curveZnum[i] = curveZnum[i-1];
  };
  curveZnum[0] = numZ;
}
