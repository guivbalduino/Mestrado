/*
    ----------- [Sw_xtr_35] - Scan modbus address -----------

    Explanation: Basic example that scan MODBUS address of a sensor
    and set it to default

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
  - XTR_SOCKET_E           _________
                          |---------|
                          | A  B  C |
                          |_D__E__F_|


  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/
//Uncomment the sensor that you want to scan modbus address
Aqualabo_OPTOD mySensor(XTR_SOCKET_E);
//Aqualabo_PHEHT mySensor(XTR_SOCKET_E);
//Aqualabo_C4E mySensor(XTR_SOCKET_E);
//Aqualabo_NTU mySensor(XTR_SOCKET_E);
//Aqualabo_CTZN mySensor(XTR_SOCKET_E);
//Aqualabo_MES5 mySensor(XTR_SOCKET_E);


void setup()
{

  USB.println(F("Scan MODBUS address example code"));

  mySensor.ON();

  //!*************************************************************
  //! Name: init()
  //!
  //! Note: This particular function only works in Socket E
  //!
  //! Description: Initializes the sensor with avering=1
  //!
  //! Returns: 0 is OK, 1 if error
  //!*************************************************************
  uint8_t response = mySensor.init();
  if (response == 0)
  {
    USB.println(F("Sensor found in default MODBUS slave address"));
  }
  else
  {
    USB.println(F("Error initializing the sensor.\r\nBeginning MODBUS slave address scanning..."));

    uint8_t i = 0;
    for (i = 0; i < 248; i++)
    {

      USB.print(F("Address:"));
      USB.print(i, DEC);
      USB.print(F(" -> "));
      response = mySensor.searchAddress(i);
      if (response == 0)
      {
        USB.println(F("Sensor found and address set to default"));
        break;
      }
      else
      {
        USB.println(F("Sensor not found"));
      }
    }
  }
}


void loop()
{
  delay(1000);
}
