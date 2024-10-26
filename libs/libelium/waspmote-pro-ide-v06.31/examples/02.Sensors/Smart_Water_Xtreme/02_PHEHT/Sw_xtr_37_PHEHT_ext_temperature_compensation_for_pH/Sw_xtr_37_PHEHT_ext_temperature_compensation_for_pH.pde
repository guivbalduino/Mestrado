/*
    --- [Sw_xtr_37] - PHEHT external temperature compensation for pH ----

    Explanation: Example that enable and set an external reference value
    of temperature in order to compensate pH measures.

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

    Version:           3.0
    Design:            David Gascón
    Implementation:    V.Boria
*/
#include <WaspSensorXtr.h>


/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_E (Only valid socket for parameter compensation)
                           _________
                          |---------|
                          | A  B  C |
                          |_D__E__F_|


  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

//Uncomment the sensor that you want to read the serial number
Aqualabo_PHEHT mySensor(XTR_SOCKET_E);

uint8_t response = 0;

//Fill this variable with your external atmospheric pressure value in ºC
float ext_temp_value = 25;

void setup()
{
  //Turn on the sensor
  mySensor.ON();

  //!*************************************************************
  //! Name: init()
  //!
  //! Note: This particular function only works in Socket E
  //!
  //! Description: Initializes the sensor with avering = 1
  //!
  //! Returns: 0 is OK, 1 if error
  //!*************************************************************
  response = mySensor.init();
  if (response)
  {
    USB.println(F("Error initializing the sensor. \r\nCheck the sensor is in Socket E and restart the code."));
    while (1);
  }

  //!*************************************************************
  //! Name: enableCompensation(uint8_t compensatedParam, uint8_t extParamWithWhichCompensate, uint8_t enablingState)
  //!
  //! Note: This particular function only works in Socket E. 
  //!       This is not necessary since the probe already compensates with its 
  //!       internal default temperature sensor
  //!
  //! Description:  Enables internal measurement compensation to the probe.
  //!               This setting is stored in sensor FLASH memory and thus persistent
  //!               If disabled, temperature will use its internal temperature sensor
  //!
  //! Params:  compensatedParam possible values:            COMPENSATE_PH
  //!          extParamWithWhichCompensate possible values: EXTERNAL_TEMP (in ºC)
  //!          enablingState possible values:               ENABLE, DISABLE
  //!
  //! Returns: 1 if OK, 0 if error
  //!*************************************************************
  response = mySensor.enableCompensation(COMPENSATE_PH, EXTERNAL_TEMP, ENABLE);
  if (response)
  {
    USB.println(F("Parameter compensation state successfully set"));
  }
  else
  {
    USB.println(F("Fail setting parameter compensation state"));
  }

  //!*************************************************************
  //! Name: setCompensationValue(uint8_t extParamWithWhichCompensate, float value)
  //!
  //! Note: This particular function only works in Socket E
  //!
  //! Description:  sets a compensation value to be used in measurement compensation instead of the default.
  //!
  //! Params:  extParamWithWhichCompensate possible values: EXTERNAL_TEMP (in ºC)
  //!          value is the float value read by an external sensor in order to compensate measurements
  //!
  //! Returns: 1 if OK, 0 if error
  //!*************************************************************
  response =  mySensor.setCompensationValue(EXTERNAL_TEMP, ext_temp_value);
  if (response)
  {
    USB.println(F("Compensation value successfully set"));
  }
  else
  {
    USB.println(F("Fail setting compensation value"));
  }

  //Turn off the sensor
  mySensor.OFF();

}

void loop()
{
  // Turn ON the sensor
  mySensor.ON();

  // Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  mySensor.read();

  // Turn off the sensor
  mySensor.OFF();

  // 7. Print information
  USB.println(F("---------------------------"));
  USB.println(F("PHEHT"));
  USB.print(F("Temperature: "));
  USB.printFloat(mySensor.sensorPHEHT.temperature, 2);
  USB.println(F(" degrees Celsius"));
  USB.print(F("pH: "));
  USB.printFloat(mySensor.sensorPHEHT.pH, 2);
  USB.println();
  USB.print(F("pH: "));
  USB.printFloat(mySensor.sensorPHEHT.pHMV, 2);
  USB.println(F(" mV"));
  USB.print(F("Redox: "));
  USB.printFloat(mySensor.sensorPHEHT.redox, 2);
  USB.println(F(" mV"));
  USB.println(F("---------------------------"));

  delay(5000);
}
