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

// choose HTTP server settings
///////////////////////////////////////
char type[] = "https";
char host[] = "10.10.10.1";
uint16_t port = 443;
///////////////////////////////////////

// define certificate for SSL
////////////////////////////////////////////////////////////////////////
char certificate[] =
"-----BEGIN CERTIFICATE-----\n"\
"MIIDxTCCAq2gAwIBAgIJAM7fafAjnxm6MA0GCSqGSIb3DQEBCwUAMHgxCzAJBgNV\n"\
"BAYTAkVTMQ8wDQYDVQQIDAZBcmFnb24xETAPBgNVBAcMCFphcmFnb3phMTIwMAYD\n"\
"VQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmlidWlkYXMgUy5MLjER\n"\
"MA8GA1UEAwwIbWVzaGxpdW0wIBcNMjAwOTI1MTE1NzI1WhgPMjEyMDA5MDExMTU3\n"\
"MjVaMHgxCzAJBgNVBAYTAkVTMQ8wDQYDVQQIDAZBcmFnb24xETAPBgNVBAcMCFph\n"\
"cmFnb3phMTIwMAYDVQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmli\n"\
"dWlkYXMgUy5MLjERMA8GA1UEAwwIbWVzaGxpdW0wggEiMA0GCSqGSIb3DQEBAQUA\n"\
"A4IBDwAwggEKAoIBAQDAgL3erG+bYXGpPtw6rTUdFz7sFnuYff7Omd9yOoUF+0T6\n"\
"uqVv3hwyFMvghwOy7IUqx9vik1H/w2jpjbYrWp+TRVNxakrBZ4kQKXA6CyhRp65n\n"\
"GBG6tKwc5us8hIPxybvvG2K0h3+f/lyrHFMmAd50d6TwY7XzjxiaeUNmR+qi6qim\n"\
"BnwUijQPhDrGZGvcztccEw4xm1VmqNfA5UDJAnssfT85T1A36tLzcyZhvDh9LE8m\n"\
"ThaI7QquOmsLmhLkjI9wTgeGCIYw973oYkHiEjn93WVApcA/2zsjOXhNUSmwAPUv\n"\
"8/jNHsQbS5+3Jp7gcEBRD8aKagp/+paBls9Sw4gLAgMBAAGjUDBOMB0GA1UdDgQW\n"\
"BBS/inwKaIJh2yeqvL3hRRSMA7l79TAfBgNVHSMEGDAWgBS/inwKaIJh2yeqvL3h\n"\
"RRSMA7l79TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBJTpRYXcxz\n"\
"hWi+6U5LhjJHgn+qFIW9AXwIOnZvM2OLJ+mbVxy9lLbzEeA4NjikZNhDRvuhuU+O\n"\
"0dvmMQfN7HwZyamLIwHhayflL70V8TGby5FMlg9F/9qfyNjXZOEqu6xwrqJhg2qY\n"\
"y1NeIKB8QseSIeS2fIIlDhbpUH4+xss+w1ZKHWPUyOLWjVmXAFw63ebqcYXayD+g\n"\
"/VA7mfLfUjaCzQk8eB3Mvk9WMd+DH6smjJANQlMpUPJGisJn/PjVvmk8zOIaV6ld\n"\
"LJjgWNR6JaPtbhJ19bk3LgNetr93gaOnPOqDi2ZQOtxOYT+H/JMadpHTtxYWDbww\n"\
"gxjqWkkygn0N\n"\
"-----END CERTIFICATE-----";
////////////////////////////////////////////////////////////////////////


uint8_t error;
uint8_t status;

// define the Waspmote ID 
char moteID[] = "node_01";

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

  error = WIFI_PRO_V3.setCA(0, certificate);
  if (error == 0)
  {
    USB.println(F("3. Set CA configured"));
  }
  else
  {
    USB.println(F("3. Set CA ERROR"));
  }

  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO_V3.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  // set the Waspmote ID
  frame.setID(moteID);  
}



void loop()
{
  
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
    
    // create new frame (only ASCII)
    frame.createFrame(ASCII); 

    // add sensor fields
    frame.addSensor(SENSOR_STR, "this_is_a_string");
    frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

    // print frame
    frame.showFrame();  


    ///////////////////////////////
    // 3.2. Send Frame to Meshlium
    ///////////////////////////////

    // http frame
    error = WIFI_PRO_V3.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);

    // check response
    if (error == 0)
    {
      USB.println(F("Send frame to meshlium done"));
    }
    else
    {
      USB.println(F("Error sending frame"));
      if (WIFI_PRO_V3._httpResponseStatus)
      {
        USB.print(F("HTTP response status: "));  
        USB.println(WIFI_PRO_V3._httpResponseStatus);  
      }
    }
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR"));
  }
  
  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO_V3.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  PWR.deepSleep("00:00:00:10",RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);

}
