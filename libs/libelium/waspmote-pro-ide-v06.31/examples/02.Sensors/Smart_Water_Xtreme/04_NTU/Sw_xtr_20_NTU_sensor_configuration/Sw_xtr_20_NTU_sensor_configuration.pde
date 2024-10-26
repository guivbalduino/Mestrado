/*
    ----------- [Sw_xtr_20] - NTU sensor configuration -----------------

    Explanation: Basic example that initializes the sensor with
    default configuration for averaging and selected range for turbidity

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
    - XTR_SOCKET_E (Only valid socket for init() or calibrating)
                           _________
                          |---------|
                          | A  B  C |
                          |_D__E__F_|


  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/
Aqualabo_NTU mySensor(XTR_SOCKET_E);


void setup()
{
  USB.println(F("NTU configuration example"));


   mySensor.ON();
   
  //!*************************************************************
  //! Name: init(uint8_t range)
  //!
  //! Note: This particular function only works in Socket E
  //!
  //! Description: Initializes the sensor with with avering=1 and the selected range
  //!  
  //! Param: range (Range for NTU measure)
  //!        select from: RANGE_AUTOMATIC, RANGE_1, RANGE_2, RANGE_3, RANGE_4 (see guide for more info)
  //!
  //! Returns: 0 is OK, 1 if error
  //!*************************************************************
  uint8_t response = mySensor.init(RANGE_AUTOMATIC);
  if (response == 0)
  {
    USB.println(F("Sensor initializing OK"));
  }
  else
  {
    USB.println(F("Error initializing the sensor. \r\nCheck the sensor and restart the code."));
  }

}

void loop()
{

}



