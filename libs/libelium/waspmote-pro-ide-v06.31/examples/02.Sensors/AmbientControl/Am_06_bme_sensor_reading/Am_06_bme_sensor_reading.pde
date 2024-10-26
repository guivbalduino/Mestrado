/*  
 *  ------------  [AM_06] - BME sensor reading  -------------- 
 *  
 *  Explanation: This is the basic code to read the temperature, humidity 
 *  and Atmospheric presure from the BME sensor
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
 *  Implementation:  Yuri Carmona
 */

#include <WaspSensorAmbient.h>

float temperature; 
float humidity; 
float pressure; 


void setup() 
{
  USB.ON();
  USB.println(F("Temperature example"));
}

void loop()
{
  // Read sensor
  temperature = SensorAmbient.getTemperatureBME();
  humidity = SensorAmbient.getHumidityBME();
  pressure = SensorAmbient.getPressureBME();
  
  USB.print(F("Temperature:"));
  USB.print(temperature);
  USB.println(F(" Celsius"));
  
  USB.print(F("Humidity:"));
  USB.print(humidity);
  USB.println(F(" %"));
  
  USB.print(F("Atmospheric pressure:"));
  USB.print(pressure);
  USB.println(F(" Pa"));

  // wait 2 seconds
  delay(2000);
}

