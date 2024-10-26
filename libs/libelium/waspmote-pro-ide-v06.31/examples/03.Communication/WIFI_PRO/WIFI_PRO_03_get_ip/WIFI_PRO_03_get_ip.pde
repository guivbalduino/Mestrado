/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to get information once 
 *  the module is connected to the AP. The following settings are read:
 *    - IP address
 *    - GW address
 *    - Netmask address
 *    - DNS 1 address
 *    - DNS 2 address
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
uint8_t status;
unsigned long previous;




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

  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO.ON(socket);

  if( error == 0 )
  {    
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }


  //////////////////////////////////////////////////
  // 2. Join AP
  //////////////////////////////////////////////////  

  // get actual time
  previous = millis();

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  {    
    USB.print(F("WiFi is connected OK"));
    USB.print(F(" Time(ms):"));
    USB.println(millis()-previous);

    USB.println(F("-------------------------------------"));   

    ////////////////////////////////////////////////
    // 2.1. Get IP address
    ////////////////////////////////////////////////
    error = WIFI_PRO.getIP();

    if (error == 0)
    {    
      USB.print(F("IP address: "));
      USB.println(WIFI_PRO._ip);   
    }
    else
    {
      USB.println(F("getIP error"));
    }
    
    ////////////////////////////////////////////////
    // 2.2. Get GW address
    ////////////////////////////////////////////////
    error = WIFI_PRO.getGateway();

    if (error == 0)
    {    
      USB.print(F("GW address: "));    
      USB.println(WIFI_PRO._gw);
    }
    else
    {
      USB.println(F("getGateway error"));     
    }
    
    ////////////////////////////////////////////////
    // 2.3. Get Netmask address
    ////////////////////////////////////////////////
    error = WIFI_PRO.getNetmask();

    if (error == 0)
    {    
      USB.print(F("Netmask address: "));
      USB.println(WIFI_PRO._netmask);
    }
    else
    {
      USB.println(F("getNetmask error"));
    }
    
    
    ////////////////////////////////////////////////
    // 2.4. Get DNS 1
    ////////////////////////////////////////////////
    error = WIFI_PRO.getDNS(1);

    if (error == 0)
    {    
      USB.print(F("DNS 1 address: "));
      USB.println(WIFI_PRO._dns1);
    }
    else
    {
      USB.println(F("getDNS error"));
    }
    
    
    ////////////////////////////////////////////////
    // 2.5. Get DNS 2
    ////////////////////////////////////////////////
    error = WIFI_PRO.getDNS(2);

    if (error == 0)
    {    
      USB.print(F("DNS 2 address: "));
      USB.println(WIFI_PRO._dns2);
    }
    else
    {
      USB.println(F("getDNS error"));
    }
    
    
    USB.println(F("-------------------------------------"));

  }
  else
  {
    USB.print(F("WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
  }


  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  delay(5000);
}






