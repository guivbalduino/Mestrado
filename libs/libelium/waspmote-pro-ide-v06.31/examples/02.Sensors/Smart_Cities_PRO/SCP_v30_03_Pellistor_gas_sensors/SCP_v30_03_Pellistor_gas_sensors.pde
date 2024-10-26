/*
    ------------ [SCP_v30_03] - Pellistor gas sensors ------------

    Explanation: This is the basic code to manage and read the Pellistor
    gas sensor with Smart Cities PRO board. Pellistor sensor list:
      - CH4

    Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L.
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

#include <WaspSensorCities_PRO.h>

/*
   Define object for sensor: gas_sensor
   Input to choose board socket.
   Waspmote OEM. Possibilities for this sensor:
  	- SOCKET_1
  	- SOCKET_3
  	- SOCKET_5
   P&S! Possibilities for this sensor:
  	- SOCKET_B
  	- SOCKET_C
  	- SOCKET_F
*/
Gas gas_sensor(SOCKET_C);


/*
   Waspmote OEM. Possibilities for this sensor:
    - SOCKET_2
    - SOCKET_4
   P&S! Possibilities for this sensor:
    - SOCKET_A
    - SOCKET_B
    - SOCKET_C
    - SOCKET_E
    - SOCKET_F
*/
bmeCitiesSensor bme(SOCKET_A);


float concentration;	// Stores the concentration level in ppm
float temperature;	// Stores the temperature in ºC
float humidity;		// Stores the realitve humidity in %RH
float pressure;		// Stores the pressure in Pa


void setup()
{
  USB.println(F("Pellistor CH4 example"));
  USB.println(F("A BME sensor in socket A is also required"));
}



void loop()
{
  ///////////////////////////////////////////
  // 1. Power on  sensors
  ///////////////////////////////////////////

  // switch on BME sensor (temperature, humidity and pressure)
  bme.ON();

  // Read enviromental variables
  temperature = bme.getTemperature();
  humidity = bme.getHumidity();
  pressure = bme.getPressure();

  // Power off the BME sensor
  bme.OFF();


  // Power on the Pellistor sensor.
  // If the gases PRO board is off, turn it on automatically.
  gas_sensor.ON();

  // Pellistor gas sensor needs a warm up time at least 120 seconds
  // To reduce the battery consumption, use deepSleep instead delay
  // After 2 minutes, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Enter deep sleep mode to wait for Pellistor heating time..."));
  PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  USB.ON();
  USB.println(F("wake up!!"));


  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////

  // Read the Pellistor sensor and compensate with the temperature internally
  concentration = gas_sensor.getConc(temperature);

  // Power off the Pellistor sensor
  gas_sensor.OFF();

  // And print the values via USB
  USB.println(F("***************************************"));
  USB.print(F("Gas concentration: "));
  USB.printFloat(concentration, 3);
  USB.println(F(" % LEL"));
  USB.print(F("Temperature: "));
  USB.printFloat(temperature, 3);
  USB.println(F(" Celsius degrees"));
  USB.print(F("RH: "));
  USB.printFloat(humidity, 3);
  USB.println(F(" %"));
  USB.print(F("Pressure: "));
  USB.printFloat(pressure, 3);
  USB.println(F(" Pa"));
  USB.println(F("***************************************"));


  ///////////////////////////////////////////
  // 3. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep.
  // After 3 minutes, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Enter deep sleep mode"));
  PWR.deepSleep("00:00:03:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.ON();
  USB.println(F("wake up!!"));

}

