/*  
 *  ------ [SW_07] - Turbidity Sensor Reading for Smart Water-------- 
 *  
 *  Explanation: Turn on the Turbidity sensor and read the turbidity 
 *  value. The turbidity sensor can also read the temperature of the water
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

#include <TurbiditySensor.h>

// Create an instance of the class
turbidityClass turbidity;

void setup() 
{  
  // Turn on the Turbidity sensor board and start the USB
  USB.ON();  
  USB.println(F("Turbidity example for Smart Water"));
  
  ///////////////////////////////////////////
  // 1. Power on  sensors
  /////////////////////////////////////////// 
  turbidity.ON();
}

void loop() 
{  
  ///////////////////////////////////////////////////////////
  // 2. Get Turbidity Measure
  ///////////////////////////////////////////////////////////  

  float turVal = turbidity.getTurbidity();
  USB.print(F("Turbidity Value: "));
  USB.print(turVal);    
  USB.print(F(" NTU | "));    
  
  ///////////////////////////////////////////////////////////
  // 3. Get Temperature Measure from Turbidity sensor
  ///////////////////////////////////////////////////////////  

  float temperature = turbidity.getTemperature();
  USB.print(F("Temperature Value: "));
  USB.print(temperature);    
  USB.println(F(" Celsius Degrees"));     


   delay(2000); 
}

