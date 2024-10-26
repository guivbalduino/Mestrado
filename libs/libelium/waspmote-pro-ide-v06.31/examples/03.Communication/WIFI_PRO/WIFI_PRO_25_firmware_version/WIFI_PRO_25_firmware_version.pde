/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how request the firmware version
 *  
 *  Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Design:            David Gascon 
 *  Implementation:    Luis Miguel Martí
 */


#include <WaspWIFI_PRO.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// define variables
uint8_t error;

void setup() 
{
  USB.println(F("Start program"));  


  //////////////////////////////////////////////////
  // 1. Switch ON the WiFi module
  //////////////////////////////////////////////////
  error = WIFI_PRO.ON(socket);

  if (error == 0)
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }


  //////////////////////////////////////////////////
  // 2. Get firmware version
  //////////////////////////////////////////////////
  error = WIFI_PRO.getFirmwareVersion();

  if (error == 0)
  {    
    USB.print("2. Firmware version: ");
    USB.println(WIFI_PRO._firmwareVersion);
  }
  else
  {
    USB.println(F("2. WiFi get version ERROR"));
  }
}



void loop()
{ 
 
}


