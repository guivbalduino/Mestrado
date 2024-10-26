/*
    ------ LoRaWAN Code Example --------

    Explanation: This example shows how to configure the data rate.
    The possibilities are:

      LoRaWAN EU or IN or ASIA-PAC / LATAM:

      0: SF = 12, BW = 125 kHz, BitRate =  250 bps
      1: SF = 11, BW = 125 kHz, BitRate =  440 bps
      2: SF = 10, BW = 125 kHz, BitRate =  980 bps
      3: SF =  9, BW = 125 kHz, BitRate = 1760 bps
      4: SF =  8, BW = 125 kHz, BitRate = 3125 bps
      5: SF =  7, BW = 125 kHz, BitRate = 5470 bps

      LoRaWAN US or AU:

      0: SF = 10, BW = 125 kHz, BitRate =   980 bps
      1: SF =  9, BW = 125 kHz, BitRate =  1760 bps
      2: SF =  8, BW = 125 kHz, BitRate =  3125 bps
      3: SF =  7, BW = 125 kHz, BitRate =  5470 bps

      LoRaWAN JP:

      0: SF = 12, BW = 125 kHz, BitRate =   250 bps
      1: SF = 11, BW = 125 kHz, BitRate =   440 bps
      2: SF = 10, BW = 125 kHz, BitRate =   980 bps
      3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
      4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
      5: SF =  7, BW = 125 kHz, BitRate =  5470 bps
      6: SF =  7, BW = 250 kHz, BitRate = 11000 bps

      LoRaWAN KR:

      0: SF = 12, BW = 125 kHz, BitRate =   250 bps
      1: SF = 11, BW = 125 kHz, BitRate =   440 bps
      2: SF = 10, BW = 125 kHz, BitRate =   980 bps
      3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
      4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
      5: SF =  7, BW = 125 kHz, BitRate =  5470 bps

    Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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

    Version:           3.6
    Design:            David Gascon
    Implementation:    Luismi Marti
*/

#include <WaspLoRaWAN.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// variable
uint8_t error;


void setup()
{
  USB.ON();
  USB.println(F("LoRaWAN example - Data Rate configuration"));
  USB.println(F("\nData Rate options:"));

  //////////////////////////////////////////////
  // 1. switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("1. Switch ON OK"));
  }
  else
  {
    USB.print(F("1. Switch ON error = "));
    USB.println(error, DEC);
  }

  if (LoRaWAN._version == RN2483_MODULE || LoRaWAN._version == RN2903_IN_MODULE || LoRaWAN._version == RN2903_AS_MODULE)
  {
    USB.println(F("------------------------------------------------------"));
    USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
    USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
    USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
    USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
    USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
    USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
    USB.println(F("------------------------------------------------------\n"));
  }
  else if (LoRaWAN._version == RN2903_MODULE)
  {
    USB.println(F("------------------------------------------------------"));
    USB.println(F("  0: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
    USB.println(F("  1: SF = 9,  BW = 125 kHz, BitRate =  1760 bps"));
    USB.println(F("  2: SF = 8,  BW = 125 kHz, BitRate =  3125 bps"));
    USB.println(F("  3: SF = 7,  BW = 125 kHz, BitRate =  5470 bps"));
    USB.println(F("------------------------------------------------------\n"));
  }
  else if (LoRaWAN._version == ABZ_MODULE)
  {
    // Get band
    error = LoRaWAN.getBand();

    // Check status
    if ( error == 0 )
    {
      if (LoRaWAN._bandABZ == BAND_JP923)
      {
        USB.println(F("------------------------------------------------------"));
        USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
        USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
        USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
        USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
        USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
        USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
        USB.println(F("  6: SF =  7, BW = 250 kHz, BitRate = 11000 bps"));
        USB.println(F("------------------------------------------------------\n"));
      }
      else if (LoRaWAN._bandABZ == BAND_KR920)
      {
        USB.println(F("------------------------------------------------------"));
        USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
        USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
        USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
        USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
        USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
        USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
        USB.println(F("------------------------------------------------------\n"));
      }
    }
    else
    {
      USB.print(F("1.1. Get band error = "));
      USB.println(error, DEC);
    }

  }
  //////////////////////////////////////////////
  // 2. Set Data Rate
  //////////////////////////////////////////////

  error = LoRaWAN.setDataRate(2);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("2. Data rate set OK"));
  }
  else
  {
    USB.print(F("2. Data rate set error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 3. Get Data Rate
  //////////////////////////////////////////////

  error = LoRaWAN.getDataRate();

  // Check status
  if ( error == 0 )
  {
    USB.print(F("3. Data rate get OK. "));
    USB.print(F("Data rate index:"));
    USB.println(LoRaWAN._dataRate, DEC);
  }
  else
  {
    USB.print(F("3. Data rate get error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Save configuration
  //////////////////////////////////////////////

  error = LoRaWAN.saveConfig();

  // Check status
  if ( error == 0 )
  {
    USB.println(F("4. Save configuration OK"));
  }
  else
  {
    USB.print(F("4. Save configuration error = "));
    USB.println(error, DEC);
  }

}


void loop()
{

}
