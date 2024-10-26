/*  
 *  --[Ev_v30_11] - Read LiquidLevel sensor and switch on Relay output 
 *  
 *  Explanation: This example shows how the liquid level sensor works 
 *  with the output relay. When the liquid level reaches a specific 
 *  level. The output relay is switched ON and will empty the water tank
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

#include <WaspSensorEvent_v30.h>

//Instance objects
relayClass relay;
liquidLevelClass liquidLevel(SOCKET_4); 

uint8_t value = 0;
  
void setup() 
{ 
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));  
  
  // Turn on the sensor board
  Events.ON();
  // Enable interruptions from the board
  Events.attachInt();
}

void loop() 
{
  ///////////////////////////////////////
  // 1. Read the sensor level
  ///////////////////////////////////////
  
  // Read the sensor level
  value = liquidLevel.readliquidLevel();
    
  while (value == 1)
  {
    // Switch on the relay    
    relay.relayON();
    USB.println(F("LEVEL REACHED - RELAY OUTPUT ON!"));  
    delay(1000);
    value = liquidLevel.readliquidLevel();    
  }   
  
  // Switch OFF the relay OUTPUT
  relay.relayOFF();
  USB.println(F("LEVEL NOT ACHIEVED - RELAY OUTPUT OFF!"));
  
  
  ///////////////////////////////////////
  // 2. Go to deep sleep mode
  ///////////////////////////////////////
  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);
  USB.ON();
  USB.println(F("wake up\n"));  

  
  ///////////////////////////////////////
  // 3. Check Interruption Flags
  ///////////////////////////////////////
  
  // Check interruption from RTC alarm
  if (intFlag & RTC_INT)
  {
    USB.println(F("-----------------------------"));
    USB.println(F("RTC INT captured"));
    USB.println(F("-----------------------------"));
    // clear flag
    intFlag &= ~(RTC_INT);
  }
  
  // Check interruption from Sensor Board
  if (intFlag & SENS_INT)
  {
    // Disable interruptions from the board
    Events.detachInt();
    
    // Load the interruption flag
    Events.loadInt();
    
    // In case the interruption came from liquid level
    if (liquidLevel.getInt())
    {
      USB.println(F("-----------------------------"));
      USB.println(F("Interruption from Liquid Level"));
      USB.println(F("-----------------------------"));
    }
        
    // Clean the interruption flag
    intFlag &= ~(SENS_INT);
    
    // Enable interruptions from the board
    Events.attachInt();
  }
}

