/*  
 *  --[Ag_v30_05b] - Dendrometer sensor reading with reference
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  dendrometer on it once every second
 *  
 *  Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Design:    Luis Miguel Martí
 */

#include <WaspSensorAgr_v30.h>

// Variable to store the read value
float value;

/*
 * Define object for sensor: dendSensor
 * Input to choose type of dendrometer. 
 * Possibilities for this sensor:
 *  - SENS_SA_DF
 *  - SENS_SA_DF4
 *  - SENS_SA_DD
 *  - SENS_SA_DC3
 *  - SENS_SA_DC2 (old)
 */
dendrometerClass dendSensor(SENS_SA_DF);

void setup()
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program")); 
   
  // Turn on the sensor board
  Agriculture.ON();  

  // This function reads the dendrometer value
  // and sets it as zero millimeters reference
  USB.print(F("Reference captured at: "));
  dendSensor.setReference();
  USB.printFloat(dendSensor._reference,3);
  USB.println(F(" mm .The following samples will be relatives to this"));
}
 
void loop()
{
  // Part 1: Read the dendrometer value and returns
  // the difference between this value and reference
  value = dendSensor.readGrowth();  
  
  // Part 2: USB printing
  // Print the Dendrometer value through the USB
  USB.print(F("Dendrometer: "));
  USB.printFloat(value,3);
  USB.println(F(" mm"));
  delay(1000);
}
