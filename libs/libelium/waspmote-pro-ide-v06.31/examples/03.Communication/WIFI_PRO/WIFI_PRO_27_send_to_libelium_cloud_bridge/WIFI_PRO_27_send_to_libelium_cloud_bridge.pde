/*
    ------ WIFI Example --------

    Explanation: This example shows how to perform HTTPS GET requests
    to the Libelium Bride.

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


// SERVER settings
////////////////////////////////////////////////////////////////////////
const char flash_http_format[] PROGMEM = "GET %s?frame=%s HTTP/1.1\r\nHost: %s\r\nContent-Length: 0\r\n";
const char flash_http_host[]   PROGMEM = "hw.libelium.com";
const char flash_http_path[]   PROGMEM = "/hw/ps";
const char flash_http_rport[]  PROGMEM = "443";
const char* const flash_http_table[]  PROGMEM = {flash_http_format, flash_http_host, flash_http_path, flash_http_rport};
////////////////////////////////////////////////////////////////////////


// buffer of memory to create the request
char data[1500];

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
////////////////////////////////////////////////////////////////////////
const char TOKEN_HEADER[] PROGMEM = "Authorization: Bearer ";
const char TOKEN_1024[] PROGMEM = "eyJqdGkiOiI1MDlhOTFmYzE0YjIwNzI2ZjFjOGJlMjI5ODJmNDE2NzgzNTdhNjIyZWIxMzNjOGUxY2VhNWMzMDE0OGJjNjZlODNmZTY4YTZjODgzMmUwMiIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJhdWQiOjQsImp0aSI6IjUwOWE5MWZjMTRiMjA3MjZmMWM4YmUyMjk4MmY0MTY3ODM1N2E2MjJlYjEzM2M4ZTFjZWE1YzMwMTQ4YmM2NmU4M2ZlNjhhNmM4ODMyZTAyIiwiaWF0IjoxNTQ0NjEyMjM5LCJuYmYiOjE1NDQ2MTIyMzksImV4cCI6MTU3NjE0ODIzOSwic3ViIjo2LCJzY29wZXMiOltdLCJtZXNoLmd3X2lkIjoiW21lc2guZnJlZV0gKDU0MCkgeS5jYXJtb25hQGxpYmVsaXVtLmNvbSIsIm1lc2guZ3dfcG9sIjoiNWJlZWIzODk1MWFmNzkyOWYzMDAwMDAzIn0.sHSyI0Jb5Khu8INPtC98ZHSov1UQoBC9V6NNfWbfty6s09uIsByUlxTkmJlSvwCluj9d06fTOTETfmwpY7FPbnWEj7u8oqr4nnRq9oDp2vmgC_yrzYsv-vVRK6eFCEaXrVSbO-t1ls-bftA4R7J2DBWR0hLXLe3-bUAcu6tPPJU";
const char TOKEN_END[] PROGMEM = "\r\n\r\n";
const char* const token_table[] PROGMEM = {TOKEN_HEADER, TOKEN_1024, TOKEN_END};
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

  error = wifiSetCertificate();

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
  USB.println(F("3. WiFi switched OFF"));
  WIFI_PRO.OFF(socket);
  
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

    ////////////////////////////////////////////////
    // 3. Send data
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
    USB.println(F("3. Frame created:"));
    frame.showFrame();

    // send data via TCP secure socket
    sendFrame();
    
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
  }


  //////////////////////////////////////////////////
  // 4. Switch OFF
  //////////////////////////////////////////////////
  USB.println(F("4. WiFi switched OFF\n"));
  WIFI_PRO.OFF(socket);


  USB.println(F("DeepSleep for 10 seconds...\n"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE2, ALL_OFF);
  USB.println();
  USB.println();

}






/***********************************************************************
   This function configures SSL certificate into the WiFi module
***********************************************************************/
uint8_t wifiSetCertificate()
{
  char certificate[1500];
  memset(certificate, 0x00, sizeof(certificate));

  // read certificate from flash memory
  strcat_P(certificate, (char*)pgm_read_word(&(certificate_table[0])));

  // set CA certificate for HTTPS
  if (strlen(certificate) > 1500)
  {
    USB.println(F("WiFi CA certificate length is greater than 1500 bytes"));
  }

  return WIFI_PRO.setCA(certificate);
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
   send current frame contents via WiFi
 ***********************************************************************/
void sendFrame()
{
  char resource[1200];
  char host[60];
  char rport[20];
  memset(host, 0x00, sizeof(host));
  memset(rport, 0x00, sizeof(rport));
  strcpy_P(host, (char*)pgm_read_word(&(flash_http_table[1])));
  strcpy_P(rport, (char*)pgm_read_word(&(flash_http_table[3])));

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  {
    USB.println(F("WiFi is connected OK"));

    // get IP address
    error = WIFI_PRO.getIP();

    if (error == 0)
    {
      USB.print(F("WiFi module IP address: "));
      USB.println( WIFI_PRO._ip );
    }
    else
    {
      USB.println(F("WiFi module error getting IP address"));
    }

    // set TCP client
    error = WIFI_PRO.setTCPclient( host, rport, NULL);

    // check response
    if (error == 0)
    {
      // get socket handle (from 0 to 9)
      socket_handle = WIFI_PRO._socket_handle;

      USB.print(F("WiFi module set up a TCP socket in handle: "));
      USB.println(socket_handle, DEC);
    }
    else
    {
      USB.print(F("WiFi module return error in TCP connection "));
      WIFI_PRO.printErrorCode();
      status = false;
    }

    if (status == true)
    {
      // SSL hand shake
      error = WIFI_PRO.sslHandshake(socket_handle);

      if (error == 0)
      {
        USB.println(F("WiFi module SSL handshake OK"));
      }
      else
      {
        USB.println(F("WiFi module SSL handshake error"));
        WIFI_PRO.printErrorCode();
      }


      // generate http get request
      genHttpRequestFrame(resource, sizeof(resource));
      addToken(resource, sizeof(resource));

      error = WIFI_PRO.send( socket_handle, resource);

      if (error == 0)
      {
        USB.println(F("WiFi module sent data OK"));
      }
      else
      {
        USB.print(F("WiFi module returned error sending data "));
        WIFI_PRO.printErrorCode();
      }
    }

    // Wait for answer from server
    error = WIFI_PRO.receive(socket_handle, 10000);

    // check answer
    if (error == 0)
    {
      USB.println(F("WiFi module Server response:"));
      USB.println(F("-------------------------------"));
      USB.println(WIFI_PRO._buffer, WIFI_PRO._length);
      USB.println(F("-------------------------------"));
    }


    // Close socket
    error = WIFI_PRO.closeSocket(socket_handle);

    // check response
    if (error == 0)
    {
      USB.println(F("WiFi module close socket OK"));
    }
    else
    {
      USB.print(F("WiFi module returned error closing the connection "));
      WIFI_PRO.printErrorCode();
    }
  }
  else
  {
    USB.println(F("WiFi is not connected to network"));
  }
}




