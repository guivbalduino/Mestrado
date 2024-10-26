/*
    ------ LoRaWAN Code Example --------

    Explanation: This example shows how to configure the power level
    LoRaWAN interface:
          EU       433 MHz    US       AU       IN        ASIA-PAC/LATAM   JP       KR
      0:  N/A       10 dBm    N/A      N/A      20 dBm    20 dBm           16 dBm   14 dBm
      1:  14 dBm     7 dBm    N/A      N/A      18 dBm    18 dBm           14 dBm   12 dBm
      2:  11 dBm     4 dBm    N/A      N/A      16 dBm    16 dBm           12 dBm   10 dBm
      3:   8 dBm     1 dBm    N/A      N/A      14 dBm    14 dBm           10 dBm   8  dBm
      4:   5 dBm    -2 dBm    N/A      N/A      12 dBm    12 dBm           8  dBm   6  dBm
      5:   2 dBm    -5 dBm   20 dBm   20 dBm    10 dBm    10 dBm           6  dBm   4  dBm
      6:  N/A       N/A      18 dBm   18 dBm    N/A       N/A              4  dBm   2  dBm
      7:  N/A       N/A      16 dBm   16 dBm    N/A       N/A              2  dBm   0  dBm
      8:  N/A       N/A      14 dBm   14 dBm    N/A       N/A              N/A      N/A
      9:  N/A       N/A      12 dBm   12 dBm    N/A       N/A              N/A      N/A
      10: N/A       N/A      10 dBm   10 dBm    N/A       N/A              N/A      N/A

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

    Version:           3.5
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


  if (LoRaWAN._version == RN2483_MODULE || LoRaWAN._version == RN2903_IN_MODULE || LoRaWAN._version == RN2903_AS_MODULE)
  {
    USB.println(F("------------------------------------------------------"));
    USB.println(F("    EU         433 MHz     IN         ASIA-PAC / LATAM"));
    USB.println(F("0:  N/A         10 dBm     20 dBm     20 dBm"));
    USB.println(F("1:  14 dBm       7 dBm     18 dBm     18 dBm"));
    USB.println(F("2:  11 dBm       4 dBm     16 dBm     16 dBm"));
    USB.println(F("3:   8 dBm       1 dBm     14 dBm     14 dBm"));
    USB.println(F("4:   5 dBm      -2 dBm     12 dBm     12 dBm"));
    USB.println(F("5:   2 dBm      -5 dBm     10 dBm     10 dBm"));
    USB.println(F("------------------------------------------------------\n"));
  }
  else if (LoRaWAN._version == RN2903_MODULE)
  {
    USB.println(F("------------------------------------------------------"));
    USB.println(F("     US/AU"));
    USB.println(F("5:   20 dBm"));
    USB.println(F("6:   18 dBm"));
    USB.println(F("7:   16 dBm"));
    USB.println(F("8:   14 dBm"));
    USB.println(F("9:   12 dBm"));
    USB.println(F("10:  10 dBm"));
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
        USB.println(F("     JP"));
        USB.println(F("0:   16 dBm"));
        USB.println(F("1:   14 dBm"));
        USB.println(F("2:   12 dBm"));
        USB.println(F("3:   10 dBm"));
        USB.println(F("4:   8 dBm"));
        USB.println(F("5:   6 dBm"));
        USB.println(F("6:   4 dBm"));
        USB.println(F("7:   2 dBm"));
        USB.println(F("------------------------------------------------------\n"));
      }
      else if (LoRaWAN._bandABZ == BAND_KR920)
      {
        USB.println(F("------------------------------------------------------"));
        USB.println(F("     KR"));
        USB.println(F("0:   14 dBm"));
        USB.println(F("1:   12 dBm"));
        USB.println(F("2:   10 dBm"));
        USB.println(F("3:   8 dBm"));
        USB.println(F("4:   6 dBm"));
        USB.println(F("5:   4 dBm"));
        USB.println(F("6:   2 dBm"));
        USB.println(F("7:   0 dBm"));
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
  // 2. Set Power level
  //////////////////////////////////////////////

  error = LoRaWAN.setPower(5);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("2. Power level set OK"));
  }
  else
  {
    USB.print(F("2. Power level set error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 3. Get Device EUI
  //////////////////////////////////////////////

  error = LoRaWAN.getPower();

  // Check status
  if ( error == 0 )
  {
    USB.print(F("3. Power level get OK. "));
    USB.print(F("Power index:"));
    USB.println(LoRaWAN._powerIndex, DEC);
  }
  else
  {
    USB.print(F("3. Power level set error = "));
    USB.println(error, DEC);
  }


  USB.println(F("------------------------------------"));
  USB.println(F("Keep in mind the power setting cannot"));
  USB.println(F("be saved in the module's memory. Every"));
  USB.println(F("time the module is powered on, the user"));
  USB.println(F("must set the parameter again"));
  USB.println(F("------------------------------------\n"));

}


void loop()
{

}
