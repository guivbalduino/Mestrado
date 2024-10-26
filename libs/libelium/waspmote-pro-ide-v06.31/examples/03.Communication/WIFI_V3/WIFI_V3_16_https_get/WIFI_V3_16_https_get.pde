/*
    ------ WIFI Example --------

    Explanation: This example shows how to perform HTTPS GET requests

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


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose HTTP server settings
///////////////////////////////////////
char HTTP_SERVER[] = "postman-echo.com";
char HTTP_PATH[] = "/get";
uint16_t HTTP_PORT = 443;
///////////////////////////////////////


// define trusted Certificate Authority
////////////////////////////////////////////////////////////////////////
char TRUSTED_CA[] =\ 
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
unsigned long previous;



void setup()
{
  USB.println(F("Start program"));

  USB.println(F("***************************************"));
  USB.println(F("It is assumed the module was previously"));
  USB.println(F("configured in autoconnect mode."));
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
    
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
    USB.print(F(" Time(ms):"));
    USB.println(millis() - previous);
    PWR.reboot();
  }


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
  // 3. Configure HTTP conection
  //////////////////////////////////////////////////

  error = WIFI_PRO_V3.httpsConfiguration(HTTP_SERVER, HTTP_PORT);
  if (error == 0)
  {
    USB.println(F("3. HTTP conection configured"));
  }
  else
  {
    USB.print(F("3. HTTP conection configured ERROR"));
  }

}



void loop()
{

  //////////////////////////////////////////////////
  // 1. Perform the HTTPS GET
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.httpsGet(HTTP_PATH);

  // check response
  if (error == 0)
  {
    USB.print(F("HTTPS GET done!\r\nStatus: "));
    USB.println(WIFI_PRO_V3._httpResponseStatus,DEC);
  }
  else
  {
    USB.println(F("Error in HTTPS GET!"));  
  }

  delay(10000);
  
}

