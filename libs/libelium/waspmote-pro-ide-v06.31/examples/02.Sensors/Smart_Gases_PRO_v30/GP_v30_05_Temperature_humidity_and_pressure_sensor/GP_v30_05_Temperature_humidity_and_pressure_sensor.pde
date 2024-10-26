/*
    -------  [GP_v30_05] - Temperature, humidity and pressure sensor  ---------

    Explanation: This is the basic code to manage and read the temperature,
    humidity and pressure sensor. Cycle time: 3 minutes

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

    Version:           3.2
    Design:            David Gascón
    Implementation:    Alejandro Gállego
*/

#include <WaspSensorGas_Pro.h>

/*
 * Waspmote OEM. Possibilities for this sensor:
 * 	- CENTRAL SOCKET
 * P&S! Possibilities for this sensor:
 * 	- SOCKET_E
 */
bmeGasesSensor  bme;

float temperature;	// Stores the temperature in ºC
float humidity;		// Stores the realitve humidity in %RH
float pressure;		// Stores the pressure in Pa


void setup()
{
  USB.ON();
  USB.println(F("Temperature, humidity and pressure sensor example"));
}


void loop()
{
  ///////////////////////////////////////////
  // 1. Turn on the sensor
  ///////////////////////////////////////////

  bme.ON();


  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////

  // Read enviromental variables
  temperature = bme.getTemperature();
  humidity = bme.getHumidity();
  pressure = bme.getPressure();

  // And print the values via USB
  USB.println(F("***************************************"));
  USB.print(F("Temperature: "));
  USB.print(temperature);
  USB.println(F(" Celsius degrees"));
  USB.print(F("RH: "));
  USB.print(humidity);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  USB.print(pressure);
  USB.println(F(" Pa"));

  ///////////////////////////////////////////
  // 3. Turn off the sensor
  ///////////////////////////////////////////

  bme.OFF();


  ///////////////////////////////////////////
  // 3. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 3 minutes, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Go to deep sleep mode..."));
  PWR.deepSleep("00:00:03:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.ON();
  USB.println(F("Wake up!!\r\n"));

}
