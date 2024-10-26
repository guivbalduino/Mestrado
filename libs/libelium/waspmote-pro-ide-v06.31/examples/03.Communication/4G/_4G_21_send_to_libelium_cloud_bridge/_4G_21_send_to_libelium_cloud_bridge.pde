/*
    ---  4G example ---

    Explanation: This example shows how to send data to Libelium Cloud Bridge

    Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Yuri Carmona
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
const char flash_http_format[] PROGMEM = "GET %s?frame=%s HTTP/1.1\r\nHost: %s\r\nContent-Length: 0\r\n";
const char flash_http_host[]   PROGMEM = "hw.libelium.com";
const char flash_http_path[]   PROGMEM = "/hw/ps";
uint16_t  port = 443;
const char* const flash_http_table[]  PROGMEM = {flash_http_format, flash_http_host, flash_http_path};
///////////////////////////////////////


// buffer of memory to create the request
char data[1500];

// define Socket ID (mandatory CONNECTION_1)
///////////////////////////////////////
uint8_t connId = Wasp4G::CONNECTION_1;
///////////////////////////////////////


// define certificate for SSL
////////////////////////////////////////////////////////////////////////
const char certificate[] PROGMEM =
  "-----BEGIN CERTIFICATE-----\r"\
  "MIID3DCCAsSgAwIBAgIJAMrHeK4tOUN7MA0GCSqGSIb3DQEBCwUAMIGBMQswCQYD\r"\
  "VQQGEwJFUzERMA8GA1UECAwIWmFyYWdvemExETAPBgNVBAcMCFphcmFnb3phMTIw\r"\
  "MAYDVQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmlidWlkYXMgUy5M\r"\
  "LjEYMBYGA1UEAwwPaHcubGliZWxpdW0uY29tMCAXDTE4MTAwMzA4NDkyOVoYDzIx\r"\
  "MTgwOTA5MDg0OTI5WjCBgTELMAkGA1UEBhMCRVMxETAPBgNVBAgMCFphcmFnb3ph\r"\
  "MREwDwYDVQQHDAhaYXJhZ296YTEyMDAGA1UECgwpTGliZWxpdW0gQ29tdW5pY2Fj\r"\
  "aW9uZXMgRGlzdHJpYnVpZGFzIFMuTC4xGDAWBgNVBAMMD2h3LmxpYmVsaXVtLmNv\r"\
  "bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMo3Fif9BlMOUmGRJxSq\r"\
  "JUYZUpPbJULBpegbxGLpiie4fTvEfml7csj8EhHch5ItWi+Zq6m8VfOJ7kAO1vxv\r"\
  "UYmprH+GfJXnQzBPROrazRu5fDk9C5NjTTu7PqNvmD3RLEnAWvY+k/B7qjqfXr5V\r"\
  "IWoQScIOgn2y/Qf2QGYf710uswPPOEMRZQ1oo9EE8zy9gsplQ8ym1xmENPavdv/x\r"\
  "5Fccyj3O0Gd6pXtTVZq0n5w/7qFEG55sRFJXnXXdxzgsRSdUk8wPpgZi7r05o2YP\r"\
  "YXHnoX0CcrfyPZE7wlijYIokzHxUZLvO0UnL8ZWzu+s4ULPANaQN03TTIO8zoXns\r"\
  "CwsCAwEAAaNTMFEwHQYDVR0OBBYEFE/Yuv3pY1LdcfuD5pre9qFNhynjMB8GA1Ud\r"\
  "IwQYMBaAFE/Yuv3pY1LdcfuD5pre9qFNhynjMA8GA1UdEwEB/wQFMAMBAf8wDQYJ\r"\
  "KoZIhvcNAQELBQADggEBACR4VyHIyeo9wJZfEAY/riv2y9kKorRIKU5uaKMMGFS0\r"\
  "tBV4/8sBJT16oc/PMAfpY7ot8Y6L5wxTaSXL4MsZM1QWD/DWehRGzDrjJPvZEEpW\r"\
  "x1moImbaCRr9THGV/Wg0gtbm5L8HCq0WWFaNKq4lZMUC1YkFDrKq2a23hoWEhihb\r"\
  "RxDudy0QehgqOIv+m0wLCfCcDqywCeuFXRaijDEj1wMW+1JVW1CPxwTiU+APeNMe\r"\
  "T4ebvxqEPrENm6LYCujZR8t+T/zlssqDiev218zRJWikMO+OOkMa08uWHx3gq1Pe\r"\
  "/CkY3qjmAgVx6yvbvo6mDkUK8MlzQCisbK/CLdOgefk=\r"\
  "-----END CERTIFICATE-----";
const char* const certificate_table[]  PROGMEM = {certificate};
////////////////////////////////////////////////////////////////////////


// Define Token for user authentication
///////////////////////////////////////
const char TOKEN_HEADER[] PROGMEM = "Authorization: Bearer ";
const char TOKEN_1024[] PROGMEM = "eyJqdGkiOiI1MDlhOTFmYzE0YjIwNzI2ZjFjOGJlMjI5ODJmNDE2NzgzNTdhNjIyZWIxMzNjOGUxY2VhNWMzMDE0OGJjNjZlODNmZTY4YTZjODgzMmUwMiIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJhdWQiOjQsImp0aSI6IjUwOWE5MWZjMTRiMjA3MjZmMWM4YmUyMjk4MmY0MTY3ODM1N2E2MjJlYjEzM2M4ZTFjZWE1YzMwMTQ4YmM2NmU4M2ZlNjhhNmM4ODMyZTAyIiwiaWF0IjoxNTQ0NjEyMjM5LCJuYmYiOjE1NDQ2MTIyMzksImV4cCI6MTU3NjE0ODIzOSwic3ViIjo2LCJzY29wZXMiOltdLCJtZXNoLmd3X2lkIjoiW21lc2guZnJlZV0gKDU0MCkgeS5jYXJtb25hQGxpYmVsaXVtLmNvbSIsIm1lc2guZ3dfcG9sIjoiNWJlZWIzODk1MWFmNzkyOWYzMDAwMDAzIn0.sHSyI0Jb5Khu8INPtC98ZHSov1UQoBC9V6NNfWbfty6s09uIsByUlxTkmJlSvwCluj9d06fTOTETfmwpY7FPbnWEj7u8oqr4nnRq9oDp2vmgC_yrzYsv-vVRK6eFCEaXrVSbO-t1ls-bftA4R7J2DBWR0hLXLe3-bUAcu6tPPJU";
const char TOKEN_END[] PROGMEM = "\r\n\r\n";
const char* const token_table[] PROGMEM = {TOKEN_HEADER, TOKEN_1024, TOKEN_END};
///////////////////////////////////////


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
    USB.println(F("- 4G module ready..."));

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
  }
  else
  {    
    USB.println(F("- 4G module not ready..."));
  }


  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  _4G.OFF();

  USB.println(F("- Switch OFF 4G module"));
  USB.println();
  USB.println(F("************* SETUP done **************"));
  USB.println();
}




void loop()
{  
  USB.println();
  USB.println(F("************** New LOOP ***************"));
  
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("- 4G module ready..."));

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
    // Send data
    ////////////////////////////////////////////////
    RTC.ON();
    RTC.getTime();

    // set identifier
    frame.setID("Node01");
    // Create new frame 
    frame.createFrame(BINARY);
    // set frame fields (Time from RTC)
    frame.addSensor(SENSOR_TIME, RTC.hour, RTC.minute, RTC.second);

    // show frame contents
    USB.println(F("- Frame created:"));
    frame.showFrame();
    
    sendFrame();

  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("- 4G module not started"));
  }

  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("- Switch OFF 4G module"));
  _4G.OFF();


  ////////////////////////////////////////////////
  // 4. Sleep
  ////////////////////////////////////////////////
  USB.println(F("- Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("- Wake up!!\n\n"));

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
    Add Token to HTTP request
***********************************************************************/
void addToken(char *pointer, uint16_t size)
{
  // concatenate last header to HTTP request
  strcat_P(pointer, (char*)pgm_read_word(&(token_table[0])));
  strcat_P(pointer, (char*)pgm_read_word(&(token_table[1])));
  strcat_P(pointer, (char*)pgm_read_word(&(token_table[2])));

  USB.println();
  USB.println();
  USB.println(F("HTTP request:"));
  USB.println(F("-------------------------------"));
  USB.println(pointer);
  USB.println(F("-------------------------------"));
  USB.println();
}







/***********************************************************************
  Send current frame contents via 4G
 ***********************************************************************/
void sendFrame()
{
  char resource[1200];
  char host[60];
  memset(host, 0x00, sizeof(host));
  strcpy_P(host, (char*)pgm_read_word(&(flash_http_table[1])));

  // set TCP socket
  error = _4G.openSocketSSL(connId, host, port);

  if (error == 0)
  {
    USB.println(F("- 4G module TCP socket open"));

    USB.print(F("- 4G module IP address:"));
    USB.println(_4G._ip);

    // generate http get request
    genHttpRequestFrame(resource, sizeof(resource));
    addToken(resource, sizeof(resource));

    // send TCP packet
    error = _4G.sendSSL(connId, resource);
    if (error == 0)
    {
      USB.println(F("- 4G module sending done"));
    }
    else
    {
      USB.print(F("- 4G module sending error code: "));
      USB.println(error, DEC);
    }

    // Receive answer from server
    error = _4G.receiveSSL(connId, 10000);

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
      USB.println(F("- 4G module no data received from server"));
    }
  }
  else
  {
    USB.print(F("- 4G module error opening socket. Error code: "));
    USB.println(error, DEC);
  }

  // Close socket
  error = _4G.closeSocketSSL(connId);

  if (error == 0)
  {
    USB.println(F("- 4G module socket closed OK"));
  }
  else
  {
    USB.print(F("- 4G module error closing socket. Error code: "));
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
  error = _4G.manageSSL(connId, Wasp4G::SSL_ACTION_STORE, Wasp4G::SSL_TYPE_CA_CERT, ca_cert);

  if (error == 0)
  {
    USB.println(F("- 4G set CA certificate OK"));
  }
  else
  {
    USB.print(F("- 4G set CA certificate ERROR. Error="));
    USB.println(error, DEC);
  }
}


