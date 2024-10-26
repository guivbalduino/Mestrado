/*  
 *  ------------  [AM_02] - Humidity sensor reading  -------------- 
 *  
 *  Explanation: This is the basic code to read the humidity from the 
 *  Sensirion module
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
 *  Version:         3.0
 *  Design:          David Gascón
 *  Implementation:  Luis Miguel Marti
 */

#include <WaspSensorAmbient.h>

float digitalHumidity; 


void setup() 
{
  USB.ON();
  USB.println(F("Humidity example"));
}

void loop()
{
  // Read the humidity sensor
  digitalHumidity = SensorAmbient.getHumidity();

  USB.print(F("humidity:"));
  USB.println(digitalHumidity);

  //wait 2 seconds
  delay(2000);
}

