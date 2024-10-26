/*
    ----------- [Ag_xtr_05] - Using Agriculture EEPROM Example -----------

    Explanation:This example shows how to use the EEPROM memory of 
    Smart Agriculture Xtreme board.

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

// address in the Smart Agriculture Xtreme EEPROM
int address = 0x51; 
// value to write
int value = 10;  
// Aux variable
int data = 0;
 
 
void setup()
{
  // Init USB
  USB.ON();
}

void loop()
{
  // WARNING: Reserved EEMPROM addresses below @0x50
  // SensorXtr.writeEEPROM do not let the user to write 
  // below this address.
  // Do not try to write below this address as 
  // you could over-write important configuration
  // --> Available addresses: from 0x51 to 0x7F
  
  // Writing in the Smart Agriculture Xtreme EEPROM  
  SensorXtr.writeEEPROM(address, value);
  
  // Reading the Smart Agriculture Xtreme EEPROM
  data = SensorXtr.readEEPROM(address);
  USB.print(F("Address EEPROM:  "));
  USB.print(address,DEC);
  USB.print(F(" -- Value: "));
  USB.println(data, DEC);
  
  address++;
  value++;
  
  if(address >= 0x7F) 
  {
    address = 0x51;
    USB.println("END");
    delay(10000);    
  }
  delay(1);
}
