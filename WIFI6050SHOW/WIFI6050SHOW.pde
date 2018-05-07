import hypermedia.net.*;







 UDP udp; 
int num = 0;
char[] teapotPacket = new char[16];  // InvenSense Teapot packet
int serialCount = 0;                 // current packet byte position
int synced = 0;
int interval = 0;
int[] teapot = new int[9];
float[] q = new float[4];
int[] countMPU = new int[6];
float[] gravity = new float[3];
float[] euler = new float[3];
float[] ypr = new float[3];

 void setup() {
 udp = new UDP( this, 1234 ); 
 //udp.log( true );        
 udp.listen( true );           
 }

 void draw()
 {
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
         int ch = (kk[i]);
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
                for (int j = 0; i < 4; i++) if (q[j] >= 2) q[j] = -4 + q[j];
                
                //print(float(Math.round((q[0])*100))/100+"\t"
                //+ float(Math.round((q[1])*100))/100+"\t"
                //+ float(Math.round((q[2])*100))/100+"\t"
                //+ float(Math.round((q[3])*100))/100);
                
                euler[0] = atan2(2*q[1]*q[2] - 2*q[0]*q[3], 2*q[0]*q[0] + 2*q[1]*q[1] - 1);
                euler[1] = -asin(2*q[1]*q[3] + 2*q[0]*q[2]);
                euler[2] = atan2(2*q[2]*q[3] - 2*q[0]*q[1], 2*q[0]*q[0] + 2*q[3]*q[3] - 1);
    
                
                //print(q[0]+"\t"+q[1]+"\t"+q[2]+"\t"+q[3]);
                
                //print("euler:\t" + euler[0]*180.0f/PI + "\t" + euler[1]*180.0f/PI + "\t" + euler[2]*180.0f/PI);
                
                countMPU[teapotPacket[12]] ++;
                //println("\tMPU-" + int(teapotPacket[12]) 
                //+ "\tnum" + num + "\tmillis: "+ millis() +"\tMPU0: " +countMPU[0]+"\tMPU1: " +countMPU[1]
                //+"\tMPU2: " +countMPU[2]+"\tMPU3: " +countMPU[3]+"\tMPU4: " +countMPU[4]+"\tMPU5: " +countMPU[5]
                //+"\t0xFF-"+ byte(teapotPacket[11]));
                
                
                if( int(teapotPacket[12]) == 1){
                //print("euler:\t" + euler[0]*180.0f/PI + "\t" + euler[1]*180.0f/PI + "\t" + euler[2]*180.0f/PI);
                print(float(Math.round((q[0])*1000))/1000+"\t"
                + float(Math.round((q[1])*1000))/1000+"\t"
                + float(Math.round((q[2])*1000))/1000+"\t"
                + float(Math.round((q[3])*1000))/1000);
                //countMPU[teapotPacket[12]] ++;
                println("\tMPU-" + int(teapotPacket[12]) 
                + "\tnum" + num + "\tmillis: "+ millis() +"\tMPU0: " +countMPU[0]+"\tMPU1: " +countMPU[1]
                +"\tMPU2: " +countMPU[2]+"\tMPU3: " +countMPU[3]+"\tMPU4: " +countMPU[4]+"\tMPU5: " +countMPU[5]
                +"\t0xFF-"+ byte(teapotPacket[11]));
                }
            }
        }
     }
   }
}
