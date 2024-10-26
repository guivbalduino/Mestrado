/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to set up static settings for
 *  the WiFi module. In this example it is shown how to set the static 
 *  IP address, the DNS server address, the gateway address and the 
 *  netmask address
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

// Define static IP Address
///////////////////////////////////////
char STATIC_IP[]   = "10.10.10.12";
char DNS_ADDRESS[] = "8.8.8.8";
char GATEWAY[]     = "10.10.10.1";
char NETMASK[]     = "255.255.128.0";
///////////////////////////////////////

uint8_t error;
uint8_t status;
unsigned long previous;


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

  if (error == 0)
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }


  //////////////////////////////////////////////////
  // 2. Set static IP address
  //////////////////////////////////////////////////  

  // set IP address
  error = WIFI_PRO.setIP(STATIC_IP);

  // Check answer
  if (error == 0)
  {    
    USB.println(F("2. Static IP set OK"));
  }
  else
  {
    USB.println(F("2. Error calling 'setIP' function")); 
    WIFI_PRO.printErrorCode();
  }


  //////////////////////////////////////////////////
  // 3. Set DNS server
  //////////////////////////////////////////////////  

  // set DNS address
  error = WIFI_PRO.setDNS(DNS_ADDRESS);

  // Check answer
  if (error == 0)
  {    
    USB.println(F("3. DNS server set OK"));
  }
  else
  {
    USB.println(F("3. Error calling 'setDNS' function")); 
    WIFI_PRO.printErrorCode();
  }


  //////////////////////////////////////////////////
  // 4. Set DNS server
  //////////////////////////////////////////////////  

  // set GW address
  error = WIFI_PRO.setGateway(GATEWAY);

  // Check answer
  if (error == 0)
  {    
    USB.println(F("4. Gateway set OK"));
  }
  else
  {
    USB.println(F("4. Error calling 'setGateway' function")); 
    WIFI_PRO.printErrorCode();
  }


  //////////////////////////////////////////////////
  // 5. Set Subnet mask address
  //////////////////////////////////////////////////  

  // set Netmask
  error = WIFI_PRO.setNetmask(NETMASK);

  // Check answer
  if (error == 0)
  {    
    USB.println(F("5. Netmask set OK"));
  }
  else
  {
    USB.println(F("5. Error calling 'setNetmask' function")); 
    WIFI_PRO.printErrorCode();
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
    USB.println(F("6. Error calling 'softReset' function"));
  }


  USB.println(F("Setup DONE\n\n"));
}



void loop()
{     
  
  // get actual time
  previous = millis();
  
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
  // 2. Check if connected
  //////////////////////////////////////////////////  

  // check connectivity
  status = WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  {    
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);

    ///////////////////////////////////////////////
    // 2.1. current ESSID
    ///////////////////////////////////////////////
    error = WIFI_PRO.getESSID();

    // check response
    if (error == 0)
    {
      USB.print(F("2.1. Current ESSID: "));
      USB.println( WIFI_PRO._essid );
    }
    else
    {
      USB.println(F("2.1. Error calling 'getESSID' function"));
      WIFI_PRO.printErrorCode();
    }

    ///////////////////////////////////////////////
    // 2.2. get active IP address
    ///////////////////////////////////////////////
    error = WIFI_PRO.getIP();

    if (error == 0)
    {    
      USB.print(F("2.2. IP address:"));
      USB.println(WIFI_PRO._ip);

    }
    else
    {
      USB.println(F("2.2. Error calling 'getIP' function"));
    }    
    
    ///////////////////////////////////////////////
    // 2.3. ping
    ///////////////////////////////////////////////
    error = WIFI_PRO.ping("www.google.com"); 

    // check response
    if (error == 0)
    {
      USB.print(F("2.3. Round Trip Time (ms) = "));
      USB.println( WIFI_PRO._rtt, DEC );      
    }
    else
    {
      USB.println(F("2.3. Error calling 'ping' function"));
      WIFI_PRO.printErrorCode();
    }
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);
  }
  
  //////////////////////////////////////////////////
  // 3. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO.OFF(socket);
  USB.println(F("WiFi switched OFF\n\n")); 

  delay(10000);  
}


