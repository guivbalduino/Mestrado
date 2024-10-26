/*
    --------------- 4G_17 - A-GPS (MS-Assisted GPS)  ---------------

    Explanation: This example shows how to use de A-GPS in MS-Assisted mode
    This mode is less accurate but faster than other modes.

    Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L.
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

    Version:           3.2
    Design:            David Gascón
    Implementation:    Alejandro Gállego
*/
#include <Wasp4G.h>

// APN settings
///////////////////////////////////////
char apn[] = "gprs-service.com";
char login[] = "";
char password[] = "";
///////////////////////////////////////

// define variables
uint8_t error;
uint8_t gps_status;
float gps_latitude;
float gps_longitude;


void setup()
{
  USB.ON();
  USB.println("Start program");


  //////////////////////////////////////////////////
  // Set operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);

  //////////////////////////////////////////////////
  // Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();


  //////////////////////////////////////////////////
  // 1. Switch on the 4G module
  //////////////////////////////////////////////////
  error = _4G.ON();

  // check answer
  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // 2. Set 2G/3G network
    ////////////////////////////////////////////////
    // It is mandatory to work in 3G/2G netowrk 
    // to operate with the A-GPS functions
    error = _4G.setWirelessNetwork(Wasp4G::NETWORK_UTRAN);
    error = _4G.checkDataConnection(60);

    if (error == 0)  
    {
      USB.println(F("2. 4G module set 3G/2G network"));      
    }
    else
    {
      USB.println(F("2. Error calling the 'checkDataConnection' function"));
    }

    
    ////////////////////////////////////////////////
    // 3. Send AGPS HTTP request to the server
    ////////////////////////////////////////////////

    gps_status = _4G.gpsSendHttpRequest();

    // check answer
    if (gps_status == 0)
    {
      USB.println(F("3. GPS signal received"));

      USB.println(F("Acquired position:"));
      USB.println(F("----------------------------"));
      USB.print(F("Latitude: "));
      USB.println(_4G._latitude);
      USB.print(F("Longitude: "));
      USB.println(_4G._longitude);
      USB.println(F("----------------------------\n"));


      USB.println("Conversion to float variable type:");
      gps_latitude = atof(_4G._latitude);
      gps_longitude = atof(_4G._longitude);

      USB.print(F("Latitude: "));
      USB.printFloat(gps_latitude, 6);
      USB.println();
      USB.print(F("Longitude: "));
      USB.printFloat(gps_longitude, 6);
      USB.println();

    }
    else
    {
      USB.print(F("3. Error calling the 'gpsSendHttpRequest' function. Code: "));
      USB.println(gps_status, DEC);
    }


    ////////////////////////////////////////////////
    // 4. Set 4G/3G/2G network
    ////////////////////////////////////////////////
    error = _4G.setWirelessNetwork(Wasp4G::NETWORK_3GPP);
    error = _4G.checkDataConnection(60);
   
    if (error == 0)  
    {
      USB.println(F("4. 4G module set 4G/3G/2G network"));      
    }
    else
    {
      USB.println(F("4. Error calling the 'checkDataConnection' function"));
    }
    
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }
}



void loop()
{
  // do nothing

}

