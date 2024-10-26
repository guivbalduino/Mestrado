/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up a TCP client connecting 
 *  to a TCP server and then shows how to send/receive information. 
 *  Finally, the socket is closed
 *  
 *  Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Implementation:    Yuri Carmona
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO_V3.h> 


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose TCP server settings
///////////////////////////////////////
char HOST[]        = "192.168.131.182";
uint16_t REMOTE_PORT = 12345;
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;
uint16_t tcp_session = 0;


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
}



void loop()
{ 
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO_V3.ON(socket);

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
    error = WIFI_PRO_V3.tcpSetClient(HOST, REMOTE_PORT);

    // check response
    if (error == 0)
    {
      // get socket handle (from 0 to 9)
      tcp_session = WIFI_PRO_V3._tcpSessionId;
      
      USB.print(F("3.1. Open TCP socket OK in handle: "));
      USB.println(tcp_session, DEC);
    }
    else
    {
      USB.println(F("3.1. Error calling 'setTCPclient' function"));
      status = false;   
    }

    if (status == true)
    {   
      ////////////////////////////////////////////////
      // 3.2. send data
      ////////////////////////////////////////////////
      error = WIFI_PRO_V3.tcpSend(tcp_session, "This is a message from Waspmote!!\n");
      
      /* BINARY SENDING
      uint8_t data[] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37};
      uint16_t size = 7
      error = WIFI_v3.send( socket_handle, data, size);
      */

      // check response
      if (error == 0)
      {
        USB.println(F("3.2. Send data OK"));   
      }
      else
      {
        USB.println(F("3.2. Error calling 'send' function"));
      }

      ////////////////////////////////////////////////
      // 3.3. Wait for answer from server
      ////////////////////////////////////////////////
      USB.println(F("Listen to TCP socket:"));
      error = WIFI_PRO_V3.tcpReceive(tcp_session, 15000);

      // check answer  
      if (error == 0)
      {
        USB.println(F("\n========================================"));
        USB.print(F("Data: "));  
        USB.println( WIFI_PRO_V3._buffer, WIFI_PRO_V3._length);

        USB.print(F("Length: "));  
        USB.println( WIFI_PRO_V3._length,DEC);
        USB.println(F("========================================"));
      }
      else
      {
        USB.println("No data received");
      }

      ////////////////////////////////////////////////
      // 3.4. close socket
      ////////////////////////////////////////////////
      error = WIFI_PRO_V3.tcpClose(tcp_session);

      // check response
      if (error == 0)
      {
        USB.println(F("3.3. Close socket OK"));   
      }
      else
      {
        USB.print(F("3.3. Error calling 'tcpClose' function. Error: "));
        USB.println(error, DEC);
      }
    }
  }


  //////////////////////////////////////////////////
  // 4. Switch OFF
  //////////////////////////////////////////////////  
  USB.println(F("WiFi switched OFF\n\n")); 
  WIFI_PRO_V3.OFF(socket);


  USB.println(F("Wait 10 seconds...\n")); 
  delay(10000);

}
