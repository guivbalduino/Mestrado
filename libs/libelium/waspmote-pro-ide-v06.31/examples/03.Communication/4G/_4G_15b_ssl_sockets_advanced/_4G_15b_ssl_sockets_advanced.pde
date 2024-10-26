/*
    --- 4G_15b - SSL functions for TCP sockets  ---

    Explanation: This example shows how to use the SSL commands so as
    to open a TCP client socket to the specified server address and port

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

    Version:           3.0
    Design:            David Gascón
    Implementation:    Isabel Burillo
*/

#include <Wasp4G.h>
#include <WaspFrame.h>


// APN settings
///////////////////////////////////////
char apn[] = "gprs-service.com";
char login[] = "";
char password[] = "";
///////////////////////////////////////


// SERVER settings
///////////////////////////////////////
const char flash_http_format[] PROGMEM = "GET %s?frame=%s HTTP/1.1\r\nHost: %s\r\nContent-Length: 0\r\n\r\n";
const char flash_http_host[]   PROGMEM = "test.libelium.com";
const char flash_http_path[]   PROGMEM = "/getpost_frame_parser.php";
uint16_t  port = 443;
const char* const flash_http_table[]  PROGMEM = {flash_http_format, flash_http_host, flash_http_path};
///////////////////////////////////////


// buffer of memory to create the request
char data[500];


// define Socket ID (mandatory CONNECTION_1)
///////////////////////////////////////
uint8_t socketId = Wasp4G::CONNECTION_1;
///////////////////////////////////////


// define Cipher Suite for Telit v2 modules
// – CHOSEN_BY_REMOTE_SERVER
// – TLS_RSA_WITH_RC4_128_MD5
// – TLS_RSA_WITH_RC4_128_SHA
// – TLS_RSA_WITH_AES_128_CBC_SHA
// – TLS_RSA_WITH_NULL_SHA
// – TLS_RSA_WITH_AES_256_CBC_SHA
//
// or define Cipher Suite for Telit v1 modules
// – CHOSEN_BY_REMOTE_SERVER
// – TLS_RSA_WITH_RC4_128_MD5
// – TLS_RSA_WITH_RC4_128_SHA
// – V1_TLS_RSA_WITH_AES_256_CBC_SHA
// – TLS_RSA_WITH_NULL_SHA
///////////////////////////////////////
uint8_t cipherSuite = Wasp4G::CHOSEN_BY_REMOTE_SERVER;
///////////////////////////////////////


// Authentication mode
// – SSL_VERIFY_NONE
// – MANAGE_SERVER_AUTH
// – MANAGE_SERVER_AND_CLIENT_AUTH
///////////////////////////////////////
uint8_t authMode = Wasp4G::MANAGE_SERVER_AUTH;
///////////////////////////////////////


// SSL/TLS protocol Version
// NO SUPPORTED BY TELIT V1 MODULES
// – SSL_v3
// – TLS_v1_0
// – TLS_v1_1
// – TLS_v1_2
///////////////////////////////////////
uint8_t protocolVersion = Wasp4G::TLS_v1_0;
///////////////////////////////////////


// define certificate for SSL
////////////////////////////////////////////////////////////////////////
const char certificate[] PROGMEM =//
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
const char* const certificate_table[]  PROGMEM = {certificate};
////////////////////////////////////////////////////////////////////////


// define variables
uint8_t  error;
uint32_t previous;
uint8_t  socketIndex;


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
    configCertificate();


    ////////////////////////////////////////////////
    // 3. Set SSL/TLS protocol version
    // NO SUPPORTED BY TELIT V1 MODULES
    ////////////////////////////////////////////////

    error = _4G.setSSLprotocol(socketId, protocolVersion);

    if (error == 0)
    {
      USB.println(F("3. Set SSL/TLS protocol OK"));
    }
    else
    {
      USB.println(F("3. Error setting SSL protocol"));
    }


    ////////////////////////////////////////////////
    // 4. Powers off the 4G module
    ////////////////////////////////////////////////
    _4G.OFF();

    USB.println(F("4. Switch OFF 4G module\n\n"));

  }
  else
  {
    USB.println(F("1. 4G module not ready..."));
  }

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
    // 2.1. Create new frame
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

    ////////////////////////////////////////////////
    // 2.2. Send data
    ////////////////////////////////////////////////
    sendFrame();


    ////////////////////////////////////////////////
    // 3. Powers off the 4G module
    ////////////////////////////////////////////////
    USB.println(F("3. Switch OFF 4G module"));
    _4G.OFF();

  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
  }

  ////////////////////////////////////////////////
  // 4. Sleep
  ////////////////////////////////////////////////
  USB.println(F("4. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("5. Wake up!!\n\n"));

}


/***********************************************************************
    Generate HTTP request
***********************************************************************/
void genHttpRequestFrame(char *pointer, uint16_t size)
{
  // get the http format from flash
  char http_format[100];
  char host[60];
  char path[60];
  memset(http_format, 0x00, sizeof(http_format));
  memset(host, 0x00, sizeof(host));
  memset(path, 0x00, sizeof(path));
  strcpy_P(http_format, (char*)pgm_read_word(&(flash_http_table[0])));
  strcpy_P(host, (char*)pgm_read_word(&(flash_http_table[1])));
  strcpy_P(path, (char*)pgm_read_word(&(flash_http_table[2])));

  // define 'frame_string' buffer
  char frame_string[frame.length * 2 + 1];
  memset(frame_string, 0x00, sizeof(frame_string));

  // convert frame from bytes to ASCII representation
  for (uint16_t i = 0; i < frame.length; i++)
  {
    Utils.hex2str(&frame.buffer[i], &frame_string[i * 2], 1);
  }

  // generate http get request
  snprintf( pointer, size - 1, http_format, path, frame_string, host);

}


/***********************************************************************
  Send current frame contents via 4G
 ***********************************************************************/
void sendFrame()
{
  char resource[1000];
  char host[60];
  memset(host, 0x00, sizeof(host));
  strcpy_P(host, (char*)pgm_read_word(&(flash_http_table[1])));

  // set TCP socket
  error = _4G.openSocketSSL(socketId, host, port);

  if (error == 0)
  {
    USB.println(F("2.2. Opening a socket... done!"));

    USB.print(F("\t4G module IP address:"));
    USB.println(_4G._ip);

    // generate http get request
    genHttpRequestFrame(resource, sizeof(resource));


    //////////////////////////////////////////////
    // 2.3. Send data through socket
    //////////////////////////////////////////////
    error = _4G.sendSSL(socketId, resource);
    if (error == 0)
    {
      USB.println(F("2.3. Sending data... done!"));
    }
    else
    {
      USB.print(F("2.3. Error sending data. Code: "));
      USB.println(error, DEC);
    }


    //////////////////////////////////////////////
    // 2.4. Receive data
    //////////////////////////////////////////////
    USB.println(F("2.4. Waiting to receive data..."));
    // Wait for incoming data from the socket (if the other side responds)
    error = _4G.receiveSSL(socketId, 20000);

    if (error == 0)
    {
      if (_4G._length > 0)
      {
        USB.println(F("- 4G module Server response:"));
        USB.println(F("-------------------------------"));
        USB.println(_4G._buffer, _4G._length);
        USB.println(F("-------------------------------"));
      }
      else
      {
        USB.println(F("- 4G module no data received from server"));
      }
    }
    else
    {
      USB.print(F("- 4G module no data received from server. Error code:"));
      USB.println(error, DEC);
    }

    //////////////////////////////////////////////
    // 2.5. Close socket
    //////////////////////////////////////////////
    error = _4G.closeSocketSSL(socketId);

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
    USB.print(F("2.2. Error opening socket. Error code: "));
    USB.println(error, DEC);
  }


}


/***********************************************************************
  Function to set the CA certificate
 ***********************************************************************/
void configCertificate()
{
  char ca_cert[1500];

  // clear the buffer
  memset(ca_cert, 0x00, sizeof(ca_cert));
  strcat_P(ca_cert, (char*)pgm_read_word(&(certificate_table[0])));

  // Set CA certificate
  error = _4G.manageSSL(socketId, Wasp4G::SSL_ACTION_STORE, Wasp4G::SSL_TYPE_CA_CERT, ca_cert, cipherSuite, authMode);

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
