/*
    ------ LoRaWAN Code Example --------

    Explanation: This example shows how to configure the region and 
    different parameters that can be configured depending on the 
    LoRaWAN configured in the module.

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
  USB.println(F("LoRaWAN example - LoRaWAN EU Channel configuration"));

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
  // 1. switch on
  //////////////////////////////////////////////
  //  ABZModuleBands:
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

  LoRaWAN.showChannelConfig();

  switch (LoRaWAN._band)
  {

    case AS923:

      USB.println(F(" - Region is AS923"));

      //////////////////////////////////////////////
      // 3. Configure LoRaWAN AS923 channel
      //    The network server usually configures
      //    rest of the channels automatically so
      //    this configuration is not mandatory
      //////////////////////////////////////////////
      error = LoRaWAN.setChannelFreq(3, 923200000);
      if ( error == 0 )
      {
        USB.print(F("3.0. Set channel frequency OK. "));
        USB.print(F("Frequency in channel 3: "));
        USB.println(LoRaWAN._freq[3]);
      }
      else
      {
        USB.print(F("3.0. Set channel frequency error = "));
        USB.println(error, DEC);
      }

      LoRaWAN.showChannelConfig();

      break;


    case AU915:

      USB.println(F(" - Region is AU915"));

      //////////////////////////////////////////////
      // 1. switch on
      //////////////////////////////////////////////
      //  SubBandsLoRaWAN_AU_US:
      //      SUB_BAND_0
      //      SUB_BAND_1
      //      SUB_BAND_2
      //      SUB_BAND_3
      //      SUB_BAND_4
      //      SUB_BAND_5
      //      SUB_BAND_6
      //      SUB_BAND_7
      //////////////////////////////////////////////
      // Initialize band with one of the list above
      //////////////////////////////////////////////
      error = LoRaWAN.setChannelMask(SUB_BAND_0);
      // Check status
      if ( error == 0 )
      {
        USB.println(F("3. Sub band configured"));
      }
      else
      {
        USB.print(F("3. Set channel mask error = "));
        USB.println(error, DEC);
      }

      LoRaWAN.showChannelConfig();

      break;

    case EU868:

      USB.println(F(" - Region is EU868"));

      //////////////////////////////////////////////
      // 3. Configure LoRaWAN EU868 channel
      //    The network server usually configures
      //    rest of the channels automatically so
      //    this configuration is not mandatory
      //////////////////////////////////////////////
      error = LoRaWAN.setChannelFreq(3, 868700000);
      if ( error == 0 )
      {
        USB.print(F("3.0. Set channel frequency OK. "));
        USB.print(F("Frequency in channel 3: "));
        USB.println(LoRaWAN._freq[3]);
      }
      else
      {
        USB.print(F("3.0. Set channel frequency error = "));
        USB.println(error, DEC);
      }

      LoRaWAN.showChannelConfig();

      break;


    case KR920:

      USB.println(F(" - Region is KR920"));

      //////////////////////////////////////////////
      // 3. Configure LoRaWAN AS923 channel
      //    The network server usually configures
      //    rest of the channels automatically so
      //    this configuration is not mandatory
      //////////////////////////////////////////////
      error = LoRaWAN.setChannelFreq(3, 923300000);
      if ( error == 0 )
      {
        USB.print(F("3.0. Set channel frequency OK. "));
        USB.print(F("Frequency in channel 3: "));
        USB.println(LoRaWAN._freq[3]);
      }
      else
      {
        USB.print(F("3.0. Set channel frequency error = "));
        USB.println(error, DEC);
      }

      LoRaWAN.showChannelConfig();

      break;

    case IN865:

      USB.println(F(" - Region is IN865"));

      //////////////////////////////////////////////
      // 3. Configure LoRaWAN AS923 channel
      //    The network server usually configures
      //    rest of the channels automatically so
      //    this configuration is not mandatory
      //////////////////////////////////////////////
      error = LoRaWAN.setChannelFreq(3, 865200000);
      if ( error == 0 )
      {
        USB.print(F("3.0. Set channel frequency OK. "));
        USB.print(F("Frequency in channel 0: "));
        USB.println(LoRaWAN._freq[0]);
      }
      else
      {
        USB.print(F("3.0. Set channel frequency error = "));
        USB.println(error, DEC);
      }

      LoRaWAN.showChannelConfig();

      break;


    case US915:

      USB.println(F(" - Region is US915"));

      //////////////////////////////////////////////
      // 1. switch on
      //////////////////////////////////////////////
      //  SubBandsLoRaWAN_AU_US:
      //      SUB_BAND_0
      //      SUB_BAND_1
      //      SUB_BAND_2
      //      SUB_BAND_3
      //      SUB_BAND_4
      //      SUB_BAND_5
      //      SUB_BAND_6
      //      SUB_BAND_7
      //////////////////////////////////////////////
      // Initialize band with one of the list above
      //////////////////////////////////////////////
      error = LoRaWAN.setChannelMask(SUB_BAND_0);
      // Check status
      if ( error == 0 )
      {
        USB.println(F("3. Sub band configured"));
      }
      else
      {
        USB.print(F("3. Set channel mask error = "));
        USB.println(error, DEC);
      }

      LoRaWAN.showChannelConfig();

      break;

  }

  USB.println(F("----------------------------"));

}


void loop()
{


}

