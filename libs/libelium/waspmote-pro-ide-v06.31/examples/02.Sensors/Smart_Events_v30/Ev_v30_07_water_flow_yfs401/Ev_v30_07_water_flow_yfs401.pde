/*
    --[Ev_v30_07] - Reading flow sensor

    Explanation: This example show the flow sensor works in the
    corresponding socket

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Version:           3.1
    Design:            David Gascón
    Implementation:    Carlos Bello
*/

#include <WaspSensorEvent_v30.h>

bool flag = false;

// Variable to store the read value
float value;
//Instance object
flowClass yfs401(SENS_FLOW_YFS401);


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
  // 1. Read sensor
  ///////////////////////////////////////
  value = yfs401.flowReading();

  // Print the flow read value
  USB.print(F("Flow: "));
  USB.print(value);
  USB.println(F(" l/min"));

   
  ///////////////////////////////////////
  // 2. Enable/Disable Flow Sensor 
  ///////////////////////////////////////
  // NOTE: It is possible to enable/disable interruptions
  // from the flow sensor by calling the corresponding function
  USB.print(F("Change flow interruption flag each loop(): "));
  if (flag == true)
  {
    yfs401.disableFlowInt();
    USB.println(F("DISABLED"));
    flag = false;
  }  
  else
  {
    yfs401.enableFlowInt();
    USB.println(F("ENABLED"));
    flag = true;
  }

   
  ///////////////////////////////////////
  // 3. Go to deep sleep mode
  ///////////////////////////////////////
  USB.print(F("Enter deep sleep... "));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);
  USB.ON();
  USB.println(F("Wake up!!"));


  ///////////////////////////////////////
  // 4. Check Interruption Flags
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
    
    if (yfs401.getInt())
    {
      USB.println(F("-----------------------------"));
      USB.println(F("Interruption from flow sensor"));
      USB.println(F("-----------------------------"));
    }
    
    // Clean the interruption flag
    intFlag &= ~(SENS_INT);
    
    // Enable interruptions from the board
    Events.attachInt();
  }

  USB.println();
}


