/*
    ------ [Ind_01] - 4-20 mA example --------

    Explanation: Basic example that turns on, reads and turns off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

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
  - XTR_SOCKET_B       _________
  - XTR_SOCKET_F      |---------|
                      | A  B  C |
                      |_D__E__F_|


  Example: 4-20mA sensor on socket A will be
  [Sensor Class]   [Sensor Name] [Selected socket]
  Industries_4_20  mySensor      (XTR_SOCKET_B);

  Refer to the technical guide for information about possible combinations.

*/

Industry_4_20 mySensor(IND_SOCKET_B);

void setup()
{
  USB.println(F("4-20mA example for Smart Industries"));
  USB.println();
}


void loop()
{
  // Turn ON the sensor
  mySensor.ON();

  // Read the sensor
  mySensor.read();

  // Turn off the sensor
  mySensor.OFF();

  // Print information
  USB.println(F("---------------------------"));
  USB.print(F("4-20 mA sensor current: "));
  USB.printFloat(mySensor._current, 3);
  USB.println(F("mA"));

  delay(5000);
}
