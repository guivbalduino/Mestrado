/*
    ------------  [SCP_v30_09] - Frame Class Utility  --------------

    Explanation: This is the basic code to create a frame with some
  	Smart Cities Pro Sensor Board sensors

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

    Version:		    3.3
    Design:         David Gascón
    Implementation: Alejandro Gállego
*/

#include <WaspSensorCities_PRO.h>
#include <WaspFrame.h>
#include <WaspPM.h>


/*
   Define objects for sensors
   Imagine we have a P&S! with the next sensors:
    - SOCKET_A: BME280 sensor (temperature, humidity & pressure)
    - SOCKET_B: Electrochemical gas sensor (O3)
    - SOCKET_C: Electrochemical gas sensor (NO2)
    - SOCKET_D: Particle matter sensor (dust)
    - SOCKET_E: Luxes sensor
    - SOCKET_F: Pellistor sensor (CO2)
*/
bmeCitiesSensor bme(SOCKET_A);
luxesCitiesSensor luxes(SOCKET_E);
Gas sensor_o3(SOCKET_B);
Gas sensor_no2(SOCKET_C);
Gas sensor_co2(SOCKET_F);


// define vars for sensor values
float temperature;
float humidity;
float pressure;
uint32_t luminosity;
float concentration_o3;
float concentration_no2;
float concentration_co2;
int OPC_status;
int OPC_measure;

// define Waspmote ID
char node_ID[] = "Node_01";


void setup()
{
  USB.ON();
  USB.println(F("Frame Utility Example for Cities Pro Board"));
  USB.println(F("Sensors used:"));
  USB.println(F("- SOCKET_A: BME280 sensor (temperature, humidity & pressure)"));
  USB.println(F("- SOCKET_B: Electrochemical gas sensor (O3)"));
  USB.println(F("- SOCKET_C: Electrochemical gas sensor (NO2)"));
  USB.println(F("- SOCKET_D: Particle matter sensor (dust)"));
  USB.println(F("- SOCKET_E: Luxes sensor"));
  USB.println(F("- SOCKET_F: NDIR sensor (CO2)"));

  // Set the Waspmote ID
  frame.setID(node_ID);
}


void loop()
{
  ///////////////////////////////////////////
  // 1. Read BME and luxes sensors
  ///////////////////////////////////////////

  // switch off all gas sensors for better performance
  sensor_o3.OFF();
  sensor_no2.OFF();
  sensor_co2.OFF();

  // switch on BME sensor
  // read temperature, humidity and pressure
  // switch off BME sensor
  bme.ON();
  temperature = bme.getTemperature();
  humidity = bme.getHumidity();
  pressure = bme.getPressure();
  bme.OFF();

  // switch on luxes sensor
  // read luminosity
  // switch off luxes sensor
  luxes.ON();
  luminosity = luxes.getLuminosity();
  luxes.OFF();

  // switch on all gas sensor again
  sensor_o3.ON();
  sensor_no2.ON();
  sensor_co2.ON();


  ///////////////////////////////////////////
  // 2. Wait heating time
  ///////////////////////////////////////////

  // Sensors need time to warm up and get a response from gas
  // To reduce the battery consumption, use deepSleep instead delay
  // After 2 minutes, Waspmote wakes up thanks to the RTC Alarm
  USB.println();
  USB.println(F("Enter deep sleep mode to wait for sensors heating time..."));
  PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  USB.ON();
  USB.println(F("wake up!!\r\n"));


  ///////////////////////////////////////////
  // 3. Read gas sensors
  ///////////////////////////////////////////

  // Read the sensors and compensate with the temperature internally
  concentration_o3 = sensor_o3.getConc(temperature);
  concentration_no2 = sensor_no2.getConc(temperature);
  concentration_co2 = sensor_co2.getConc(temperature);


  // switch off CO2 sensor
  // Pellistor and NDIR sensors must be switched off after
  // reading because they present a high power consumption
  sensor_co2.OFF();


  ///////////////////////////////////////////
  // 4. Read particle matter sensor
  ///////////////////////////////////////////

  // Turn on the particle matter sensor
  OPC_status = PM.ON();
  if (OPC_status == 1)
  {
    USB.println(F("Particle sensor started"));
  }
  else
  {
    USB.println(F("Error starting the particle sensor"));
  }

  // Get measurement from the particle matter sensor
  if (OPC_status == 1)
  {
    // Power the fan and the laser and perform a measure of 5 seconds
    OPC_measure = PM.getPM(5000, 5000);
  }

  PM.OFF();


  ///////////////////////////////////////////
  // 5. Print sensor values
  ///////////////////////////////////////////

  USB.println(F("***********************************************"));
  USB.print(F("SOCKET_A -- > Temperature : "));
  USB.printFloat(temperature, 2);
  USB.println(F(" Celsius degrees"));
  USB.print(F("SOCKET_A -- > Humidity : "));
  USB.printFloat(humidity, 2);
  USB.println(F(" % "));
  USB.print(F("SOCKET_A -- > Pressure : "));
  USB.printFloat(pressure, 2);
  USB.println(F(" Pa"));
  USB.print(F("SOCKET_B -- > O3 concentration : "));
  USB.printFloat(concentration_o3, 3);
  USB.println(F(" ppm"));
  USB.print(F("SOCKET_C -- > NO2 concentration : "));
  USB.printFloat(concentration_no2, 3);
  USB.println(F(" ppm"));

  // check answer
  if (OPC_measure == 1)
  {
    USB.print(F("SOCKET_D -- > PM 1 : "));
    USB.printFloat(PM._PM1, 3);
    USB.println(F(" ug / m3"));
    USB.print(F("SOCKET_D -- > PM 2.5 : "));
    USB.printFloat(PM._PM2_5, 3);
    USB.println(F(" ug / m3"));
    USB.print(F("SOCKET_D -- > PM 10 : "));
    USB.printFloat(PM._PM10, 3);
    USB.println(F(" ug / m3"));
  }
  else
  {
    USB.print(F("SOCKET_D -- > Error performing the measure. Error code : "));
    USB.println(OPC_measure, DEC);
  }

  USB.print(F("SOCKET_E -- > Luminosity : "));
  USB.print(luminosity);
  USB.println(F(" luxes"));
  USB.print(F("SOCKET_F -- > CO2 concentration : "));
  USB.printFloat(concentration_co2, 3);
  USB.println(F(" ppm"));
  USB.println(F("***********************************************"));



  ///////////////////////////////////////////
  // 6. Create ASCII frame
  ///////////////////////////////////////////

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // Add sensor values
  frame.addSensor(SENSOR_CITIES_PRO_TC, temperature);
  frame.addSensor(SENSOR_CITIES_PRO_HUM, humidity);
  frame.addSensor(SENSOR_CITIES_PRO_PRES, pressure);
  frame.addSensor(SENSOR_CITIES_PRO_O3, concentration_o3);
  frame.addSensor(SENSOR_CITIES_PRO_NO2, concentration_no2);
  frame.addSensor(SENSOR_CITIES_PRO_CO2, concentration_co2);
  frame.addSensor(SENSOR_CITIES_PRO_LUXES, luminosity);
  frame.addSensor(SENSOR_CITIES_PRO_PM1, PM._PM1);
  frame.addSensor(SENSOR_CITIES_PRO_PM2_5, PM._PM2_5);
  frame.addSensor(SENSOR_CITIES_PRO_PM10, PM._PM10);
 
  // Show the frame
  frame.showFrame();


  ///////////////////////////////////////////
  // 7. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 30 seconds, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Enter deep sleep mode"));
  PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  USB.ON();
  USB.println(F("wake up!!"));

}
