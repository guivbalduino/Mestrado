/*
    ------ WIFI Example --------

    Explanation: This example shows how to use the SSL commands so as
    to open a TCP client socket to the specified server address and port
    Finally, the socket is closed

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
    Design:            David Gascon
    Implementation:    Luis Miguel Martí
*/

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO.h>
#include <WaspFrame.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose TCP server settings
///////////////////////////////////////
char HOST[]        = "test.libelium.com";
char REMOTE_PORT[] = "443";
char LOCAL_PORT[]  = "3000";
///////////////////////////////////////

// buffer of memory to create the request
char data[500];

// define data to send through TCP socket
///////////////////////////////////////
char http_format[] =
  "GET /getpost_frame_parser.php?frame=%s HTTP/1.1\r\n"\
  "Host: %s\r\n"\
  "Content-Length: 0\r\n\r\n";
////////////////////////////////////////////////////////////////////////

// define certificate for SSL
////////////////////////////////////////////////////////////////////////
char TRUSTED_CA[] =//
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

uint8_t error;
uint8_t status;
uint32_t previous;
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

  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = WIFI_PRO.ON(socket);

  if ( error == 0 )
  {
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }

  //////////////////////////////////////////////////
  // 2. Set Trusted CA
  //////////////////////////////////////////////////
  error = WIFI_PRO.setCA(TRUSTED_CA);

  if (error == 0)
  {
    USB.println(F("2. Trusted CA set OK"));
  }
  else
  {
    USB.println(F("2. Error calling 'setCA' function"));
    WIFI_PRO.printErrorCode();
  }

  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////
  USB.println(F("3. WiFi switched OFF\n\n"));
  WIFI_PRO.OFF(socket);

}



void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = WIFI_PRO.ON(socket);

  if ( error == 0 )
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
  if ( status == true )
  {
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);

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
    USB.println(millis() - previous);
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
      // 3.2. SSL hand shake
      ////////////////////////////////////////////////
      error = WIFI_PRO.sslHandshake(WIFI_PRO._socket_handle);

      if (error == 0)
      {
        USB.println(F("3.2. SSL handle shake OK"));
      }
      else
      {
        USB.println(F("3.2. Error calling 'sslHandshake' function"));
        WIFI_PRO.printErrorCode();
      }



      ////////////////////////////////////////////////
      // 3.3. send data
      ////////////////////////////////////////////////

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
      char frame_string[frame.length * 2 + 1];
      memset(frame_string, 0x00, sizeof(frame_string));

      // convert frame from bytes to ASCII representation
      Utils.hex2str((uint8_t*)frame.buffer, (char*)frame_string, frame.length);

      snprintf( data, sizeof(data), http_format, frame_string, HOST);
      USB.println(F("Data to send:"));
      USB.println(F("----------------------------------------"));
      USB.println(data);
      USB.println(F("----------------------------------------"));


      error = WIFI_PRO.send( socket_handle, data);

      // check response
      if (error == 0)
      {
        USB.println(F("3.3. Send data OK"));
      }
      else
      {
        USB.println(F("3.3. Error calling 'send' function"));
        WIFI_PRO.printErrorCode();
      }

      ////////////////////////////////////////////////
      // 3.4. Wait for answer from server
      ////////////////////////////////////////////////
      USB.println(F("Listen to TCP socket:"));
      error = WIFI_PRO.receive(socket_handle, 30000);

      // check answer
      if (error == 0)
      {
        USB.println(F("========================================"));
        USB.print(F("Data: "));
        USB.println( WIFI_PRO._buffer, WIFI_PRO._length);

        USB.print(F("Length: "));
        USB.println( WIFI_PRO._length, DEC);
        USB.println(F("========================================"));
      }

      ////////////////////////////////////////////////
      // 3.5. close socket
      ////////////////////////////////////////////////
      error = WIFI_PRO.closeSocket(socket_handle);

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
  USB.println(F("4. WiFi switched OFF\n\n"));
  WIFI_PRO.OFF(socket);


  USB.println(F("Wait 10 seconds...\n"));
  delay(10000);

}
