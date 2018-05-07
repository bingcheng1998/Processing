
int choosenum = 0;
int rectwidth = 200; 
int recthight = 100; 
int NextX, NextY, PickX, PickY;      // Position of square button
boolean Next = false;
boolean Pick = false;


void chooseSerial(){
NextX = 200;
NextY = 400;
PickX = 600;
PickY = 400;

  
  update(mouseX, mouseY);
  if(choose == 1){  
  port = new Serial(this, portName, 250000);//调整波特率
  port.bufferUntil('\n');
  }
  // portName = Serial.list()[1];
  
}




void sketchSerial(){
  
  background(bg1);
  textSize(24);
  fill(255);
  //text("Upper monitor for three dimensional force sensor", 150, 23);
  //textSize(20);
  //fill(255,0,0);
  //text("caution!!", 100, 50);
  //fill(200);
  //textSize(18);
  //text("Please choose your Serial, and this APP will crash ", 150, 70);
  //text("if you click the \"Next\" buttom after the last display.", 150, 90);
  //text("Please press the space bar and the APP will shut down.", 150, 110);
  //text("Then you can find the data-day-hour-minut.txt in the same folder.", 150, 130);
  textSize(12);
  text("Bingcheng V 1.0.1",870, 540);
 // textSize(18);
  //fill(200);
  //text("If the Serial is not found, the app will shut down", 150, 70);
  //fill(192,192,192,100);
  //noStroke();
  //rect(100, 270, 800, 100, 6);
  textSize(25);
  fill(0);
  text("Serial "+"["+choosenum+"]:", 150, 320);
  
  textSize(20);
  //fill(255);
  
  text(Serial.list()[choosenum], 150, 360);
}
void mousePressed() {
if(choose == 0){
  if (Pick) {
    portName = Serial.list()[choosenum];
    port = new Serial(this, portName, 250000);//调整波特率
  port.bufferUntil('\n');
  choose = 1;
  }
  if (Next) {
   choosenum++;
   if(choosenum>=Serial.list().length){
     choosenum=0;
   }
  }
}
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void update(int x, int y) {
if ( overRect(NextX, NextY, rectwidth,recthight) ) {
    Next = true;
  } else if(overRect(PickX, PickY, rectwidth,recthight) ){
    Pick = true;
  }
  else {
    Next = false;
    Pick = false;
  }
}