/*  
 *  ------ [SW_02] - ORP sensor Reading for Smart Water-------- 
 *  
 *  Explanation: Turn on the Smart Water Board and reads the ORP sensor
 *  extracting the value from the calibration values and temperature
 *  compensation
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

float ORPValue;

// Offset obtained from sensor calibration
#define calibration_offset 0.0

ORPClass ORPSensor;

void setup()
{
  USB.ON();
  USB.println(F("ORP example for Smart Water..."));

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
  
  // Reading of the ORP sensor
  ORPValue = ORPSensor.readORP();
  // Apply the calibration offset
  ORPValue = ORPValue - calibration_offset;

  ///////////////////////////////////////////
  // 3. Print the output values
  ///////////////////////////////////////////

  USB.print(F("ORP Estimated: "));
  USB.print(ORPValue);
  USB.println(F(" volts"));  


  delay(1000);
}

