/*  
 *  ------------  [SCP_v30_08] - Noise Level Sensor  -------------- 
 *  
 *  Explanation: This is the basic code to manage and read the noise 
 *  level sensor. The sensor can be configured at SLOW (1 second of 
 *  measuring) and SLOW (125 milliseconds of measuring).
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
 *  Implementation:    Ahmad Saad Al Kalla
 */


#include <WaspSensorCities_PRO.h>

void setup()
{
  USB.ON(); 
  USB.println(F("Reading Noise Level Sensor"));
  // Configure the noise sensor for UART communication
  noise.configure(); 
}


void loop()
{

  // Get a new measure of the SPLA from the noise sensor
  int status = noise.getSPLA(SLOW_MODE);

  if (status == 0) 
  {
    USB.print(F("Sound Pressure Level with A-Weighting (SLOW): "));
    USB.print(noise.SPLA);
    USB.println(F(" dBA"));
  }
  else
  {
    USB.println(F("[CITIES PRO] Communication error. No response from the audio sensor (SLOW)"));
  }

  delay(5);
  
}
