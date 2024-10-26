/*
    ------ Sigfox Code Example --------

    Explanation: This example shows how to set/get different FCC parameters
    

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
    Design:            David Gascon
    Implementation:    Yuri Carmona
*/
#include <WaspSigfox.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////


uint8_t error;


void setup()
{
  USB.ON();
  USB.println();
  USB.println(F("**********************************************"));
  USB.println(F("| This code only works with Sigfox900 module |")); 
  USB.println(F("**********************************************"));
  //////////////////////////////////////////////
  // switch on
  //////////////////////////////////////////////
  error = Sigfox.ON(socket);

  // Check status
  if (error == 0)
  {
    USB.println(F("Switch ON OK"));
  }
  else
  {
    USB.println(F("Switch ON ERROR"));
  }

  USB.println();
}



void loop()
{
  //////////////////////////////////////////////
  // show Region
  //////////////////////////////////////////////
  error = Sigfox.getRegion();

  // Check status
  if (error == 0)
  {
    USB.print(F("Get region OK: "));

    switch (Sigfox._region)
    {
      case SIGFOX_REGION_ETSI:    USB.println("ETSI region");    break;
      case SIGFOX_REGION_FCC:     USB.println("FCC region");     break;
      case SIGFOX_REGION_ARIB:    USB.println("ARIB region");    break;
      case SIGFOX_REGION_UNKNOWN:
      default:                    USB.println("Unknown region"); break;
    }
  }
  else
  {
    USB.println(F("Get region: ERROR"));
  }


  //////////////////////////////////////////////
  // set Macro Channel Bitmask
  //////////////////////////////////////////////
  error = Sigfox.setMacroChannelBitmask("000001FF0000000000000000");

  // Check status
  if (error == 0)
  {
    USB.println(F("Set Macro channel bitmask OK"));
  }
  else
  {
    USB.println(F("Set Macro channel bitmask: ERROR"));
  }

  //////////////////////////////////////////////
  // get Macro Channel Bitmask
  //////////////////////////////////////////////
  error = Sigfox.getMacroChannelBitmask();

  // Check status
  if (error == 0)
  {
    USB.print(F("Get Macro channel bitmask OK: "));
    USB.println(Sigfox._macroChannelBitmask);
  }
  else
  {
    USB.println(F("Get Macro channel bitmask: ERROR"));
  }


  //////////////////////////////////////////////
  // set Macro Channel 
  //////////////////////////////////////////////
  error = Sigfox.setMacroChannel(1);

  // Check status
  if (error == 0)
  {
    USB.println(F("Set Macro channel OK"));
  }
  else
  {
    USB.println(F("Set Macro channel: ERROR"));
  }

  //////////////////////////////////////////////
  // get Macro Channel
  //////////////////////////////////////////////
  error = Sigfox.getMacroChannel();

  // Check status
  if (error == 0)
  {
    USB.print(F("Get Macro channel OK: "));
    USB.println(Sigfox._macroChannel, DEC);
  }
  else
  {
    USB.println(F("Get Macro channel: ERROR"));
  }

  
  //////////////////////////////////////////////
  // set Downlink Frequency Offset
  //////////////////////////////////////////////
  error = Sigfox.setDownFreqOffset(3000000);

  // Check status
  if (error == 0)
  {
    USB.println(F("Set Downlink Frequency Offset OK"));
  }
  else
  {
    USB.println(F("Set Downlink Frequency Offset: ERROR"));
  }

  
  //////////////////////////////////////////////
  // get Downlink Frequency Offset
  //////////////////////////////////////////////
  error = Sigfox.getDownFreqOffset();

  // Check status
  if (error == 0)
  {
    USB.print(F("Get Downlink Frequency Offset: "));
    USB.println(Sigfox._downFreqOffset);
  }
  else
  {
    USB.println(F("Get Downlink Frequency Offset: ERROR"));
  }



  USB.println(F("-------------------------------"));

  delay(5000);
}