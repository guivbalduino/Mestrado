/*
    ----------- [Ag_xtr_30] - SO-421 sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Calibreted oxigen
      - Body temperature
      - Sensor millivolts

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
Apogee_SO421 mySensor(XTR_SOCKET_A);

void setup()
{
  USB.println(F("SO-421 example"));
}

void loop()
{
  // 1. Turn ON the sensor
  /*
    ON() function turns on the sensor and the heater before take a read.
    Sensor response time is 15 seconds.
    Dont forget to turn it off after read it.
  */
  mySensor.ON();
  delay(15000);

  // 2. Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  mySensor.read();

  // 3. Turn off the sensor and the heater
  mySensor.OFF();

  // 4. Print information
  USB.println(F("---------------------------"));
  USB.println(F("SO-421"));
  USB.print(F("Calibrated Oxigen: "));
  USB.printFloat(mySensor.sensorSO421.calibratedOxygen, 3);
  USB.println(F(" %"));
  USB.print(F("Body temperature: "));
  USB.printFloat(mySensor.sensorSO421.bodyTemperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Sensor millivolts: "));
  USB.printFloat(mySensor.sensorSO421.milliVolts, 4);
  USB.println(F(" mV"));
  USB.println(F("---------------------------\n"));

  /*
    Note: To send the SO-421 sensor values with the FRAME library,
    please use the SO-411 tags. There are not specific tags for the SO-421 due
    to memory limitations.

    This is an example for the socket A:

    frame.addSensor(AGRX_SO411_CO_A, mySensor.sensorSO421.calibratedOxygen);
    frame.addSensor(AGRX_SO411_TC2_A, mySensor.sensorSO421.bodyTemperature);
    frame.addSensor(AGRX_SO411_MV2_A, mySensor.sensorSO421.milliVolts);

  */

  delay(5000);

}
