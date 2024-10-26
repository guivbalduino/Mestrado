/*
    ------ WIFI Example --------

    Explanation: This example shows how to perform HTTP GET requests

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
    Implementation:    Luis Miguel Martí
*/

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO_V3.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose HTTP server settings
///////////////////////////////////////
char HTTP_SERVER[] = "postman-echo.com";
char HTTP_PATH[] = "/get?foo1=bar1&foo2=bar2";
uint16_t HTTP_PORT = 80;
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;

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
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.ON(socket);

  if (error == 0)
  {
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }

  //////////////////////////////////////////////////
  // 2. Check if connected
  //////////////////////////////////////////////////


  // get actual time
  previous = millis();

  // check connectivity
  status =  WIFI_PRO_V3.isConnected();

  // check if module is connected
  if (status == true)
  {
    USB.println(F("2. WiFi is connected OK"));

    USB.print(F("IP address: "));
    USB.println(WIFI_PRO_V3._ip);

    USB.print(F("GW address: "));
    USB.println(WIFI_PRO_V3._gw);

    USB.print(F("Netmask address: "));
    USB.println(WIFI_PRO_V3._netmask);
    
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
    PWR.reboot();
  }



  //////////////////////////////////////////////////
  // 3. Configure HTTP conection
  //////////////////////////////////////////////////

  error = WIFI_PRO_V3.httpConfiguration(HTTP_SERVER, HTTP_PORT);
  if (error == 0)
  {
    USB.println(F("3. HTTP conection configured"));
  }
  else
  {
    USB.print(F("3. HTTP conection configured ERROR"));
  }

}



void loop()
{

  // check connectivity
  status =  WIFI_PRO_V3.isConnected();

  // check if module is connected
  if (status == true)
  {
    //////////////////////////////////////////////////
    // 1. Perform the HTTP GET
    //////////////////////////////////////////////////
  
    error = WIFI_PRO_V3.httpGet(HTTP_PATH);
  
    // check response
    if (error == 0)
    {
      USB.print(F("HTTP GET done!\r\nStatus: "));
      USB.println(WIFI_PRO_V3._httpResponseStatus,DEC);
    }
    else
    {
      USB.println(F("Error in HTTP GET!"));  
    }
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
  }
  delay(10000);
}

