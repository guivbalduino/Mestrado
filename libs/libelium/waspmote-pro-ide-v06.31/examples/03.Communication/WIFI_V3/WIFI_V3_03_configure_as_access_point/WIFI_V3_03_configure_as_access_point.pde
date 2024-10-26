/*
    ------ WIFI Example --------

    Explanation: This example shows how to configure the WiFi module
    to set up an Access Point for other wifi stations.

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
    Implementation:    Yuri Carmona
*/


#include <WaspWIFI_PRO_V3.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// WiFi AP settings (CHANGE TO USER'S AP)
///////////////////////////////////////
char ssid[] = "Waspmote_SSID";
char passkey[] = "password";
uint8_t authentication_mode = WaspWIFI_v3::AUTH_WPA2;
///////////////////////////////////////

// define variables
uint8_t error;
uint8_t status;
unsigned long previous;



void setup()
{
  USB.println(F("Start program"));


  //////////////////////////////////////////////////
  // 1. Switch ON the WiFi module
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
  // 2. Reset to default values
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.resetValues();

  if (error == 0)
  {
    USB.println(F("2. WiFi reset to default"));
  }
  else
  {
    USB.println(F("2. WiFi reset to default ERROR"));
  }


  //////////////////////////////////////////////////
  // 3. Configure mode (Station or AP)
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.configureMode(WaspWIFI_v3::MODE_ACCESS_POINT);

  if (error == 0)
  {
    USB.println(F("3. WiFi configured OK"));
  }
  else
  {
    USB.println(F("3. WiFi configured ERROR"));
  }


  //////////////////////////////////////////////////
  // 4. Configure SSID and password
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.configureAp(ssid, passkey, authentication_mode);

  if (error == 0)
  {
    USB.println(F("4. WiFi AP configuration OK"));
  }
  else
  {
    USB.println(F("4. WiFi AP configuration ERROR"));
  }


  // get current time
  previous = millis();



  //////////////////////////////////////////////////
  // 5. Connect to AP
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.configureApSettings(
    WaspWIFI_v3::DHCP_ENABLED,
    "192.168.4.1", 
    "192.168.4.2", 
    "192.168.4.101", 
    120);

  if (error == 0)
  {
    USB.println(F("5. WiFi AP network settings OK"));
  }
  else
  {
    USB.println(F("5. WiFi AP network settings ERROR"));
  }

}



void loop()
{
  WIFI_PRO_V3.getConnectedDevices();
  if (WIFI_PRO_V3._apClients)
  {
    USB.println(F("Devices connected:"));
    for (uint8_t i = 0; i < WIFI_PRO_V3._apClients; i++)
    {
      USB.print(F("\tDevice:\t"));
      USB.print(WIFI_PRO_V3.client[i].mac);
      USB.print(F("\t||\tIP:"));
      USB.println(WIFI_PRO_V3.client[i].ip);
    }
  }
  else
  {
    USB.println(F("No devices found!"));
  }
  delay(10000);
}


