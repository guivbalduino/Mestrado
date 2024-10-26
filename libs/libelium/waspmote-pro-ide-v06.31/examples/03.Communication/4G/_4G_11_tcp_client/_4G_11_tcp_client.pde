/*
    --- 4G_11 - TCP client  ---

    Explanation: This example shows how to open a TCP client socket
    to the specified server address and port. Besides, the functions
    for sending/receiving data are used.

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
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

    Version:           3.2
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
char host[] = "test.libelium.com";
uint16_t remote_port = 80;
///////////////////////////////////////

// define Socket ID (from 'CONNECTION_1' to 'CONNECTION_6')
///////////////////////////////////////
uint8_t connId = Wasp4G::CONNECTION_1;
///////////////////////////////////////

// define data to send through TCP socket
///////////////////////////////////////
char http_format[] =
  "GET /getpost_frame_parser.php?frame=%s HTTP/1.1\r\n"\
  "Host: test.libelium.com\r\n"\
  "Content-Length: 0\r\n\r\n";
///////////////////////////////////////

// define variables
uint8_t  error;
uint32_t previous;
uint8_t  socketIndex;
char data[500];


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
}



void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // Enter PIN code
    ////////////////////////////////////////////////

    /*
      USB.println(F("Enter PIN code..."));
      if (_4G.enterPIN("****") == 1)
      {
      USB.println(F("PIN code accepted"));
      }
      else
      {
      USB.println(F("PIN code incorrect"));
      }
    */

    ////////////////////////////////////////////////
    // 2. TCP socket
    ////////////////////////////////////////////////

    error = _4G.openSocketClient(connId, Wasp4G::TCP, host, remote_port);

    if (error == 0)
    {
      USB.println(F("2.1. Opening a socket... done!"));

      USB.print(F("IP address:"));
      USB.println(_4G._ip);
 
      //////////////////////////////////////////////
      // 2.2. Create a frame and data to send via HTTP request
      //////////////////////////////////////////////

      RTC.ON();
      RTC.getTime();

      // set identifier
      frame.setID("Node01");
      // Create new frame (ASCII)
      frame.createFrame(ASCII);
      // set frame fields (Time from RTC)
      frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second);
      // show frame contents
      frame.showFrame();

      // define aux buffer
      char frame_string[frame.length*2 + 1];
      memset(frame_string, 0x00, sizeof(frame_string));

      // convert frame from bytes to ASCII representation
      Utils.hex2str((uint8_t*)frame.buffer, (char*)frame_string, frame.length);

      snprintf( data, sizeof(data), http_format, frame_string);
      USB.print(F("data to send:"));
      USB.println(data);


      //////////////////////////////////////////////
      // 2.3. Send it through the connection
      //////////////////////////////////////////////

      // send TCP packet
      error = _4G.send(connId, data);
      if (error == 0)
      {
        USB.println(F("2.3. Sending a frame... done!"));
      }
      else
      {
        USB.print(F("2.3. Error sending a frame. Code: "));
        USB.println(error, DEC);
      }


      //////////////////////////////////////////////
      // 2.4. Receive data
      //////////////////////////////////////////////

      // Wait for incoming data from the socket (if the other side responds)
      USB.print(F("2.4. Waiting to receive data..."));

      error = _4G.receive(connId, 60000);

      if (error == 0)
      {
        if (_4G.socketInfo[connId].size > 0)
        {
          USB.println(F("\n-----------------------------------"));
          USB.print(F("Data received:"));
          USB.println(_4G._buffer, _4G._length);
          USB.println(F("-----------------------------------"));
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
    }
    else
    {
      USB.print(F("2.1. Error opening socket. Error code: "));
      USB.println(error, DEC);
    }

    //////////////////////////////////////////////
    // 2.5. Close socket
    //////////////////////////////////////////////
    error = _4G.closeSocketClient(connId);

    if (error == 0)
    {
      USB.println(F("2.5. Socket closed OK"));
    }
    else
    {
      USB.print(F("2.5. Error closing socket. Error code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
  }

  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  _4G.OFF();


  ////////////////////////////////////////////////
  // 4. Sleep
  ////////////////////////////////////////////////
  USB.println(F("4. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("5. Wake up!!\n\n"));

}
