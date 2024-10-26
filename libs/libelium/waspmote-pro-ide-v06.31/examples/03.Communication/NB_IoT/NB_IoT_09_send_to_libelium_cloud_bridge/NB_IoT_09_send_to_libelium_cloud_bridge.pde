/*
    ---  NB_IOT_09_send_to_libelium_cloud_bridge example ---

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

    Version:           3.0
    Design:            David Gascón
    Implementation:    P.Moreno, J.Siscart
*/

#include <WaspBG96.h>
#include <WaspFrame.h>


// APN settings
char apn[] = "";
char login[] = "";
char password[] = "";
///////////////////////////////////////
// Operator selection
/////////////////////////////////////////
char network_operator[] = "";
/////////////////////////////////////////
// <Operator_type> options: 
// LALPHANUMERIC_OPERATOR	Long format alphanumeric <network_operator> which can be up to 16 characters long.
// SALPHANUMERIC_OPERATOR	Short format alphanumeric <network_operator>.
// NUMERIC_OPERATOR			Numeric <network_operator>. GSM location area identification number.
/////////////////////////////////////////
uint8_t operator_type = LALPHANUMERIC_OPERATOR;
/////////////////////////////////////////
// Band configuration
/////////////////////////////////////////
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
///////////////////////////////////////
char band[] = B20;
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
char data[1610];

// define data to send through TCP socket
///////////////////////////////////////
char http_format[] =
  "GET /hw/ps?frame=%s HTTP/1.1\r\n"\
  "Host: %s\r\n"\
  "Content-Length: 0\r\n"\
  "Authorization: Bearer %s\r\n\r\n";
///////////////////////////////////////

// define Socket ID (mandatory CONNECTION_1)
///////////////////////////////////////
uint8_t connId = WaspBG96::CONNECTION_1;
///////////////////////////////////////

// define certificate for SSL
////////////////////////////////////////////////////////////////////////
const char certificate[] PROGMEM =
  "-----BEGIN CERTIFICATE-----\r\n"\
  "MIID3DCCAsSgAwIBAgIJAMrHeK4tOUN7MA0GCSqGSIb3DQEBCwUAMIGBMQswCQYD\r\n"\
  "VQQGEwJFUzERMA8GA1UECAwIWmFyYWdvemExETAPBgNVBAcMCFphcmFnb3phMTIw\r\n"\
  "MAYDVQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmlidWlkYXMgUy5M\r\n"\
  "LjEYMBYGA1UEAwwPaHcubGliZWxpdW0uY29tMCAXDTE4MTAwMzA4NDkyOVoYDzIx\r\n"\
  "MTgwOTA5MDg0OTI5WjCBgTELMAkGA1UEBhMCRVMxETAPBgNVBAgMCFphcmFnb3ph\r\n"\
  "MREwDwYDVQQHDAhaYXJhZ296YTEyMDAGA1UECgwpTGliZWxpdW0gQ29tdW5pY2Fj\r\n"\
  "aW9uZXMgRGlzdHJpYnVpZGFzIFMuTC4xGDAWBgNVBAMMD2h3LmxpYmVsaXVtLmNv\r\n"\
  "bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMo3Fif9BlMOUmGRJxSq\r\n"\
  "JUYZUpPbJULBpegbxGLpiie4fTvEfml7csj8EhHch5ItWi+Zq6m8VfOJ7kAO1vxv\r\n"\
  "UYmprH+GfJXnQzBPROrazRu5fDk9C5NjTTu7PqNvmD3RLEnAWvY+k/B7qjqfXr5V\r\n"\
  "IWoQScIOgn2y/Qf2QGYf710uswPPOEMRZQ1oo9EE8zy9gsplQ8ym1xmENPavdv/x\r\n"\
  "5Fccyj3O0Gd6pXtTVZq0n5w/7qFEG55sRFJXnXXdxzgsRSdUk8wPpgZi7r05o2YP\r\n"\
  "YXHnoX0CcrfyPZE7wlijYIokzHxUZLvO0UnL8ZWzu+s4ULPANaQN03TTIO8zoXns\r\n"\
  "CwsCAwEAAaNTMFEwHQYDVR0OBBYEFE/Yuv3pY1LdcfuD5pre9qFNhynjMB8GA1Ud\r\n"\
  "IwQYMBaAFE/Yuv3pY1LdcfuD5pre9qFNhynjMA8GA1UdEwEB/wQFMAMBAf8wDQYJ\r\n"\
  "KoZIhvcNAQELBQADggEBACR4VyHIyeo9wJZfEAY/riv2y9kKorRIKU5uaKMMGFS0\r\n"\
  "tBV4/8sBJT16oc/PMAfpY7ot8Y6L5wxTaSXL4MsZM1QWD/DWehRGzDrjJPvZEEpW\r\n"\
  "x1moImbaCRr9THGV/Wg0gtbm5L8HCq0WWFaNKq4lZMUC1YkFDrKq2a23hoWEhihb\r\n"\
  "RxDudy0QehgqOIv+m0wLCfCcDqywCeuFXRaijDEj1wMW+1JVW1CPxwTiU+APeNMe\r\n"\
  "T4ebvxqEPrENm6LYCujZR8t+T/zlssqDiev218zRJWikMO+OOkMa08uWHx3gq1Pe\r\n"\
  "/CkY3qjmAgVx6yvbvo6mDkUK8MlzQCisbK/CLdOgefk=\r\n"\
  "-----END CERTIFICATE-----";
const char* const certificate_table[]  PROGMEM = {certificate};
////////////////////////////////////////////////////////////////////////

// Define Token for user authentication
///////////////////////////////////////
const char TOKEN_HEADER[] PROGMEM = "Authorization: Bearer ";
const char TOKEN_1024[] PROGMEM = "eyJqdGkiOiI3ZDAwY2FmMzQ1MTk3ZjBmMGU1OTAxMTQyZDM3NDU0YzgwNGFiMGY2Yjc0MGJlMDVlMjZkMGZiZDc4Y2FhN2YwODA0Y2UzYjE3NmFlY2E4MiIsInR5cCI6IkpXVCIsImFsZyI6IlJTMjU2In0.eyJhdWQiOjUsImp0aSI6IjdkMDBjYWYzNDUxOTdmMGYwZTU5MDExNDJkMzc0NTRjODA0YWIwZjZiNzQwYmUwNWUyNmQwZmJkNzhjYWE3ZjA4MDRjZTNiMTc2YWVjYTgyIiwiaWF0IjoxNTUxMzU4NjE5LCJuYmYiOjE1NTEzNTg2MTksImV4cCI6MTU4Mjg5NDYxOSwic3ViIjo2LCJzY29wZXMiOltdLCJtZXNoLmd3X2lkIjoiW21lc2guZnJlZV0gKDU0MCkgeS5jYXJtb25hQGxpYmVsaXVtLmNvbSIsIm1lc2guZ3dfcG9sIjoiNWJlZWIzODk1MWFmNzkyOWYzMDAwMDAzIn0.i9vaX8DsoaVqmHJWtmpH88k40teG0L7-cmIfhg4alfgg3mSkFq9eNMfHb5tZ76pJsUkfFkhBP_JAjg-vj3hhgGb2kzTQzFVeUaSdblnWAcYs0G85NYnH-RyvCCXAsSq-tGlHfb0F8Q9XKQRXQY1wQwwRFuT8wfIigsvG1d7MaDI";
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
  BG96.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  BG96.show_APN();


  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = BG96.ON();

  if (error == 0)
  {
    USB.println(F("- BG96 module ready..."));

    ////////////////////////////////////////////////
    // Enter PIN code
    ////////////////////////////////////////////////

    /*
      USB.println(F("Setting PIN code..."));
      if (BG96.enterPIN("****") == 1)
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
    USB.println(F("- BG96 module not ready..."));
  }


  ////////////////////////////////////////////////
  // 3. Powers off the BG96 module
  ////////////////////////////////////////////////
  error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("- Module is power off"));
    }
    else
    {
      USB.println(F("- Power off ERROR"));
    }

  //USB.println(F("- Switch OFF BG96 module"));
  USB.println();
  USB.println(F("************* SETUP done **************"));
  USB.println();
}




void loop()
{  
  USB.println();
  USB.println(F("************** New LOOP ***************"));

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
  
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = BG96.ON();

  if (error == 0)
  {
    USB.println(F("- BG96 module ready..."));

    ////////////////////////////////////////////////
    // Enter PIN code
    ////////////////////////////////////////////////

    /*
      USB.println(F("Setting PIN code..."));
      if (BG96.enterPIN("****") == 1)
      {
      USB.println(F("PIN code accepted"));
      }
      else
      {
      USB.println(F("PIN code incorrect"));
      }
    */

    ////////////////////////////////////////////////
    // 2.1. Check connection to network and continue
    ////////////////////////////////////////////////
    error = BG96.nbiotConnection(apn, band, network_operator, operator_type);
    if (error == 0)
    {
      USB.println(F("2.1. NB-IoT connection: OK "));

      ////////////////////////////////////////////////
      // 2.2.1 NB-IoT Context Activation
      ////////////////////////////////////////////////
      error = BG96.contextActivation(1,5);
      if (error == 0)
      {
        USB.println(F("2.2.1. NB-IoT context connection: OK "));
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
        // 4. Send data
        ////////////////////////////////////////////////    
        sendFrame();
      }
      else
      {
        USB.print(F("2.2.1. Context activation error: ")); USB.println(error,DEC);
        USB.println(BG96._buffer, BG96._length);
      }
    }
    else
    {
      USB.print(F("2.1. NB-IoT module connection error: ")); USB.println(error,DEC);
      USB.println(BG96._buffer, BG96._length);
    }

  }
  else
  {
    // Problem with the communication with the BG96 module
    USB.println(F("- BG96 module not started"));
  }

  ////////////////////////////////////////////////
  // 5. Powers off the BG96 module
  ////////////////////////////////////////////////
  USB.println(F("- Switch OFF BG96 module"));
  error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("- Module is power off"));
    }
    else
    {
      USB.println(F("- Power off ERROR"));
    }


  ////////////////////////////////////////////////
  // 6. Sleep
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
  Send current frame contents via BG96
 ***********************************************************************/
void sendFrame()
{   
  char resource[1200];
  char host[60];
  memset(host, 0x00, sizeof(host));
  strcpy_P(host, (char*)pgm_read_word(&(flash_http_table[1])));
  
  // set TCP socket
  error = BG96.openSocketSSL(connId, host, port);

  if (error == 0)
  {
    USB.println(F("- BG96 module TCP socket open"));

    USB.print(F("- BG96 module IP address:"));
    USB.println(BG96._ip);

    // generate http get request
    genHttpRequestFrame(resource, sizeof(resource));
    addToken(resource, sizeof(resource));

    // send TCP packet
    error = BG96.sendSSL(connId, resource);
    if (error == 0)
    {
      USB.println(F("- BG96 module sending done"));
    }
    else
    {
      USB.print(F("- BG96 module sending error code: "));
      USB.println(error, DEC);
    }

    // Receive answer from server
    error = BG96.receiveSSL(connId, 10000);

    if (error == 0)
    {
      if (BG96._length > 0)
      {
        USB.println(F("- BG96 module Server response:"));
        USB.println(F("-------------------------------"));
        USB.println(BG96._buffer, BG96._length);
        USB.println(F("-------------------------------"));
      }
      else
      {
        USB.println(F("- BG96 module no data received from server"));
      }
    }
    else
    {
      USB.println(F("- BG96 module no data received from server"));
    }
  }
  else
  {
    USB.print(F("- BG96 module error opening socket. Error code: "));
    USB.println(error, DEC);
  }

  // Close socket
  error = BG96.closeSocketSSL(connId);

  if (error == 0)
  {
    USB.println(F("- BG96 module socket closed OK"));
  }
  else
  {
    USB.print(F("- BG96 module error closing socket. Error code: "));
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
  error = BG96.manageSSL(connId, WaspBG96::SSL_ACTION_STORE, WaspBG96::SSL_TYPE_CA_CERT, ca_cert);

  if (error == 0)
  {
    USB.println(F("- BG96 set CA certificate OK"));
  }
  else
  {
    USB.print(F("- BG96 set CA certificate ERROR. Error="));
    USB.println(error, DEC);
  }
}


