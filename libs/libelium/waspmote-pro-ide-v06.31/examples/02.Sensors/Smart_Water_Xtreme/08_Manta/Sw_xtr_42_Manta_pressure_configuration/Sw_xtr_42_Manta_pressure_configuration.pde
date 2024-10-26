/*
    ----------- [Sw_xtr_42] - Manta pressure configuration   -----------

    Explanation: Basic example that configures the pressure value to the manta
    sensor and reads it.

    Copyright (C) 2020 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Isabel Burillo
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_F       _________
                      |---------|
                      | A  B  C |
                      |_D__E__F_|

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_water_xtreme_tecnical.pdf
*/


//   [Sensor Class] [Sensor Name]
Eureka_Manta mySensor;

float pressure = 760.0;

void setup()
{

  USB.ON();
  USB.println(F("Manta example"));

  // 1. Turn ON the sensor
  mySensor.ON();

  // 4. Get pressure
  mySensor.getBarometricPressure();

  USB.print(F("- Initial Barometric Pressure: "));
  USB.print(mySensor.sensorEureka.pressure);
  USB.println(F(" mm Hg"));

  // 2. Set pressure
  USB.print(F("- Set pressure: "));
  USB.printFloat(pressure, 1);
  USB.println(F(" mm Hg"));
  
  mySensor.setBarometricPressure(pressure);

  // 3. Save config
  mySensor.saveConfig();

  // 4. Get pressure
  mySensor.getBarometricPressure();

  USB.print(F("- Barometric Pressure configured: "));
  USB.print(mySensor.sensorEureka.pressure);
  USB.println(F(" mm Hg"));

  // 5. Turn off the sensor
  mySensor.OFF();

}


void loop()
{

}
