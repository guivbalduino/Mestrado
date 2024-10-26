/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up a UDP client and 
 *  send/receive information. After this step, the socket is closed
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


// choose UDP server settings
///////////////////////////////////////
char HOST[]        = "172.24.98.218";
char REMOTE_PORT[] = "3000";
char LOCAL_PORT[]  = "2000";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;
uint8_t udp_handle = 0;


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

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // check if module is connected
  if (status == true)
  {    
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

    // get IP address
    error = WIFI_PRO.getIP();

    if (error == 0)
    {
      USB.print(F("IP address: "));    
      USB.println( WIFI_PRO._ip );     
    }
    else
    {
      USB.println(F("getIP error"));     
    }
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);
  }


  //////////////////////////////////////////////////
  // 3. UDP
  //////////////////////////////////////////////////  

  // Check if module is connected
  if (status == true)
  {
    //////////////////////////////////////////////// 
    // 3.1. Open UP socket
    //////////////////////////////////////////////// 
    error = WIFI_PRO.setUDP( HOST, REMOTE_PORT, LOCAL_PORT);

    // check response
    if (error == 0)
    {
      // get UDP handle
      udp_handle = WIFI_PRO._socket_handle;
      
      USB.print(F("3.1. Open UDP socket OK in handle: "));
      USB.println(udp_handle, DEC);
    }
    else
    {
      USB.println(F("3.1. Error calling 'setUDPclient' function"));
      WIFI_PRO.printErrorCode();
      status = false;
    }


    if (status == true)
    {
      ////////////////////////////////////////////////
      // 3.2. Send data
      ////////////////////////////////////////////////
      error = WIFI_PRO.send( udp_handle, "This is a message from Waspmote!!\n");

      // check response
      if (error == 0)
      {
        USB.println(F("3.2. Send data OK"));
      }
      else
      {
        USB.println(F("3.2. Error calling 'send' function"));
        WIFI_PRO.printErrorCode();       
      }


      ////////////////////////////////////////////////
      // 3.3. Wait for answer from server
      ////////////////////////////////////////////////
      USB.print(F("3.3. Listen to UDP socket:"));  
      error = WIFI_PRO.receive(udp_handle, 30000);

      // check answer  
      if (error == 0)
      {
        USB.println(F("\n========================================"));
        USB.print(F("Data: "));  
        USB.println( WIFI_PRO._buffer, WIFI_PRO._length);

        USB.print(F("Length: "));  
        USB.println( WIFI_PRO._length,DEC);
        USB.println(F("========================================"));
      }
      else
      {
        USB.println(F("No data received"));          
      }


      ////////////////////////////////////////////////
      // 3.4. close socket
      ////////////////////////////////////////////////     
      error = WIFI_PRO.closeSocket(udp_handle);

      // check response
      if (error == 0)
      {
        USB.println(F("3.4. Close socket OK"));   
      }
      else
      {
        USB.println(F("3.4. Error calling 'closeSocket' function"));
        WIFI_PRO.printErrorCode();       
      }
    }
  }


  //////////////////////////////////////////////////
  // 4. Switch OFF
  //////////////////////////////////////////////////
  USB.println(F("WiFi switched OFF\n\n"));
  WIFI_PRO.OFF(socket);


  USB.println(F("Wait 10 seconds...\n"));
  delay(10000);

}

