/*  
 *  ------ [900HP_05] - get RSSI from last received packet  -------- 
 *  
 *  Explanation: This program shows how to get RSSI value from the 
 *  last received packet. For this protocol, there is an API function which
 *  shows this information. Before running this example, make sure there 
 *  is another emitter sending packets to this XBee module in order to 
 *  receive information.
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

#include <WaspXBee900HP.h>

// define variable
uint8_t error;

// variable to store RSSI
int rssi;


void setup()
{  
  // init USB port
  USB.ON();
  USB.println(F("Receiving example"));

  // init XBee 
  xbee900HP.ON();
}


void loop()
{ 
  // receive XBee packet
  error = xbee900HP.receivePacketTimeout(10000);

  // check answer  
  if( error == 0 ) 
  {
    
    USB.println(F("\n\n-- New packet received--"));  
    
    // Show data stored in '_payload' buffer indicated by '_length'
    USB.print(F("Data: "));  
    USB.println( xbee900HP._payload, xbee900HP._length);

    // Show data stored in '_payload' buffer indicated by '_length'
    USB.print(F("Length: "));  
    USB.println( xbee900HP._length,DEC);

    // get RSSI signal and make conversion to -dBm
    xbee900HP.getRSSI();  
    
    if( xbee900HP.error_AT == 0 )
    {
      rssi = xbee900HP.valueRSSI[0];
      rssi *= -1;
      USB.print(F("RSSI(dBm): "));
      USB.println(rssi,DEC);
    }
    else
    {
      USB.println(F("Error getting RSSI")); 
    }
  }
  else
  {
    // Print error message:
    /*
     * '7' : Buffer full. Not enough memory space
     * '6' : Error escaping character within payload bytes
     * '5' : Error escaping character in checksum byte
     * '4' : Checksum is not correct	  
     * '3' : Checksum byte is not available	
     * '2' : Frame Type is not valid
     * '1' : Timeout when receiving answer   
     */
    USB.print(F("Error receiving a packet:"));
    USB.println(error,DEC);     
  }

} 





