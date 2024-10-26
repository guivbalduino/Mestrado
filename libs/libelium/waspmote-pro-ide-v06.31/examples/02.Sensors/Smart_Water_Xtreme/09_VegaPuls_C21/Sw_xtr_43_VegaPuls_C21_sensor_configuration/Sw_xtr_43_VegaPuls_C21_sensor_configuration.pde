/*
    ----------- [Ag_xtr_43] - VegaPuls C21 sensor reading --------------------

    Explanation: Basic example that turns on, configures and reads the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters:
      - Distance

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
    Implementation:    V.Boria
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
VegaPuls_C21 mySensor(XTR_SOCKET_A);

void setup()
{
  USB.println(F("VegaPuls C21 configuration example"));
  mySensor.ON();

  //!*************************************************************
  //! Name: writePowerOperationMode(uint8_t _pom)
  //!
  //! Description: Writes the power operation mode of the sensor
  //!
  //! Param: _pom (power operation mode)
  //!        select from: C21_LOW_POWER_MODE, C21_NORMAL_POWER_MODE
  //!
  //! Returns: 1 if OK, 0 if error
  //!*************************************************************
  mySensor.writePowerOperationMode(C21_NORMAL_POWER_MODE);
  mySensor.readPowerOperationMode();


  //!*************************************************************
  //! Name: writeDistanceUnit(uint8_t _distanceUnit)
  //!
  //! Description: Writes the distance unit of the sensor
  //!
  //! Param: _distanceUnit
  //!        select from: C21_DISTANCE_IN_M, C21_DISTANCE_IN_FT
  //!
  //! Returns: 1 if OK, 0 if error
  //!*************************************************************
  mySensor.writeDistanceUnit(C21_DISTANCE_IN_M);
  mySensor.readDistanceUnit();


  //!*************************************************************
  //! Name: writeTemperatureUnit(uint8_t _temperatureUnit)
  //!
  //! Description: Writes the temperature unit of the sensor
  //!
  //! Param: _temperatureUnit
  //!        select from: C21_TEMPERATURE_IN_C, C21_TEMPERATURE_IN_F
  //!
  //! Returns: 1 if OK, 0 if error
  //!*************************************************************
  mySensor.writeTemperatureUnit(C21_TEMPERATURE_IN_C);
  mySensor.readTemperatureUnit();


  //!*************************************************************
  //! Name: writeStageReference(char* _stageReference)
  //!
  //! Description: Writes the stage configuration of the sensor
  //!              The stage reference is the bottom of the empty tank
  //!
  //! Param: _stageReference is by default in meters, max: 15m
  //!        example: "0.512"
  //!
  //! Returns: 1 if OK, 0 if error
  //!*************************************************************
  mySensor.writeStageReference("10.000");
  mySensor.readStageReference();

  USB.println(F("---------------------------"));
  USB.println(F("VegaPuls C21"));
  USB.print(F("Power operation mode: "));
  if (mySensor.VegaPulsC21.powerOperationMode == 1)
  {
    USB.println(F("Normal"));
  }
  else
  {
    USB.println(F("Low"));
  }
  USB.print(F("Distance unit: "));
  if (mySensor.VegaPulsC21.distanceUnit == 1)
  {
    USB.println(F("Feet"));
  }
  else
  {
    USB.println(F("Meters"));
  }
  USB.print(F("Temperature unit: "));
  if (mySensor.VegaPulsC21.temperatureUnit == 1)
  {
    USB.println(F("Fahrenheit"));
  }
  else
  {
    USB.println(F("Celsius"));
  }
  USB.print(F("Stage reference: "));
  USB.printFloat(mySensor.VegaPulsC21.stageReference, 3);
  USB.println(F(""));
  USB.println(F("---------------------------"));

}

void loop()
{

  // Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  mySensor.read();

  float levelPercentage = 100 - ((mySensor.VegaPulsC21.distance * 100.0) / (mySensor.VegaPulsC21.stage + mySensor.VegaPulsC21.distance));

  // Print information
  USB.println(F("---------------------------"));
  USB.println(F("VegaPuls C21"));
  USB.print(F("Stage: "));
  USB.printFloat(mySensor.VegaPulsC21.stage, 3);
  USB.println(F(" m"));
  USB.print(F("Distance: "));
  USB.printFloat(mySensor.VegaPulsC21.distance , 3);
  USB.println(F(" m"));
  USB.print(F("Temperature: "));
  USB.printFloat(mySensor.VegaPulsC21.temperature, 1);
  USB.println(F(" Celsius degrees"));
  USB.print(F("Device status: "));
  USB.println(mySensor.VegaPulsC21.status, DEC);
  USB.print(F("Level percentage: "));
  USB.printFloat(levelPercentage, 1);
  USB.println(F(" %"));
  USB.println(F("---------------------------\n"));

  delay(5000);
}
