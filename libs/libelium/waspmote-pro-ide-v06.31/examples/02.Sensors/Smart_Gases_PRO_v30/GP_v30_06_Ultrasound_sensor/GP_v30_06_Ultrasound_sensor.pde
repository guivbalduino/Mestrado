/*
 *  ------------  [GP_v30_06] - Ultrasound sensor  --------------
 *
 *  Explanation: This is the basic code to manage and read the
 *  ultrasound sensor.Cycle time: 30 seconds
 *
 *  Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
 *  http://www.libelium.com
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Version:		        3.2
 *  Design:             David Gascón
 *  Implementation:     Alejandro Gállego
 */

#include <WaspSensorGas_Pro.h>

/*
 * Waspmote OEM. Possibilities for this sensor:
 * 	- CENTRAL SOCKET
 * P&S! Possibilities for this sensor:
 * 	- SOCKET_E
 */
ultrasoundGasesSensor  ultrasound;

uint16_t range;


void setup()
{
  USB.ON();
  USB.println(F("Ultrasound sensor example"));

}

void loop()
{
  ///////////////////////////////////////////
  // 1. Turn on the sensors
  ///////////////////////////////////////////

  ultrasound.ON();


  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////

  // Read the ultrasound sensor
  range = ultrasound.getDistance();

  // And print the value via USB
  USB.println(F("***************************************"));
  USB.print(F("Distance: "));
  USB.print(range);
  USB.println(F(" cm"));


  ///////////////////////////////////////////
  // 3. Power off sensors
  ///////////////////////////////////////////

  ultrasound.OFF();


  ///////////////////////////////////////////
  // 4. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 30 seconds, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Enter deep sleep mode"));
  PWR.deepSleep("00:00:00:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);
  USB.ON();
  USB.println(F("wake up!!"));

}
