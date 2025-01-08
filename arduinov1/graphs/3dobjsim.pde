// The following code is copied from : 
// https://howtomechatronics.com/tutorials/arduino/arduino-and-mpu6050-accelerometer-and-gyroscope-tutorial/


import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float roll, pitch, yaw;





void setup() {
  size(2560, 1440, P3D);

  // Initialize OSC receiver on port 8000
  oscP5 = new OscP5(this, 9999);

  // For testing, set up a remote location (if needed)
  myRemoteLocation = new NetAddress("127.0.0.1", 9999);
 
}

void displayCredits() {
  // Credits in the bottom-right corner
  textSize(50);
  textAlign(RIGHT, BOTTOM); // Right and bottom alignment for credits text
  
  // Display credits in white with slight transparency for a subtle effect
  fill(255, 255, 255, 200);
  text("www.HowToMechatronics.com", width - 200, height - 200);
}

void draw() {
  // Center the 3D coordinates and set background
  translate(width / 2, height / 2, 0);
  background(30, 30, 30);
  fill(255, 255, 255, 200);
  textSize(52);
  text("Roll: " + int(roll) + "     Pitch: " + int(pitch)+ "    Yaw: " + int(yaw)  , -100, 265);
  text("CREDITS : www.HowToMechatronics.com", -100, 365 ); 

  // Rotate the object based on the Euler angles: roll, pitch, yaw
  rotateX(radians(-pitch));  // Rotate around X axis (pitch)
  rotateZ(radians(roll));    // Rotate around Z axis (roll)
  rotateY(radians(yaw));     // Rotate around Y axis (yaw)

  // 3D object (box)
    
  fill(0, 76, 153);
  stroke(255);
  box(386, 40, 200); // Draw a box as a 3D object

 
  
 
}

// Callback to handle incoming OSC messages
void oscEvent(OscMessage theOscMessage) {
  
  println("Received OSC message: " + theOscMessage);
  if (theOscMessage.checkAddrPattern("/imu/ypr")) {
    yaw = theOscMessage.get(0).floatValue();
    pitch = theOscMessage.get(1).floatValue();
    roll = theOscMessage.get(2).floatValue();
    
    // Print the extracted yaw, pitch, and roll values to the console
    println("Yaw: " + yaw + ", Pitch: " + pitch + ", Roll: " + roll);
  }
}
