/*  
 *  --[Ag_v30_12] - DS18B20 sensor reading 
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  temperature sensor every second
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
float temp = 0;
//Instance object
ds18b20Class ds18b20;

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
  // Read the temperature sensor 
  temp = ds18b20.readDS18b20();   
  
  // Part 2: USB printing
  // Print values through the USB
  USB.print(F("Temperature (DS18B20): "));
  USB.print(temp);
  USB.println(F(" ºC"));
  delay(1000);  
}
