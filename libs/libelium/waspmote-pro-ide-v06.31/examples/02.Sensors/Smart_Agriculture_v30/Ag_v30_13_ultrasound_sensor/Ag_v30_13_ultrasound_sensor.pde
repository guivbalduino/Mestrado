/*  
 *  --[Ag_v30_13] - Ultrasound Sensor reading 
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  ultrasound sensor every second
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
uint16_t dist = 0;

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
  // Part 1: Read Values
  // Read the ultrasound sensor 
  dist = Agriculture.getDistance();   
  
  // Part 2: USB printing
  // Print values through the USB
  USB.print(F("Distance: "));
  USB.print(dist);
  USB.println(F(" cm"));
  delay(1000);  
}
