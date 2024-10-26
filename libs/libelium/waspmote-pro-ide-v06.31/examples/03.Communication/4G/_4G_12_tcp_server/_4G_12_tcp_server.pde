/*
    --- 4G_12 - TCP server  ---

    Explanation: This example shows how to open a TCP listening socket
    and waits for incoming connections. After correctly connecting to a
    TCP client, sending/receiving functions are shown

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
    Design:            David Gascón
    Implementation:    Alejandro Gállego
*/

#include <Wasp4G.h>
#include <WaspFrame.h>


// APN settings
///////////////////////////////////////
char apn[] = "movistar.es";
char login[] = "movistar";
char password[] = "movistar";
///////////////////////////////////////

// SERVER settings
///////////////////////////////////////
uint16_t local_port = 5000;
uint8_t keep_alive  = 240; // From 0 (disabled) to 240 minutes
///////////////////////////////////////

// define Socket ID (from 'CONNECTION_1' to 'CONNECTION_6')
///////////////////////////////////////
uint8_t connId = Wasp4G::CONNECTION_1;
///////////////////////////////////////


// define variables
uint8_t  error;
uint32_t previous;
uint8_t  socketIndex;
boolean  tcp_server_status = false;
uint8_t  socket_state;


void setup()
{
  USB.ON();
  USB.println(F("Start program"));

  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();


  //////////////////////////////////////////////////
  // 3. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("4G module ready"));

    ////////////////////////////////////////////////
    // Enter PIN code
    ////////////////////////////////////////////////

    /*
      USB.println(F("Setting PIN code..."));
      if (_4G.enterPIN("****") == 1)
      {
      USB.println(F("PIN code accepted"));
      }
      else
      {
      USB.println(F("PIN code incorrect"));
      }
    */

  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
  }
}



void loop()
{

  ///////////////////////////////////////////////////////
  // 1. Open TCP Listen on defined port
  ///////////////////////////////////////////////////////

  error = _4G.openSocketServer(connId, Wasp4G::TCP, local_port, keep_alive);

  if (error == 0)
  {
    USB.println(F("1. Socket open"));

    USB.println(F("----------------------------"));
    USB.print(F("IP address: "));
    USB.println(_4G._ip);
    USB.print(F("Local port: "));
    USB.println(local_port);
    USB.println(F("----------------------------"));

    // update flag
    tcp_server_status = true;
  }
  else
  {
    USB.print(F("1. Error opening socket. Error code: "));
    USB.println(error, DEC);

    // update flag
    tcp_server_status = false;
  }


  ///////////////////////////////////////////////////////
  // 2. Wait for incoming connection from TCP client
  ///////////////////////////////////////////////////////

  USB.println(F("2. Wait for incoming connection (30 secs): "));

  error = _4G.manageSockets(30000);

  if (error == 0)
  {
    if (_4G.socketStatus[connId].state == Wasp4G::STATUS_SUSPENDED)
    {
      USB.println(F("Data connection in socket:"));
      USB.println(F("-------------------------------------"));
      USB.print(F("Socket ID: "));
      USB.println(_4G.socketStatus[connId].id, DEC);
      USB.print(F("Socket State: "));
      USB.println(_4G.socketStatus[connId].state, DEC);
      USB.print(F("Socket Local IP: "));
      USB.println(_4G.socketStatus[connId].localIp);
      USB.print(F("Socket Local Port: "));
      USB.println(_4G.socketStatus[connId].localPort, DEC);
      USB.print(F("Socket Remote IP: "));
      USB.println(_4G.socketStatus[connId].remoteIp);
      USB.print(F("Socket Remote Port: "));
      USB.println(_4G.socketStatus[connId].remotePort, DEC);
      USB.println(F("-------------------------------------"));

      // update flag
      tcp_server_status = true;
    }
    else
    {
      tcp_server_status = false;
      USB.print(F("3. Incorrect Socket State: "));
      USB.println(_4G.socketStatus[connId].state, DEC);      
    }
  }
  else
  {
    USB.print(F("3. No incoming data. Code: "));
    USB.println(error, DEC);

    // update flag
    tcp_server_status = false;
  }



  ///////////////////////////////////////////////////////
  // 3. Loop while connected
  ///////////////////////////////////////////////////////

  while (tcp_server_status == true)
  {
    //////////////////////////////////////////////
    // 3.1. Get socket info
    //////////////////////////////////////////////
    error = _4G.getSocketInfo(connId);

    if (error == 0)
    {
      USB.println(F("3.1. Socket Info since it was opened:"));
      USB.println(F("-------------------------------------"));
      USB.print(F("Socket ID: "));
      USB.println(_4G.socketInfo[connId].id, DEC);
      USB.print(F("Socket Sent bytes: "));
      USB.println(_4G.socketInfo[connId].sent, DEC);
      USB.print(F("Socket Received bytes: "));
      USB.println(_4G.socketInfo[connId].received, DEC);
      USB.print(F("Socket pending bytes read: "));
      USB.println(_4G.socketInfo[connId].size);
      USB.print(F("Socket bytes sent and not yet acked: "));
      USB.println(_4G.socketInfo[connId].ack, DEC);
      USB.println(F("-------------------------------------"));
    }
    else
    {
      USB.print(F("3.1. Error getting socket info. Erro code: "));
      USB.println(error, DEC);
    }


    //////////////////////////////////////////////
    // 3.2. Send data
    //////////////////////////////////////////////
    error = _4G.send(connId, "This is a message from Waspmote TCP server\n");

    if (error == 0)
    {
      USB.println(F("3.2. Data sent via TCP socket"));
    }
    else
    {
      USB.println(F("3.2. Error sending data via TCP socket"));
    }


    //////////////////////////////////////////////
    // 3.3. Receive data
    //////////////////////////////////////////////

    // Wait for incoming data from the socket (if the other side responds)
    USB.print(F("3.3. Waiting to receive data (30 secs): "));

    error = _4G.receive(connId, 30000);

    if (error == 0)
    {
      if (_4G._length > 0)
      {
        USB.println(F("\nData received:"));
        USB.println(F("====================================="));
        USB.println(_4G._buffer, _4G._length);
        USB.println(F("====================================="));
      }
      else
      {
        USB.println(F("NO data received"));
      }
    }
    else
    {
      USB.println(F("No data received."));
      USB.println(error, DEC);
    }



    //////////////////////////////////////////////
    // 3.4. Check Socket Listen status
    /////////////////////////////////////////////
    error = _4G.getSocketStatus(connId);

    if (error == 0)
    {
      // get state
      socket_state = _4G.socketStatus[connId].state;
      
      USB.print(F("3.4. Get socket status OK: "));
      USB.println(socket_state, DEC);


      // check socket status
      if (socket_state == Wasp4G::STATUS_CLOSED)
      {
        USB.println(F("SOCKET CLOSED"));

        // update flag
        tcp_server_status = false;
      }
    }
    else
    {
      USB.print(F("3.4. Error getting socket status. Error code: "));
      USB.println(error, DEC);

      // update flag
      tcp_server_status = false;
    }

    USB.println();
  }


  ///////////////////////////////////////////////////////
  // 4. Close socket
  ///////////////////////////////////////////////////////
  error = _4G.closeSocketServer(connId, Wasp4G::TCP);

  if (error == 0)
  {
    USB.println(F("4. Socket closed OK"));
  }
  else
  {
    USB.print(F("4. Error closing socket. Error code: "));
    USB.println(error, DEC);
  }

  USB.println();
}
