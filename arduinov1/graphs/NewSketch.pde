import oscP5.*;
import netP5.*;
import java.util.ArrayList;

OscP5 oscP5;
NetAddress myRemoteLocation;

float roll, pitch, yaw, pressure, altitude;
ArrayList<Float> altitudeValues = new ArrayList<>();
ArrayList<Long> timestamps = new ArrayList<>();
ArrayList<String> labels = new ArrayList<>();
int maxDataPoints = 500;

void setup() {
  size(1200, 900);

  oscP5 = new OscP5(this, 9999);
  smooth();
}

void draw() {
  background(30, 30, 30);

  int graphWidth = width - 40;
  int graphHeight = height - 150;
  int graphX = 20;
  int graphY = 50;

  drawGrid(graphX, graphY, graphWidth, graphHeight);
  drawGraph(graphX, graphY, graphWidth, graphHeight);
  drawLabels(graphX, graphY, graphWidth, graphHeight);
}

void drawGrid(int graphX, int graphY, int graphWidth, int graphHeight) {
  stroke(100);
  strokeWeight(1);
  int gridSpacing = 20;

  for (int i = 0; i <= graphWidth; i += gridSpacing) {
    line(graphX + i, graphY, graphX + i, graphY + graphHeight);
  }
  for (int i = 0; i <= graphHeight; i += gridSpacing) {
    line(graphX, graphY + i, graphX + graphWidth, graphY + i);
  }
}

void drawGraph(int graphX, int graphY, int graphWidth, int graphHeight) {
  if (altitudeValues.size() < 2) return;

  strokeWeight(2);
  for (int i = 1; i < altitudeValues.size(); i++) {
    float x1 = map(i - 1, 0, maxDataPoints, graphX, graphX + graphWidth);
    float x2 = map(i, 0, maxDataPoints, graphX, graphX + graphWidth);

    float y1 = map(altitudeValues.get(i - 1), 340, 380, graphY + graphHeight, graphY);
    float y2 = map(altitudeValues.get(i), 340, 380, graphY + graphHeight, graphY);

    String label = labels.get(i);
    if (label.equals("Stairs Up")) stroke(0, 255, 0); // Green
    else if (label.equals("Stairs Down")) stroke(255, 0, 0); // Red
    else if (label.equals("Lift Up")) stroke(0, 0, 255); // Blue
    else if (label.equals("Lift Down")) stroke(255, 255, 0); // Yellow

    line(x1, y1, x2, y2);
  }
}

void drawLabels(int graphX, int graphY, int graphWidth, int graphHeight) {
  textSize(12);
  textAlign(CENTER, BOTTOM);
  fill(255);
  for (int i = 0; i < altitudeValues.size(); i++) {
    if (i % 50 == 0 && timestamps.size() > i) {
      long timestamp = timestamps.get(i);
      String timeLabel = new java.text.SimpleDateFormat("HH:mm:ss").format(new java.util.Date(timestamp));
      float x = map(i, 0, maxDataPoints, graphX, graphX + graphWidth);
      text(timeLabel, x, graphY + graphHeight + 15);
    }
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/imu/ypr")) {
    altitude = theOscMessage.get(4).floatValue();

    if (altitudeValues.size() >= maxDataPoints) {
      altitudeValues.remove(0);
      timestamps.remove(0);
      labels.remove(0);
    }

    altitudeValues.add(altitude);
    timestamps.add(System.currentTimeMillis());
    labels.add(classifyActivity());

    redraw();
  }
}

String classifyActivity() {
  if (altitudeValues.size() < 2) return "";

  float change = altitude - altitudeValues.get(altitudeValues.size() - 2);
  if (abs(change) < 0.5) return ""; // Ignore small changes

  if (change > 0.5) return "Stairs Up";
  if (change < -0.5) return "Stairs Down";

  // Sudden, large altitude change indicates a lift
  if (abs(change) > 5.0) return change > 0 ? "Lift Up" : "Lift Down";

  return "";
}

