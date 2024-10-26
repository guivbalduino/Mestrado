/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up the TX power
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
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO.h>

// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// define power level (from 0 to 14)
///////////////////////////////////////
uint8_t power = 14;
///////////////////////////////////////

uint8_t error;
unsigned long previous;
uint8_t status;


void setup() 
{
  USB.println(F("Start program"));  


  //////////////////////////////////////////////////
  // 1. Switch ON the WiFi module
  //////////////////////////////////////////////////
  error = WIFI_PRO.ON(socket);

  if( error == 0 )
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }
     
  
  //////////////////////////////////////////////////
  // 2. Set TX Power Level
  //////////////////////////////////////////////////
  error = WIFI_PRO.setPower(power);

  if( error == 0 )
  {    
    USB.println(F("2. TX power level set OK"));
  }
  else
  {
    USB.println(F("2. Error when calling 'setPower'"));
  }  
  
  
  //////////////////////////////////////////////////
  // 3. Set TX Power Level
  //////////////////////////////////////////////////
  error = WIFI_PRO.getPower();

  if( error == 0 )
  {    
    USB.print(F("3. Get TX power level: "));
    USB.println(WIFI_PRO._power, DEC);
  }
  else
  {
    USB.println(F("3. Error when calling 'getPower'"));
  }  
}



void loop()
{ 
  // do nothing
}



