/*
 *  ------ NB_IoT 11 - TCP client --------
 *
 *  Explanation: This example shows how to open a TCP client socket
 *  to the specified server address and port. Besides, the functions
 *  for sending/receiving data are used.
 *
 *  Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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
 *  Design:            David Gascón
 *  Implementation:    P.Moreno, J.Siscart
 */

#include <WaspBG96.h>
#include <WaspFrame.h>

uint8_t error;
uint32_t previous;
char data[500];

// APN settings
char apn[] = "";
char login[] = "";
char password[] = "";
///////////////////////////////////////
// Operator selection
///////////////////////////////////////
char network_operator[] = "";
///////////////////////////////////////
// <Operator_type> options: 
// LALPHANUMERIC_OPERATOR	Long format alphanumeric <network_operator> which can be up to 16 characters long.
// SALPHANUMERIC_OPERATOR	Short format alphanumeric <network_operator>.
// NUMERIC_OPERATOR			Numeric <network_operator>. GSM location area identification number.
///////////////////////////////////////
uint8_t operator_type = LALPHANUMERIC_OPERATOR;
///////////////////////////////////////
// Band configuration
///////////////////////////////////////
// NB-IoT & LTE-M1 bands:
// B1			
// B2			
// B3			
// B4			
// B5			
// B8			
// B12			
// B13			
// B18			
// B19			
// B20			
// B26			
// B28			
// B39			
// ------------------------------------
// GSM bands:
// GSM900 		
// GSM1800		
// GSM850		
// GSM1900		
// GSM_ANYBAND	
// NB_ANYBAND	
// M1_ANYBAND	
/////////////////////////////////////
char band[] = B20;
/////////////////////////////////////
// SERVER settings
///////////////////////////////////////
char host[] = "test.libelium.com";
uint16_t remote_port = 80;
///////////////////////////////////////
// define data to send through TCP socket
///////////////////////////////////////
char http_format[] =
  "GET /getpost_frame_parser.php?frame=%s HTTP/1.1\r\n"\
  "Host: test.libelium.com\r\n"\
  "Content-Length: 0\r\n\r\n";
///////////////////////////////////////
// define Socket ID (from 'CONNECTION_1' to 'CONNECTION_6')
///////////////////////////////////////
uint8_t connId = WaspBG96::CONNECTION_1;
///////////////////////////////////////


void setup()
{
  USB.ON();
  USB.println(F("Start program\n"));

  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  BG96.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  BG96.show_APN();
}


void loop()
{

  //////////////////////////////////////////////
  // 1. Create a frame and data to send via HTTP request
  //////////////////////////////////////////////

  RTC.ON();
  RTC.getTime();
  RTC.OFF();

  // set identifier
  frame.setID("NB_IOT_TCP");
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
  USB.print(F("1. Data to send: "));
  USB.println(data);

  //////////////////////////////////////////////////
  // 2. Switch ON the NB-IoT module
  //////////////////////////////////////////////////
  error = BG96.ON();

  if (error == 0)
  {
    USB.println(F("2. NB-IoT module ready"));

    ////////////////////////////////////////////////
    // 2.1. Check connection to network and continue
    ////////////////////////////////////////////////
    error = BG96.nbiotConnection(apn, band, network_operator, operator_type);
    if (error == 0)
    {
      USB.println(F("2.1. NB-IoT connection: OK "));

      ////////////////////////////////////////////////
      // 1.2.1 NB-IoT Context Activation
      ////////////////////////////////////////////////
      error = BG96.contextActivation(1,5);
      if (error == 0)
      {
        USB.println(F("2.1. NB-IoT context connection: OK "));
        USB.print(F("IP: ")); USB.println(BG96._ip);

        ////////////////////////////////////////////////
        // 3. Setting DNS server
        ////////////////////////////////////////////////
        error = BG96.setDNSServer("8.8.8.8","8.8.4.4");
        if (error == 0)
        {
          USB.println(F("3. Setting DNS server: OK "));
        }
        else
        {
          USB.println(F("3. DNS error: ")); USB.println(error,DEC);
          USB.println(BG96._buffer, BG96._length);
        }

        ////////////////////////////////////////////////
        // 4. TCP socket
        ////////////////////////////////////////////////

        error = BG96.openSocketClient(connId, "TCP", host, remote_port);

        if (error == 0)
        {
          USB.println(F("4. Opening a socket... done!"));

          USB.print(F("IP BG96 address:"));
          USB.println(BG96._ip);
        }

        //////////////////////////////////////////////
        // 4.1. Send it through the connection
        //////////////////////////////////////////////

        // send TCP packet
        error = BG96.send(connId, data);
        if (error == 0)
        {
          USB.println(F("4.1. Sending a frame... done!"));
        }
        else
        {
          USB.print(F("4.1. Error sending a frame. Code: "));
          USB.println(error, DEC);
        }

        //////////////////////////////////////////////
        // 4.2. Receive data
        //////////////////////////////////////////////

        // Wait for incoming data from the socket (if the other side responds)
        USB.print(F("4.2. Waiting to receive data..."));

        error = BG96.receive(connId, 60000);

        if (error == 0)
        {
          if (BG96.socketInfo[connId].received > 0)
          {
            USB.println(F("\n-----------------------------------"));
            USB.print(F("Data received:"));
            USB.println(BG96._buffer, BG96._length);
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

        //////////////////////////////////////////////
        // 4.3. Close socket
        //////////////////////////////////////////////
        error = BG96.closeSocketClient(connId);

        if (error == 0)
        {
          USB.println(F("4.3. Socket closed OK"));
        }
        else
        {
          USB.print(F("4.3. Error closing socket. Error code: "));
          USB.println(error, DEC);
        }
      }
    }
  }
  else
  {
    // Problem with the communication with the NB-IoT module
    USB.println(F("NB-IoT module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }

  //////////////////////////////////////////////////
  // 5. Switch OFF the NB-IoT module
  //////////////////////////////////////////////////
  error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("5. Module is power off"));
    }
    else
    {
      USB.println(F("5. Power off ERROR"));
    }


  //////////////////////////////////////////////////
  // 6. Sleep
  //////////////////////////////////////////////////
  USB.println(F("6. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("7. Wake up!!\n\n"));

}
