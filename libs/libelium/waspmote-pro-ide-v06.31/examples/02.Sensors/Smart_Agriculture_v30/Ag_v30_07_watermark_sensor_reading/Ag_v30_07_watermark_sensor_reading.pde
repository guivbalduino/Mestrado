/*  
 *  --[Ag_v30_07] - Watermark sensor reading
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  Watermark sensors every second
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify 
 *  it under the terms of the GNU General Public License as published by 
 *  the Free Software Foundation, either version 3 of the License, or 
 *  (at your option) any later version. 
 *  
 *  This program is distributed in the hope that it will be useful, 
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of 
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 *  GNU General Public License for more details. 
 *  
 *  You should have received a copy of the GNU General Public License 
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>. 
 *  
 *  Version:           3.0
 *  Design:            David Gascón 
 *  Implementation:    Carlos Bello
 */

#include <WaspSensorAgr_v30.h>

// Variable to store the read value
float watermark1, watermark2, watermark3;
//Instance objects
watermarkClass wmSensor1(SOCKET_1);
watermarkClass wmSensor2(SOCKET_2);
watermarkClass wmSensor3(SOCKET_3);

void setup()
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));
  
  // Turn on the sensor board
  Agriculture.ON(); 
}
 
void loop()
{
  // Part 1: Read the Watermarks sensors one by one 
  USB.println(F("Wait for Watermark 1..."));
  watermark1 = wmSensor1.readWatermark();      
  
  USB.println(F("Wait for Watermark 2..."));  
  watermark2 = wmSensor2.readWatermark();      
  
  USB.println(F("Wait for Watermark 3..."));  
  watermark3 = wmSensor3.readWatermark();      
  
  // Part 2: USB printing
  // Print the watermark measures
  USB.print(F("Watermark 1 - Frequency: "));
  USB.print(watermark1);
  USB.println(F(" Hz"));
  USB.print(F("Watermark 2 - Frequency: "));
  USB.print(watermark2);
  USB.println(F(" Hz"));  
  USB.print(F("Watermark 3 - Frequency: "));
  USB.print(watermark3);
  USB.println(F(" Hz"));  
  USB.println();

  delay(1000);
}
