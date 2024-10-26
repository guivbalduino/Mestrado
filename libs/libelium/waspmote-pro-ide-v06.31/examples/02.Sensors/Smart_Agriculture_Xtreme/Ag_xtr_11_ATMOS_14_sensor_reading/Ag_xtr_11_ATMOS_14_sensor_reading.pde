/*
    ----------- [Ag_xtr_11] - ATMOS 14 / VP4 sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Vapor pressure
      - Humidity
      - Temperature 
      - Atmospheric pressure in soil and air

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

    Version:           3.2
    Design:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_A       _________
  - XTR_SOCKET_B      |---------|
  - XTR_SOCKET_C      | A  B  C |
  - XTR_SOCKET_D      |_D__E__F_|


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

*/

//   [Sensor Class] [Sensor Name] [Selected socket]
ATMOS_14 mySensor(XTR_SOCKET_A);

void setup()
{
  USB.println(F("ATMOS 14 example"));
}

void loop()
{
  // 1. Turn ON the sensor
  mySensor.ON();

  // 2. Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  mySensor.read();

  // 3. Turn off the sensor
  mySensor.OFF();

  // 4. Print information
  USB.println(F("---------------------------"));
  USB.println(F("ATMOS 14"));
  USB.print(F("Vapor Pressure:"));
  USB.printFloat(mySensor.sensorATMOS14.vaporPressure, 3);
  USB.println(F(" kPa"));
  USB.print(F("Temperature:"));
  USB.printFloat(mySensor.sensorATMOS14.temperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Relative Humidity:"));
  USB.printFloat(mySensor.sensorATMOS14.relativeHumidity, 1);
  USB.println(F(" %RH"));
  USB.print(F("Atmospheric Pressure:"));
  USB.printFloat(mySensor.sensorATMOS14.atmosphericPressure, 2);
  USB.println(F(" kPa"));
  USB.println(F("---------------------------\n"));

  delay(5000);

}
