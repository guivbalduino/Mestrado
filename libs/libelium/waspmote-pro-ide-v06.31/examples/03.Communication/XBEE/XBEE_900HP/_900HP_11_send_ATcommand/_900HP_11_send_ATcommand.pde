/*  
 *  ------ [900HP_11] - send packets to a gateway -------- 
 *  
 *  Explanation: This program shows how to send AT commands to the XBee
 *  modules
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


void setup()
{
  // init USB port
  USB.ON();
  USB.println(F("Send AT commands to XBee module example"));

  // init XBee
  xbee900HP.ON();
  
  
  //////////////////////////
  // 1. Request PAN ID
  //////////////////////////  
  USB.println(F("\n1. Request PAN ID"));
  
  if(!xbee900HP.sendCommandAT("ID#")) 
  {
    USB.print(F("PANID: "));
    USB.printHex(xbee900HP.commandAT[0]);
    USB.printHex(xbee900HP.commandAT[1]);
    USB.println();
  }
  else
  {
    USB.println(F("at error"));
  }
  
  
  //////////////////////////
  // 2. Request encryption mode
  //////////////////////////  
  USB.println(F("\n2. Request encryption mode"));
  if(!xbee900HP.sendCommandAT("EE#")) 
  {
    USB.print(F("encryption mode: "));
    USB.printHex(xbee900HP.commandAT[0]);
    USB.println();
  }
  else
  {
    USB.println(F("at error"));
  }
  
}


void loop()
{
  // Do nothing
  delay(5000);
}



