/*
    ----------- [Ag_xtr_26] - 4-20 mA example --------------------

    Explanation: Basic example that turns on, reads and turns off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - sensor current

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

    Version:           3.0
    Design:            David Gascón
    Implementation:    P.Moreno, J.Siscart
*/

// Put your libraries here (#include ...)
#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_B       _________
  - XTR_SOCKET_F      |---------|
                      | A  B  C |
                      |_D__E__F_|


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

// object to manage _4_20mA
_4_20mA my_4_20mA(XTR_SOCKET_B);

void setup()
{
  USB.println(F("4-20mA example for Smart Agriculture Xtreme"));
  USB.println();

  // It is mandatory to turn ON the board
  SensorXtr.ON();
}

void loop()
{
  // Turn ON the sensor
  my_4_20mA.ON();

  // Read the sensor
  my_4_20mA.read();
  
  // Turn off the sensor
  my_4_20mA.OFF();

  // Print information
  USB.println(F("---------------------------"));
  USB.print(F("4-20 mA sensor current: "));
  USB.printFloat(my_4_20mA.current, 3);
  USB.println(F("mA"));

  delay(5000);

}
