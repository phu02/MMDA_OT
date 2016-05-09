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

  String accelString;
  String gyroString;
  float accel[3];
  //float gyros[3];
  //int *gyro1, *gyro2, *gyro3;
  float gyros[3];
  
  my3IMU.acc.get_Gxyz(accel);
  my3IMU.getAngles(gyros);
  accel[2] = accel[2]*1.1;
  accelString += String(accel[0]);
  accelString += ", ";
  accelString += String(accel[1]);
  accelString += ", ";
  accelString += String(accel[2]);
  accelString += ", ";  

  gyroString += String(gyros[0]);
  gyroString += ", ";
  gyroString += String(gyros[1]);
  gyroString += ", ";
  gyroString += String(gyros[2]);
  gyroString += ", "; 


  File accelFile = FileSystem.open("/mnt/sd/accel.txt", FILE_WRITE);
  File gyroFile = FileSystem.open("/mnt/sd/gyro.txt", FILE_WRITE);


  accelFile.println(accelString);
  gyroFile.println(gyroString);

  Serial.println(accelFile);
  Serial.println(gyroFile);
  delay(10);
}
