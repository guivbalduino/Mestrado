/*
    ------ WIFI Example --------

    Explanation: This example shows how to set up a TCP client connecting 
    to a TCP server and then shows how to send/receive information. 
    Finally, the socket is closed

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


// choose TCP server settings
///////////////////////////////////////
char HOST[]        = "postman-echo.com";
uint16_t REMOTE_PORT = 443;
uint16_t LOCAL_PORT  = 3000;
///////////////////////////////////////

// define data to send through TCP socket
///////////////////////////////////////
char data[] =
  "GET /get?foo1=bar1&amp;foo2=bar2 HTTP/1.1\0d\0a"\
  "Host: postman-echo.com\0d\0a\0d\0a";
////////////////////////////////////////////////////////////////////////

// define certificate for SSL
////////////////////////////////////////////////////////////////////////
char TRUSTED_CA[] =//
"-----BEGIN CERTIFICATE-----\n"\
"MIIFfjCCBGagAwIBAgIQDivd/iQtUtceNHMmaFc27TANBgkqhkiG9w0BAQsFADBG\n"\
"MQswCQYDVQQGEwJVUzEPMA0GA1UEChMGQW1hem9uMRUwEwYDVQQLEwxTZXJ2ZXIg\n"\
"Q0EgMUIxDzANBgNVBAMTBkFtYXpvbjAeFw0yMDA1MDcwMDAwMDBaFw0yMTA2MDcx\n"\
"MjAwMDBaMBsxGTAXBgNVBAMTEHBvc3RtYW4tZWNoby5jb20wggEiMA0GCSqGSIb3\n"\
"DQEBAQUAA4IBDwAwggEKAoIBAQDTYNFeARbSNWlGrFJQj33LJWyFRvs5YLhM3uXZ\n"\
"lH92I/yRpGUIaZX79DHStxH38LI+MifkYpAtKhzq91+Q5IhY/uH7hv1mmyqaldIG\n"\
"RxYhWlPtNCwHxr3vZmCrWkEtNjGpcVlYEz7WQXX1TAh5uur8Uz9pu7FMKwqU8MD/\n"\
"CimcfK3mLpRYE+VjhEGb50dMOEKOu68kApXYVjWGI9TikHpACZe2rbIDKPaDG7zM\n"\
"qkvVeELj5Ix9i+p6x3gv1DRd3DHCBifWvAdY+bVN3w9llGClXYOwLuHM2nvKL8eA\n"\
"zYt4kSyUaq0f8GLMZpI5I5c5VOzjYkaQnoHuAq9yC0YV6QBTAgMBAAGjggKRMIIC\n"\
"jTAfBgNVHSMEGDAWgBRZpGYGUqB7lZI8o5QHJ5Z0W/k90DAdBgNVHQ4EFgQUZZWc\n"\
"Uq/uxWZ1LWqq8ozl4gg67OIwLwYDVR0RBCgwJoIQcG9zdG1hbi1lY2hvLmNvbYIS\n"\
"Ki5wb3N0bWFuLWVjaG8uY29tMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggr\n"\
"BgEFBQcDAQYIKwYBBQUHAwIwOwYDVR0fBDQwMjAwoC6gLIYqaHR0cDovL2NybC5z\n"\
"Y2ExYi5hbWF6b250cnVzdC5jb20vc2NhMWIuY3JsMCAGA1UdIAQZMBcwCwYJYIZI\n"\
"AYb9bAECMAgGBmeBDAECATB1BggrBgEFBQcBAQRpMGcwLQYIKwYBBQUHMAGGIWh0\n"\
"dHA6Ly9vY3NwLnNjYTFiLmFtYXpvbnRydXN0LmNvbTA2BggrBgEFBQcwAoYqaHR0\n"\
"cDovL2NydC5zY2ExYi5hbWF6b250cnVzdC5jb20vc2NhMWIuY3J0MAwGA1UdEwEB\n"\
"/wQCMAAwggEFBgorBgEEAdZ5AgQCBIH2BIHzAPEAdgD2XJQv0XcwIhRUGAgwlFaO\n"\
"400TGTO/3wwvIAvMTvFk4wAAAXHuB/NKAAAEAwBHMEUCIQDT53eDqQF7O/nHFTO3\n"\
"+Div0+LrPE9kWWnjm8AeVw3MjgIgaMnke/Vnf2m2SbUMEgJoiXtbfOBNyLxhiUIt\n"\
"EirqvgQAdwBc3EOS/uarRUSxXprUVuYQN/vV+kfcoXOUsl7m9scOygAAAXHuB/Nm\n"\
"AAAEAwBIMEYCIQDipZleDUEfvSoI6ezb+lOd4I5UjLf+0aPK8pV24YTGVgIhAOwk\n"\
"qyApKJ6rEOn+cSSQr4Zszr8ca3YTITtes1v1QR/tMA0GCSqGSIb3DQEBCwUAA4IB\n"\
"AQCK0cgm5BExJroZzjlmzb7kdeRo7mmfppXWBsnQSJRoVtcvv1nKQhsOuWz3Ouub\n"\
"b3KWXzxcvAz14hZylrv5yS4XexWY7LmwhyCyvJWF3KDL4ZJRfIDMJHKCGg0eKakp\n"\
"81lQ7lWLnkw/I5Bb3eqSfvpn19FKXFiD0uId7rTJ0LnACqHo81ObKyNof1UXHBk7\n"\
"p7j4H+4mEJ4am+jsRT0kEl+ZUrBWAuhgoIpHDVZr+8wg8tprhcQwrgepJMXKB5ZS\n"\
"ZCqo/OHYA3+TInTLFBP31QautGMtRWZ1N2tBe7B2Mv7kzT27sjHmfx4BB0FC6sXI\n"\
"tOhB/0o+8lCaN2zdBNVXbVBv\n"\
"-----END CERTIFICATE-----";
////////////////////////////////////////////////////////////////////////

uint8_t error;
uint8_t status;
uint32_t previous;
uint16_t tcp_session = 0;


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
  error = WIFI_PRO_V3.ON(socket);

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
  error = WIFI_PRO_V3.setCA(0, TRUSTED_CA);
  
  if (error == 0)
  {
    USB.println(F("3. Set CA configured"));
  }
  else
  {
    USB.print(F("3. Set CA ERROR"));
  }


  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////
  USB.println(F("3. WiFi switched OFF\n\n"));
  WIFI_PRO_V3.OFF(socket);

}



void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.ON(socket);

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
  status =  WIFI_PRO_V3.isConnected();

  // check if module is connected
  if (status == true)
  {
    USB.println(F("2. WiFi is connected OK"));

    USB.print(F("IP address: "));
    USB.println(WIFI_PRO_V3._ip);

    USB.print(F("GW address: "));
    USB.println(WIFI_PRO_V3._gw);

    USB.print(F("Netmask address: "));
    USB.println(WIFI_PRO_V3._netmask);
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
    PWR.reboot();
  }

  //////////////////////////////////////////////////
  // 3. TCP
  //////////////////////////////////////////////////
  
  // make sure all sockets are closed
  USB.println(F("3.1. Closing all sockets"));
  WIFI_PRO_V3.tcpCloseAllSockets();
  
  // Check if module is connected
  if (status == true)
  {
    ////////////////////////////////////////////////
    // 3.1. Open TCP socket
    ////////////////////////////////////////////////
    error = WIFI_PRO_V3.tcpSetSecureClient( HOST, REMOTE_PORT);

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
      USB.println(F("3.1. Error calling 'tcpSetSecureClient' function"));
      status = false;   
    }

    if (status == true)
    {
      ////////////////////////////////////////////////
      // 3.3. send data
      ////////////////////////////////////////////////

      error = WIFI_PRO_V3.tcpSend( tcp_session, data);

      // check response
      if (error == 0)
      {
        USB.println(F("3.2. Send data OK")); 
      }
      else
      {
        USB.print(F("3.2. Error calling 'send' function: "));
        USB.println(WIFI_PRO_V3._cmeerror);
      }

      ////////////////////////////////////////////////
      // 3.4. Wait for answer from server
      ////////////////////////////////////////////////
      USB.println(F("Listen to TCP socket:"));
      error = WIFI_PRO_V3.tcpReceive(tcp_session, 30000);

      // check answer
      if (error == 0)
      {
        USB.println(F("========================================"));
        USB.print(F("Data: "));
        USB.println( WIFI_PRO_V3._buffer, WIFI_PRO_V3._length);

        USB.print(F("Length: "));
        USB.println( WIFI_PRO_V3._length, DEC);
        USB.println(F("========================================"));
      }

      ////////////////////////////////////////////////
      // 3.5. close socket
      ////////////////////////////////////////////////
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


  //////////////////////////////////////////////////
  // 4. Switch OFF
  //////////////////////////////////////////////////
  USB.println(F("4. WiFi switched OFF\n\n"));
  WIFI_PRO_V3.OFF(socket);


  USB.println(F("Wait 10 seconds...\n"));
  delay(10000);

}
