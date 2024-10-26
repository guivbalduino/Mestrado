/*  
 *  ------------  [SCP_v30_13] - Noise Level Sensor V2  -------------- 
 *  
 *  Explanation: This is the basic code to manage and read the noise 
 *  level sensor. The sensor can be configured at: 
 *  SLOW (1 second of measuring) and 
 *  FAST (125 milliseconds of measuring).
 *  CONTINOUS (average of custom time)
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
 *  Version:    3.0 
 *  Design:     Heimdal laHoz, Cristian Montoya.
 */


#include <WaspSensorCities_PRO.h>

/*
   P&S! Possibilities for this sensor:
    - SOCKET_A - External Powered
    - SOCKET_D - Stand-Alone
*/

noiseSensorV2 my_noise(SOCKET_D);
uint8_t status;

void setup()
{
  uint8_t error;
  
  USB.ON(); 

  error=my_noise.ON();

  if(error == 0)
  {
    USB.println(F("Noise Level Sensor powered ON"));

    error= my_noise.getInfo();

    if (error == 0) 
    {
      USB.print(F("Serial Number: "));
      USB.println(my_noise.SerialN);
    }
    else
    {
      USB.println(F("Timeout: No response from the Noise Sensor"));
    }  
  }else
  {
    USB.println(F("Noise Level Sensor powered ERROR"));
  }

  my_noise.OFF();

}


void loop()
{

  my_noise.ON();

  ///////////////////////////////////////////
  // 2. Read sensor
  ///////////////////////////////////////////
  
  //SLOW MODE
  // Get a new measure of the SPLA from the noise sensor
  status = my_noise.get(LAS_MODE);

  if (status == 0) 
  {
    USB.print(F("Sound Pressure Level with A-Weighting (SLOW): "));
    USB.printFloat(my_noise.SPLA,2);
    USB.println(F(" dBA"));
  }
  else
  {
    USB.println(F("Communication error. No response from the audio sensor "));
  }
  delay(100);


//FAST MODE
// Get a new measure of the SPLA from the noise sensor
  status = my_noise.get(LAF_MODE);

  if (status == 0) 
  {
    USB.print(F("Sound Pressure Level with A-Weighting (FAST): "));
    USB.printFloat(my_noise.SPLA,2);
    USB.println(F(" dBA"));
  }
  else
  {
    USB.println(F("Communication error. No response from the audio sensor"));
  }
  delay(100);


  //CONTINUOUS MODE
  // Get a equivalent coninuous measure of the SPLA from the noise sensor during 60 seconds
  status = my_noise.getAverage(60000);

  if (status == 0) 
  {
    USB.print(F("Sound Pressure Level with Equivalent continuous is the average (LAEq): "));
    USB.printFloat(my_noise.SPLA,2);
    USB.println(F(" dBA"));
  }
  else
  {
    USB.println(F("Communication error. No response from the audio sensor"));
  }
  delay(100);  

  ///////////////////////////////////////////
  // 3. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 30 seconds, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Enter deep sleep mode"));
  PWR.deepSleep("00:00:00:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.ON();
  USB.println(F("wake up!!"));
}
