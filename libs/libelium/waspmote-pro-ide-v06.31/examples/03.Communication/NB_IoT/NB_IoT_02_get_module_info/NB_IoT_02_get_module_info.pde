/*  
 *  ------ NB_IoT 02 - Getting module info -------- 
 *  
 *  Explanation: This example shows how to get IMSI from SIM card, IMEI 
 *  from NB-IoT module, besides than other device info fields.
 *  
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
 *  Version:           3.0
 *  Design:            David Gascón 
 *  Implementation:    P.Moreno, J.Siscart 
 */

#include <WaspBG96.h>

uint8_t error;

void setup()
{
  USB.ON();
  USB.println("Start program");

  //////////////////////////////////////////////////
  // 1. Switch on the NB-IoT module
  //////////////////////////////////////////////////
  error = BG96.ON();

  // check answer
  if (error == 0)
  {    
    USB.println(F("NB-IoT module ready\n"));
    
    ////////////////////////////////////////////////
    // 1.1. Manufacturer identification
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_MANUFACTURER_ID);
    if (error == 0)
    {
      USB.print(F("1.1. Manufacturer identification: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.1. Manufacturer identification ERROR"));
    }
 
    ////////////////////////////////////////////////
    // 1.2. Model identification
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_MODEL_ID);
    if (error == 0)
    {
      USB.print(F("1.2. Model identification: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.2. Model identification ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.3. Revision identification
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_REV_ID);
    if (error == 0)
    {
      USB.print(F("1.3. Revision identification: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.3. Revision identification ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.4. Revision identification
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_IMEI);
    if (error == 0)
    {
      USB.print(F("1.4. IMEI: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.4. IMEI ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.5. IMSI
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_IMSI);
    if (error == 0)
    {
      USB.print(F("1.5. IMSI: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.5. IMSI ERROR"));
    }

    ////////////////////////////////////////////////
    // 1.6. ICCID
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_ICCID);
    if (error == 0)
    {
      USB.print(F("1.6. ICCID: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.6. ICCID ERROR"));
    }    
  }
  else
  {
    // Problem with the communication with the NB-IoT module
    USB.println(F("NB-IoT module not started"));
  }

  //////////////////////////////////////////////////
  // 2. Switch OFF the NB-IoT module
  //////////////////////////////////////////////////
  error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("2. Module is power off"));      
    }
    else
    {
      USB.println(F("2. Power off ERROR"));
    }
  
}



void loop()
{
  // do nothing
}
