/*
    --------------- 4G_05 - Receiving SMS  ---------------

    Explanation: This example shows how to set up the module to use
    SMS and receive text messages. After reading a new incoming SMS, 
    this text message is deleted from memory.

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

    Version:           3.0
    Design:            David Gascón
    Implementation:    Alejandro Gállego
*/

#include <Wasp4G.h>

// define variables
uint8_t error;
uint8_t status;
uint8_t index;


void setup()
{
  USB.ON();
  USB.println(F("Start program"));


  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));


    ////////////////////////////////////////////////
    // Enter PIN code
    ////////////////////////////////////////////////

    /*
      USB.println(F("Setting PIN code..."));
      if (_4G.enterPIN("****") == 1)
      {
      USB.println(F("PIN code accepted"));
      }
      else
      {
      USB.println(F("PIN code incorrect"));
      }
    */

    ////////////////////////////////////////////////
    // 2. Configure SMS options
    ////////////////////////////////////////////////
    error = _4G.configureSMS();

    if (error == 0)
    {
      USB.println(F("2. 4G module configured to use SMS"));
    }
    else
    {
      USB.print(F("2. Error calling 'configureSMS' function. Code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }
}



void loop()
{
  //////////////////////////////////////////////
  // 1. Wait for new incoming SMS
  //////////////////////////////////////////////
  error = _4G.readNewSMS(30000);

  if (error == 0)
  {
    USB.println(F("-----------------------------------"));
    USB.print(F("SMS index: "));
    USB.println(_4G._smsIndex, DEC);

    USB.print(F("SMS Status: "));
    USB.println(_4G._smsStatus);

    USB.print(F("Phone number: "));
    USB.println(_4G._smsNumber);

    USB.print(F("SMS date: "));
    USB.println(_4G._smsDate);

    USB.print(F("SMS time: "));
    USB.println(_4G._smsTime);

    USB.print(F("SMS body: "));
    USB.println(_4G._buffer, _4G._length);
    USB.println(F("-----------------------------------"));
  }
  else
  {
    USB.print(F("No incoming SMS. Code: "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 2. Read all existing SMS
  //////////////////////////////////////////////

  // init variables
  status = 0;
  index = 1;

  while (status == 0)
  {
    // Read incoming SMS
    status = _4G.readSMS(index);

    if (status == 0)
    {
      USB.println(F("--- READ SMS ---"));

      USB.print(F("SMS index: "));
      USB.println(_4G._smsIndex, DEC);

      USB.print(F("SMS body: "));
      USB.println(_4G._buffer, _4G._length);

      USB.print(F("SMS Status: "));
      USB.println(_4G._smsStatus);

      USB.print(F("Phone number: "));
      USB.println(_4G._smsNumber);

      USB.print(F("SMS date: "));
      USB.println(_4G._smsDate);

      USB.print(F("SMS time: "));
      USB.println(_4G._smsTime);
      USB.println(F("-------------------------------"));

    }
    else
    {
      USB.print(F("No more SMS. Code: "));
      USB.println(error, DEC);
    }

    // increase index to access the next SMS
    index++;
  }



  //////////////////////////////////////////////
  // 3. Delete all existing SMS
  //////////////////////////////////////////////

  // set index to delete to first possible message
  index = 1;
  
  error = _4G.deleteSMS(index, Wasp4G::SMS_DELETE_ALL_1);

  if (error == 0)
  {
    USB.println(F("Delete SMSs done"));
  }
  else
  {
    USB.print(F("Error calling 'deleteSMS' function. Code:"));
    USB.println(error, DEC);
  }

  USB.println(F("************************************************************"));

}

