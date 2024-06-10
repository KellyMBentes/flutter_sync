# Flutter Sync

## Overview

This project aims to create a Linux program designed to run in kiosk mode using Flutter for the frontend, MQTT for messaging, 
and gRPC for remote procedure calls.

## Features

- **Flutter Frontend:** A modern, reactive UI using Flutter.
- **MQTT Messaging:** Efficient, lightweight messaging with MQTT.
- **gRPC Communication:** High-performance remote procedure calls with gRPC.
- **Kiosk Mode:** Locked-down environment using Openbox and LightDM.

## Requirements

- Linux-based operating system
- Flutter SDK
- Dart SDK
- MQTT broker
- gRPC
- Openbox
- LightDM

## Installation

### Setting up the Environment

1. **Install Flutter:**

   Follow the official Flutter installation guide: [Flutter Install](https://flutter.dev/docs/get-started/install)

2. **Install MQTT Broker:**

   You have two options for installing an MQTT broker:

   **Option 1: Mosquitto**
   ```bash
   sudo apt-get install mosquitto
   sudo systemctl enable mosquitto
   sudo systemctl start mosquitto
   ```

   **Option 2: MQTTX**

   Follow the official installation guide for MQTTX: [MQTTX Install](https://mqttx.app/)

   For initial tests, you can use the MQTTX online broker: [MQTTX Online Broker](http://mqtt-client.emqx.com/)

3. **Install gRPC**
  
   Follow the Dart gRPC quick start guide: [Dart gRPC Quick Start Guide](https://grpc.io/docs/languages/dart/quickstart/)

4. **Install Openbox and LightDM**

   ```bash
   sudo apt-get install openbox lightdm
   ```

### Configuring Kiosk
1. **Clone the Repository:**

   Clone the project repository:
   ```bash
   https://github.com/KellyMBentes/flutter_sync.git
   cd flutter_sync
   ```

2. **Build the Flutter Application:**

   Build the Flutter Application before configure Kiosk Mode:
   ```bash
   flutter build linux
   ```
3. **Configure Openbox**

   Create a script to set up and start your Dart server. Here’s an example of what that script might look like:
   
   Create the script start_dart_server.sh in the root of your project:

   ```bash
   nano /home/yourusername/grpc-dart/example/helloworld/start_dart_server.sh
   ```

   Add the following lines to the script:
   ```bash
   #!/bin/bash
   cd /home/yourusername/grpc-dart/example/helloworld
   dart pub get
   dart bin/server.dart
   ```

   Make sure the script has execute permissions:

   ```bash
   chmod +x /home/yourusername/grpc-dart/example/helloworld/start_dart_server.sh
   ```

   Edit the Openbox autostart file:

   ```bash
   nano ~/.config/openbox/autostart
   ```

   Add the following lines to start the Flutter app on login:

   ```bash
   # Start the Dart server
   /home/yourusername/grpc-dart/example/helloworld/start_dart_server.sh
   # Start the Flutter application
   /home/yourusername/flutter_sync/build/linux/x64/release/bundle/flutter_sync
   ```
4. **Configure LightDM**
  
   Edit the LightDM configuration file:
   
   ```bash
   sudo nano /etc/lightdm/lightdm.conf
   ```
   
   Set the default session to Openbox:
   
   ```bash
   [SeatDefaults]
   autologin-user=kiosk-user
   user-session=openbox
   ```

### Running The Program
1. **Ensure the MQTT broker is running**
2. **Change display manager to lightDM:**
   
   ```bash
   sudo dpkg-reconfigure lightdm
   ```
   
3. **Reboot the system:**
   ```bash
   sudo reboot
   ```

### Exiting Kiosk Mode
1. **Open a Terminal:**
   - Press `Ctrl` + `Alt` + `Fn` + `F2` to open a terminal window.
  
2. **Change display manager to your previous one:**
   
   ```bash
   sudo dpkg-reconfigure lightdm
   ```
   
3. **Reboot the system:**
   ```bash
   sudo reboot
   ```

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
- [Flutter](flutter.dev)
- [MQTT](mqtt.org)
- [gRPC](grpc.io)
- [Openbox](openbox.org)
- [LightDM](wiki.archlinux.org/LightDM)
