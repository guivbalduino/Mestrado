/*
    ----------- [Ag_xtr_20] - SDI12 serial number reading --------------------

    Explanation: Basic example that turns on a sensor, reads serial 
    number and turn off the sensor. Sensor serial number is stored in the 
    corresponding class variable and printed by the serial monitor.

    Measured parameters:
      - SDI-12 sensor serial number

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

//------------------------------------------------------
//      SELECT THE RIGHT SOCKET FOR EACH SENSOR
//------------------------------------------------------
/*
  Possible sockets are:
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
//Uncomment the sensor that you want to read the serial number
Apogee_SI411 mySensor(XTR_SOCKET_A);
//Apogee_SF421 mySensor(XTR_SOCKET_A);
//Apogee_SO411 mySensor(XTR_SOCKET_A);
//Decagon_GS3 mySensor(XTR_SOCKET_A);
//Decagon_5TE mySensor(XTR_SOCKET_A);
//Decagon_5TM mySensor(XTR_SOCKET_A);
//Decagon_MPS6 mySensor(XTR_SOCKET_A);
//Decagon_VP4 mySensor(XTR_SOCKET_A);


void setup()
{
  USB.println(F("Sensor serial number reading example"));
}

void loop()
{
  // 1. Turn ON the sensor
  mySensor.ON();
  
  // 2. Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
  */
  mySensor.readSerialNumber();
  
  // 3. Turn off the sensor
  mySensor.OFF();

  // 4. Print information
  USB.println(F("---------------------------"));
  USB.print(F("Sensor serial number: "));
  USB.println(mySensor.sensorSI411.sensorSerialNumber);
  //USB.println(mySensor.sensorSF421.sensorSerialNumber);
  //USB.println(mySensor.sensorSO411.sensorSerialNumber);
  //USB.println(mySensor.sensorGS3.sensorSerialNumber);
  //USB.println(mySensor.sensor5TE.sensorSerialNumber);
  //USB.println(mySensor.sensor5TM.sensorSerialNumber);
  //USB.println(mySensor.sensorMPS6.sensorSerialNumber);
  //USB.println(mySensor.sensorVP4.sensorSerialNumber);
  USB.println(F("---------------------------\n"));

  delay(5000);

}
