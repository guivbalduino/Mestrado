/*
    ------ Sigfox Code Example --------

    Explanation: This example shows how to configure the module to work
    in the regions RC2 and RC4.    

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
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
  USB.println(F("***********************************************************"));
  USB.println(F("This code only works with:")); 
  USB.println(F("--> \"Sigfox US\" modules"));
  USB.println(F("--> \"Sigfox AU / APAC / LATAM\" modules")); 
  USB.println(F("***********************************************************"));
  USB.println();
  
  //////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////
  error = Sigfox.ON(socket);

  // Check status
  if (error == 0)
  {
    USB.println(F("1. Switch ON OK"));
  }
  else
  {
    USB.println(F("1. Switch ON ERROR"));
  }


  USB.println();
  USB.println(F("------------------------------------------------------------"));
  USB.println(F("Use this code block to:")); 
  USB.println(F("Configure \"Sigfox AU / APAC / LATAM\" module for RC4 zone")); 
  USB.println(F("------------------------------------------------------------"));

  //////////////////////////////////////////////
  // 2. Configure Sigfox RC4 zone
  //////////////////////////////////////////////
  error = Sigfox.setRegionRC4();

  // Check status
  if (error == 0)
  {
    USB.println(F("2. Set Region RC4 OK"));
  }
  else
  {
    USB.println(F("2. Set Region RC4 ERROR"));
  }

  //////////////////////////////////////////////
  // 3. Get Macro Channel Bitmask
  //////////////////////////////////////////////
  error = Sigfox.getMacroChannelBitmask();

  // Check status
  if (error == 0)
  {
    USB.print(F("3. Get Macro channel bitmask OK: "));
    USB.println(Sigfox._macroChannelBitmask);
  }
  else
  {
    USB.println(F("3. Get Macro channel bitmask: ERROR"));
  }

  //////////////////////////////////////////////
  // 4. Get Macro Channel
  //////////////////////////////////////////////
  error = Sigfox.getMacroChannel();

  // Check status
  if (error == 0)
  {
    USB.print(F("4. Get Macro channel OK: "));
    USB.println(Sigfox._macroChannel, DEC);
  }
  else
  {
    USB.println(F("4. Get Macro channel: ERROR"));
  }

  //////////////////////////////////////////////
  // 5. Get Downlink Frequency Offset
  //////////////////////////////////////////////
  error = Sigfox.getDownFreqOffset();

  // Check status
  if (error == 0)
  {
    USB.print(F("5. Get Downlink Frequency Offset: "));
    USB.println(Sigfox._downFreqOffset);
  }
  else
  {
    USB.println(F("5. Get Downlink Frequency Offset: ERROR"));
  }



  
  USB.println();
  USB.println(F("------------------------------------------------------------"));
  USB.println(F("Use this code block to:")); 
  USB.println(F("Configure \"Sigfox US\" module for RC2 zone")); 
  USB.println(F("------------------------------------------------------------"));
  
  //////////////////////////////////////////////
  // 6. Configure Sigfox RC2 zone
  //////////////////////////////////////////////
  error = Sigfox.setRegionRC2();

  // Check status
  if (error == 0)
  {
    USB.println(F("6. Set Region RC2 OK"));
  }
  else
  {
    USB.println(F("6. Set Region RC2 ERROR"));
  }
  
  //////////////////////////////////////////////
  // 7. Get Macro Channel Bitmask
  //////////////////////////////////////////////
  error = Sigfox.getMacroChannelBitmask();

  // Check status
  if (error == 0)
  {
    USB.print(F("7. Get Macro channel bitmask OK: "));
    USB.println(Sigfox._macroChannelBitmask);
  }
  else
  {
    USB.println(F("7. Get Macro channel bitmask: ERROR"));
  }

  //////////////////////////////////////////////
  // 8. Get Macro Channel
  //////////////////////////////////////////////
  error = Sigfox.getMacroChannel();

  // Check status
  if (error == 0)
  {
    USB.print(F("8. Get Macro channel OK: "));
    USB.println(Sigfox._macroChannel, DEC);
  }
  else
  {
    USB.println(F("8. Get Macro channel: ERROR"));
  }

  //////////////////////////////////////////////
  // 9. Get Downlink Frequency Offset
  //////////////////////////////////////////////
  error = Sigfox.getDownFreqOffset();

  // Check status
  if (error == 0)
  {
    USB.print(F("9. Get Downlink Frequency Offset: "));
    USB.println(Sigfox._downFreqOffset);
  }
  else
  {
    USB.println(F("9. Get Downlink Frequency Offset: ERROR"));
  }
  
  USB.println();
}



void loop()
{
  
}
