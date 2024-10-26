/*
    --[Ev_v30_10] - Reading external input

    Explanation: This example show how the external input works
    when the source power is down. The SOCKET_6 is used for the external
    input by default

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

//Instance objects
relayClass relay;

uint8_t value = 0;

void setup()
{
  // 1. Initialization of the modules
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
  value = relay.readInRel();

  // Print the info
  if (value == 1)
  {
    USB.println(F("Sensor output: External input enabled"));
  }
  else
  {
    USB.println(F("Sensor output: External input disabled"));
  }


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

    // In case the interruption came from Relay Ext Int
    if (relay.getInt())
    {
      USB.println(F("-----------------------------"));
      USB.println(F("Interruption from Relay Input"));
      USB.println(F("-----------------------------"));
    }

    // Clean the interruption flag
    intFlag &= ~(SENS_INT);
    // Enable interruptions from the board
    Events.attachInt();
  }
}

