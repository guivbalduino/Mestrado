/*
    ------ LoRaWAN Code Example --------

    Explanation: This example shows how to configure the power level
    LoRaWAN interface:
            AS923     AU915     EU868     KR920     IN865    US915
      0:   16 dBm    20 dBm    14 dBm    14 dBm    20 dBm    N/A  
      1:   14 dBm    18 dBm    12 dBm    12 dBm    18 dBm    N/A  
      2:   12 dBm    16 dBm    10 dBm    10 dBm    16 dBm    N/A  
      3:   10 dBm    14 dBm     8 dBm     8 dBm    14 dBm    N/A  
      4:    8 dBm    12 dBm     6 dBm     6 dBm    12 dBm    N/A  
      5:    6 dBm    10 dBm     4 dBm     4 dBm    10 dBm   20 dBm
      6:    4 dBm     8 dBm     2 dBm     2 dBm     8 dBm   18 dBm
      7:    2 dBm     6 dBm     0 dBm     0 dBm     6 dBm   16 dBm
      8:    N/A       4 dBm     N/A       N/A       4 dBm   14 dBm
      9:    N/A       2 dBm     N/A       N/A       2 dBm   12 dBm
      10:   N/A       0 dBm     N/A       N/A       0 dBm   10 dBm

    Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Luismi Marti
*/

#include <WaspLoRaWAN_Global.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// variable
uint8_t error;


void setup()
{
  USB.ON();
  USB.println(F("LoRaWAN example - Power configuration"));

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

  LoRaWAN.factoryReset();

  USB.println(F("-------------------------------------------------------------"));
  USB.println(F("      AS923     AU915     EU868     KR920     IN865     US915"));
  USB.println(F("0:   16 dBm    20 dBm    14 dBm    14 dBm    20 dBm     N/A  "));
  USB.println(F("1:   14 dBm    18 dBm    12 dBm    12 dBm    18 dBm     N/A  "));
  USB.println(F("2:   12 dBm    16 dBm    10 dBm    10 dBm    16 dBm     N/A  "));
  USB.println(F("3:   10 dBm    14 dBm     8 dBm     8 dBm    14 dBm     N/A  "));
  USB.println(F("4:    8 dBm    12 dBm     6 dBm     6 dBm    12 dBm     N/A  "));
  USB.println(F("5:    6 dBm    10 dBm     4 dBm     4 dBm    10 dBm    20 dBm"));
  USB.println(F("6:    4 dBm     8 dBm     2 dBm     2 dBm     8 dBm    18 dBm"));
  USB.println(F("7:    2 dBm     6 dBm     0 dBm     0 dBm     6 dBm    16 dBm"));
  USB.println(F("8:    N/A       4 dBm     N/A       N/A       4 dBm    14 dBm"));
  USB.println(F("9:    N/A       2 dBm     N/A       N/A       2 dBm    12 dBm"));
  USB.println(F("10:   N/A       0 dBm     N/A       N/A       0 dBm    10 dBm"));
  USB.println(F("-------------------------------------------------------------\n"));

  //////////////////////////////////////////////
  // 2. Set region
  //////////////////////////////////////////////
  //  LoRaWAN_Region:
  //      AS923
  //      AU915
  //      EU868
  //      KR920
  //      IN865
  //      US915
  //////////////////////////////////////////////
  // Initialize band with one of the list above
  //////////////////////////////////////////////
  
  // LoRaWAN_Region band = *band_of_your_choice*;
  LoRaWAN_Region band = AS923;
  
  error = LoRaWAN.setBand(band);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("2. Set region band OK"));
  }
  else
  {
    USB.print(F("2. Set region band error = "));
    USB.println(error, DEC);
  }

  switch (LoRaWAN._band)
  {

    case AS923:
      USB.println(F("----------"));
      USB.println(F("   AS923"));
      USB.println(F("----------"));
      USB.println(F("0: 16 dBm"));
      USB.println(F("1: 14 dBm"));
      USB.println(F("2: 12 dBm"));
      USB.println(F("3: 10 dBm"));
      USB.println(F("4:  8 dBm"));
      USB.println(F("5:  6 dBm"));
      USB.println(F("6:  4 dBm"));
      USB.println(F("7:  2 dBm"));
      USB.println(F("----------\n"));

      break;


    case AU915:
      USB.println(F("----------"));
      USB.println(F(" AU915"));
      USB.println(F("----------"));
      USB.println(F("0: 20 dBm"));
      USB.println(F("1: 18 dBm"));
      USB.println(F("2: 16 dBm"));
      USB.println(F("3: 14 dBm"));
      USB.println(F("4: 12 dBm"));
      USB.println(F("5: 10 dBm"));
      USB.println(F("6:  8 dBm"));
      USB.println(F("7:  6 dBm"));
      USB.println(F("8:  4 dBm"));
      USB.println(F("9:  2 dBm"));
      USB.println(F("10: 0 dBm"));
      USB.println(F("----------\n"));

      break;

    case EU868:
      USB.println(F("----------"));
      USB.println(F(" EU868"));
      USB.println(F("----------"));
      USB.println(F("0: 14 dBm"));
      USB.println(F("1: 12 dBm"));
      USB.println(F("2: 10 dBm"));
      USB.println(F("3:  8 dBm"));
      USB.println(F("4:  6 dBm"));
      USB.println(F("5:  4 dBm"));
      USB.println(F("6:  2 dBm"));
      USB.println(F("7:  0 dBm"));
      USB.println(F("----------\n"));

      break;


    case KR920:
      USB.println(F("----------"));
      USB.println(F(" KR920"));
      USB.println(F("----------"));
      USB.println(F("0: 14 dBm"));
      USB.println(F("1: 12 dBm"));
      USB.println(F("2: 10 dBm"));
      USB.println(F("3:  8 dBm"));
      USB.println(F("4:  6 dBm"));
      USB.println(F("5:  4 dBm"));
      USB.println(F("6:  2 dBm"));
      USB.println(F("7:  0 dBm"));
      USB.println(F("----------\n"));

      break;

    case IN865:
      USB.println(F("----------"));
      USB.println(F(" IN865"));
      USB.println(F("----------"));
      USB.println(F("0: 20 dBm"));
      USB.println(F("1: 18 dBm"));
      USB.println(F("2: 16 dBm"));
      USB.println(F("3: 14 dBm"));
      USB.println(F("4: 12 dBm"));
      USB.println(F("5: 10 dBm"));
      USB.println(F("6:  8 dBm"));
      USB.println(F("7:  6 dBm"));
      USB.println(F("8:  4 dBm"));
      USB.println(F("9:  2 dBm"));
      USB.println(F("10: 0 dBm"));
      USB.println(F("----------\n"));

      break;


    case US915:
      USB.println(F("----------"));
      USB.println(F("  US915"));
      USB.println(F("----------"));
      USB.println(F("5: 20 dBm"));
      USB.println(F("6: 18 dBm"));
      USB.println(F("7: 16 dBm"));
      USB.println(F("8: 14 dBm"));
      USB.println(F("9: 12 dBm"));
      USB.println(F("10:10 dBm"));
      USB.println(F("----------\n"));

      break;

  }


  //////////////////////////////////////////////
  // 3. Set Power level
  //////////////////////////////////////////////

  error = LoRaWAN.setPower(5);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("3. Power level set OK"));
  }
  else
  {
    USB.print(F("3. Power level set error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Get Device EUI
  //////////////////////////////////////////////

  error = LoRaWAN.getPower();

  // Check status
  if ( error == 0 )
  {
    USB.print(F("4. Power level get OK. "));
    USB.print(F("Power index:"));
    USB.println(LoRaWAN._powerIndex, DEC);
  }
  else
  {
    USB.print(F("4. Power level set error = "));
    USB.println(error, DEC);
  }
}


void loop()
{

}
