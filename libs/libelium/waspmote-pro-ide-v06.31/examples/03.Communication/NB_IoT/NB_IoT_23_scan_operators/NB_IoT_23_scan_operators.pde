/*
    --------------- NB_IoT_23 - Scan operators  ---------------

    Explanation: This example shows how to scan network operators.

    *  Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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
    *  Implementation:    P.Moreno, J.Siscart
    */

#include <WaspBG96.h>

uint8_t error;
uint32_t previous;

void setup()
{
  //////////////////////////////////////////////////
  // 1. Switch on the BG96 module
  //////////////////////////////////////////////////
  previous = millis();
  USB.println("BG96 Module ON...");
  error = BG96.ON();
  if (error == 0)
  {
    USB.print(F("1. BG96 module ready in "));
    USB.print(millis()-previous);
    USB.println(F(" ms"));
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. BG96 module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }


    ////////////////////////////////////////////////
    // 1.1. Hardware identification
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_HW);
    if (error == 0)
    {
      USB.print(F("1.1. Hardware identification: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.1. Manufacturer identification ERROR"));
    }

    ////////////////////////////////////////////////
    // 2.1. User manual AT command
    // sendCommand("<AT command>","<Module response_1>","<Module response_2>",timeout)
    // AT command: AT command sent to the module.
    // Module response: Response to the AT command sent it. Typical response is OK.
    // Module response_2: ERROR Response. Typical response is ERROR.
    // timeout: Time period to wait a module response.
    ////////////////////////////////////////////////    
    error = BG96.sendCommand("AT+CFUN=0\r", "OK", 2000);
    if (error != 1)
    {
      if (error == 2)
      {
        USB.println(F("2.1. AT command ERROR:"));
        USB.println(BG96._buffer, BG96._length);
      }
      if (error == 0)
      {
        USB.println(F("2.1. AT command Timeout:"));        
      }      
    }
    else
    {
      USB.println(F("2.1. SendCommand OK. Module answer: "));
      USB.println(BG96._buffer, BG96._length);
    }

    ////////////////////////////////////////////////
    // 2.2. User manual AT command
    // sendCommand("<AT command>","<Module response_1>","<Module response_2>",timeout)
    // AT command: AT command sent to the module.
    // Module response: Response to the AT command sent it. Typical response is OK.
    // Module response_2: ERROR Response. Typical response is ERROR.
    // timeout: Time period to wait a module response.
    ////////////////////////////////////////////////    
    error = BG96.sendCommand("AT+QCFG=\"nwscanseq\",00,1\r", "OK", 2000);
    if (error != 1)
    {
      if (error == 2)
      {
        USB.println(F("2.2. AT command ERROR:"));
        USB.println(BG96._buffer, BG96._length);
      }
      if (error == 0)
      {
        USB.println(F("2.2. AT command Timeout:"));        
      }      
    }
    else
    {
      USB.println(F("2.2. SendCommand OK. Module answer: "));
      USB.println(BG96._buffer, BG96._length);
    }

    ////////////////////////////////////////////////
    // 2.3. User manual AT command
    // sendCommand("<AT command>","<Module response_1>","<Module response_2>",timeout)
    // AT command: AT command sent to the module.
    // Module response: Response to the AT command sent it. Typical response is OK.
    // Module response_2: ERROR Response. Typical response is ERROR.
    // timeout: Time period to wait a module response.
    ////////////////////////////////////////////////    
    error = BG96.sendCommand("AT+QCFG=\"nwscanmode\",0,1\r", "OK", 2000);
    if (error != 1)
    {
      if (error == 2)
      {
        USB.println(F("2.3. AT command ERROR:"));
        USB.println(BG96._buffer, BG96._length);
      }
      if (error == 0)
      {
        USB.println(F("2.3. AT command Timeout:"));        
      }      
    }
    else
    {
      USB.println(F("2.3. SendCommand OK. Module answer: "));
      USB.println(BG96._buffer, BG96._length);
    }

    ////////////////////////////////////////////////
    // 2.4. User manual AT command
    // sendCommand("<AT command>","<Module response_1>","<Module response_2>",timeout)
    // AT command: AT command sent to the module.
    // Module response: Response to the AT command sent it. Typical response is OK.
    // Module response_2: ERROR Response. Typical response is ERROR.
    // timeout: Time period to wait a module response.
    ////////////////////////////////////////////////    
    error = BG96.sendCommand("AT+QCFG=\"iotopmode\",2,1\r", "OK", 2000);
    if (error != 1)
    {
      if (error == 2)
      {
        USB.println(F("2.4. AT command ERROR:"));
        USB.println(BG96._buffer, BG96._length);
      }
      if (error == 0)
      {
        USB.println(F("2.4. AT command Timeout:"));        
      }      
    }
    else
    {
      USB.println(F("2.4. SendCommand OK. Module answer: "));
      USB.println(BG96._buffer, BG96._length);
    }

    ////////////////////////////////////////////////
    // 2.5. User manual AT command
    // sendCommand("<AT command>","<Module response_1>","<Module response_2>",timeout)
    // AT command: AT command sent to the module.
    // Module response: Response to the AT command sent it. Typical response is OK.
    // Module response_2: ERROR Response. Typical response is ERROR.
    // timeout: Time period to wait a module response.
    ////////////////////////////////////////////////    
    error = BG96.sendCommand("AT+CFUN=1\r", "OK", 2000);
    if (error != 1)
    {
      if (error == 2)
      {
        USB.println(F("2.5. AT command ERROR:"));
        USB.println(BG96._buffer, BG96._length);
      }
      if (error == 0)
      {
        USB.println(F("2.5. AT command Timeout:"));        
      }      
    }
    else
    {
      USB.println(F("2.5. SendCommand OK. Module answer: "));
      USB.println(BG96._buffer, BG96._length);
    }

    //Waitting a little bit
    delay(5000);

    ////////////////////////////////////////////////
    // 2. Scan operators network
    ////////////////////////////////////////////////
    error = BG96.scanOperators();
    if (error == 0)
    {
      USB.print(F("2. Operators List: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("2. Scan ERROR"));
    }

    ////////////////////////////////////////////////
    // 3. Scan operators network
    ////////////////////////////////////////////////
    error = BG96.OFF();
    if (error == 0)
    {
      USB.print(F("3. Module is power off"));
      //USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("3. Power off ERROR"));
    }

}


void loop()
{
  // put your main code here, to run repeatedly:

}
