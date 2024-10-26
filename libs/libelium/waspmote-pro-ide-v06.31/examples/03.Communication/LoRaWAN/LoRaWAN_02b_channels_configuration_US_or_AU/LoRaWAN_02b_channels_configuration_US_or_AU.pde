/*  
 *  ------ LoRaWAN Code Example -------- 
 *  
 *  Explanation: This example shows how to configure the channels settings.
 *  There are 64 channels. All channels are set to on by default. In addition 
 *  to the status user can change the data rate range and query the frequency
 *  of the channel
 *  
 *  Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Design:            David Gascon 
 *  Implementation:    Luismi Marti
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
  USB.println(F("LoRaWAN example - LoRaWAN US Channel configuration"));

  //////////////////////////////////////////////
  // 1. switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 2. Set frequency for specific channel
  //////////////////////////////////////////////

  error = LoRaWAN.getChannelFreq(3);

  // Check status
  if( error == 0 ) 
  {
    USB.print(F("2. Frequency get OK. "));    
    USB.print(F("Frequency:"));
    USB.println(LoRaWAN._freq[3]);
  }
  else 
  {
    USB.print(F("2. Frequency get error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 3. Set Data rate range for specific channel
  //////////////////////////////////////////////

  error = LoRaWAN.setChannelDRRange(3, 0, 2);

  // Check status
  if( error == 0 ) 
  {
    USB.print(F("3. Data Rate range set OK. "));    
    USB.print(F("Data Rate min:"));
    USB.print(LoRaWAN._drrMin[3], DEC); 
    USB.print(F(". Data Rate max:"));
    USB.println(LoRaWAN._drrMax[3], DEC);
  }
  else 
  {
    USB.print(F("3. Data rate range set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Set Data rate range for specific channel
  //////////////////////////////////////////////

  error = LoRaWAN.setChannelStatus(3, "off");

  // Check status
  if( error == 0 ) 
  {
    USB.print(F("4. Channel status set OK: "));
    USB.println(LoRaWAN._status[3], DEC);
  }
  else 
  {
    USB.print(F("4. Channel status set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 5. Save configuration
  //////////////////////////////////////////////

  error = LoRaWAN.saveConfig();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5. Save configuration OK"));     
  }
  else 
  {
    USB.print(F("5. Save configuration error = ")); 
    USB.println(error, DEC);
  }


  ///////////////////////////////////////////////////////////
  // show configuration for all channels available
  ///////////////////////////////////////////////////////////

  USB.println(F("\n----------------------------"));

  for( int i=0; i<64; i++)
  {
    LoRaWAN.getChannelFreq(i);
    LoRaWAN.getChannelDRRange(i);
    LoRaWAN.getChannelStatus(i);

    USB.print(F("Channel: "));
    USB.println(i);
    USB.print(F("  Freq: "));
    USB.println(LoRaWAN._freq[i]);
    USB.print(F("  DR min: "));
    USB.println(LoRaWAN._drrMin[i], DEC);
    USB.print(F("  DR max: "));
    USB.println(LoRaWAN._drrMax[i], DEC);
    USB.print(F("  Status: "));
    if (LoRaWAN._status[i] == 1)
    {
      USB.println(F("on"));
    }
    else
    {
      USB.println(F("off"));
    }
    USB.println(F("----------------------------"));
  } 
  

}


void loop() 
{


}
