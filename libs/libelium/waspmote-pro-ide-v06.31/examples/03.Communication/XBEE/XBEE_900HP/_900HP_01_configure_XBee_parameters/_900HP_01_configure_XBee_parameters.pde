/*
    ------ [900HP_01] - configure basic XBee parameters --------

    Explanation: This program shows how to set the basic networking
    parameters to a XBee module.

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

    Version:           3.1
    Design:            David Gascón
    Implementation:    Yuri Carmona
*/

#include <WaspXBee900HP.h>


// Define the PANID (Personal Area Network Identifier)
uint8_t  panID[2] = {0x7F, 0xFF};

// Define the Frequency Channel Mask
//////////////////////////////////////////////////////////////////
// This is a bitmap to enable frequency channels:
//    Bit 0 – 902.400 MHZ
//    Bit 1 – 902.800 MHZ
//      ...
//    Bit 31 – 914.800 MHZ
//      ...
//    Bit 63 – 927.600 MHZ
//
//  Bitfield per region:
//    US/Canada  0xFFFFFFFFFFFFFFFF (Channels 0-63)
//    Australia  0xFFFFFFFE00000000 (Channels 33-63)
//    Brazil     0xFFFFFFFE00000FFF (Channels 0-11,33-63)
// 
// Even if you try to enable forbidden channels via sw, the radio will refuse
// to activate them, keeping wireless operation within regulations. The radio
// uses a hard-coded bit mask for validating channels. 
//////////////////////////////////////////////////////////////////
uint8_t channelMask[8] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};

// Define Preamble ID: from 0x00 to 0x07
uint8_t preambleID = 0x00;

// Define the Encryption mode: 1 (enabled) or 0 (disabled)
uint8_t encryptionMode = 0;

// Define the AES 16-byte Encryption Key
char  encryptionKey[] = "WaspmoteLinkKey!";





void setup()
{
  // init USB
  USB.ON();

  // init XBee
  xbee900HP.ON();

  USB.println(F("-------------------------------"));
  USB.println(F("Configure XBee900 HP"));
  USB.println(F("-------------------------------"));

  USB.print(F("XBee900HP uses a bitmap to enable frequency channels:\n"\
              "Bit  0: 902.400 MHz\n"\
              "Bit  1: 902.800 MHz\n" \
              "Bit  2: 903.200 MHz\n" \
              "Bit  3: 903.600 MHz\n" \
              "Bit  4: 904.000 MHz\n" \
              "Bit  5: 904.400 MHz\n" \
              "Bit  6: 904.800 MHz\n" \
              "Bit  7: 905.200 MHz\n" \
              "Bit  8: 905.600 MHz\n" \
              "Bit  9: 906.000 MHz\n" \
              "Bit 10: 906.400 MHz\n" \
              "Bit 11: 906.800 MHz\n" \
              "Bit 12: 907.200 MHz\n" \
              "...\n"\
              "Bit 31: 914.800 MHz\n" \
              "...\n" \
              "Bit 63: 927.600 MHz\n"));

  USB.println(F("-------------------------------"));

  //////////////////////////////////////////////
  // 1. Query available frequency channels
  //////////////////////////////////////////////
  xbee900HP.getAvailableFreq();

  // check at commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.print(F("1. Available Frequency bitmap is: 0x"));
    USB.printHex( xbee900HP._availableFreq[0] );
    USB.printHex( xbee900HP._availableFreq[1] );
    USB.printHex( xbee900HP._availableFreq[2] );
    USB.printHex( xbee900HP._availableFreq[3] );
    USB.printHex( xbee900HP._availableFreq[4] );
    USB.printHex( xbee900HP._availableFreq[5] );
    USB.printHex( xbee900HP._availableFreq[6] );
    USB.printHex( xbee900HP._availableFreq[7] );
    USB.println();
  }
  else
  {
    USB.println(F("1. Error calling 'getAvailableFreq()'"));
  }


  //////////////////////////////////////////////
  // 2. Set Channel Mask for frequency bands
  //////////////////////////////////////////////
  xbee900HP.setChannelMask( channelMask );

  // check at commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.print(F("2. Channel Mask bitmap is set to: 0x"));
    USB.printHex( xbee900HP._channelMask[0] );
    USB.printHex( xbee900HP._channelMask[1] );
    USB.printHex( xbee900HP._channelMask[2] );
    USB.printHex( xbee900HP._channelMask[3] );
    USB.printHex( xbee900HP._channelMask[4] );
    USB.printHex( xbee900HP._channelMask[5] );
    USB.printHex( xbee900HP._channelMask[6] );
    USB.printHex( xbee900HP._channelMask[7] );
    USB.println();
  }
  else
  {
    USB.println(F("2. Error calling 'setChannelMask()'"));
  }



  //////////////////////////////////////////////
  // 3. Get Minimum Frequency Count
  //////////////////////////////////////////////
  xbee900HP.getMinFreqCount();

  // check at commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.print(F("3. Minimum Frequency Count:"));
    USB.println(xbee900HP._minFreqCount, DEC);
  }
  else
  {
    USB.println(F("3. Error calling 'getMinFreqCount()'"));
  }



  //////////////////////////////////////////////
  // 4. set PANID
  //////////////////////////////////////////////
  xbee900HP.setPAN( panID );

  // check the AT commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.print(F("4. PAN ID set OK to: 0x"));
    USB.printHex( xbee900HP.PAN_ID[0] );
    USB.printHex( xbee900HP.PAN_ID[1] );
    USB.println();
  }
  else
  {
    USB.println(F("4. Error calling 'setPAN()'"));
  }


  //////////////////////////////////////////////
  // 5. Set Preamble ID
  //////////////////////////////////////////////
  xbee900HP.setPreambleID( preambleID );

  // check at commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.print(F("5. Preamble set to:"));
    USB.println(xbee900HP._preambleID, DEC);
  }
  else
  {
    USB.println(F("5. Error calling 'setPreambleID()'"));
  }


  /////////////////////////////////////
  // 6. set encryption mode (1:enable; 0:disable)
  /////////////////////////////////////
  xbee900HP.setEncryptionMode( encryptionMode );

  // check the AT commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.print(F("6. AES encryption configured (1:enabled; 0:disabled):"));
    USB.println( xbee900HP.encryptMode, DEC );
  }
  else
  {
    USB.println(F("6. Error calling 'setEncryptionMode()'"));
  }



  /////////////////////////////////////
  // 7. set the encryption key
  /////////////////////////////////////
  xbee900HP.setLinkKey( encryptionKey );

  // check the AT commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.println(F("7. AES encryption key set OK"));
  }
  else
  {
    USB.println(F("7. Error calling 'setLinkKey()'"));
  }


  /////////////////////////////////////
  // 8. write values to XBee module memory
  /////////////////////////////////////
  xbee900HP.writeValues();

  // check the AT commmand execution flag
  if (xbee900HP.error_AT == 0)
  {
    USB.println(F("8. Changes stored OK"));
  }
  else
  {
    USB.println(F("8. Error calling 'writeValues()'"));
  }

  USB.println(F("-------------------------------"));

}



void loop()
{

  // Do nothing

}

