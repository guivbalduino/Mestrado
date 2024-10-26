/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to configure several Access
 *  Point profiles in order to join different networks to improve the
 *  robustness of the deployment (i.e. the Waspmote moves inside a building)
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
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
 *  along with this program.  If not, see <http://wwProfileClientEnumw.gnu.org/licenses/>.  
 *  
 *  Version:           3.0
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona
 */


#include <WaspWIFI_PRO.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// WiFi AP settings (CHANGE TO USER'S AP)
/////////////////////////////////
char ESSID_0[]   = "ANDROID";
char AUTHKEY_0[] = "yuripass";
/////////////////////////////////
char ESSID_1[]   = "libelium_AP";
char AUTHKEY_1[] = "password";
/////////////////////////////////
char ESSID_2[]   = "libelium_wsn2";
char AUTHKEY_2[] = "libelium.2012_";
/////////////////////////////////


uint8_t error;
uint8_t status;
unsigned long previous;



void setup() 
{
  USB.println(F("Start program"));


  //////////////////////////////////////////////////
  // 1. Switch ON the WiFi module
  //////////////////////////////////////////////////
  error = WIFI_PRO.ON(socket);

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
  error = WIFI_PRO.resetValues();

  if (error == 0)
  {    
    USB.println(F("2. WiFi reset to default"));
  }
  else
  {
    USB.println(F("2. WiFi reset to default ERROR"));
  }


  //////////////////////////////////////////////////
  // 3. Set PROFILE_0
  //////////////////////////////////////////////////

  // 3.1. Set ESSID
  error = WIFI_PRO.setESSID( PROFILE_0, ESSID_0 );

  if (error == 0)
  {    
    USB.println(F("3.1. WiFi set ESSID_0 OK"));
  }
  else
  {
    USB.println(F("3.1. WiFi set ESSID_0 ERROR"));
  }

  // 3.2. Set AUTHKEY
  error = WIFI_PRO.setPassword( PROFILE_0, WPA2, AUTHKEY_0 );

  if (error == 0)
  {    
    USB.println(F("3.2. WiFi set AUTHKEY_0 OK"));
  }
  else
  {
    USB.println(F("3.2. WiFi set AUTHKEY_0 ERROR"));
  }


  //////////////////////////////////////////////////
  // 4. Set PROFILE_1
  //////////////////////////////////////////////////

  // 4.1. Set ESSID
  error = WIFI_PRO.setESSID( PROFILE_1, ESSID_1 );

  if (error == 0)
  {    
    USB.println(F("4.1. WiFi set ESSID_1 OK"));
  }
  else
  {
    USB.println(F("4.1. WiFi set ESSID_1 ERROR"));
  }  

  // 4.2. Set AUTHKEY
  error = WIFI_PRO.setPassword( PROFILE_1, WPA2, AUTHKEY_1 );

  if (error == 0)
  {    
    USB.println(F("4.2. WiFi set AUTHKEY_1 OK"));
  }
  else
  {
    USB.println(F("4.2. WiFi set AUTHKEY_1 ERROR"));
  }


  //////////////////////////////////////////////////
  // 5. Set PROFILE_2
  //////////////////////////////////////////////////

  // 5.1. Set ESSID
  error = WIFI_PRO.setESSID( PROFILE_2, ESSID_2 );

  if (error == 0)
  {    
    USB.println(F("5.1. WiFi set ESSID_2 OK"));
  }
  else
  {
    USB.println(F("5.1. WiFi set ESSID_2 ERROR"));
  }

  // 5.2. Set AUTHKEY
  error = WIFI_PRO.setPassword( PROFILE_2, WPA2, AUTHKEY_2 );

  if (error == 0)
  {    
    USB.println(F("5.2. WiFi set AUTHKEY_2 OK"));
  }
  else
  {
    USB.println(F("5.2. WiFi set AUTHKEY_2 ERROR"));
  }


  //////////////////////////////////////////////////
  // 6. Software Reset 
  // Parameters take effect following either a 
  // hardware or software reset
  //////////////////////////////////////////////////
  error = WIFI_PRO.softReset();

  if (error == 0)
  {    
    USB.println(F("6. WiFi softReset OK"));
  }
  else
  {
    USB.println(F("6. WiFi softReset ERROR"));
  }

  USB.println(F("SETUP done\n\n"));
}



void loop()
{ 

  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO.ON(socket);

  if (error == 0)
  {    
    USB.println(F("WiFi switched ON"));
  }
  else
  {
    USB.println(F("WiFi did not initialize correctly"));
  }


  //////////////////////////////////////////////////
  // 2. Join AP
  //////////////////////////////////////////////////  

  // get actual time
  previous = millis();

  /***********************************************************
   * WARNING: When multiple ESSIDs are set up, it is mandatory 
   * to use the 'isConnectedMultiple()' function in order to 
   * check connectivity to any of the APs defined.
   * Normally, it takes a while to join one of the APs defined.
   ************************************************************/

  // Check if module is connected
  if (WIFI_PRO.isConnectedMultiple() == true)
  {    
    USB.print(F("WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

    // Get actual 'Connection Status'
    error = WIFI_PRO.reportStatusComplete();

    if (error == 0)
    {
      USB.println(F("----------------------------------------"));
      USB.print(F("--> essid:"));    
      USB.println(WIFI_PRO._essid);
      USB.print(F("--> ip:"));    
      USB.println(WIFI_PRO._ip);
      USB.print(F("--> tx rate:"));
      USB.println(WIFI_PRO._rate, DEC );
      USB.print(F("--> signal level(%RSSI):"));
      USB.println(WIFI_PRO._level, DEC );
      USB.print(F("--> link quality(%SNR):"));
      USB.println(WIFI_PRO._quality, DEC );
      USB.print(F("--> AP bssid:"));    
      USB.println(WIFI_PRO._bssid);
      USB.print(F("--> channel:"));    
      USB.println(WIFI_PRO._channel,DEC);
      USB.print(F("--> SNR(dBm):"));    
      USB.println(WIFI_PRO._snr,DEC);
      USB.println(F("----------------------------------------"));
    }    
  }
  else
  {
    USB.print(F("WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
  }


  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 
  delay(5000);
}







