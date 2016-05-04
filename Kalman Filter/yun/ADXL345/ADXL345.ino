#include <FileIO.h>
#include <FreeSixIMU.h>
#include <FIMU_ADXL345.h>
#include <FIMU_ITG3200.h>
#include <wire.h>

FreeSixIMU my3IMU = FreeSixIMU();

//void setup() {
//
//  Bridge.begin();
//  Serial.begin(9600);
//  FileSystem.begin();
//
//  delay(5);
//  my3IMU.init();
//  delay(5); 
//
//}


void setup() {
 Serial.begin(9600);
 Wire.begin();

 delay(5);
 my3IMU.init();
 delay(5);
}

void loop() {

  //Serial.println("test");

  String dataString;
  float accel[3];
  //float gyros[3];
  //int *gyro1, *gyro2, *gyro3;
  float gyros[3];
  
  my3IMU.acc.get_Gxyz(accel);
  my3IMU.getAngles(gyros);
  accel[2] = accel[2]*1.1;
  dataString += String(accel[0]);
  dataString += ", ";
  dataString += String(accel[1]);
  dataString += ", ";
  dataString += String(accel[2]);
  dataString += ", ";  
  //dataString += String(gyros[0]);
  dataString += String(gyros[0]);
  dataString += ", ";
  //dataString += String(gyros[1]);
  dataString += String(gyros[1]);
  dataString += ", ";
  //dataString += String(gyros[2]);
  dataString += String(gyros[2]);
  dataString += ", "; 

//  File dataFile = FileSystem.open("/mnt/sda1/arduino/accel3.txt", FILE_WRITE);
  File dataFile = FileSystem.open("accel3.txt", FILE_WRITE);

  //if (dataFile) {
    dataFile.println(dataString);
    //dataFile.close();
    Serial.println(dataString);
  //}
  //else {
    //Serial.println("error opening datalog.txt");
  //} 
  delay(10);
}
