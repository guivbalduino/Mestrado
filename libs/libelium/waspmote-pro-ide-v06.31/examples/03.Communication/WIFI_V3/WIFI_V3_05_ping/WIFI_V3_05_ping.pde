/*
    ------ WIFI Example --------

    Explanation: This example shows how to check connectivity to the
    Access Point and then it performs ping connections to the host
    address specified as input

    Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Yuri Carmona
*/

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO_V3.h>

// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// IP address
///////////////////////////////////////
char ip_address[] = "142.250.74.3";
///////////////////////////////////////

uint8_t error;
uint8_t status;


void setup()
{
  USB.println(F("Start program"));  
  USB.println(F("***************************************"));  
  USB.println(F("It is assumed the module was previously"));
  USB.println(F("configured in autoconnect mode."));
  USB.println(F("Once the module is configured with the"));
  USB.println(F("AP settings, it attempts to join the AP"));
  USB.println(F("automatically once it is powered on"));    
  USB.println(F("Refer to example 'WIFI_02' to configure"));  
  USB.println(F("the WiFi module with proper settings"));
  USB.println(F("***************************************"));

  //////////////////////////////////////////////////
  // 1. Switch ON the WiFi module
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.ON(socket);

  if ( error == 0 )
  {
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }

  USB.println();

}



void loop()
{
  // Check if module is connected
  if (WIFI_PRO_V3.isConnected() == true)
  {
    USB.println(F("WiFi is connected OK"));

    // ping
    error = WIFI_PRO_V3.ping(ip_address);

    // check response
    if (error == 0)
    {
      USB.print(F("Ping sent packets = "));
      USB.println(WIFI_PRO_V3._pingSent);
      USB.print(F("Ping Received packets = "));
      USB.println(WIFI_PRO_V3._pingReceived);
      USB.print(F("Ping Lost packets = "));
      USB.println(WIFI_PRO_V3._pingLost);
      USB.print(F("Ping Total Time (ms) = "));
      USB.println(WIFI_PRO_V3._pingTime);
      USB.print(F("Ping Minimum Time (ms) = "));
      USB.println(WIFI_PRO_V3._pingMinTime);
      USB.print(F("Ping Maximum Time (ms) = "));
      USB.println(WIFI_PRO_V3._pingMaxTime);
    }
    else
    {
      USB.println(F("Error calling 'ping' function"));
    }
  }
  else
  {
    USB.println(F("WiFi is NOT connected"));
  }


  //////////////////////////////////////////////////
  // 2. Delay
  //////////////////////////////////////////////////
  delay(10000);
  USB.println();
}
