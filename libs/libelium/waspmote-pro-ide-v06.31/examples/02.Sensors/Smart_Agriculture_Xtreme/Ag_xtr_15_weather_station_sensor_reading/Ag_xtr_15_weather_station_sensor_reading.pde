/*
    ----------- [Ag_xtr_15] - Weather station sensor reading --------------------

    Explanation: Basic example that turns on, reads and turn off the
    sensor. Measured parameters are stored in the corresponding class
    variables and printed by the serial monitor.

    Measured parameters for GMX541 (depends on the model)

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

    Version:           3.3
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


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/


//Uncomment the next line if the GMX includes GPS
//#define GMX_GPS_OPTION


//   [Sensor Class] [Sensor Name]
weatherStation mySensor;

uint8_t response = 0;

void setup()
{
  USB.println(F("Weather station example"));

  // 1. Turn ON the sensor
  mySensor.ON();

  //Recommended waiting time after powering GMX station on
  delay(10000);
}

void loop()
{

  // 2. Read the sensor
  response = mySensor.read();

  if (response == 1)
  {
    // 4. Print information
    USB.println(F("---------------------------"));
    USB.println(F("GMX"));

    USB.print(F("Wind direction: "));
    USB.print(mySensor.gmx.windDirection);
    USB.println(F(" degrees"));

    USB.print(F("Avg. wind dir: "));
    USB.print(mySensor.gmx.avgWindDirection);
    USB.println(F(" degrees"));

    USB.print(F("Cor. wind dir: "));
    USB.print(mySensor.gmx.correctedWindDirection);
    USB.println(F(" degrees"));

    USB.print(F("Avg. cor. wind dir:"));
    USB.print(mySensor.gmx.avgCorrectedWindDirection);
    USB.println(F(" degrees"));

    USB.print(F("Avg. wind gust dir: "));
    USB.print(mySensor.gmx.avgWindGustDirection);
    USB.println(F(" degrees"));

    USB.print(F("Wind speed: "));
    USB.printFloat(mySensor.gmx.windSpeed, 2);
    USB.println(F(" m/s"));

    USB.print(F("Avg. wind speed: "));
    USB.printFloat(mySensor.gmx.avgWindSpeed, 2);
    USB.println(F(" m/s"));

    USB.print(F("Avg. wind gust speed:"));
    USB.printFloat(mySensor.gmx.avgWindGustSpeed, 2);
    USB.println(F(" m/s"));

    USB.print(F("Wind sensor status: "));
    USB.println(mySensor.gmx.windSensorStatus);

    USB.print(F("Precip. total: "));
    USB.printFloat(mySensor.gmx.precipTotal, 3);
    USB.println(F(" mm"));

    USB.print(F("Precip. int: "));
    USB.printFloat(mySensor.gmx.precipIntensity, 3);
    USB.println(F(" mm"));

    USB.print(F("Precip. status: "));
    USB.println(mySensor.gmx.precipStatus, DEC);

    USB.print(F("Solar radiation: "));
    USB.print(mySensor.gmx.solarRadiation);
    USB.println(F(" W/m^2"));

    USB.print(F("Sunshine hours: "));
    USB.printFloat(mySensor.gmx.sunshineHours, 2);
    USB.println(F(" hours"));

    USB.print(F("Sunrise: "));
    USB.print(mySensor.gmx.sunriseTime);
    USB.println(F(" (h:min)"));

    USB.print(F("Solar noon: "));
    USB.print(mySensor.gmx.solarNoonTime);
    USB.println(F(" (h:min)"));

    USB.print(F("Sunset: "));
    USB.print(mySensor.gmx.sunsetTime);
    USB.println(F(" (h:min)"));

    USB.print(F("Sun position: "));
    USB.print(mySensor.gmx.sunPosition);
    USB.println(F(" (degrees:degrees)"));

    USB.print(F("Twilight civil: "));
    USB.print(mySensor.gmx.twilightCivil);
    USB.println(F(" (h:min)"));

    USB.print(F("Twilight nautical: "));
    USB.print(mySensor.gmx.twilightNautical);
    USB.println(F(" (h:min)"));

    USB.print(F("Twilight astronomical: "));
    USB.print(mySensor.gmx.twilightAstronom);
    USB.println(F(" (h:min)"));

    USB.print(F("Barometric pressure: "));
    USB.printFloat(mySensor.gmx.pressure, 1);
    USB.println(F(" hPa"));

    USB.print(F("Pressure at sea level: "));
    USB.printFloat(mySensor.gmx.pressureSeaLevel, 1);
    USB.println(F(" hPa"));

    USB.print(F("Pressure at station: "));
    USB.printFloat(mySensor.gmx.pressureStation, 1);
    USB.println(F(" hPa"));

    USB.print(F("Relative humidity: "));
    USB.print(mySensor.gmx.relativeHumidity);
    USB.println(F(" %"));

    USB.print(F("Air temperature: "));
    USB.printFloat(mySensor.gmx.temperature, 1);
    USB.println(F(" Celsius degrees"));

    USB.print(F("Dew point: "));
    USB.printFloat(mySensor.gmx.dewpoint, 1);
    USB.println(F(" degrees"));

    USB.print(F("Absolute humidity: "));
    USB.printFloat(mySensor.gmx.absoluteHumidity, 2);
    USB.println(F(" g/m^3"));

    USB.print(F("Air density: "));
    USB.printFloat(mySensor.gmx.airDensity, 1);
    USB.println(F(" Kg/m^3"));

    USB.print(F("Wet bulb temperature: "));
    USB.printFloat(mySensor.gmx.wetBulbTemperature, 1);
    USB.println(F(" Celsius degrees"));

    USB.print(F("Wind chill: "));
    USB.printFloat(mySensor.gmx.windChill,1);
    USB.println(F(" Celsius degrees"));

    USB.print(F("Heat index: "));
    USB.print(mySensor.gmx.heatIndex);
    USB.println(F(" Celsius degrees"));

    USB.print(F("Compass: "));
    USB.print(mySensor.gmx.compass);
    USB.println(F(" degrees"));

    USB.print(F("X tilt: "));
    USB.printFloat(mySensor.gmx.xTilt, 0);
    USB.println(F(" degrees"));

    USB.print(F("Y tilt: "));
    USB.printFloat(mySensor.gmx.yTilt, 0);
    USB.println(F(" degrees"));

    USB.print(F("Z orient: "));
    USB.printFloat(mySensor.gmx.zOrient, 0);
    USB.println();

    USB.print(F("Timestamp: "));
    USB.println(mySensor.gmx.timestamp);

    USB.print(F("Voltage: "));
    USB.printFloat(mySensor.gmx.supplyVoltage, 1);
    USB.println(F(" V"));

    USB.print(F("Status: "));
    USB.println(mySensor.gmx.status);

    USB.println(F("---------------------------\n"));
  }
  else
  {
    USB.println(F("Sensor not connected or invalid data"));
  }

  delay(5000);

}
