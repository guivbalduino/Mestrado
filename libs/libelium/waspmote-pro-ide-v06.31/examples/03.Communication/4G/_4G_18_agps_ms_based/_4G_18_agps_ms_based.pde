/*
    --------------- 4G_18 - A-GPS (MS-Based GPS)  ---------------

    Explanation: This example shows how to use de A-GPS in MS-Based mode

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Alejandro Gállego
*/

#include <Wasp4G.h>

// APN settings
///////////////////////////////////////
char apn[] = "movistar.es";
char login[] = "movistar";
char password[] = "movistar";
///////////////////////////////////////

// define variables
uint8_t error;
uint8_t gps_status;
float gps_latitude;
float gps_longitude;
uint32_t previous;
bool gps_autonomous_needed = true;


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
    // 2. Start GPS feature
    ////////////////////////////////////////////////

    // get current time
    previous = millis();

    gps_status = _4G.gpsStart(Wasp4G::GPS_MS_BASED);

    // check answer
    if (gps_status == 0)
    {
      USB.print(F("2. GPS started in MS-BASED. Time(secs) = "));
      USB.println((millis()-previous)/1000);
    }
    else
    {
      USB.print(F("2. Error calling the 'gpsStart' function. Code: "));
      USB.println(gps_status, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
    USB.println(F("The code stops here."));
    while (1);
  }
}



void loop()
{
  ////////////////////////////////////////////////
  // Wait for satellite signals and get values
  ////////////////////////////////////////////////
  if (gps_status == 0)
  {
    error = _4G.waitForSignal(20000);

    if (error == 0)
    {
      USB.print(F("3. GPS signal received. Time(secs) = "));
      USB.println((millis()-previous)/1000);

      USB.println(F("Acquired position:"));
      USB.println(F("----------------------------"));
      USB.print(F("Latitude: "));
      USB.print(_4G._latitude);
      USB.print(F(","));
      USB.println(_4G._latitudeNS);
      USB.print(F("Longitude: "));
      USB.print(_4G._longitude);
      USB.print(F(","));
      USB.println(_4G._longitudeEW);
      USB.print(F("UTC_time: "));
      USB.println(_4G._time);
      USB.print(F("date: "));
      USB.println(_4G._date);
      USB.print(F("Number of satellites: "));
      USB.println(_4G._numSatellites, DEC);
      USB.print(F("HDOP: "));
      USB.println(_4G._hdop);
      USB.println(F("----------------------------"));

      // get degrees
      gps_latitude  = _4G.convert2Degrees(_4G._latitude, _4G._latitudeNS);
      gps_longitude = _4G.convert2Degrees(_4G._longitude, _4G._longitudeEW);

      USB.println("Conversion to degrees:");
      USB.print(F("Latitude: "));
      USB.println(gps_latitude);
      USB.print(F("Longitude: "));
      USB.println(gps_longitude);
      USB.println();


      ////////////////////////////////////////////////
      // Change to AUTONOMOUS mode if needed
      ////////////////////////////////////////////////

      if (gps_autonomous_needed == true)
      {
        _4G.gpsStop();

        gps_status = _4G.gpsStart(Wasp4G::GPS_AUTONOMOUS);

        // check answer
        if (gps_status == 0)
        {
          USB.println(F("GPS started in AUTONOMOUS mode"));

          // update variable
          gps_autonomous_needed = false;
        }
        else
        {
          USB.print(F("Error calling the 'gpsStart' function. Code: "));
          USB.println(gps_status, DEC);
        }
      }

      delay(10000);
    }
    else
    {
      USB.print("no satellites fixed. Error: ");
      USB.println(error, DEC);
    }
  }
  else
  {
    ////////////////////////////////////////////////
    // Restart GPS feature
    ////////////////////////////////////////////////

    USB.println(F("Restarting the GPS engine"));

    // stop GPS
    _4G.gpsStop();
    delay(1000);

    // start GPS
    gps_status = _4G.gpsStart(Wasp4G::GPS_MS_BASED);

    // check answer
    if (gps_status == 0)
    {
      USB.print(F("GPS started in MS-BASED. Time(ms) = "));
      USB.println(millis() - previous);
    }
    else
    {
      USB.print(F("Error calling the 'gpsStart' function. Code: "));
      USB.println(gps_status, DEC);
    }
  }

}

