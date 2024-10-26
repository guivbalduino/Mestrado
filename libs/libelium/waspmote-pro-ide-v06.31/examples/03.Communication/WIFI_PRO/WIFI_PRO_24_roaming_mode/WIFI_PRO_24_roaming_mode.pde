/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to join an access point (AP)
 *  enabling roaming mode
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
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *  
 *  Version:           3.0
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;


void setup() 
{
  USB.ON();
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

  if (error == 0)
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }


  //////////////////////////////////////////////////
  // 2. Enable Roaming Mode
  //////////////////////////////////////////////////  

  // check connectivity
  error =  WIFI_PRO.roamingMode(ENABLED);

  // Check if module is connected
  if (error == 0)
  { 
    USB.println(F("2. WiFi set Roaming Mode OK"));
  }
  else
  {
    USB.println(F("2. Error calling 'roamingMode' function")); 
  }
  
  
  //////////////////////////////////////////////////
  // 3. Periodic WiFi Scan Interval
  //////////////////////////////////////////////////  

  // check connectivity
  error =  WIFI_PRO.setScanInterval(1);

  // Check if module is connected
  if (error == 0)
  { 
    USB.println(F("3. WiFi set Periodic Scan Interval OK"));
  }
  else
  {
    USB.println(F("3. Error calling 'setScanInterval' function")); 
  }
  
  
  //////////////////////////////////////////////////
  // 4. SNR Low Threshold
  //////////////////////////////////////////////////  

  // check connectivity
  error =  WIFI_PRO.setLowThreshold(20);

  // Check if module is connected
  if (error == 0)
  { 
    USB.println(F("4. WiFi set SNR Low Threshold OK"));
  }
  else
  {
    USB.println(F("4. Error calling 'setLowThreshold' function")); 
  }
    
  
  //////////////////////////////////////////////////
  // 5. SNR High Threshold
  //////////////////////////////////////////////////  

  // check connectivity
  error =  WIFI_PRO.setHighThreshold(30);

  // Check if module is connected
  if (error == 0)
  { 
    USB.println(F("5. WiFi set SNR High Threshold OK"));
  }
  else
  {
    USB.println(F("5. Error calling 'setHighThreshold' function")); 
  }
  
}



void loop()
{
  //////////////////////////////////////////////////
  // Check connectivity
  //////////////////////////////////////////////////  

  // get actual time
  previous = millis();

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  { 
    USB.print(F("WiFi is connected OK."));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

    // Get actual 'Connection Status'
    error = WIFI_PRO.reportStatusComplete();

    if (error == 0)
    {
      USB.println(F("------------------------------"));
      USB.print(F("--> ESSID:"));    
      USB.println(WIFI_PRO._essid);
      USB.print(F("--> IP address:"));    
      USB.println(WIFI_PRO._ip);
      USB.print(F("--> TX rate:"));
      USB.println(WIFI_PRO._rate, DEC );
      USB.print(F("--> Signal level(%RSSI):"));
      USB.println(WIFI_PRO._level, DEC );
      USB.print(F("--> link quality(%SNR):"));
      USB.println(WIFI_PRO._quality, DEC );
      USB.print(F("--> BSSID:"));    
      USB.println(WIFI_PRO._bssid);
      USB.print(F("--> channel:"));    
      USB.println(WIFI_PRO._channel,DEC);
      USB.print(F("--> SNR(dBm):"));    
      USB.println(WIFI_PRO._snr,DEC);
      USB.println(F("------------------------------"));
    }
  }
  else
  {
    USB.print(F("WiFi is connected ERROR.")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);  
  }


  USB.println(F("Wait 1 second...\n\n")); 
  delay(1000);
}
