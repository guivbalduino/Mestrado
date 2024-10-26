/*
    ------ WIFI Example --------

    Explanation: This example shows how to set up a TCP server indicating
    the local port.

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


// choose TCP server settings
///////////////////////////////////////
uint16_t LOCAL_PORT = 12345;
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
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
    PWR.reboot();
  }



  //////////////////////////////////////////////////
  // 3. Open TCP server
  //////////////////////////////////////////////////
  USB.println(F("3.1. Closing all sockets"));
  WIFI_PRO_V3.udpCloseAllSockets();
  
  // 3.1. Open FTP session
  error = WIFI_PRO_V3.udpSetServer(LOCAL_PORT);

  // check response
  if (error == 0)
  {
    USB.println(F("3. Set UDP server OK"));
  }
  else
  {
    USB.print(F("3. Error calling 'udpSetServer' function. Error: "));
    USB.println(error, DEC);
  }

  USB.println(F("-----------------------------------"));
  USB.println(F("Listening for incoming connections:"));
  USB.println(F("-----------------------------------"));

}



void loop()
{

  ////////////////////////////////////////////////
  // 1. Wait for answer from server
  ////////////////////////////////////////////////
  // Keep in mind that turning off the module
  // will close the UDP connection. If you 
  // intend to make the platform sleep, you 
  // should configure the UDP connection
  // again after the platform wakes up or use 
  // the power option to power the module in 
  // SOCKET0
  ////////////////////////////////////////////////
  USB.println(F("Listen to TCP socket:"));
  error = WIFI_PRO_V3.udpReceive(WIFI_PRO_V3._udpClientSessionId, 15000);

  // check answer
  if (error == 0)
  {
    USB.print(F("Data received from client: "));
    USB.print( WIFI_PRO_V3._udpClientIp);
    
    USB.println(F("\n========================================"));
    USB.print(F("Data: "));
    USB.println( WIFI_PRO_V3._buffer, WIFI_PRO_V3._length);

    USB.print(F("Length: "));
    USB.println( WIFI_PRO_V3._length, DEC);
    USB.println(F("========================================"));
    
    error = WIFI_PRO_V3.udpSend(WIFI_PRO_V3._udpSessionId, WIFI_PRO_V3._udpClientIp, WIFI_PRO_V3._udpClientPort, "This is a message from Waspmote!!\n");
      
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
  }
  else
  {
    USB.println("No data received");
  }

}

