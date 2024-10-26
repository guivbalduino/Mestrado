/*
    ------ WIFI Example --------

    Explanation: This example shows how to perform HTTP GET requests

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
    Implementation:    Luis Miguel Martí
*/

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO_V3.h>
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
const char* const flash_http_table[]  PROGMEM = {flash_http_format, flash_http_host, flash_http_path};
uint16_t rport = 443;
////////////////////////////////////////////////////////////////////////


// buffer of memory to create the request
char data[1500];

// define certificate for SSL
////////////////////////////////////////////////////////////////////////
const char certificate[] PROGMEM =
  "-----BEGIN CERTIFICATE-----\n"\
  "MIID3DCCAsSgAwIBAgIJAMrHeK4tOUN7MA0GCSqGSIb3DQEBCwUAMIGBMQswCQYD\n"\
  "VQQGEwJFUzERMA8GA1UECAwIWmFyYWdvemExETAPBgNVBAcMCFphcmFnb3phMTIw\n"\
  "MAYDVQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmlidWlkYXMgUy5M\n"\
  "LjEYMBYGA1UEAwwPaHcubGliZWxpdW0uY29tMCAXDTE4MTAwMzA4NDkyOVoYDzIx\n"\
  "MTgwOTA5MDg0OTI5WjCBgTELMAkGA1UEBhMCRVMxETAPBgNVBAgMCFphcmFnb3ph\n"\
  "MREwDwYDVQQHDAhaYXJhZ296YTEyMDAGA1UECgwpTGliZWxpdW0gQ29tdW5pY2Fj\n"\
  "aW9uZXMgRGlzdHJpYnVpZGFzIFMuTC4xGDAWBgNVBAMMD2h3LmxpYmVsaXVtLmNv\n"\
  "bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMo3Fif9BlMOUmGRJxSq\n"\
  "JUYZUpPbJULBpegbxGLpiie4fTvEfml7csj8EhHch5ItWi+Zq6m8VfOJ7kAO1vxv\n"\
  "UYmprH+GfJXnQzBPROrazRu5fDk9C5NjTTu7PqNvmD3RLEnAWvY+k/B7qjqfXr5V\n"\
  "IWoQScIOgn2y/Qf2QGYf710uswPPOEMRZQ1oo9EE8zy9gsplQ8ym1xmENPavdv/x\n"\
  "5Fccyj3O0Gd6pXtTVZq0n5w/7qFEG55sRFJXnXXdxzgsRSdUk8wPpgZi7r05o2YP\n"\
  "YXHnoX0CcrfyPZE7wlijYIokzHxUZLvO0UnL8ZWzu+s4ULPANaQN03TTIO8zoXns\n"\
  "CwsCAwEAAaNTMFEwHQYDVR0OBBYEFE/Yuv3pY1LdcfuD5pre9qFNhynjMB8GA1Ud\n"\
  "IwQYMBaAFE/Yuv3pY1LdcfuD5pre9qFNhynjMA8GA1UdEwEB/wQFMAMBAf8wDQYJ\n"\
  "KoZIhvcNAQELBQADggEBACR4VyHIyeo9wJZfEAY/riv2y9kKorRIKU5uaKMMGFS0\n"\
  "tBV4/8sBJT16oc/PMAfpY7ot8Y6L5wxTaSXL4MsZM1QWD/DWehRGzDrjJPvZEEpW\n"\
  "x1moImbaCRr9THGV/Wg0gtbm5L8HCq0WWFaNKq4lZMUC1YkFDrKq2a23hoWEhihb\n"\
  "RxDudy0QehgqOIv+m0wLCfCcDqywCeuFXRaijDEj1wMW+1JVW1CPxwTiU+APeNMe\n"\
  "T4ebvxqEPrENm6LYCujZR8t+T/zlssqDiev218zRJWikMO+OOkMa08uWHx3gq1Pe\n"\
  "/CkY3qjmAgVx6yvbvo6mDkUK8MlzQCisbK/CLdOgefk=\n"\
  "-----END CERTIFICATE-----";
const char* const certificate_table[]  PROGMEM = {certificate};
////////////////////////////////////////////////////////////////////////


// Define Token for user authentication
////////////////////////////////////////////////////////////////////////
const char TOKEN_HEADER[] PROGMEM = "Authorization: Bearer ";
const char TOKEN_1024[] PROGMEM = "eyJqdGkiOiI1MDlhOTFmYzE0YjIwNzI2ZjFjOGJlMjI5ODJmNDE2NzgzNTdhNjIyZWIxMzNjOGUxY2VhNWMzMDE0OGJjNjZlODNmZTY4YTZjODgzMmUwMiIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJhdWQiOjQsImp0aSI6IjUwOWE5MWZjMTRiMjA3MjZmMWM4YmUyMjk4MmY0MTY3ODM1N2E2MjJlYjEzM2M4ZTFjZWE1YzMwMTQ4YmM2NmU4M2ZlNjhhNmM4ODMyZTAyIiwiaWF0IjoxNTQ0NjEyMjM5LCJuYmYiOjE1NDQ2MTIyMzksImV4cCI6NDczMTgyMTgzOSwic3ViIjo2LCJzY29wZXMiOltdLCJtZXNoLmd3X2lkIjoiW21lc2guZnJlZV0gKDU0MCkgeS5jYXJtb25hQGxpYmVsaXVtLmNvbSIsIm1lc2guZ3dfcG9sIjoiNWJlZWIzODk1MWFmNzkyOWYzMDAwMDAzIn0.pcw_jxPFGYEmJDPbm7Od6Ey-Izo4F5KkhKigc3zkLYQqmAjA67HPI7g0Jw6MDsx8CDdTYSyPkAOdEzUFRCCjWYozAEZduY-a8ALNM1gm7r2zwuFHM_HwsWVVaVQztkuMXOveJzO-HYxYqtHsHIzx64Ql053dkvyoNzUp-I5YlhM";
const char TOKEN_END[] PROGMEM = "\r\n\r\n";
const char* const token_table[] PROGMEM = {TOKEN_HEADER, TOKEN_1024, TOKEN_END};
////////////////////////////////////////////////////////////////////////


uint8_t error;
uint8_t status;
uint32_t previous;
uint16_t tcp_session = 0;

void setup()
{
  USB.println(F("Start program"));

  USB.println(F("***************************************"));
  USB.println(F("It is assumed the module was previously"));
  USB.println(F("configured in autoconnect mode and with"));
  USB.println(F("the Meshlium AP settings."));
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
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
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
  }

  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO_V3.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
}



void loop()
{
  USB.println();
  USB.println(F("************** New LOOP ***************"));
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO_V3.ON(socket);

  if (error == 0)
  {    
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }

  // check connectivity
  status =  WIFI_PRO_V3.isConnected();

  // check if module is connected
  if (status == true)
  {
    ///////////////////////////////
    // 3.1. Create a new Frame 
    ///////////////////////////////

    USB.print(F("IP address: "));
    USB.println(WIFI_PRO_V3._ip);
    
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

    ///////////////////////////////
    // 3.2. Send Frame to Meshlium
    ///////////////////////////////
    sendFrame();

  }
  else
  {
    USB.println(F("WiFi is not connected to network"));
  }
  
  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO_V3.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  PWR.deepSleep("00:00:00:10",RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);

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

  return WIFI_PRO_V3.setCA(0, certificate);
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
  memset(host, 0x00, sizeof(host));
  strcpy_P(host, (char*)pgm_read_word(&(flash_http_table[1])));
  
  USB.println(F("WiFi is connected OK"));

  error = WIFI_PRO_V3.tcpSetSecureClient(host, rport);

  // check response
  if (error == 0)
  {
    // get socket handle (from 0 to 9)
    tcp_session = WIFI_PRO_V3._tcpSessionId;
    
    USB.print(F("3.1. Open TCP socket OK in handle: "));
    USB.println(tcp_session, DEC);
  }
  else
  {
    USB.println(F("3.1. Error calling 'setTCPclient' function"));
    status = false;   
  }

  if (status == true)
  {   
    // generate http get request
    genHttpRequestFrame(resource, sizeof(resource));
    addToken(resource, sizeof(resource));
   
    ////////////////////////////////////////////////
    // 3.2. send data
    ////////////////////////////////////////////////
    error = WIFI_PRO_V3.tcpSendHTTP(tcp_session, resource);
    
    /* BINARY SENDING
    uint8_t data[] = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37};
    uint16_t size = 7
    error = WIFI_v3.send( socket_handle, data, size);
    */

    // check response
    if (error == 0)
    {
      USB.println(F("3.2. Send data OK"));   
      USB.print(F("Server status response: "));
      USB.println(WIFI_PRO_V3._httpResponseStatus);
    }
    else
    {
      USB.println(F("3.2. Error calling 'send' function"));
    }

    ////////////////////////////////////////////////
    // 3.4. close socket
    // If WIFI_PRO_V3._tcpNotifCode is 4 TCP
    // connection was closed by the server
    ////////////////////////////////////////////////
    if (WIFI_PRO_V3._tcpNotifCode != 4)
    {
      error = WIFI_PRO_V3.tcpClose(tcp_session);

      // check response
      if (error == 0)
      {
        USB.println(F("3.3. Close socket OK"));   
      }
      else
      {
        USB.print(F("3.3. Error calling 'tcpClose' function. Error: "));
        USB.println(error, DEC);
      }
    }
  }
}
