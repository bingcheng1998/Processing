import processing.serial.*;     //引入serial库
String pre = "                 ";
Serial port;                         // The serial port
int datanum= 4;
int[] num = new int[5];
int[][] buffer = new int[5][5];
int init=0;
int datacount = 0;

//--------------------------------------------------------------------------------

void setup() {
  size(640, 360);
    String portName = Serial.list()[1];
    println(Serial.list());
    port = new Serial(this, portName, 9600);
    port.bufferUntil('\n');  
    textFont(createFont("PingFangSC-Regular-48.wvm", 20));
}

//--------------------------------------------------------------------------------

void draw() {
  background(100);
  int h = 10;
  if (datacount == 4){
  init=0;
  datacount=0;
  for(int i=0; i<datanum; i++){
    h=30*i+30;
    textblock(i, h, 20);
  };
  };
  
}

//--------------------------------------------------------------------------------
void textblock(int i, int _hight, int _width){
   text("Pressure " +(i+1)+" : " , _hight, _width);
   pre = pre + " ,";
   for(int j=0; j<5; j++){
   text(buffer[i][j], _hight, _width+20*j);
   };
}

//--------------------------------------------------------------------------------
void serialEvent(Serial port) {
 
   while (port.available() > 0) {
      int k=0;
      String inString = port.readString();
      
      print(inString);
      
      String[] list = split(inString, ',');
      // list[0] is now "Chernenko", list[1] is "Andropov"...
      
      for(int i=0; i<5; i++){
        num[i]=int(list[i]);
        if(num[i]==0) k++;
        buffer[datacount][i]=num[i];
      };
      if(k==5) init=1;
      datacount++;
   };
}

//--------------------------------------------------------------------------------