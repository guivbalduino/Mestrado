/*
    ----------- [Sw_xtr_45] - SAC sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Temperature
      - SAC in m-1
      - COD equivalent in mg/L
      - BOD equivalent in mg/L
      - COT equivalent in mg/L carbon
      - UV compensated absorbance
      - GR compensated absorbance
      - Turbidity equivalent in mg/L
      - UV compensated transmittance
      - GR compensated transmittance

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
    Implementation:    L. M. Martí
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
Aqualabo_SAC mySensor(XTR_SOCKET_D);

void setup()
{
  USB.println(F("SAC example"));

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
  USB.println(F("SAC"));
  USB.print(F("Temperature: "));
  USB.printFloat(mySensor.sensorSAC.temperature, 4);
  USB.println(F(" degrees Celsius"));
  USB.print(F("SAC: "));
  USB.printFloat(mySensor.sensorSAC.sac, 4);
  USB.println(F(" m-1"));
  USB.print(F("COD: "));
  USB.printFloat(mySensor.sensorSAC.cod, 4);
  USB.println(F(" mg/L"));
  USB.print(F("BOD: "));
  USB.printFloat(mySensor.sensorSAC.bod, 4);
  USB.println(F(" mg/L"));
  USB.print(F("COT: "));
  USB.printFloat(mySensor.sensorSAC.cot, 4);
  USB.println(F(" mg/L carbon"));
  if (mySensor.socket == XTR_SOCKET_E)
  {
    USB.print(F("UV Compensated absorbance: "));
    USB.printFloat(mySensor.sensorSAC.uvComp, 4);
    USB.println(F(" []"));
    USB.print(F("GR Compensated absorbance: "));
    USB.printFloat(mySensor.sensorSAC.grComp, 4);
    USB.println(F(" []"));
    USB.print(F("Turbidity equivalent: "));
    USB.printFloat(mySensor.sensorSAC.turb, 4);
    USB.println(F(" FAU"));
    USB.print(F("UV transmittance: "));
    USB.printFloat(mySensor.sensorSAC.uvTran, 4);
    USB.println(F(" []"));
    USB.print(F("GR transmittance: "));
    USB.printFloat(mySensor.sensorSAC.grTran, 4);
    USB.println(F(" []"));
    USB.println(F("---------------------------"));
  }
  delay(5000);
}



