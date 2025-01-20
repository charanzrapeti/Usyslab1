import csv
import time
from datetime import datetime
from threading import Thread
from pythonosc.dispatcher import Dispatcher
from pythonosc.osc_server import BlockingOSCUDPServer

# Data structure to store sensor data
data = []
frame_count = 0  # Counter for frames received
running = False  # Control flag for starting and stopping the server

# Callback functions for processing OSC messages
def handle_sensor(address, yaw, pitch, roll, pressure, altitude, frameId, sensorTime):
    global data, frame_count
    entry = {
        "timestamp": datetime.now().strftime("%H:%M:%S"),  # Format timestamp as hh:mm:ss
        "yaw": round(yaw, 3),  # Round to 3 decimal places
        "pitch": round(pitch, 3),
        "roll": round(roll, 3),
        "pressure": round(pressure, 3),
        "altitude": round(altitude, 3),
        "frameId": frameId,
        "sensorTime":sensorTime
    }
    data.append(entry)
    frame_count = frameId  

# Function to export data to CSV
def export_to_csv(filename):
    keys = ["timestamp", "yaw", "pitch", "roll", "pressure", "altitude", "frameId", "sensorTime"]
    with open(filename, "w", newline="") as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=keys)
        writer.writeheader()
        writer.writerows(data)
    print(f"Data exported to {filename}")

# Function to display frame count every second
def display_frame_count():
    global running, frame_count
    while running:
        print(f"Frames Received: {frame_count}, Time: {datetime.now().strftime('%H:%M:%S')}")
        time.sleep(1)

# Main function to set up OSC server
def main():
    global running

    dispatcher = Dispatcher()
    dispatcher.map("/imu/ypr", handle_sensor)  # Map MPU6050 address

    ip = "192.168.0.111"  # Listen on all network interfaces
    port = 9999  # UDP port for OSC messages
    server = BlockingOSCUDPServer((ip, port), dispatcher)

    print("Press 1 to start...")
    while True:
        user_input = input()
        if user_input == "1":
            running = True
            print(f"Listening on {ip}:{port}... Press 2 to end and save.")
            # Start a thread to display the frame count
            Thread(target=display_frame_count, daemon=True).start()
            try:
                server.serve_forever()
            except KeyboardInterrupt:
                server.shutdown()
                running = False
                print("Server stopped.")
                export_to_csv("sensor_data.csv")
        elif user_input == "2" and running:
            print("Stopping server and saving data...")
            running = False
            server.shutdown()
            export_to_csv("sensor_data.csv")
            break

if __name__ == "__main__":
    main()
