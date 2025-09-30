import processing.serial.*;

Serial puerto;
float temperatura = 0;
String datos = "";

void setup() {
  size(800, 600);
  
  println("=== PUERTOS DISPONIBLES ===");
  printArray(Serial.list());
  println("\nCambia el índice [0] en el código si es necesario");
  
  // IMPORTANTE: Ajustar el índice según tu sistema
  // En Windows suele ser el puerto COM más alto
  try {
    String portName = Serial.list()[1];
    puerto = new Serial(this, portName, 9600);
    puerto.bufferUntil('\n');
    println("Conectado a: " + portName);
  } catch (Exception e) {
    println("Error: " + e.getMessage());
  }
  
  textSize(24);
}

void draw() {
  background(20, 30, 50);
  
  // Título
  fill(255, 200, 0);
  textSize(32);
  textAlign(CENTER);
  text("Monitor UART - Temperatura", width/2, 50);
  
  // Termómetro visual
  float alturaBarra = map(temperatura, 0, 50, 0, 400);
  
  // Contenedor del termómetro
  stroke(255);
  strokeWeight(3);
  noFill();
  rect(width/2 - 60, 120, 120, 420);
  
  // Barra coloreada según temperatura
  noStroke();
  if (temperatura < 20) {
    fill(100, 150, 255); // Azul frío
  } else if (temperatura < 35) {
    fill(100, 255, 100); // Verde templado
  } else {
    fill(255, 100, 100); // Rojo caliente
  }
  rect(width/2 - 55, 535 - alturaBarra, 110, alturaBarra);
  
  // Valor numérico grande
  fill(255);
  textSize(64);
  textAlign(CENTER);
  // text(nf(temperatura, 0, 1) + "°C", width/2, 580);
  text(temperatura + "°C", width/2, 580);
  // Escala graduada
  stroke(255);
  strokeWeight(1);
  textSize(16);
  for (int i = 0; i <= 50; i += 10) {
    float y = map(i, 0, 50, 535, 135);
    line(width/2 - 70, y, width/2 - 60, y);
    fill(255);
    textAlign(RIGHT);
    text(i + "°", width/2 - 75, y + 5);
  }
  
  // Instrucciones
  fill(200);
  textSize(14);
  textAlign(CENTER);
  text("Datos recibidos por puerto serial desde Arduino", width/2, height - 20);
}

void serialEvent(Serial puerto) {
  datos = puerto.readStringUntil('\n');
  if (datos != null) {
    datos = trim(datos);
    
    if (datos.startsWith("TEMP:")) {
      String tempStr = datos.substring(5);
      try {
        temperatura = float(tempStr);
        println("Temperatura: " + temperatura + "°C");
      } catch (Exception e) {
        println("Error parseando: " + datos);
      }
    }
  }
}
