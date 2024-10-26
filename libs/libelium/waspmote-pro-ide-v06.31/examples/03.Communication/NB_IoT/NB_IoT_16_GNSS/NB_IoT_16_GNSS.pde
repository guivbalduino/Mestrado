/*
    --------------- NB_IoT16 - GNSS  ---------------

    Explanation: This example shows how to use GNSS features

    *  Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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
    *  Version:           3.2
    *  Design:            David Gascón
    *  Implementation:    P.Moreno, J.Siscart
    */

#include <WaspBG96.h>

// define variables
uint8_t error;
uint8_t gps_status;
float gps_latitude;
float gps_longitude;
uint32_t previous;


void setup()
{
  USB.ON();
  USB.println("Start program");


  //////////////////////////////////////////////////
  // 1. Switch on the BG96 module
  //////////////////////////////////////////////////
  error = BG96.ON();

  // check answer
  if (error == 0)
  {
    USB.println(F("1. BG96 module ready..."));


    ////////////////////////////////////////////////
    // 2. Start GPS feature
    ////////////////////////////////////////////////

    // get current time
    previous = millis();

    // init GPS feature
    gps_status = BG96.gpsStart();

    // check answer
    if (gps_status == 0)
    {
      USB.print(F("2. GNSS started. Time(secs) = "));
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
    USB.println(F("1. BG96 module not started"));
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
    error = BG96.waitForSignal(20000);
    if (error == 0)
    {
      USB.print(F("3. GPS signal received. Time(secs) = "));
      USB.println((millis()-previous)/1000);

      USB.println(F("Acquired position:"));
      USB.println(F("----------------------------"));
      USB.print(F("Latitude: "));
      USB.print(BG96._latitude);
      USB.print(F(","));
      USB.println(BG96._latitudeNS);
      USB.print(F("Longitude: "));
      USB.print(BG96._longitude);
      USB.print(F(","));
      USB.println(BG96._longitudeEW);
      USB.print(F("Altitude: "));
      USB.println(BG96._altitude);
      USB.print(F("Speed: "));
      USB.println(BG96._speedOG);
      USB.print(F("COG: "));
      USB.println(BG96._courseOG);
      USB.print(F("UTC_time: "));
      USB.println(BG96._time);
      USB.print(F("date: "));
      USB.println(BG96._date);
      USB.print(F("Number of satellites: "));
      USB.println(BG96._numSatellites, DEC);
      USB.print(F("HDOP: "));
      USB.println(BG96._hdop);
      USB.println(F("----------------------------"));

      // get degrees
      gps_latitude  = BG96.convert2Degrees(BG96._latitude, BG96._latitudeNS);
      gps_longitude = BG96.convert2Degrees(BG96._longitude, BG96._longitudeEW);

      USB.println("Conversion to degrees:");
      USB.print(F("Latitude: "));
      USB.println(gps_latitude);
      USB.print(F("Longitude: "));
      USB.println(gps_longitude);
      USB.println();
      delay(10000);
    }
    else
    {
      USB.println("no satellites fixed");
    }
  }
  else
  {
    ////////////////////////////////////////////////
    // Restart GPS feature
    ////////////////////////////////////////////////

    USB.println(F("Restarting the GPS engine"));

    // stop GPS
    BG96.gpsStop();
    delay(1000);

    // start GPS
    gps_status = BG96.gpsStart();
  }  

}
