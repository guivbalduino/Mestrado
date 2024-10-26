/*  
 *  --[Ag_v30_10] - Pluviometer sensor reading
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  pluviometer sensor once every second
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
 *  Version:           3.1
 *  Design:            David Gascón 
 *  Implementation:    Carlos Bello
 */

#include <WaspSensorAgr_v30.h>

//Instance object
weatherStationClass weather;

// variable to store the number of pending pulses
int pendingPulses;

void setup()
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));

  // Turn on the sensor board
  Agriculture.ON();
  
  USB.print(F("Time:"));
  RTC.ON();
  USB.println(RTC.getTime());
}


void loop()
{
  /////////////////////////////////////////////
  // 1. Enter sleep mode
  /////////////////////////////////////////////
  Agriculture.sleepAgr("00:00:00:00", RTC_ABSOLUTE, RTC_ALM1_MODE4, SENSOR_ON, SENS_AGR_PLUVIOMETER);
  
  
  /////////////////////////////////////////////
  // 2.1. check pluviometer interruption
  /////////////////////////////////////////////
  if( intFlag & PLV_INT)
  {
    USB.println(F("+++ PLV interruption +++"));
    
    pendingPulses = intArray[PLV_POS];
    
    USB.print(F("Number of pending pulses:"));
    USB.println( pendingPulses );

    for(int i=0 ; i<pendingPulses; i++)
    {
      // Enter pulse information inside class structure
      weather.storePulse();
      
      // decrease number of pulses
      intArray[PLV_POS]--;
    }

    // Clear flag
    intFlag &= ~(PLV_INT); 
  }

  /////////////////////////////////////////////
  // 2.2. check RTC interruption
  /////////////////////////////////////////////
  if(intFlag & RTC_INT)
  {
    USB.println(F("+++ RTC interruption +++"));
    USB.print(F("Time:"));
    USB.println(RTC.getTime());
        
    USB.println(F("----------------------------------------------------"));

    // Print the accumulated rainfall
    USB.print(F("Current hour accumulated rainfall (mm/h): "));
    USB.println( weather.readPluviometerCurrent() );

    // Print the accumulated rainfall
    USB.print(F("Previous hour accumulated rainfall (mm/h): "));
    USB.println( weather.readPluviometerHour() );

    // Print the accumulated rainfall
    USB.print(F("Last 24h accumulated rainfall (mm/day): "));
    USB.println( weather.readPluviometerDay() );

    USB.println(F("----------------------------------------------------\n"));

    // Clear flag
    intFlag &= ~(RTC_INT); 
  }

}



