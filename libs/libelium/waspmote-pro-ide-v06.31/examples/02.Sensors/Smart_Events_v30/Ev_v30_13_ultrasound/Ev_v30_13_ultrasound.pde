/*  
 *  --[Ev_v30_13] - Reading the UltraSound Sensor
 *  
 *  Explanation: Turn on the Events v30 board and read the 
 *  ultrasound sensor every ten second
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
 *  Implementation:    Carlos Bello
 */

#include <WaspSensorEvent_v30.h>

// Variable to store the read value
uint16_t dist = 0;


void setup()
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));  
  
  // Turn on the sensor board
  Events.ON();  
}

 
void loop()
{
  ///////////////////////////////////////
  // 1. Read sensor
  ///////////////////////////////////////
  
  // Read the ultrasound sensor 
  dist = Events.getDistance();   
  
  // Print values through the USB
  USB.print(F("Distance: "));
  USB.print(dist);
  USB.println(F(" cm"));
  
  
  ///////////////////////////////////////
  // 2. Go to deep sleep mode  
  ///////////////////////////////////////
  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);  

  USB.ON();
  USB.println(F("wake up\n"));
  
}
