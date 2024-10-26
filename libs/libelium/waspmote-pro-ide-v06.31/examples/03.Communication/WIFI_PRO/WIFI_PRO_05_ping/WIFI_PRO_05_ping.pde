/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to check connectivity to the
 *  Access Point and then it performs ping connections to the host 
 *  address specified as input
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

uint8_t error;
unsigned long previous;
uint8_t status;


void setup() 
{
  USB.println(F("Start program"));  
  USB.println(F("***************************************"));  
  USB.println(F("Once the module is set with one or more"));
  USB.println(F("AP settings, it attempts to join the AP"));
  USB.println(F("automatically once it is powered on"));    
  USB.println(F("Refer to example 'WIFI_PRO_01' to configure"));  
  USB.println(F("the WiFi module with proper settings"));
  USB.println(F("***************************************"));
}



void loop()
{ 
  // get actual time
  previous = millis();


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
  // 2. Join AP
  //////////////////////////////////////////////////  

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if( status == true )
  { 
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

    for( int i=0; i<10; i++ )
    {
      // 3. ping
      error = WIFI_PRO.ping("www.google.com"); 
    
      // check response
      if( error == 0 )
      {
        USB.print(F("Round Trip Time (ms) = "));
        USB.println( WIFI_PRO._rtt, DEC );      
      }
      else
      {
        USB.println(F("Error calling 'ping' function"));
        WIFI_PRO.printErrorCode();
      }
      
      delay(1000);
    }
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
  }


  //////////////////////////////////////////////////
  // 3. Switch OFF the WiFi module
  //////////////////////////////////////////////////
  WIFI_PRO.OFF(socket);
  USB.println(F("3. WiFi switched OFF\n\n"));
  delay(10000);
}



