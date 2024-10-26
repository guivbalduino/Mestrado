/*
    ------ [Ind_03] - RS-232 Example --------

    Explanation: Basic example that turns on, reads and turns off the
    modbus sensor. To read a modbus sensor over RS485 connect it to 
    the SOCKET E, to read a modbus sensor over RS232 connect it to the
    SOCKET F.

    Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L.
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
*/

#include <WaspIndustry.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_F       _________
                      |---------|
                      | A  B  C |
                      |_D__E__F_|


  Example: Modbus sensor on socket E over RS232 will be
  [Sensor Class]    [Sensor Name] [Communication speed]
  Industry232       mySensor      (baudrate);
  
  Refer to the technical guide for information about possible combinations.
  
*/

// Instantiate Industry232 object
Industry232 sensor232(9600);

uint8_t error;

void setup()
{
  USB.println(F("Modbus example for Smart Industries"));
  USB.println();
  sensor232.ON();
  sensor232.send("AUTO");
}


void loop()
{
  if(sensor232.receive() > 0)
  { 
    USB.println(sensor232._buffer, sensor232._length);
  }

  delay(5000);
}
