/*
 *   ------------  [Ga_v30_15] - Ultrasound sensor reading  --------------
 *
 *   Explanation: This example read the distance from the ultrasound
 *   sensor. 
 *
 *   Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
 *   http://www.libelium.com
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *   Version:           3.0
 *   Design:            David Gascón
 *   Implementation:    Ahmad Saad
*/

// Library include
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>

float distance;    // Stores the luminosity value

char node_ID[] = "US_example";

void setup()
{
  USB.ON();
  USB.println(F("Ultrasound sensor example"));
  // Set the Waspmote ID
  frame.setID(node_ID);  
  
  ///////////////////////////////////////////
  // 1. Turn on the board
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();
  delay(100);   
}

void loop()
{
  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////  

 // Read distance from Ultrasound sensor
  distance = Gases.getDistance();

  // Print of the results
  USB.print(F("Distance: "));
  USB.print(distance);
  USB.print(F(" cm "));
  USB.println();
  
  ///////////////////////////////////////////
  // 3. Create ASCII frame
  ///////////////////////////////////////////
  
  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add distance
  frame.addSensor(SENSOR_GASES_US, distance);
  // Show the frame
  frame.showFrame();
  
  delay(3000);
}

