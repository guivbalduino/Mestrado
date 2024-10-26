/*
   ------ Sigfox Code Example --------

   Explanation: This example shows how to send a Libelium Tiny Frame.
   This type of frame has been designed to create short frames with data.

   Copyright (C) 2020 Libelium Comunicaciones Distribuidas S.L.
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

   Version:           3.0
   Design:            David Gascon
   Implementation:    Isabel Burillo
*/
#include <WaspSigfox.h>
#include <WaspFrame.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

uint8_t error;

void setup()
{
  USB.ON();
  USB.println(F("Sigfox - Sending Tiny Frame example"));
}


void loop()
{
  //////////////////////////////////////////////
  // 1. Creating a new frame
  //////////////////////////////////////////////

  // init ACC
  ACC.ON();

  USB.println(F("Creating an BINARY frame"));

  // Create new frame
  frame.createFrame(BINARY);

  // set frame fields (Battery sensor - uint8_t)
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

  // set frame fields (multiple)
  frame.addSensor(SENSOR_ACC, ACC.getX(), ACC.getY(), ACC.getZ());

  // Prints frame
  frame.showFrame();

  // accelerometer OFF
  ACC.OFF();


  //////////////////////////////////////////////
  // 2. switch on
  //////////////////////////////////////////////
  error = Sigfox.ON(socket);

  // Check sending status
  if ( error == 0 )
  {
    USB.println(F("Switch ON OK"));
  }
  else
  {
    USB.println(F("Switch ON ERROR"));
  }


  //////////////////////////////////////////////
  // 3. send data
  //////////////////////////////////////////////

  USB.println(F("Sending packets..."));

  // set maximum payload
  frame.setTinyLength(11);

  boolean end = false;
  uint8_t pending_fields = 0;

  while (end == false)
  {
    pending_fields = frame.generateTinyFrame();

    USB.print(F("Tiny frame generated:"));
    USB.printHexln(frame.bufferTiny, frame.lengthTiny);

    // Send packet
    error = Sigfox.send(frame.bufferTiny, frame.lengthTiny);

    // Check TX flag
    if (error == 0)
    {
      // Send successful, exit the while loop
      USB.println(F("Sigfox transmission OK"));
    }
    else
    {
      // Error transmitting the packet
      USB.println(F("Sigfox transmission error"));
    }

    if (pending_fields > 0)
    {
      end = false;
    }
    else
    {
      end = true;
      delay(1000);
    }
  }


  //////////////////////////////////////////////
  // 4. sleep
  //////////////////////////////////////////////
  USB.println("\nEnter sleep");
  PWR.deepSleep("00:01:00:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.println("\n***************************************");
}
