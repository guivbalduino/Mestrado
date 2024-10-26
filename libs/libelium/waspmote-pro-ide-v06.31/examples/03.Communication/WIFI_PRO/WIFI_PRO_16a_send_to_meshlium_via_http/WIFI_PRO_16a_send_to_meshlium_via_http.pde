/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to perform HTTP GET requests
 *  to the Meshlium device. A special php file parses the fields and
 *  insert them into the Meshlium's database
 *  
 *  NOTE: This example is valid for Meshlium Manager System versions
 *  prior to v4.0.9 which only supports HTTPS.
 *  
 *  Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Version:           3.1
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona 
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO.h> 
#include <WaspFrame.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose URL settings
///////////////////////////////////////
char type[] = "http";
char host[] = "10.10.10.1";
char port[] = "80";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;


// define the Waspmote ID 
char moteID[] = "node_01";


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
  
  
  // set the Waspmote ID
  frame.setID(moteID);  
}



void loop()
{ 
  // get actual time
  previous = millis();
  

  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO.ON(socket);

  if (error == 0)
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

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // check if module is connected
  if (status == true)
  {    
    USB.print(F("WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

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
    error = WIFI_PRO.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);

    // check response
    if (error == 0)
    {
      USB.println(F("HTTP OK"));          
      USB.print(F("HTTP Time from OFF state (ms):"));    
      USB.println(millis()-previous);
    }
    else
    {
      USB.println(F("Error calling 'getURL' function"));
      WIFI_PRO.printErrorCode();
    }
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
  delay(10000);
}
