/*  
 *  ------ [868LP_01] - configure basic XBee parameters -------- 
 *  
 *  Explanation: This program shows how to set the basic networking
 *  parameters to a XBee module.
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
 *  Design:            David Gascón 
 *  Implementation:    Yuri Carmona
 */

#include <WaspXBee868LP.h>

// PAN (Personal Area Network) Identifier
uint8_t  panID[2] = {0x12,0x34}; 

// Define Freq Channel to be set: 
uint8_t  mask[4] = {0x1F,0xFF,0xFF,0xFF};

// Define preamble ID
uint8_t preambleID = 0x06;

// Define the Encryption mode: 1 (enabled) or 0 (disabled)
uint8_t encryptionMode = 0;

// Define the AES 16-byte Encryption Key
char  encryptionKey[] = "WaspmoteLinkKey!"; 


void setup()
{
  // open USB port
  USB.ON();

  USB.println(F("-------------------------------"));
  USB.println(F("Configure XBee 868LP"));
  USB.println(F("-------------------------------"));

  // init XBee 
  xbee868LP.ON();

  /////////////////////////////////////
  // 1. set channel 
  /////////////////////////////////////
  xbee868LP.setChannelMask( mask );

  // check at commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("1. Channel set OK to: 0x"));
    USB.printHex( xbee868LP._channelMask[0] );
    USB.printHex( xbee868LP._channelMask[1] );
    USB.printHex( xbee868LP._channelMask[2] );
    USB.printHex( xbee868LP._channelMask[3] );
    USB.println();
  }
  else 
  {
    USB.println(F("1. Error calling 'setChannel()'"));
  }


  /////////////////////////////////////
  // 2. set PANID
  /////////////////////////////////////
  xbee868LP.setPAN( panID );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("2. PAN ID set OK to: 0x"));
    USB.printHex( xbee868LP.PAN_ID[0] ); 
    USB.printHex( xbee868LP.PAN_ID[1] ); 
    USB.println();
  }
  else 
  {
    USB.println(F("2. Error calling 'setPAN()'"));  
  }

  /////////////////////////////////////
  // 3. set preamble ID
  /////////////////////////////////////
  xbee868LP.setPreambleID( preambleID );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("2. Preamble ID set OK to: 0x"));
    USB.printHex( xbee868LP._preambleID );
    USB.println();
  }
  else 
  {
    USB.println(F("2. Error calling 'setPreambleID()'"));  
  }

  /////////////////////////////////////
  // 4. set encryption mode (1:enable; 0:disable)
  /////////////////////////////////////
  xbee868LP.setEncryptionMode( encryptionMode );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.print(F("3. AES encryption configured (1:enabled; 0:disabled):"));
    USB.println( xbee868LP.encryptMode, DEC );
  }
  else 
  {
    USB.println(F("3. Error calling 'setEncryptionMode()'"));
  }

  /////////////////////////////////////
  // 5. set encryption key
  /////////////////////////////////////
  xbee868LP.setLinkKey( encryptionKey );

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.println(F("4. AES encryption key set OK"));
  }
  else 
  {
    USB.println(F("4. Error calling 'setLinkKey()'")); 
  }

  /////////////////////////////////////
  // 6. write values to XBee module memory
  /////////////////////////////////////
  xbee868LP.writeValues();

  // check the AT commmand execution flag
  if( xbee868LP.error_AT == 0 ) 
  {
    USB.println(F("5. Changes stored OK"));
  }
  else 
  {
    USB.println(F("5. Error calling 'writeValues()'"));   
  }

  USB.println(F("-------------------------------")); 
}



void loop()
{

  /////////////////////////////////////
  // 1. get channel 
  /////////////////////////////////////
  xbee868LP.getChannelMask();
  USB.print(F("Channel mask: 0x"));
    USB.printHex( xbee868LP._channelMask[0] );
    USB.printHex( xbee868LP._channelMask[1] );
    USB.printHex( xbee868LP._channelMask[2] );
    USB.printHex( xbee868LP._channelMask[3] );
    USB.println();
  
  /////////////////////////////////////
  // 2. get PANID
  /////////////////////////////////////
  xbee868LP.getPAN();
  USB.print(F("panid: "));
  USB.printHex(xbee868LP.PAN_ID[0]); 
  USB.printHex(xbee868LP.PAN_ID[1]); 
  USB.println(); 

  /////////////////////////////////////
  // 3. get encryption mode (1:enable; 0:disable)
  /////////////////////////////////////
  xbee868LP.getEncryptionMode();
  USB.print(F("encryption mode: "));
  USB.printHex(xbee868LP.encryptMode);
  USB.println(); 

  USB.println(F("-------------------------------")); 

  delay(3000);
}
