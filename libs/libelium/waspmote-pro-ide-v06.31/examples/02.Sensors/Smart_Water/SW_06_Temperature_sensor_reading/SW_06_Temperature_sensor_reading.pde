/*  
 *  ------ [SW_06] - Temperature sensor Reading for Smart Water-------- 
 *  
 *  Explanation: Turn on the Smart Water Board and reads the Temperature
 *  sensor printing the result through the USB
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
 *  Implementation:    Ahmad Saad
 */

#include <WaspSensorSW.h>

// This variable will store the temperature value
float temp;

// Create an instance of the class
pt1000Class TemperatureSensor;

char node_ID[] = "Temperature_example";


void setup()
{
  USB.ON();
  USB.println(F("Water temperature PT-1000 example for Smart Water..."));
  
  ///////////////////////////////////////////
  // 1. Turn ON the Smart Water sensor board 
  ///////////////////////////////////////////  
  Water.ON(); 
}

void loop()
{
  ///////////////////////////////////////////
  // 2. read the sensors
  ///////////////////////////////////////////
  
  // Reading of the Temperature sensor
  temp = TemperatureSensor.readTemperature();

  ///////////////////////////////////////////
  // 3. Print the output values
  ///////////////////////////////////////////

  // Print of the results
  USB.print(F("Temperature (celsius degrees): "));
  USB.println(temp);


  // Delay
  delay(1000);  
}

