import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float roll, pitch, yaw;
int maxDataPoints = 500; // Max number of points to show on the graph (controlled by the width of the graph)
float[] rollValues = new float[maxDataPoints];
float[] pitchValues = new float[maxDataPoints];
float[] yawValues = new float[maxDataPoints];
int dataIndex = 0;

void setup() {
  size(800, 600);  // Set the window size
  
   // Initialize OSC receiver on port 8000
  oscP5 = new OscP5(this, 9999);

  // For testing, set up a remote location (if needed)
  myRemoteLocation = new NetAddress("127.0.0.1", 9999);

  
  // Initialize the values
  for (int i = 0; i < maxDataPoints; i++) {
    rollValues[i] = 0;
    pitchValues[i] = 0;
    yawValues[i] = 0;
  }
  
  // Set smooth rendering
  smooth();
}

void draw() {
  // Set background color for each frame
  background(30, 30, 30); // Darker background for the window
  
  // Graph dimensions and positioning
  int graphWidth = width - 40; // Graph will extend to the right edge, starting from 20px padding
  int graphX = 20; // Set the graph's X starting position (20px padding from the left)
  int graphY = height / 4; // Move the graph slightly higher by changing this value
  int graphHeight = height / 2; // Graph will take up half the height of the window
  
  // Draw title and current values (text in top-right corner)
  drawTitle();
  
  // Draw the line graph for Roll, Pitch, and Yaw
  drawGrid(graphX, graphY, graphWidth, graphHeight);
  drawGraph(graphX, graphY, graphWidth, graphHeight);
}

void drawTitle() {
  // Title and current values display in the top-right corner
  textSize(20);
  textAlign(RIGHT, TOP); // Align the text to the top-right corner

  // Draw Roll in red, Pitch in green, and Yaw in blue
  fill(255, 0, 0);  // Red for Roll
  text("Roll: " + int(roll), width - 20, 20);
  
  fill(0, 255, 0);  // Green for Pitch
  text("Pitch: " + int(pitch), width - 20, 45);
  
  fill(0, 0, 255);  // Blue for Yaw
  text("Yaw: " + int(yaw), width - 20, 70);
}

void drawGrid(int graphX, int graphY, int graphWidth, int graphHeight) {
  // Draw grid lines to make the graph easier to read
  
  stroke(100); // Set grid line color to light gray
  strokeWeight(1); // Thinner lines for the grid
  
  int gridSpacing = 20; // Space between grid lines
  
  // Draw vertical grid lines (only within the graph's width)
  for (int i = 0; i <= graphWidth; i += gridSpacing) {
    line(graphX + i, graphY, graphX + i, graphY + graphHeight);
  }
  
  // Draw horizontal grid lines (only within the graph's height)
  for (int i = 0; i <= graphHeight; i += gridSpacing) {
    line(graphX, graphY + i, graphX + graphWidth, graphY + i);
  }
}

void drawGraph(int graphX, int graphY, int graphWidth, int graphHeight) {
  // Set graph style
  strokeWeight(3); // Make lines thicker for clarity
  noFill();
  
  // Draw the roll, pitch, and yaw values as lines
  stroke(255, 0, 0); // Red for Roll
  drawLineGraph(rollValues, graphX, graphY, graphWidth, graphHeight);

  stroke(0, 255, 0); // Green for Pitch
  drawLineGraph(pitchValues, graphX, graphY, graphWidth, graphHeight);

  stroke(0, 0, 255); // Blue for Yaw
  drawLineGraph(yawValues, graphX, graphY, graphWidth, graphHeight);
}

void drawLineGraph(float[] values, int startX, int startY, int graphWidth, int graphHeight) {
  // Draw the line graph from the second data point (no need to draw from the first point)
  for (int i = 1; i < maxDataPoints; i++) {
    float prevY = startY + graphHeight - (values[i - 1] * graphHeight / 180);  // Mapping to graph height
    float currY = startY + graphHeight - (values[i] * graphHeight / 180);      // Mapping to graph height
    line(startX + i - 1, prevY, startX + i, currY);  // Draw the line between previous and current points
  }
}

// Callback to handle incoming OSC messages
void oscEvent(OscMessage theOscMessage) {
  
  println("Received OSC message: " + theOscMessage);
  if (theOscMessage.checkAddrPattern("/imu/ypr")) {
    yaw = theOscMessage.get(0).floatValue();
    pitch = theOscMessage.get(1).floatValue();
    roll = theOscMessage.get(2).floatValue();
    
     // Store the new data values into the arrays
        rollValues[dataIndex] = roll;
        pitchValues[dataIndex] = pitch;
        yawValues[dataIndex] = yaw;

        // Move to the next index, and reset if it exceeds maxDataPoints
        dataIndex++;
        if (dataIndex >= maxDataPoints) {
          dataIndex = 0;  // Start over when max data points are reached
        }
    
    // Print the extracted yaw, pitch, and roll values to the console
    println("Yaw: " + yaw + ", Pitch: " + pitch + ", Roll: " + roll);
  }
}
