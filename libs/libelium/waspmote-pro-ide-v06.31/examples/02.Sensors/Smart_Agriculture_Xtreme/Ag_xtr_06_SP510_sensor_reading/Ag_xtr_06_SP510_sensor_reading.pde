/*
    ----------- [Ag_xtr_06] - SP-510 sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Shortwave radiation
      - Sensor voltage

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

    Version:           3.2
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_B       _________
  - XTR_SOCKET_C      |---------|
  - XTR_SOCKET_E      | A  B  C |
  - XTR_SOCKET_F      |_D__E__F_|


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

//   [Sensor Class] [Sensor Name] [Selected socket]
Apogee_SP510 mySensor = Apogee_SP510(XTR_SOCKET_B);

void setup()
{
  USB.println(F("SP-510 example"));
}

void loop()
{
  // 1. Turn ON the sensor
  /*
    ON() function turns on the sensor and the heater before take a read.
    Dont forget to turn it off after read it.
  */
  mySensor.ON();
  delay(10000);

  // 3. Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  mySensor.read();

  // 4. Turn off the sensor and the heater
  mySensor.OFF();

  // 5. Print information
  USB.println(F("---------------------------"));
  USB.println(F("SP-510"));
  USB.print(F("Shortwave Radiation: "));
  USB.printFloat(mySensor.radiation, 2);
  USB.println(F(" W*m-2"));
  USB.print(F("Sensor voltage: "));
  USB.printFloat(mySensor.radiationVoltage, 4);
  USB.println(F(" V"));
  USB.println(F("---------------------------\n"));

  delay(1000);

}
