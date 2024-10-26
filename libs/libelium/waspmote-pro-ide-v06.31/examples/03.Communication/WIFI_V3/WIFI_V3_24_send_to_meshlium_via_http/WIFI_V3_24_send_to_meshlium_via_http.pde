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
#include <WaspFrame.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose HTTP server settings
///////////////////////////////////////
char type[] = "http";
char host[] = "10.10.10.1";
uint16_t port = 80;
///////////////////////////////////////

uint8_t error;
uint8_t status;

// define the Waspmote ID 
char moteID[] = "node_01";

void setup()
{
  USB.println(F("Start program"));

  USB.println(F("***************************************"));
  USB.println(F("It is assumed the module was previously"));
  USB.println(F("configured in autoconnect mode and with"));
  USB.println(F("the Meshlium AP settings."));
  USB.println(F("Once the module is configured with the"));
  USB.println(F("AP settings, it attempts to join the AP"));
  USB.println(F("automatically once it is powered on"));
  USB.println(F("Refer to example 'WIFI_02' to configure"));
  USB.println(F("the WiFi module with proper settings"));
  USB.println(F("***************************************"));

  // set the Waspmote ID
  frame.setID(moteID);  
}



void loop()
{
  
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO_V3.ON(socket);

  if (error == 0)
  {    
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }

  // check connectivity
  status =  WIFI_PRO_V3.isConnected();

  // check if module is connected
  if (status == true)
  {
    ///////////////////////////////
    // 3.1. Create a new Frame 
    ///////////////////////////////
    
    // create new frame (only ASCII)
    frame.createFrame(ASCII); 

    // add sensor fields
    frame.addSensor(SENSOR_STR, "this_is_a_string");
    frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

    // print frame
    frame.showFrame();  


    ///////////////////////////////
    // 3.2. Send Frame to Meshlium
    ///////////////////////////////

    // http frame
    error = WIFI_PRO_V3.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);

    // check response
    if (error == 0)
    {
      USB.println(F("Send frame to meshlium done"));
    }
    else
    {
      USB.println(F("Error sending frame"));
      if (WIFI_PRO_V3._httpResponseStatus)
      {
        USB.print(F("HTTP response status: "));  
        USB.println(WIFI_PRO_V3._httpResponseStatus);  
      }
    }
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
  }
  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO_V3.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  delay(10000);
}

