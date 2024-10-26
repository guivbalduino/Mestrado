/*
    ------ WIFI Example --------

    Explanation: This example shows how to set up the module to open both 
    TCP and UDP sockets so it is able to send/receive simultaneously from
    both TCP and UDP servers

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
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
    Design:            David Gascon
    Implementation:    Yuri Carmona
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
char UDP_HOST[]  = "10.10.10.17";
char UDP_RPORT[] = "3000";
char UDP_LPORT[] = "3000";
///////////////////////////////////////

// choose TCP server settings
///////////////////////////////////////
char TCP_HOST[]  = "10.10.10.17";
char TCP_RPORT[] = "2000";
char TCP_LPORT[] = "2000";
///////////////////////////////////////

// define handle variable for several connections
uint16_t udpHandle;
uint16_t tcpHandle;

uint8_t error;
uint8_t status;
unsigned long previous;
uint32_t timeout = 20000;


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
  // get current time
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

  // Check if module is connected
  if (status == true)
  {
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);

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
    USB.println(millis() - previous);
  }


  //////////////////////////////////////////////////
  // 3. Open sockets
  //////////////////////////////////////////////////

  // Check if module is connected
  if (status == true)
  {
    ////////////////////////////////////////////////
    // 3.1. Open TCP socket
    ////////////////////////////////////////////////
    error = WIFI_PRO.setTCPclient( TCP_HOST, TCP_RPORT, TCP_LPORT);

    // check response
    if (error == 0)
    {
      // get socket handle (from 0 to 9)
      tcpHandle = WIFI_PRO._socket_handle;

      USB.print(F("3.1. Open TCP socket OK. TCP handle:"));
      USB.println(tcpHandle);
    }
    else
    {
      USB.println(F("3.1. Error calling 'setTCPclient' function"));
      WIFI_PRO.printErrorCode();
      tcpHandle = -1;
    }


    ////////////////////////////////////////////////
    // 3.2. Open UDP socket
    ////////////////////////////////////////////////
    error = WIFI_PRO.setUDP( UDP_HOST, UDP_RPORT, UDP_LPORT);

    // check response
    if (error == 0)
    {
      // get socket handle (from 0 to 9)
      udpHandle = WIFI_PRO._socket_handle;

      USB.print(F("3.2. Open UDP socket OK. UDP handle:"));
      USB.println(udpHandle);
    }
    else
    {
      USB.println(F("3.2. Error calling 'setUDPclient' function"));
      WIFI_PRO.printErrorCode();
      udpHandle = -1;
    }


    //////////////////////////////////////////////////
    // 4. Send data
    //////////////////////////////////////////////////

    ////////////////////////////////////////////////
    // 4.1. Send TCP data
    ////////////////////////////////////////////////

    if (tcpHandle != -1)
    {
      error = WIFI_PRO.send(tcpHandle, "This is a message from Waspmote via TCP socket!!\n");

      // check response
      if (error == 0)
      {
        USB.println(F("4.1. Send data OK"));
      }
      else
      {
        USB.println(F("4.1. Error calling 'send' function"));
        WIFI_PRO.printErrorCode();
      }
    }


    ////////////////////////////////////////////////
    // 4.2. Send UDP data
    ////////////////////////////////////////////////
    if (udpHandle != -1)
    {
      error = WIFI_PRO.send(udpHandle, "This is a message from Waspmote via UDP socket!!\n");

      // check response
      if (error == 0)
      {
        USB.println(F("4.2. Send data OK"));
      }
      else
      {
        USB.println(F("4.2. Error calling 'send' function"));
        WIFI_PRO.printErrorCode();
      }
    }


    ////////////////////////////////////////////////
    // 4.3. Wait for answer from TCP server
    ////////////////////////////////////////////////
    if (tcpHandle != -1)
    {
      USB.print(F("4.3. Listen to TCP socket:"));
      error = WIFI_PRO.receive(tcpHandle, 20000);

      // check answer
      if (error == 0)
      {
        USB.print(F("\nTCP Data: "));
        USB.println( WIFI_PRO._buffer, WIFI_PRO._length);

        USB.print(F("TCP Length: "));
        USB.println( WIFI_PRO._length, DEC);
      }
      else
      {
        USB.println(F("No TCP data received"));
      }
    }


    ////////////////////////////////////////////////
    // 4.4. Wait for answer from UDP server
    ////////////////////////////////////////////////
    if (udpHandle != -1)
    {
      USB.print(F("4.4. Listen to UDP socket:"));
      error = WIFI_PRO.receive(udpHandle, 20000);

      // check answer
      if (error == 0)
      {
        USB.print(F("\nUDP Data: "));
        USB.println( WIFI_PRO._buffer, WIFI_PRO._length);

        USB.print(F("UDP Length: "));
        USB.println( WIFI_PRO._length, DEC);
      }
      else
      {
        USB.println(F("No UDP data received"));
      }
    }


    ////////////////////////////////////////////////
    // 4.5. close TCP socket
    ////////////////////////////////////////////////
    if (tcpHandle != -1)
    {
      error = WIFI_PRO.closeSocket(tcpHandle);

      // check response
      if (error == 0)
      {
        USB.println(F("4.5. Close TCP socket OK"));
      }
      else
      {
        USB.println(F("4.5. Error calling 'closeSocket' function"));
        WIFI_PRO.printErrorCode();
      }
    }


    ////////////////////////////////////////////////
    // 4.6. close UDP socket
    ////////////////////////////////////////////////
    if (udpHandle != -1)
    {
      error = WIFI_PRO.closeSocket(udpHandle);

      // check response
      if (error == 0)
      {
        USB.println(F("4.6. Close UDP socket OK"));
      }
      else
      {
        USB.println(F("4.6. Error calling 'closeSocket' function"));
        WIFI_PRO.printErrorCode();
      }
    }
  }

  
  //////////////////////////////////////////////////
  // 5. Switch OFF
  //////////////////////////////////////////////////
  USB.println(F("5. WiFi switched OFF\n\n"));
  WIFI_PRO.OFF(socket);


  USB.println(F("Wait 10 seconds........\n"));
  delay(10000);

}


