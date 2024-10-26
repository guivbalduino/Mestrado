/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up a TCP client connecting 
 *  to a TCP server and then shows how to send/receive information. 
 *  Finally, the socket is closed
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


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose TCP server settings
///////////////////////////////////////
char HOST[]        = "172.24.98.188";
char REMOTE_PORT[] = "12345";
char LOCAL_PORT[]  = "3000";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;
uint16_t socket_handle = 0;


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

  // check if module is connected
  if( status == true )
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
  // 3. TCP
  //////////////////////////////////////////////////  

  // Check if module is connected
  if (status == true)
  {   
    
    //////////////////////////////////////////////// 
    // 3.1. Open TCP socket
    ////////////////////////////////////////////////
    error = WIFI_PRO.setTCPclient( HOST, REMOTE_PORT, LOCAL_PORT);

    // check response
    if (error == 0)
    {
      // get socket handle (from 0 to 9)
      socket_handle = WIFI_PRO._socket_handle;
      
      USB.print(F("3.1. Open TCP socket OK in handle: "));
      USB.println(socket_handle, DEC);
    }
    else
    {
      USB.println(F("3.1. Error calling 'setTCPclient' function"));
      WIFI_PRO.printErrorCode();
      status = false;   
    }

    if (status == true)
    {   
      ////////////////////////////////////////////////
      // 3.2. send data
      ////////////////////////////////////////////////
      error = WIFI_PRO.send( socket_handle, "This is a message from Waspmote!!\n");
      
      /* BINARY SENDING
      uint8_t data[] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37};
      uint16_t size = 7
      error = WIFI_PRO.send( socket_handle, data, size);
      */

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
      USB.println(F("Listen to TCP socket:"));
      error = WIFI_PRO.receive(socket_handle, 30000);

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

      ////////////////////////////////////////////////
      // 3.4. close socket
      ////////////////////////////////////////////////
      error = WIFI_PRO.closeSocket(socket_handle);

      // check response
      if (error == 0)
      {
        USB.println(F("3.3. Close socket OK"));   
      }
      else
      {
        USB.println(F("3.3. Error calling 'closeSocket' function"));
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
