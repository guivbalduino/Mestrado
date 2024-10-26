/*
    ----------- [Ag_xtr_08] - 5TE sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Electrical conductivity
      - Volumetric water content
      - Temperature of the soil

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

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

//   [Sensor Class] [Sensor Name] [Selected socket]
Decagon_5TE mySensor(XTR_SOCKET_A);

void setup()
{
  USB.println(F("5TE example"));
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

  // 4. Conversion of dielectric permittivity into Volumetric Water Content (VWC)
  // for mineral soil using Topp equation
  float VWC = ((4.3 * pow(10, -6) * pow(mySensor.sensor5TE.dielectricPermittivity, 3))
            - (5.5 * pow(10, -4) * pow(mySensor.sensor5TE.dielectricPermittivity, 2))
            + (2.92 * pow(10, -2) * mySensor.sensor5TE.dielectricPermittivity)
            - (5.3 * pow(10, -2))) * 100 ;

  // 5. Print information
  USB.println(F("---------------------------"));
  USB.println(F("5TE"));
  USB.print(F("Dielectric Permittivity: "));
  USB.printFloat(mySensor.sensor5TE.dielectricPermittivity, 2);
  USB.println();
  USB.print(F("Volumetric Water Content: "));
  USB.printFloat(VWC, 2);
  USB.println(F(" %VWC"));  
  USB.print(F("Electrical Conductivity: "));
  USB.printFloat(mySensor.sensor5TE.electricalConductivity, 2);
  USB.println(F(" dS/m"));
  USB.print(F("Soil temperature: "));
  USB.printFloat(mySensor.sensor5TE.temperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.println(F("---------------------------\n"));

  delay(5000);

}
