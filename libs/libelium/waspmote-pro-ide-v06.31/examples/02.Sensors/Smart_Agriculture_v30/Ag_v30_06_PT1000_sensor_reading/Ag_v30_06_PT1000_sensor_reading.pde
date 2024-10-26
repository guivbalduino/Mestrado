/*  
 *  --[Ag_v30_06] - PT1000 sensor reading
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  PT1000 sensor every second
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

//Variable to store the read value
float value;
//Instance object
pt1000Class pt1000Sensor;

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
  // Part 1: Read the PT1000 sensor 
  value = pt1000Sensor.readPT1000();  
  
  // Part 2: USB printing
  // Print the PT1000 temperature value through the USB
  USB.print(F("PT1000: "));
  USB.printFloat(value,3);
  USB.println(F(" ºC"));  
  delay(2000);
}
