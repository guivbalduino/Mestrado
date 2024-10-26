/*
    ----------- [Sw_xtr_41] - Manta sensor reading  -----------

    Explanation: Basic example that configure the manta sensor, turns on,
    reads and turn off the sensor. Measured parameters are stored in the
    corresponding class variables and printed by the serial monitor.

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

    Version:           3.1
    Design:            David Gascón
    Implementation:    Isabel Burillo
*/

#include <WaspSensorXtr.h>
#include <WaspFrame.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_F       _________
                      |---------|
                      | A  B  C |
                      |_D__E__F_|

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_water_xtreme_tecnical.pdf
*/


//   [Sensor Class] [Sensor Name]
Eureka_Manta mySensor;

void setup()
{

  USB.ON();
  USB.println(F("Manta example"));

  /*  
   NOTE: The configureSensor() function restores the factory default configuration.
   This default configuration does not necessary fit with the sensors attached to
   your Manta probe. Run this function only if you know what you are doing.
  */

  /*// 1. Turn ON the sensor
  mySensor.ON();

  // 2. Configure sensor by Default
  mySensor.configureSensor();

  // 3. Save config
  mySensor.saveConfig();

  // 4. Turn off the sensor
  mySensor.OFF();
  */

}


void loop()
{
  // 1. Turn ON the sensor
  mySensor.ON();

  // 2. Read the sensor
  /*
    Note: read() function does not directly return sensor values.
    They are stored in the class vector variables defined for that purpose.
    Values are available as a float value
  */
  delay(20000); // warm up sensors
  mySensor.read();

  // 3. Turn off the sensor
  mySensor.OFF();

  // 4. Print information
  USB.println(F("---------------------------"));
  USB.println(F("Manta 40"));
  USB.print(F("Temperature: "));
  USB.printFloat(mySensor.sensorEureka.temperature, 2);
  USB.println(F(" degrees Celsius"));
  USB.print(F("pH: "));
  USB.printFloat(mySensor.sensorEureka.ph, 2);
  USB.println(F(" pH"));
  USB.print(F("ORP: "));
  USB.printFloat(mySensor.sensorEureka.orp, 2);
  USB.println(F(" mV"));
  USB.print(F("Depth: "));
  USB.printFloat(mySensor.sensorEureka.depth, 2);
  USB.println(F(" m"));
  USB.print(F("Specific Conductance: "));
  USB.printFloat(mySensor.sensorEureka.spCond, 2);
  USB.println(F(" uS/cm"));
  USB.print(F("HDO: "));
  USB.printFloat(mySensor.sensorEureka.hdo, 2);
  USB.println(F(" mg/l"));
  USB.print(F("Chl: "));
  USB.printFloat(mySensor.sensorEureka.chl, 2);
  USB.println(F(" ug/l"));
  USB.print(F("NH4: "));
  USB.printFloat(mySensor.sensorEureka.nh4, 2);
  USB.println(F(" mg/l-N"));
  USB.print(F("NO3: "));
  USB.printFloat(mySensor.sensorEureka.no3, 2);
  USB.println(F(" mg/l-N"));
  USB.print(F("Cl: "));
  USB.printFloat(mySensor.sensorEureka.cl, 2);
  USB.println(F(" mg/l-N"));
  USB.print(F("Turb: "));
  USB.printFloat(mySensor.sensorEureka.turb, 2);
  USB.println(F(" FNU"));
  USB.print(F("BGA: "));
  USB.printFloat(mySensor.sensorEureka.bg, 2);
  USB.println(F(" ppb"));
  USB.print(F("Timestamp: "));
  USB.print(mySensor.sensorEureka.ME_date);
  USB.print(F(" "));
  USB.println(mySensor.sensorEureka.ME_time);
  USB.println(F("---------------------------"));

  //  5. Create ASCII frame
  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // It is mandatory to specify the Smart Agriculture Xtreme type
  frame.setFrameType(INFORMATION_FRAME_WTR_XTR);

  // Add sensor values
  frame.addSensor(WTRX_MANTA_TC_F, mySensor.sensorEureka.temperature);
  frame.addSensor(WTRX_MANTA_PH_F, mySensor.sensorEureka.ph);
  frame.addSensor(WTRX_MANTA_ORP_F, mySensor.sensorEureka.orp);
  frame.addSensor(WTRX_MANTA_DEPTH_F, mySensor.sensorEureka.depth);
  frame.addSensor(WTRX_MANTA_COND_F, mySensor.sensorEureka.spCond);
  frame.addSensor(WTRX_MANTA_HDO_F, mySensor.sensorEureka.hdo);
  frame.addSensor(WTRX_MANTA_CHL_F, mySensor.sensorEureka.chl);
  frame.addSensor(WTRX_MANTA_NH4_F, mySensor.sensorEureka.nh4);
  frame.addSensor(WTRX_MANTA_NO3_F, mySensor.sensorEureka.no3);
  frame.addSensor(WTRX_MANTA_CL_F, mySensor.sensorEureka.cl);
  frame.addSensor(WTRX_MANTA_TURB_F, mySensor.sensorEureka.turb);
  frame.addSensor(WTRX_MANTA_BGA_F, mySensor.sensorEureka.bg);

  // Show the frame
  frame.showFrame();

  // 6. Sleep
  // Go to deepsleep
  // After 15 minutes, Waspmote wakes up thanks to the RTC Alarm
  PWR.deepSleep("00:00:15:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

}
