/*
    ----------- [Ag_xtr_24] - Datasol Met sensor reading ------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Measured radiation
      - Semi-cell 1 radiation
      - Semi-cell 2 radiation
      - Environment temperature
      - Panel temperature
      - Peak sun hours
      - Necessary cleaning notice
      - Wind speed

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

    Version:           3.1
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor is:
  - XTR_SOCKET_E       _________
                      |---------|
                      | A  B  C |
                      |_D__E__F_|


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

//[Sensor Class] [Sensor Name]
DatasolMET mySensor;

void setup()
{
  USB.println(F("Datasol MET example"));
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
  USB.println(F("Datasol MET"));
  USB.print(F("Measured radiation: "));
  USB.print(mySensor.sensorDatasolMET.radiation);
  USB.println(F(" W/m2"));
  USB.print(F("Semi-cell 1 radiation: "));
  USB.print(mySensor.sensorDatasolMET.semicell1Radiation);
  USB.println(F(" W/m2"));
  USB.print(F("Semi-cell 2 radiation: "));
  USB.print(mySensor.sensorDatasolMET.semicell2Radiation);
  USB.println(F(" W/m2"));
  USB.print(F("Environment temperature: "));
  USB.printFloat(mySensor.sensorDatasolMET.environmentTemperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Panel temperature: "));
  USB.printFloat(mySensor.sensorDatasolMET.panelTemperature, 1);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Peak sun hours: "));
  USB.printFloat(mySensor.sensorDatasolMET.peakSunHours, 2);
  USB.println(F(" hours"));
  USB.print(F("Necessary cleaning notice: "));
  USB.println(mySensor.sensorDatasolMET.necessaryCleaningNotice);
  USB.print(F("Wind speed: "));
  USB.printFloat(mySensor.sensorDatasolMET.windSpeed,1);
  USB.println(F(" m/s"));
  USB.println(F("---------------------------\n"));

  delay(5000);

}
