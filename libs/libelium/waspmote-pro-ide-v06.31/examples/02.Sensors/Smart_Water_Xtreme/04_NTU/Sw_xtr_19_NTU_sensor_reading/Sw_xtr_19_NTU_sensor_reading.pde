/*
    ----------- [Sw_xtr_19] - NTU sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Temperature
      - Turbidity in NTU (1NTU = 1FNU)
      - Turbidity in mg/L

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

    Version:           3.0
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
    - XTR_SOCKET_A
    - XTR_SOCKET_B
    - XTR_SOCKET_C
    - XTR_SOCKET_D
    - XTR_SOCKET_E (Only valid socket for init() or calibrating)
                           _________
                          |---------|
                          | A  B  C |
                          |_D__E__F_|


  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/
Aqualabo_NTU mySensor(XTR_SOCKET_D);


uint8_t response = 0;

void setup()
{
  USB.println(F("NTU example"));
  
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
  USB.println(F("NTU"));
  USB.print(F("Temperature: "));
  USB.printFloat(mySensor.sensorNTU.temperature, 2);
  USB.println(F(" degrees Celsius"));
  USB.print(F("Turbidity: "));
  USB.printFloat(mySensor.sensorNTU.turbidityNTU, 2);
  USB.println(F(" NTU"));
  USB.print(F("Turbidity: "));
  USB.printFloat(mySensor.sensorNTU.turbidityMGL, 2);
  USB.println(F(" mg/L"));
  USB.println(F("---------------------------"));

  delay(5000);
}



