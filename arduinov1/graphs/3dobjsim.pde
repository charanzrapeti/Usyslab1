// The following code is copied from : 
// https://howtomechatronics.com/tutorials/arduino/arduino-and-mpu6050-accelerometer-and-gyroscope-tutorial/

import processing.serial.*;

Serial myPort;
String data = "";
float roll, pitch, yaw;

void setup() {
  size(2560, 1440, P3D);
  
  // Open the serial port on COM11 with baud rate 115200
  myPort = new Serial(this, "COM11", 115200);
  myPort.bufferUntil('\n'); // Wait until newline to read data
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

void serialEvent(Serial myPort) {
  // Read data until newline character
  data = myPort.readStringUntil('\n');
  
  // Ensure data is not null
  if (data != null) {
    data = trim(data);  // Remove extra spaces and newlines

    // Check if data starts with "ypr"
    if (data.startsWith("ypr")) {
      // Remove "ypr" and extract the roll, pitch, yaw values
      data = data.substring(4);  // Remove "ypr\t"
      String[] items = split(data, '\t');  // Split by tab character '\t'

      if (items.length == 3) {
        // Parse roll, pitch, and yaw as floats and assign them
        yaw = float(items[0]);
        pitch = float(items[1]);
        roll = float(items[2]);
      }
    }
  }
}
