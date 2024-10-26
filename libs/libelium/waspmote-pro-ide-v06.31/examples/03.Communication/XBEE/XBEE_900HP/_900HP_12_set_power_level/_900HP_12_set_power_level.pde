/*  
 *  ------ [900HP_12] - set Power Level -------- 
 *  
 *  Explanation: This program shows how to set the power level
 *  of the XBee module. Possible values:
 *    PL = 0 --> +7 dBm, (5 mW)
 *    PL = 1 --> +15 dBm, (32 mW)
 *    PL = 2 --> +18 dBm, (63 mW)
 *    PL = 3 --> +21 dBm, (125 mW)
 *    PL = 4 --> +24 dBm, (250 mW) 
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
 *  Implementation:    Yuri Carmona
 */

#include <WaspXBee900HP.h>


// Define the Power Level to be set
uint8_t  powerLevel = 4; 

 
void setup()
{
  // init USB 
  USB.ON();
  
  // init XBee
  xbee900HP.ON();             

  USB.println(F("Set Power Level example\n"));
  
  USB.println(F("XBee 900HP Power Level values:"));
  USB.println(F("-------------------------------"));
  USB.println(F("PL = 0 --> +7 dBm, (5 mW)"));
  USB.println(F("PL = 1 --> +15 dBm, (32 mW)"));
  USB.println(F("PL = 2 --> +18 dBm, (63 mW)"));
  USB.println(F("PL = 3 --> +21 dBm, (125 mW)"));
  USB.println(F("PL = 4 --> +24 dBm, (250 mW) [default]"));   
  USB.println(F("-------------------------------"));
  
  ////////////////////////////////////////////// 
  // 1. Set Power Level
  //////////////////////////////////////////////
  xbee900HP.setPowerLevel( powerLevel);
  
  // check at commmand execution flag
  if( xbee900HP.error_AT == 0 ) 
  {
    USB.print(F("1. Set Power Level to: 0x"));
    USB.printHex( xbee900HP.powerLevel );
    USB.println();
  }
  else 
  {
    USB.println(F("1. Error calling 'setPowerLevel()'"));
  }
  
 
  
  ////////////////////////////////////////////// 
  // 2. Get Power Level
  //////////////////////////////////////////////
 
  xbee900HP.getPowerLevel();
  
  // check at commmand execution flag
  if( xbee900HP.error_AT == 0 ) 
  {
    USB.print(F("2. Get Power Level to: 0x"));
    USB.printHex( xbee900HP.powerLevel );
    USB.println();
  }
  else 
  {
    USB.println(F("2 Error calling 'getPowerLevel()'"));
  }
  
 
 
  /////////////////////////////////////
  // 3. write values to XBee module memory
  /////////////////////////////////////
  xbee900HP.writeValues();
  
  // check the AT commmand execution flag  
  if( xbee900HP.error_AT == 0 ) 
  {
    USB.println(F("3. Changes stored OK"));
  }
  else 
  {
    USB.println(F("3. Error calling 'writeValues()'"));  
  }

  USB.println(F("-------------------------------"));
  
}



void loop()
{

    // Do nothing

}

