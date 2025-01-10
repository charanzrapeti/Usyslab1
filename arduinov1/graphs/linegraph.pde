import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float roll, pitch, yaw, pressure, altitude;
int maxDataPoints = 500;
float[] rollValues = new float[maxDataPoints];
float[] pitchValues = new float[maxDataPoints];
float[] yawValues = new float[maxDataPoints];
float[] pressureValues = new float[maxDataPoints];
float[] altitudeValues = new float[maxDataPoints];
int dataIndex = 0;

void setup() {
  size(1200, 900);

  oscP5 = new OscP5(this, 9999);

  for (int i = 0; i < maxDataPoints; i++) {
    rollValues[i] = 0;
    pitchValues[i] = 0;
    yawValues[i] = 0;
    pressureValues[i] = 0;
    altitudeValues[i] = 0;
  }

  smooth();
}

void draw() {
  background(30, 30, 30);

  int graphWidth = width - 40;
  int graphHeight = height / 4;
  int graphX = 20;
  int rollPitchYawGraphY = 20;
  int pressureGraphY = rollPitchYawGraphY + graphHeight + 40;
  int altitudeGraphY = pressureGraphY + graphHeight + 40;

  drawTitle();

  drawGrid(graphX, rollPitchYawGraphY, graphWidth, graphHeight);
  drawGraph(graphX, rollPitchYawGraphY, graphWidth, graphHeight, rollValues, pitchValues, yawValues, -100.0f, 100.0f);

  drawGrid(graphX, pressureGraphY, graphWidth, graphHeight);
  drawGraph(graphX, pressureGraphY, graphWidth, graphHeight, pressureValues, null, null, 97200.0f, 97300.0f);

  drawGrid(graphX, altitudeGraphY, graphWidth, graphHeight);
  drawGraph(graphX, altitudeGraphY, graphWidth, graphHeight, altitudeValues, null, null, 340.0f, 350.0f);
}

void drawTitle() {
  textSize(20);
  textAlign(RIGHT, TOP);

  fill(255, 0, 0);
  text("Roll: " + int(roll), width - 20, height -20);

  fill(0, 255, 0);
  text("Pitch: " + int(pitch), width - 20, height - 45);

  fill(0, 0, 255);
  text("Yaw: " + int(yaw), width - 20, height - 70);

  fill(255);
  text("Pressure: " + nf(pressure, 1, 2), width - 20,height -  95);

  fill(255, 255, 0);
  text("Altitude: " + nf(altitude, 1, 2), width - 20, height - 120);
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

void drawGraph(int graphX, int graphY, int graphWidth, int graphHeight, float[] values1, float[] values2, float[] values3, float minValue, float maxValue) {
  strokeWeight(2);

  if (values1 != null) {
    stroke(values2 == null && values3 == null ? 255 : 255, 0, 0); // Red or White
    drawLineGraph(values1, graphX, graphY, graphWidth, graphHeight, minValue, maxValue);
  }

  if (values2 != null) {
    stroke(0, 255, 0); // Green
    drawLineGraph(values2, graphX, graphY, graphWidth, graphHeight, minValue, maxValue);
  }

  if (values3 != null) {
    stroke(0, 0, 255); // Blue
    drawLineGraph(values3, graphX, graphY, graphWidth, graphHeight, minValue, maxValue);
  }
}

void drawLineGraph(float[] values, int startX, int startY, int graphWidth, int graphHeight, float minValue, float maxValue) {
  for (int i = 1; i < maxDataPoints; i++) {
    float prevY = startY + graphHeight - map(values[i - 1], minValue, maxValue, 0, graphHeight);
    float currY = startY + graphHeight - map(values[i], minValue, maxValue, 0, graphHeight);
    float x1 = startX + map(i - 1, 0, maxDataPoints, 0, graphWidth);
    float x2 = startX + map(i, 0, maxDataPoints, 0, graphWidth);
    line(x1, prevY, x2, currY);
  }
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/imu/ypr")) {
    yaw = theOscMessage.get(0).floatValue();
    pitch = theOscMessage.get(1).floatValue();
    roll = theOscMessage.get(2).floatValue();
    pressure = theOscMessage.get(3).floatValue();
    altitude = theOscMessage.get(4).floatValue();

    rollValues[dataIndex] = roll;
    pitchValues[dataIndex] = pitch;
    yawValues[dataIndex] = yaw;
    pressureValues[dataIndex] = pressure;
    altitudeValues[dataIndex] = altitude;

    dataIndex++;
    if (dataIndex >= maxDataPoints) {
      dataIndex = 0;
    }
  }
}
