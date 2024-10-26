/*   
 *  ------ [4-20mA_04] Frame Class utility -------- 
 *   
 *  Explanation: This sketch shows how to use the most important 
 *  features of the 4-20mA current loop board in Waspmote in 
 *  combination with the frame class. 
 *   
 *  Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *   
 *  This program is free software: you can redistribute it and/or modify 
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 2 of the License, or 
 *  (at your option) any later version. 
 *   
 *  This program is distributed in the hope that it will be useful, 
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *  GNU General Public License for more details. 
 *   
 *  You should have received a copy of the GNU General Public License 
 *  along with this program. If not, see <http://www.gnu.org/licenses/>. 
 *   
 *  Version:          3.0
 *  Design:           David Gascon 
 *  Implementation:   Ahmad Saad
 */


// Include this library for using current loop functions
#include <currentLoop.h>
#include <WaspFrame.h>

void setup()
{
  // Power on the USB for viewing data in the serial monitor
  USB.ON();
  delay(100);  


  /////////////////////////////////////////////
  // 1. Swtich ON the Board
  /////////////////////////////////////////////
  // Sets the 5V switch ON
  currentLoopBoard.ON(SUPPLY5V);
  delay(1000);

  // Sets the 12V switch ON
  currentLoopBoard.ON(SUPPLY12V); 
  delay(1000); 
}


void loop()
{
  /////////////////////////////////////////////
  // 2. Read the current values 
  /////////////////////////////////////////////
  
  // Get the sensor value as a current in mA from SOCKET_A
  float current_socketA = currentLoopBoard.readCurrent(SOCKET_A); // Plug&Sense: SOCKET_A; OEM: CHANNEL1
  // Get the sensor value as a current in mA from SOCKET_B
  float current_socketB = currentLoopBoard.readCurrent(SOCKET_B); // Plug&Sense: SOCKET_B; OEM: CHANNEL2
  // Get the sensor value as a current in mA from SOCKET_C
  float current_socketC = currentLoopBoard.readCurrent(SOCKET_C); // Plug&Sense: SOCKET_C; OEM: CHANNEL3
  // Get the sensor value as a current in mA from SOCKET_D
  float current_socketD = currentLoopBoard.readCurrent(SOCKET_D); // Plug&Sense: SOCKET_D; OEM: CHANNEL4

  
  /////////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////////

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // Add SOCKET_A current value
  frame.addSensor(SENSOR_4_20_CURRENT_SOCKET_A, current_socketA);
  // Add SOCKET_B current value
  frame.addSensor(SENSOR_4_20_CURRENT_SOCKET_B, current_socketB);
  // Add SOCKET_C current value
  frame.addSensor(SENSOR_4_20_CURRENT_SOCKET_C, current_socketC);
  // Add SOCKET_D current value
  frame.addSensor(SENSOR_4_20_CURRENT_SOCKET_D, current_socketD);

  // Show the frame
  frame.showFrame();

  // Wait 2 seconds
  delay(2000);
  

}
