import serial
import socket
import sys

# Configuración
RFC2217_HOST = 'localhost'
RFC2217_PORT = 4000
VIRTUAL_COM = 'COM1'  # ← CAMBIO AQUÍ
BAUDRATE = 9600

print("=== PUENTE WOKWI ↔ PROCESSING ===")
print(f"Esperando conexión en RFC2217 port {RFC2217_PORT}...")

try:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((RFC2217_HOST, RFC2217_PORT))
    print(f"✓ Conectado a Wokwi en {RFC2217_HOST}:{RFC2217_PORT}")
    
    ser = serial.Serial(VIRTUAL_COM, BAUDRATE, timeout=1)
    print(f"✓ Puerto virtual {VIRTUAL_COM} abierto")
    print(f"\nAhora conecta Processing a COM2")
    print("Presiona Ctrl+C para detener\n")
    
    while True:
        try:
            data = sock.recv(1024)
            if data:
                ser.write(data)
                print(data.decode('utf-8', errors='ignore'), end='')
        except:
            pass
            
except ConnectionRefusedError:
    print("\n✗ Error: No se puede conectar al puerto RFC2217.")
    print("Asegúrate de que Wokwi esté ejecutándose.")
    sys.exit(1)
except serial.SerialException as e:
    print(f"\n✗ Error con puerto serial: {e}")
    print("Verifica que COM1 esté disponible")
    sys.exit(1)
except KeyboardInterrupt:
    print("\n\nCerrando conexiones...")
finally:
    try:
        sock.close()
        ser.close()
    except:
        pass
    print("Desconectado")