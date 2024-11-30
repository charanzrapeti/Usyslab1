# Star vs Lift Detector

This project is designed to detect and visualize orientation and motion using various sensors, including the **WESMOS LOLIN 32 LITE** board, **MPU6050 (Accelerometer/Gyroscope)**, and **BMP20 (Pressure Sensor)**. The project uses an ESP32 microcontroller and works with sensor data to calculate orientation (roll, pitch, and yaw) and other parameters to simulate lift and star orientations.

## Components Used

- **WESMOS LOLIN 32 LITE** – ESP32 Development Board
- **MPU6050** – Accelerometer/Gyroscope Sensor
- **BMP20** – Pressure Sensor

## Connections

<!-- Adjust image size for responsiveness on mobile -->
<img src="https://github.com/user-attachments/assets/4784b4b9-4876-4094-b77c-50d3a98d4f0e" alt="Connection Image" style="max-width: 100%; height: auto;">

- For setting up the connections, I followed the tutorials from the following links:
  - [ESP32 + MPU6050 - Accelerometer and Gyroscope Setup](https://randomnerdtutorials.com/esp32-mpu-6050-accelerometer-gyroscope-arduino/)
  - [ESP32 I2C Communication Setup](https://randomnerdtutorials.com/esp32-i2c-communication-arduino-ide/)

## Configuring the Board and Pins

1. **Getting I2C Pins**:
   - In the `/arduinov1/setup` folder, you’ll find the code `geti2cpins.ino`. This helps you determine which pins on the board can be used for I2C communication.

2. **Detecting I2C Sensors**:
   - Use the `i2cscanner.ino` file to scan the I2C bus and detect the connected sensors. This code will output the addresses of the sensors.

   **Note**: Credits for the code are provided within the files in the form of comments.

## Understanding Registers and Sensor Data

To understand the sensor registers and their working, refer to the datasheets of the MPU6050:
- [MPU6050 Register Map](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Register-Map1.pdf)
- [MPU6050 Datasheet](https://invensense.tdk.com/wp-content/uploads/2015/02/MPU-6000-Datasheet1.pdf)

These documents will help you understand how the sensor works and how we can read data from it.

## Testing and Calibration

<!-- Adjust image size for responsiveness on mobile -->
<img src="https://github.com/user-attachments/assets/2838bfc1-e629-464e-90b4-7cdf1d7d0729" alt="Calibration Test" style="max-width: 100%; height: auto;">

<!-- Another image adjusted for mobile -->
<img src="https://github.com/user-attachments/assets/1cd99d79-9332-45e3-92f2-be4b2e37490d" alt="Calibration Test 2" style="max-width: 100%; height: auto;">

1. **Testing MPU6050 Sensor**:
   - The file `/arduinov1/setup/calibration.ino` will help you test the MPU6050 sensor by measuring the accelerometer and gyroscope readings on the X, Y, and Z axes for 200 iterations. The code calculates the errors and logs them for calibration purposes.

2. **Understanding Calibration**:
   - The code helps you identify any calibration errors by comparing expected values to actual readings and adjusting accordingly for better accuracy.

## Calculating Roll, Pitch, and Yaw Values

To compute the **Roll**, **Pitch**, and **Yaw** values from the sensor, I used the following methods:

- **Roll**: The angle of rotation around the forward/backward axis.
- **Pitch**: The angle of rotation around the left/right axis.
- **Yaw**: The angle of rotation around the vertical axis.

For a better understanding, check out this resource:
- [Tracking Orientation with Arduino and ADXL345](https://howtomechatronics.com/tutorials/arduino/how-to-track-orientation-with-arduino-and-adxl345-accelerometer/)
- [MPU6050 Accelerometer and Gyroscope Tutorial](https://howtomechatronics.com/tutorials/arduino/arduino-and-mpu6050-accelerometer-and-gyroscope-tutorial/)

In the code, we extract and calculate these values from the sensor and visualize them for further analysis.

## Reading YPR Values

Using the `I2Cdevlib` MPU6050 library by **jrowberg** (`jrowberg/I2Cdevlib-MPU6050@^1.0.0`), we modify the example code by setting up calibration values, enabling us to read the **Yaw**, **Pitch**, and **Roll** values directly from the MPU6050 sensor.

The relevant files for this setup can be found in the `/arduinov1` folder.

## Graphs and Visualization


![ezgif-5-bb407f488b](https://github.com/user-attachments/assets/c692bd32-c2da-462e-bc3a-d9f8d3970084)

The **`/arduinov1/graphs`** folder contains scripts for generating graphs and visualizing the sensor data. It models the board and simulates the sensor readings, providing real-time graphs that represent the motion and orientation data.

### Attachments:
- **[Video 2: Demonstration of the Sensor and Graph Visualization]**

## How to Use

1. **Set up the hardware** according to the connections provided above.
2. **Upload the code** to the ESP32 board using the Arduino IDE.
3. Follow the calibration procedure to ensure the sensors are accurately reading the data.
4. **Monitor the Roll, Pitch, and Yaw values** using the provided graphing tools.
5. Use the values in your application to simulate and visualize the lift and star orientation.

## Credits

This project was made possible by various tutorials and libraries:
- [Random Nerd Tutorials](https://randomnerdtutorials.com)
- [MPU6050 Datasheet and Register Map](https://invensense.tdk.com)
- [I2Cdevlib Library](https://github.com/jrowberg/i2cdevlib)

The code for setting up the sensors, testing, and calibrating is based on existing libraries and modified for this project.
