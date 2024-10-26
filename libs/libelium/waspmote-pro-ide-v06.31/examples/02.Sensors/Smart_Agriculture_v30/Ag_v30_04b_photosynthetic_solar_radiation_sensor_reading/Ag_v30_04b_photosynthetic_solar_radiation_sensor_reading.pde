/*  
 *  --[Ag_v30_04b] - Solar radiation sensor reading SQ-100-X
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  Solar Radiation Sensor on it once every second
 *  
 *  Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Version:           3.1 
 *  Design:    Cristian Montoya
 */

#include <WaspSensorAgr_v30.h>

// Instance object
radiationClass radSensor;
// Variable to store the radiation conversion value
float radiation,value;

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
  // Part 1: Read the solar radiation sensor 
  value = radSensor.readRadiation();  
  // Conversion from voltage into umol·m-2·s-1
  radiation = value / 0.0001;
  
  // Part 2: USB printing
  // Print the radiation value through the USB
  USB.print(F("Radiation: "));
  USB.print(radiation);
  USB.println(F("umol·m-2·s-1"));
  delay(1000);
}
