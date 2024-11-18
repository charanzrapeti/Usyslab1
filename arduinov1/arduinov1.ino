#include <Wire.h>
#include <SPI.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP280.h>

// Define custom I2C SDA and SCL pins
#define I2C_SDA 23
#define I2C_SCL 19
#define BMP280_ADDRESS 0x76
#define MPU6050_ADDRESS 0x68

// Declare I2C object globally
TwoWire I2CBME = TwoWire(0);  // Create custom I2C instance using bus 0

// Declare the BMP280 object globally, passing I2CBME as the custom I2C bus
Adafruit_BMP280 bmp(&I2CBME);
Adafruit_MPU6050 mpu;

void setup() {
  Serial.begin(9600);
  while (!Serial) delay(100);  // Wait for native USB
  Serial.println(F("BMP280 test"));

  // Initialize I2C with custom SDA and SCL pins
  I2CBME.begin(I2C_SDA, I2C_SCL, 400000);  // Set I2C speed to 400kHz

  // Initialize the BMP280 sensor
  if (!bmp.begin(BMP280_ADDRESS)) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring or "
                      "try a different address!"));
    Serial.print("SensorID was: 0x"); 
    Serial.println(bmp.sensorID(), 16);
    while (1) delay(10);
  }

  

  // Default settings from datasheet
  bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering */
                  Adafruit_BMP280::STANDBY_MS_500); /* Standby time */

  Serial.println(F("MPU6050 test"));

  // Try to initialize!
  if (!mpu.begin(MPU6050_ADDRESS,&I2CBME )) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }

  // set accelerometer range to +-8G
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);

  // set gyro range to +- 500 deg/s
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);

  // set filter bandwidth to 21 Hz
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  delay(100);
  
}

void loop() {
  // Read and print temperature
  Serial.print(F("Temperature = "));
  Serial.print(bmp.readTemperature());
  Serial.println(" *C");

  // Read and print pressure
  Serial.print(F("Pressure = "));
  Serial.print(bmp.readPressure());
  Serial.println(" Pa");

  // Read and print altitude
  Serial.print(F("Approx altitude = "));
  Serial.print(bmp.readAltitude(1013.25));  // Adjusted to local forecast
  Serial.println(" m");

  Serial.println();

  Serial.print("------------------------------------------");

  /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  /* Print out the values */
  Serial.print(a.acceleration.x);
  Serial.print(",");
  Serial.print(a.acceleration.y);
  Serial.print(",");
  Serial.print(a.acceleration.z);
  Serial.print(", ");
  Serial.print(g.gyro.x);
  Serial.print(",");
  Serial.print(g.gyro.y);
  Serial.print(",");
  Serial.print(g.gyro.z);
  Serial.println("");

  Serial.println();
  delay(2000);  // Delay for 2 seconds

  
}
