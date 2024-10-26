/*
 *  ------------  [SCP_v30_11] - Noise Level Sensor class 2 Time configuration  --------------
 *
 *  Explanation: This is the basic code to read and configure time parameters
 *  for Noise Level Sensor class 2.
 *
 *  Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L.
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
 *  Implementation:    P. Gallego
 */


#include <WaspSensorCities_PRO.h>

/*
   P&S! Possibilities for this sensor:
    - SOCKET_A
*/

uint8_t response = 0;

  ///////////////////////////////////////////
// 0. New date and time
  ///////////////////////////////////////////
uint8_t new_hour = 0;
uint8_t new_minute = 0;
uint8_t new_second = 0;
uint8_t new_month = 1;
uint8_t new_day = 1;
uint16_t new_year = 2022;


void setup()
{
  USB.ON();
  USB.println(F("Noise level sensor class 2. Date and time configuration example"));
    
  /////////////////////////////////////////////////////////////////
  // 1. Turn on and configure the sensor for UART communication
  /////////////////////////////////////////////////////////////////
  noiseClass2.ON();
}


void loop()
{
  
  ///////////////////////////////////////////
  // 2. Read sensor
  ///////////////////////////////////////////

  USB.println(F("***************************************"));
  
  // Gets date
  response = noiseClass2.getDate();
  
  if(response == 0)
  {
    USB.print(F("NLS2 date 1: "));
    if(noiseClass2.day<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.day);
    USB.print(F("/"));
    if(noiseClass2.month<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.month);
    USB.print(F("/"));
    USB.println(noiseClass2.year);
  }
  else
  {
    USB.println(F("Communication error while getting date. No response from noise sensor"));
  }

  // Gets time
  response = noiseClass2.getTime();

  if(response == 0)
  {
    USB.print(F("NLS2 time 1: "));
    if(noiseClass2.hour<10) 
    {
      USB.print(F("0"));
    }
    USB.print(noiseClass2.hour);
    USB.print(F(":"));
    if(noiseClass2.minute<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.minute);
    USB.print(F(":"));
    if(noiseClass2.second<10) 
    {
      USB.print(F("0"));
    }
    USB.println(noiseClass2.second);       
  }
  else
  {
    USB.println(F("Communication error while getting time. No response from noise sensor"));
  }
  USB.println(F("***************************************"));

  // Sets new date
  response = noiseClass2.setDate(new_day, new_month, new_year); // dd/mm/yy
  
  if(response == 0)
  {
    USB.print(F("New date: "));
    if(noiseClass2.day<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.day);
    USB.print(F("/"));
    if(noiseClass2.month<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.month);
    USB.print(F("/"));
    USB.println(noiseClass2.year);
  }
  else
  {
    USB.println(F("Communication error while setting new date. No response from noise sensor"));
  }

  // Sets new time
  response = noiseClass2.setTime(new_hour, new_minute, new_second); // hh/mm/ss

  if(response == 0)
  {
    USB.print(F("New time: "));
    if(noiseClass2.hour<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.hour);
    USB.print(F(":"));
    if(noiseClass2.minute<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.minute);
    USB.print(F(":"));
    if(noiseClass2.second<10) 
    {
      USB.print(F("0"));      
    }
    USB.println(noiseClass2.second);    
  }
  else
  {
    USB.println(F("Communication error while setting new time. No response from noise sensor"));
  }

  USB.println(F("***************************************"));
  
  // Gets new date
  response = noiseClass2.getDate();
  
  if(response == 0)
  {
    USB.print(F("NLS2 date 2: "));
    if(noiseClass2.day<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.day);
    USB.print(F("/"));
    if(noiseClass2.month<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.month);
    USB.print(F("/"));
    USB.println(noiseClass2.year);
  }
  else
  {
    USB.println(F("Communication error while getting new date. No response from noise sensor"));
  }

  // Gets new time
  response = noiseClass2.getTime();

  if(response == 0)
  {
    USB.print(F("NLS2 time 2: "));
    if(noiseClass2.hour<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.hour);
    USB.print(F(":"));
    if(noiseClass2.minute<10) 
    {
      USB.print(F("0"));      
    }
    USB.print(noiseClass2.minute);
    USB.print(F(":"));
    if(noiseClass2.second<10) 
    {
      USB.print(F("0"));      
    }
    USB.println(noiseClass2.second);    
  }
  else
  {
    USB.println(F("Communication error while getting new time. No response from noise sensor"));
  }
  
  USB.println(F("***************************************"));


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
