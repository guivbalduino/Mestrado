/*
    ------ LoRaWAN Code Example --------

    Explanation: This example shows how to configure the data rate.
    The possibilities are:

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
  LoRaWAN_Region band = US915;
  
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
      USB.println(F("------------------------------------------------------"));
      USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
      USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
      USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
      USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
      USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
      USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
      USB.println(F("  6: SF =  7, BW = 250 kHz, BitRate = 11000 bps"));
      USB.println(F("------------------------------------------------------\n"));

      break;


    case AU915:
      USB.println(F("------------------------------------------------------"));
      USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
      USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
      USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
      USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
      USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
      USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
      USB.println(F("  6: SF =  8, BW = 500 kHz, BitRate =  12500 bps"));
      USB.println(F("------------------------------------------------------\n"));

      break;

    case EU868:
      USB.println(F("------------------------------------------------------"));
      USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
      USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
      USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
      USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
      USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
      USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
      USB.println(F("  6: SF =  7, BW = 500 kHz, BitRate =  11000 bps"));
      USB.println(F("------------------------------------------------------\n"));

      break;


    case KR920:
      USB.println(F("------------------------------------------------------"));
      USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
      USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
      USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
      USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
      USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
      USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
      USB.println(F("------------------------------------------------------\n"));

      break;

    case IN865:
      USB.println(F("------------------------------------------------------"));
      USB.println(F("  0: SF = 12, BW = 125 kHz, BitRate =   250 bps"));
      USB.println(F("  1: SF = 11, BW = 125 kHz, BitRate =   440 bps"));
      USB.println(F("  2: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
      USB.println(F("  3: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
      USB.println(F("  4: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
      USB.println(F("  5: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
      USB.println(F("------------------------------------------------------\n"));

      break;


    case US915:
      USB.println(F("------------------------------------------------------"));
      USB.println(F("  0: SF = 10, BW = 125 kHz, BitRate =   980 bps"));
      USB.println(F("  1: SF =  9, BW = 125 kHz, BitRate =  1760 bps"));
      USB.println(F("  2: SF =  8, BW = 125 kHz, BitRate =  3125 bps"));
      USB.println(F("  3: SF =  7, BW = 125 kHz, BitRate =  5470 bps"));
      USB.println(F("  4: SF =  8, BW = 500 kHz, BitRate =  12500 bps"));
      USB.println(F("------------------------------------------------------\n"));

      break;
  }


  //////////////////////////////////////////////
  // 3. Set Data Rate
  //////////////////////////////////////////////

  error = LoRaWAN.setDataRate(0);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("3. Data rate set OK"));
  }
  else
  {
    USB.print(F("3. Data rate set error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Get Data Rate
  //////////////////////////////////////////////

  error = LoRaWAN.getDataRate();

  // Check status
  if ( error == 0 )
  {
    USB.print(F("4. Data rate get OK. "));
    USB.print(F("Data rate index:"));
    USB.println(LoRaWAN._dataRate, DEC);
  }
  else
  {
    USB.print(F("4. Data rate get error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 5. Enable Adaptive Data Rate (ADR)
  //////////////////////////////////////////////
  
  // ADR_Statu options
  //    ADR_ON
  //    ADR_OFF
  
  error = LoRaWAN.setADR(ADR_ON);

  // Check status
  if( error == 0 ) 
  {
    USB.print(F("5. Adaptive Data Rate enabled OK. "));    
    USB.print(F("ADR:"));
    USB.println(LoRaWAN._adr, DEC);   
  }
  else 
  {
    USB.print(F("5. Enable data rate error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 6. Disable Adaptive Data Rate (ADR)
  //////////////////////////////////////////////

  error = LoRaWAN.setADR(ADR_OFF);

  // Check status
  if( error == 0 ) 
  {
    USB.print(F("6. Adaptive Data Rate disabled OK. "));    
    USB.print(F("ADR:"));
    USB.println(LoRaWAN._adr, DEC);
  }
  else 
  {
    USB.print(F("6. Data rate set error = ")); 
    USB.println(error, DEC);
  }
}


void loop()
{

}
