/*
  ---------- - [Ag_xtr_27] - Teros 11 sensor reading --------------------

  Explanation: Basic example that turns on, reads and turn off the
  sensor. Measured parameters are stored in the corresponding class
  variables and printed by the serial monitor.

  Measured parameters:
  - Volumetric water content
  - Temperature of the soil

  Copyright (C) 2020 Libelium Comunicaciones Distribuidas S.L.
  http://www.libelium.com

  This program is free software: you can redistribute it and / or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see < http : //www.gnu.org/licenses/>.

  Version :           3.0
  Design :            David Gascón
  Implementation :    A.Falo
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
Meter_TEROS11 mySensor(XTR_SOCKET_A);

void setup()
{
  USB.println(F("Teros 11 example"));

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


  // 4.1 Conversion of the RAW output sensor value into Volumetric Water Content (VWC)
  // for mineral soil using calibration equation
  float VWC = ((3.879 * pow(10, -4) * mySensor.sensorTEROS11.calibratedCountsVWC)) - 0.6956;

  // for soilless media using calibration equation
  //  float VWC = ((6.771 * pow(10, -10) * pow(mySensor.sensorTEROS11.calibratedCountsVWC, 3))
  //               - (5.105 * pow(10, -6) * pow(mySensor.sensorTEROS11.calibratedCountsVWC, 2))
  //               + (1.302 * pow(10, -2) * mySensor.sensorTEROS11.calibratedCountsVWC))
  //               - 10.848;

  // 4.2 Conversion of the RAW output sensor value into Volumetric Water Content (VWC)
  // for mineral soil using calibration equation
  float DP = pow(((2.887 * pow(10, -9) * pow(mySensor.sensorTEROS11.calibratedCountsVWC, 3))
                  - (2.080 * pow(10, -5) * pow(mySensor.sensorTEROS11.calibratedCountsVWC, 2))
                  + (5.276 * pow(10, -2) * mySensor.sensorTEROS11.calibratedCountsVWC)
                  - 43.39), 2);


  // 5. Print information
  USB.println(F("---------------------------"));
  USB.println(F("Teros-11"));
  USB.print(F("Dielectric Permittivity: "));
  USB.printFloat(DP, 2);
  USB.println();
  USB.print(F("Volumetric Water Content: "));
  USB.printFloat(VWC, 2);
  USB.println(F(" m3/m3"));
  USB.print(F("Soil temperature: "));
  USB.printFloat(mySensor.sensorTEROS11.temperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.println(F("---------------------------\n"));

  delay(5000);

}
