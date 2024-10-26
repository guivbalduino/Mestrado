/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up static settings for
 *  the WiFi module. In this example it is shown how to set the static 
 *  IP address, the DNS server address, the gateway address and the 
 *  netmask address
 *  
 *  Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify  
 *  it under the terms of the GNU General Public License as published by  
 *  the Free Software Foundation, either version 3 of the License, or  
 *  (at your option) any later version.  
 *   
 *  This program is distributed in the hope that it will be useful,  
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of  
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
 *  GNU General Public License for more details.  
 *   
 *  You should have received a copy of the GNU General Public License  
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
 *  
 *  Version:           3.0
 *  Implementation:    Yuri Carmona
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO_V3.h> 

// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// WiFi AP settings (CHANGE TO USER'S AP)
///////////////////////////////////////
char SSID[] = "libelium_teaming";
char PASSW[] = "libelium.2015";
///////////////////////////////////////

// Define static IP Address
///////////////////////////////////////
char STATIC_IP[]   = "192.168.43.201";
char GATEWAY[]     = "192.168.43.1";
char NETMASK[]     = "255.255.255.0";
char DNS_ADDRESS[] = "8.8.8.8";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;


void setup() 
{
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
  error = WIFI_PRO_V3.configureMode(WaspWIFI_v3::MODE_STATION);

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
  error = WIFI_PRO_V3.configureStation(SSID, PASSW);

  if (error == 0)
  {
    USB.println(F("4. WiFi configured SSID OK"));
  }
  else
  {
    USB.println(F("4. WiFi configured SSID ERROR"));
  }



  //////////////////////////////////////////////////
  // 5. Set static IP address
  //////////////////////////////////////////////////  

  // set IP address
  error = WIFI_PRO_V3.configureStationSettings( WaspWIFI_v3::DHCP_DISABLED, STATIC_IP, NETMASK, GATEWAY);

  // Check answer
  if (error == 0)
  {    
    USB.println(F("5. Static IP set OK"));
  }
  else
  {
    USB.println(F("5. Error calling 'setIP' function")); 
  }


  //////////////////////////////////////////////////
  // 6. Set DNS server
  //////////////////////////////////////////////////  

  // set DNS address
  error = WIFI_PRO_V3.setDNS(DNS_ADDRESS);

  // Check answer
  if (error == 0)
  {    
    USB.println(F("6. DNS server set OK"));
  }
  else
  {
    USB.println(F("6. Error calling 'setDNS' function")); 
  }




  //////////////////////////////////////////////////
  // 7. Connect to AP
  //////////////////////////////////////////////////
  error = WIFI_PRO_V3.connect();

  if (error == 0)
  {
    USB.println(F("7. WiFi connected to AP OK"));

    USB.print(F("SSID: "));
    USB.println(WIFI_PRO_V3._essid);
    
    USB.print(F("Channel: "));
    USB.println(WIFI_PRO_V3._channel, DEC);

    USB.print(F("Signal strength: "));
    USB.print(WIFI_PRO_V3._power, DEC);
    USB.println("dB");

    USB.print(F("IP address: "));
    USB.println(WIFI_PRO_V3._ip);

    USB.print(F("GW address: "));
    USB.println(WIFI_PRO_V3._gw);

    USB.print(F("Netmask address: "));
    USB.println(WIFI_PRO_V3._netmask);

    WIFI_PRO_V3.getMAC();

    USB.print(F("MAC address: "));
    USB.println(WIFI_PRO_V3._mac);
  }
  else
  {
    USB.println(F("7. WiFi connect to AP ERROR"));

    USB.print(F("Disconnect status: "));
    USB.println(WIFI_PRO_V3._status, DEC);

    USB.print(F("Disconnect reason: "));
    USB.println(WIFI_PRO_V3._reason, DEC);

    /*
      enum ConnectionFailureReason{
        REASON_INTERNAL_FAILURE = 1,
        REASON_AUTH_NO_LONGER_VALID = 2,
        REASON_DEAUTH_STATION_LEAVING = 3,
        REASON_DISASSOCIATED_INACTIVITY = 4,
        REASON_DISASSOCIATED_AP_HANDLE_ERROR = 5,
        REASON_PACKET_RECEIVED_FROM_NONAUTH_STATION = 6,
        REASON_PACKET_RECEIVED_FROM_NONASSOC_STATION = 7,
        REASON_DISASSOCIATED_STATION_LEAVING = 8,
        REASON_STATION_REQUEST_REASSOC = 9,
        REASON_DISASSOCIATED_PWR_CAPABILITY_UNACCEPTABLE = 10,
        REASON_DISASSOCIATED_SUPPORTED_CHANNEL_UNACCEPTABLE = 11,
        REASON_INVALID_ELEMENT = 13,
        REASON_MIC_FAILURE = 14,
        REASON_FOUR_WAY_HANDSHAKE_TIMEOUT = 15,
        REASON_GROUP_KEY_HANDSHAKE_TIMEOUT = 16,
        REASON_ELEMENT_IN_FOUR_WAY_HANDSHAKE_DIFFERENT = 17,
        REASON_INVALID_GROUP_CIPHER = 18,
        REASON_INVALID_PAIRWISE_CIPHER = 19,
        REASON_AKMP = 20,
        REASON_UNSUPPORTED_RSNE_CAPABILITIES = 21,
        REASON_INVALID_RSNE_CAPABILITIES = 22,
        REASON_IEEE_AUTH_FAILED = 23,
        REASON_CIPHER_SUITE_REJECTED = 24,
        REASON_STATION_LOST_BEACONS_CONTINUOUSLY = 200,
        REASON_STATION_FAILED_TO_SCAN_TARGET_AP = 201,
        REASON_STATION_AUTH_FAILED_NOT_TIMEOUT = 202,
        REASON_STATION_AUTH_FAILED_NOT_TIMEOUT_NOT_MANY_STATIONS = 203,
        REASON_HANDHASKE_FAILED = 204,
      };
    */
  }

  USB.println(F("Setup DONE\n\n"));
}



void loop()
{
  
}
