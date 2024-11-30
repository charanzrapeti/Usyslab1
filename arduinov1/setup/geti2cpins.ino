// the following code is copied from : 
// https://www.eevblog.com/forum/microcontrollers/wemos-lolin32-mini-cant-find-i2c-bus/

void setup() {
 
  Serial.begin(115200);
 
  Serial.print("MOSI: ");
  Serial.println(MOSI);
  Serial.print("MISO: ");
  Serial.println(MISO);
  Serial.print("SCK: ");
  Serial.println(SCK);
  Serial.print("SS: ");
  Serial.println(SS); 
 
  Serial.print("SDA: ");
  Serial.println(SDA); 
  Serial.print("SCL: ");
  Serial.println(SCL); 
 
}

void loop() {
  // put your main code here, to run repeatedly:
}