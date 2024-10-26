/*
    --------------- 4G_08 - Send frames to Meshlium  ---------------

    Explanation: This example shows how to use HTTP requests to send
    Waspmote frames from Waspmote to Meshlium. Therefore, the Meshlium
    will be able to parse the sensor data and inset it into the database

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

    Version:           3.1
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
uint16_t remote_port = 443;
///////////////////////////////////////


// buffer of memory to create the request
char data[500];

// define data to send through TCP socket
////////////////////////////////////////////////////////////////////////
char http_format[] =
  "GET /getpost_frame_parser.php?frame=%s HTTP/1.1\r\n"\
  "Host: %s\r\n"\
  "Content-Length: 0\r\n\r\n";
////////////////////////////////////////////////////////////////////////


// define Socket ID (mandatory CONNECTION_1)
///////////////////////////////////////
uint8_t socketId = Wasp4G::CONNECTION_1;
///////////////////////////////////////


// define certificate for SSL
////////////////////////////////////////////////////////////////////////
char certificate[] =

  "-----BEGIN CERTIFICATE-----\r"\
  "MIICNjCCAZ+gAwIBAgIJAL5/5O7w2Cm5MA0GCSqGSIb3DQEBCwUAMFMxLTArBgNV\r"\
  "BAoMJExpYmVsaXVtIENvbXVuaWNhY2lvbmVzIERpc3RyaWJ1aWRhczELMAkGA1UE\r"\
  "BhMCRVMxFTATBgNVBAMMDGxpYmVsaXVtLmNvbTAgFw0xNzAxMjQwOTU1MDJaGA8y\r"\
  "MTE2MTIzMTA5NTUwMlowUzEtMCsGA1UECgwkTGliZWxpdW0gQ29tdW5pY2FjaW9u\r"\
  "ZXMgRGlzdHJpYnVpZGFzMQswCQYDVQQGEwJFUzEVMBMGA1UEAwwMbGliZWxpdW0u\r"\
  "Y29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCfI9j2DbbuK1fUrH1RKmnU\r"\
  "EQ22r7FAT+R7uxOhSBnx61qlLjtZT9zuA7eMuq9k3tUBSkMxJjai6ebqmvPUpgrU\r"\
  "0EoCZg+PrAglcvqAkzv8QDRueEi0hLCa8iTUsuora3viKMefbFR8ROH5uQrFnZK1\r"\
  "1aUQxeV0HBL9zIH8ghaLmwIDAQABoxAwDjAMBgNVHRMEBTADAQH/MA0GCSqGSIb3\r"\
  "DQEBCwUAA4GBAG2bWPWsfHzSqwlzY+5kJDeAgJ7GfQo51+QXqMq5nnjcPhgkIkvz\r"\
  "IVOO2WM01Pnm3LuEQ3YS8eHS1blOL8i7GsxxIMR6aQ8E0XYbcizPvcyL+NAdIodd\r"\
  "bSa087amkPIVcwETuGf2JdpbJLEjWayfcE1Ll+DA7UfX9korLzZzfDxX\r"\
  "-----END CERTIFICATE-----";
////////////////////////////////////////////////////////////////////////


// define the Waspmote ID
////////////////////////////////////////////////////////////////////////
char moteID[] = "node_01";
////////////////////////////////////////////////////////////////////////

int error;



void setup()
{
  USB.ON();
  USB.println(F("Start program"));

  // set the Waspmote ID
  frame.setID(moteID);


  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);

  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();



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


    ////////////////////////////////////////////////
    // 2. Set CA certificate
    ////////////////////////////////////////////////

    error = _4G.manageSSL(socketId, Wasp4G::SSL_ACTION_STORE, Wasp4G::SSL_TYPE_CA_CERT, certificate);

    if (error == 0)
    {
      USB.println(F("2. Set CA certificate OK"));
    }
    else
    {
      USB.print(F("2. Error setting CA certificate. Error="));
      USB.println(error, DEC);
    }
  }

  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  _4G.OFF();

  USB.println(F("3. Switch OFF 4G module\n\n"));



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


    ////////////////////////////////////////////////
    // 2. Create new frame
    ////////////////////////////////////////////////

    USB.println(F("2.1. Create frame:"));

    // init RTC and get time
    RTC.ON();
    RTC.getTime();

    // Create new frame (ASCII)
    frame.createFrame(ASCII);
    // set frame fields (Time from RTC)
    frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second);
    // show frame
    frame.showFrame();

    // define aux buffer
    char frame_string[frame.length * 2 + 1];
    memset(frame_string, 0x00, sizeof(frame_string));

    // convert frame from bytes to ASCII representation
    Utils.hex2str((uint8_t*)frame.buffer, (char*)frame_string, frame.length);

    // create data to send over TCP connection
    snprintf( data, sizeof(data), http_format, frame_string, host);

    USB.println(F("2.2 Data to send:"));
    USB.println(F("-----------------------------------------"));
    USB.println(data);
    USB.println(F("-----------------------------------------"));



    ////////////////////////////////////////////////
    // 3. TCP socket
    ////////////////////////////////////////////////

    error = _4G.openSocketSSL(socketId, host, remote_port);

    if (error == 0)
    {
      USB.println(F("3.1. Opening a socket... done!"));


      //////////////////////////////////////////////
      // 3.2. Send data through socket
      //////////////////////////////////////////////

      error = _4G.sendSSL(socketId, data);
      if (error == 0)
      {
        USB.println(F("3.2. Sending data... done!"));
      }
      else
      {
        USB.print(F("3.2. Error sending data. Code: "));
        USB.println(error, DEC);
      }

      //////////////////////////////////////////////
      // 2.3. Receive data
      //////////////////////////////////////////////

      // Wait for incoming data from the socket (if the other side responds)
      USB.print(F("2.3. Waiting to receive data..."));

      error = _4G.receiveSSL(socketId, 60000);

      if (error == 0)
      {
        if (_4G._length > 0)
        {
          USB.println(F("\n-----------------------------------"));
          USB.print(F("Data received:"));
          USB.println(_4G._buffer, _4G._length);
          USB.println(F("-----------------------------------"));
        }
        else
        {
          USB.println(F("NO Data received"));
        }
      }
      else
      {
        USB.print(F("No data received. Error code:"));
        USB.println(error, DEC);
      }

      //////////////////////////////////////////////
      // 2.4. Close socket
      //////////////////////////////////////////////
      error = _4G.closeSocketSSL(socketId);

      if (error == 0)
      {
        USB.println(F("2.4. Socket closed OK"));
      }
      else
      {
        USB.print(F("2.4. Error closing socket. Error code: "));
        USB.println(error, DEC);
      }

    }
    else
    {
      USB.print(F("2.1. Error opening socket. Error code: "));
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
  // 5. Sleep
  ////////////////////////////////////////////////
  USB.println(F("5. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("6. Wake up!!\n\n"));

}




