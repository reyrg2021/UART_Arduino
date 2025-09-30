#include <Arduino.h>

const int sensorPin = A0;
float temperatura;

void setup() {
  Serial.begin(9600);
  Serial.println("Sistema iniciado");
}

void loop() {
  // Leer valor analógico (0-1023 en Arduino Uno)
  int lectura = analogRead(sensorPin);
  
  // Convertir a rango 0-50°C
  temperatura = map(lectura, 0, 1023, 0, 50);
  
  // Enviar datos por UART
  Serial.print("TEMP:");
  Serial.println(temperatura);
  
  delay(1000);
}