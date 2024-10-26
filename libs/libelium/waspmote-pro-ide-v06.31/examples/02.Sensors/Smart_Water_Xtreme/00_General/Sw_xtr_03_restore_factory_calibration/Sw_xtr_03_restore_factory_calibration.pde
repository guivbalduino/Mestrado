/*
    ----------- [Sw_xtr_03] - Restore factory calibration -----------

    Explanation: Basic example that restores the factory calibration 
    of any parameter

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
//Uncomment the sensor that you want to read the serial number
Aqualabo_OPTOD mySensor(XTR_SOCKET_E);
//Aqualabo_PHEHT mySensor(XTR_SOCKET_E);
//Aqualabo_C4E mySensor(XTR_SOCKET_E);
//Aqualabo_NTU mySensor(XTR_SOCKET_E);
//Aqualabo_CTZN mySensor(XTR_SOCKET_E);
//Aqualabo_MES5 mySensor(XTR_SOCKET_E);


uint8_t response = 0;

void setup()
{

  // 1.Turn ON the sensor
  mySensor.ON();
  
  // 2. Restores the sensor to factory calibration
  //!*************************************************************
  //! Name: restoreToFactoryCalibration(uint8_t parameter)
  //! 
  //! Description: Restores the sensor to factory calibration
  //!
  //! Param: parameter
  //!        for OPTOD select from: TEMPERATURE, OXYGEN
  //!        for PHEHT select from: TEMPERATURE, PH, REDOX
  //!        for C4E select from: TEMPERATURE, CONDUCTIVITY
  //!        for NTU select from: TEMPERATURE, NTU_TURBIDITY
  //!        for CTZN select from: TEMPERATURE, CONDUCTIVITY
  //!        for MES5 select from: TEMPERATURE, SLUDGE_BLANKET, FAU_TURBIDITY
  //!
  //! Returns: 0 is OK, 1 if error
  //!*************************************************************  
  response = mySensor.restoreToFactoryCalibration(TEMPERATURE);
  if (response == 0)
  {
    USB.println(F("Restoring factory calibration OK"));
  }
  else
  {
    USB.println(F("Error restoring factory calibration of the sensor. \r\nCheck the sensor and restart the code."));
  }
   
  
  // 3. Turn off the sensor
  mySensor.OFF();

}

void loop()
{
  delay(5000);
}



