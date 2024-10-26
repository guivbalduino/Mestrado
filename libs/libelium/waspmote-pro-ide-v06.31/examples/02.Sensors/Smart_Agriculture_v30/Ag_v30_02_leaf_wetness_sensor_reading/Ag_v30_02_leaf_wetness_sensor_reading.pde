/*  
 *  --[Ag_v30_02] - Leaf wetness sensor reading 
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  leaf wetness sensor every second
 *  
 *  Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Design:            David Gascón 
 *  Implementation:    Carlos Bello
 */

#include <WaspSensorAgr_v30.h>

// Variable to store the read value
float value;
//Instance sensor object
leafWetnessClass lwSensor;

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
  // Read the leaf wetness sensor 
  value = lwSensor.getLeafWetness();	

  // show value
  USB.print("Leaf Wetness: ");
  USB.print(value);
  USB.println(" %")
  delay(1000);
}
