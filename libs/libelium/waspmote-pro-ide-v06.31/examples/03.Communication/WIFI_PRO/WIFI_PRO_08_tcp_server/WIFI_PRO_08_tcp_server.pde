/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up a TCP server indicating
 *  the local port and the number of clients that can connect to it.
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


// choose TCP server settings
///////////////////////////////////////
char LOCAL_PORT[]= "2000";
uint8_t NUM_CLIENTS = 3; //(from 1 to 10)
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


  //////////////////////////////////////////////////
  // 1. Switch ON
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
  // 2. Check if connected
  //////////////////////////////////////////////////  

  // get actual time
  previous = millis();

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  {    
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);


    USB.print(F("3. IP address:"));
    USB.println(WIFI_PRO._ip);
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
    PWR.reboot();
  }


  //////////////////////////////////////////////////
  // 3. Open TCP server
  //////////////////////////////////////////////////  

  // Check if module is connected
  if (status == true)
  {   
    // 3.1. Open FTP session
    error = WIFI_PRO.setTCPserver( LOCAL_PORT, NUM_CLIENTS );

    // check response
    if (error == 0)
    {
      USB.println(F("3.1. Open TCP server OK"));   
    }
    else
    {
      USB.println(F("3.1. Error calling 'setTCPserver' function"));
      WIFI_PRO.printErrorCode();   
    } 
  }

  USB.println(F("-----------------------------------"));
  USB.println(F("Listening for incoming connections:"));
  USB.println(F("-----------------------------------"));

}



void loop()
{ 

  //////////////////////////////////////////////////
  // 1. Update info from active sockets
  //////////////////////////////////////////////////

  error = WIFI_PRO.getAllSocketStatus();

  // check response
  if (error != 0)
  {
    USB.println(F("1.1. Error calling 'getClientStatus' function"));
    WIFI_PRO.printErrorCode();
  }


  //////////////////////////////////
  // 2. Receive data
  //////////////////////////////////

  // check on total number of available client socket
  for (int i=0; i<NUM_CLIENTS; i++)
  {
    // check socket status (0: open)
    if (WIFI_PRO.socket[i].status == 0)
    {
      // check socket incoming buffer
      if (WIFI_PRO.socket[i].size > 0)
      {
        error = WIFI_PRO.receive(WIFI_PRO.socket[i].handle);

        // check answer  
        if (error == 0)
        {          
          USB.print(F("Socket handle:"));
          USB.println(WIFI_PRO.socket[i].handle);

          USB.print(F("Client IP:"));
          USB.println(WIFI_PRO.socket[i].ip);

          USB.print(F("Client port:"));
          USB.println(WIFI_PRO.socket[i].port);

          USB.print(F("Incoming Data: "));
          USB.println(WIFI_PRO._buffer, WIFI_PRO._length);

          USB.print(F("Length: "));  
          USB.println(WIFI_PRO._length,DEC);          
        }

        // send packet to client
        error = WIFI_PRO.send(WIFI_PRO.socket[i].handle, "Send confirmation");

        // check answer  
        if (error == 0)
        {  
          USB.println(F("Send ok"));
        }
        else
        {
          USB.println(F("Send error"));
        }

        USB.println(F("-----------------------------------"));
      }
    }
  }



  //////////////////////////////////
  // 4. Close DOWN sockets
  //////////////////////////////////
  error = WIFI_PRO.closeDownSockets();

  // check response
  if (error != 0)
  {
    USB.println(F("4. Error calling 'closeDownSockets' function"));
    WIFI_PRO.printErrorCode();
  }

}

