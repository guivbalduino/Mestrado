/*
    ------------  [SCP_v30_12] - Frame Class Utility  --------------

    Explanation: This is the basic code to create a frame with some
    Smart Cities Pro Sensor Board sensors

    Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L.
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

    Version:        3.0
*/

#include <WaspSensorCities_PRO.h>
#include <WaspFrame.h>


/*
   Define objects for sensors
   Imagine we have a P&S! with the next sensors:
    - SOCKET_A: Noise Level Sensor Class 2
    - SOCKET_B: Electrochemical gas sensor (O3)
    - SOCKET_C: BME280 sensor (temperature, humidity & pressure)
*/
Gas sensor_o3(SOCKET_B);
bmeCitiesSensor bme(SOCKET_C);


// define vars for sensor values
float temperature;
float humidity;
float pressure;
uint32_t luminosity;
float concentration_o3;
uint8_t NLSC2_status = 0;

// define Waspmote ID
char node_ID[] = "Node_01";


void setup()
{
  USB.ON();
  USB.println(F("Frame Utility Example for Cities Pro Board"));
  USB.println(F("Sensors used:"));
  USB.println(F("- SOCKET_A: Noise Level Sensor Class 2"));
  USB.println(F("- SOCKET_B: Electrochemical gas sensor (O3)"));
  USB.println(F("- SOCKET_C: BME280 sensor (temperature, humidity & pressure)"));

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

  // switch on BME sensor
  // read temperature, humidity and pressure
  // switch off BME sensor
  bme.ON();
  temperature = bme.getTemperature();
  humidity = bme.getHumidity();
  pressure = bme.getPressure();
  bme.OFF();

  // switch on all gas sensor again
  sensor_o3.ON();


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


  ///////////////////////////////////////////
  // 4. Read NLS sensor
  ///////////////////////////////////////////

  noiseClass2.ON();
  
  // Get a new measure of all data from noise sensor
  NLSC2_status = noiseClass2.getAllData();

  // And print the value via USB
  if (NLSC2_status == 1)
  {
    USB.println(F("***************************************"));
    USB.println(F("Noise level measurements: "));

    USB.println(F("--- SPL ---"));
    USB.print(F("LAF = "));
    USB.printFloat(noiseClass2.LAF, 1);
    USB.println(" dB");
    USB.print(F("LAS = "));
    USB.printFloat(noiseClass2.LAS, 1);
    USB.println(" dB");
    USB.print(F("LAI = "));
    USB.printFloat(noiseClass2.LAI, 1);
    USB.println(" dB");
    USB.print(F("LBF = "));
    USB.printFloat(noiseClass2.LBF, 1);
    USB.println(" dB");
    USB.print(F("LBS = "));
    USB.printFloat(noiseClass2.LBS, 1);
    USB.println(" dB");
    USB.print(F("LBI = "));
    USB.printFloat(noiseClass2.LBI, 1);
    USB.println(" dB");
    USB.print(F("LCF = "));
    USB.printFloat(noiseClass2.LCF, 1);
    USB.println(" dB");
    USB.print(F("LCS = "));
    USB.printFloat(noiseClass2.LCS, 1);
    USB.println(" dB");
    USB.printFloat(noiseClass2.LCI, 1);
    USB.println(" dB");
    USB.print(F("LZF = "));
    USB.printFloat(noiseClass2.LZF, 1);
    USB.println(" dB");
    USB.print(F("LZS = "));
    USB.printFloat(noiseClass2.LZS, 1);
    USB.println(" dB");
    USB.print(F("LZI = "));
    USB.printFloat(noiseClass2.LZI, 1);
    USB.println(" dB");

    USB.println(F("--- SD ---"));
    USB.print(F("LAFsd = "));
    USB.printFloat(noiseClass2.LAFsd, 1);
    USB.println(" dB");
    USB.print(F("LASsd = "));
    USB.printFloat(noiseClass2.LASsd, 1);
    USB.println(" dB");
    USB.print(F("LAIsd = "));
    USB.printFloat(noiseClass2.LAIsd, 1);
    USB.println(" dB");
    USB.print(F("LBFsd = "));
    USB.printFloat(noiseClass2.LBFsd, 1);
    USB.println(" dB");
    USB.print(F("LBSsd = "));
    USB.printFloat(noiseClass2.LBSsd, 1);
    USB.println(" dB");
    USB.print(F("LBIsd = "));
    USB.printFloat(noiseClass2.LBIsd, 1);
    USB.println(" dB");
    USB.print(F("LCFsd = "));
    USB.printFloat(noiseClass2.LCFsd, 1);
    USB.println(" dB");
    USB.print(F("LCSsd = "));
    USB.printFloat(noiseClass2.LCSsd, 1);
    USB.println(" dB");
    USB.print(F("LCIsd = "));
    USB.printFloat(noiseClass2.LCIsd, 1);
    USB.println(" dB");
    USB.print(F("LZFsd = "));
    USB.printFloat(noiseClass2.LZFsd, 1);
    USB.println(" dB");
    USB.print(F("LZSsd = "));
    USB.printFloat(noiseClass2.LZSsd, 1);
    USB.println(" dB");
    USB.print(F("LZIsd = "));
    USB.printFloat(noiseClass2.LZIsd, 1);
    USB.println(" dB");

    USB.println(F("--- SEL ---"));
    USB.print(F("LAsel = "));
    USB.printFloat(noiseClass2.LAsel, 1);
    USB.println(" dB");
    USB.print(F("LBsel = "));
    USB.printFloat(noiseClass2.LBsel, 1);
    USB.println(" dB");
    USB.print(F("LCsel = "));
    USB.printFloat(noiseClass2.LCsel, 1);
    USB.println(" dB");
    USB.print(F("LZsel = "));
    USB.printFloat(noiseClass2.LZsel, 1);
    USB.println(" dB");

    USB.println(F("--- E ---"));
    USB.print(F("LAe = "));
    USB.printFloat(noiseClass2.LAe, 10);
    USB.println("");
    USB.print(F("LBe = "));
    USB.printFloat(noiseClass2.LBe, 10);
    USB.println("");
    USB.print(F("LCe = "));
    USB.printFloat(noiseClass2.LCe, 10);
    USB.println("");
    USB.print(F("LZe = "));
    USB.printFloat(noiseClass2.LZe, 10);
    USB.println("");

    USB.println(F("--- Max ---"));
    USB.print(F("LAFmax = "));
    USB.printFloat(noiseClass2.LAFmax, 1);
    USB.println(" dB");
    USB.print(F("LASmax = "));
    USB.printFloat(noiseClass2.LASmax, 1);
    USB.println(" dB");
    USB.print(F("LAImax = "));
    USB.printFloat(noiseClass2.LAImax, 1);
    USB.println(" dB");
    USB.print(F("LBFmax = "));
    USB.printFloat(noiseClass2.LBFmax, 1);
    USB.println(" dB");
    USB.print(F("LBSmax = "));
    USB.printFloat(noiseClass2.LBSmax, 1);
    USB.println(" dB");
    USB.print(F("LBImax = "));
    USB.printFloat(noiseClass2.LBImax, 1);
    USB.println(" dB");
    USB.print(F("LCFmax = "));
    USB.printFloat(noiseClass2.LCFmax, 1);
    USB.println(" dB");
    USB.print(F("LCSmax = "));
    USB.printFloat(noiseClass2.LCSmax, 1);
    USB.println(" dB");
    USB.print(F("LCImax = "));
    USB.printFloat(noiseClass2.LCImax, 1);
    USB.println(" dB");
    USB.print(F("LZFmax = "));
    USB.printFloat(noiseClass2.LZFmax, 1);
    USB.println(" dB");
    USB.print(F("LZSmax = "));
    USB.printFloat(noiseClass2.LZSmax, 1);
    USB.println(" dB");
    USB.print(F("LZImax = "));
    USB.printFloat(noiseClass2.LZImax, 1);
    USB.println(" dB");

    USB.println(F("--- Min ---"));
    USB.print(F("LAFmin = "));
    USB.printFloat(noiseClass2.LAFmin, 1);
    USB.println(" dB");
    USB.print(F("LASmin = "));
    USB.printFloat(noiseClass2.LASmin, 1);
    USB.println(" dB");
    USB.print(F("LAImin = "));
    USB.printFloat(noiseClass2.LAImin, 1);
    USB.println(" dB");
    USB.print(F("LBFmin = "));
    USB.printFloat(noiseClass2.LBFmin, 1);
    USB.println(" dB");
    USB.print(F("LBSmin = "));
    USB.printFloat(noiseClass2.LBSmin, 1);
    USB.println(" dB");
    USB.print(F("LBImin = "));
    USB.printFloat(noiseClass2.LBImin, 1);
    USB.println(" dB");
    USB.print(F("LCFmin = "));
    USB.printFloat(noiseClass2.LCFmin, 1);
    USB.println(" dB");
    USB.print(F("LCSmin = "));
    USB.printFloat(noiseClass2.LCSmin, 1);
    USB.println(" dB");
    USB.print(F("LCImin = "));
    USB.printFloat(noiseClass2.LCImin, 1);
    USB.println(" dB");
    USB.print(F("LZFmin = "));
    USB.printFloat(noiseClass2.LZFmin, 1);
    USB.println(" dB");
    USB.print(F("LZSmin = "));
    USB.printFloat(noiseClass2.LZSmin, 1);
    USB.println(" dB");
    USB.print(F("LZImin = "));
    USB.printFloat(noiseClass2.LZImin, 1);
    USB.println(" dB");

    USB.println(F("--- Peak ---"));
    USB.print(F("LApeak = "));
    USB.printFloat(noiseClass2.LApeak, 1);
    USB.println(" dB");
    USB.print(F("LBpeak = "));
    USB.printFloat(noiseClass2.LBpeak, 1);
    USB.println(" dB");
    USB.print(F("LCpeak = "));
    USB.printFloat(noiseClass2.LCpeak, 1);
    USB.println(" dB");
    USB.print(F("LZpeak = "));
    USB.printFloat(noiseClass2.LZpeak, 1);
    USB.println(" dB");

    USB.println(F("--- Leq ---"));
    USB.print(F("LAeq = "));
    USB.printFloat(noiseClass2.LAeq, 1);
    USB.println(" dB");
    USB.print(F("LBeq = "));
    USB.printFloat(noiseClass2.LBeq, 1);
    USB.println(" dB");
    USB.print(F("LCeq = "));
    USB.printFloat(noiseClass2.LCeq, 1);
    USB.println(" dB");
    USB.print("LZeq = ");
    USB.printFloat(noiseClass2.LZeq, 1);
    USB.println(" dB");

    USB.println(F("--- LN ---"));
    USB.print(F("L10 = "));
    USB.printFloat(noiseClass2.L10, 1);
    USB.println(" dB");
    USB.print(F("L20 = "));
    USB.printFloat(noiseClass2.L20, 1);
    USB.println(" dB");
    USB.print(F("L30 = "));
    USB.printFloat(noiseClass2.L30, 1);
    USB.println(" dB");
    USB.print(F("L40 = "));
    USB.printFloat(noiseClass2.L40, 1);
    USB.println(" dB");
    USB.print(F("L50 = "));
    USB.printFloat(noiseClass2.L50, 1);
    USB.println(" dB");
    USB.print(F("L60 = "));
    USB.printFloat(noiseClass2.L60, 1);
    USB.println(" dB");
    USB.print(F("L70 = "));
    USB.printFloat(noiseClass2.L70, 1);
    USB.println(" dB");
    USB.print(F("L80 = "));
    USB.printFloat(noiseClass2.L80, 1);
    USB.println(" dB");
    USB.print(F("L90 = "));
    USB.printFloat(noiseClass2.L90, 1);
    USB.println(" dB");
    USB.print(F("L99 = "));
    USB.printFloat(noiseClass2.L99, 1);
    USB.println(" dB");
  }
  else
  {
    USB.println(F("Communication error. No response from noise sensor"));
  }


  ///////////////////////////////////////////
  // 5. Print sensor values
  ///////////////////////////////////////////

  USB.println(F("***********************************************"));
  USB.print(F("SOCKET_A -- > LAeq : "));
  USB.printFloat(noiseClass2.LAeq, 1);
  USB.println(F(" dB"));
  USB.print(F("SOCKET_A -- > LBeq : "));
  USB.printFloat(noiseClass2.LBeq, 1);
  USB.println(F(" dB"));
  USB.print(F("SOCKET_A -- > LCeq : "));
  USB.printFloat(noiseClass2.LCeq, 1);
  USB.println(F(" dB"));
  USB.print(F("SOCKET_A -- > LZeq : "));
  USB.printFloat(noiseClass2.LZeq, 1);
  USB.println(F(" dB"));
  USB.print(F("SOCKET_B -- > O3 concentration : "));
  USB.printFloat(concentration_o3, 3);
  USB.println(F(" ppm"));
  USB.print(F("SOCKET_C -- > Temperature : "));
  USB.printFloat(temperature, 2);
  USB.println(F(" Celsius degrees"));
  USB.print(F("SOCKET_C -- > Humidity : "));
  USB.printFloat(humidity, 2);
  USB.println(F(" % "));
  USB.print(F("SOCKET_C -- > Pressure : "));
  USB.printFloat(pressure, 2);
  USB.println(F(" Pa"));
  USB.println(F("***********************************************"));

  ///////////////////////////////////////////
  // 6. Create ASCII frame
  ///////////////////////////////////////////

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // It is mandatory to specify the Smart Cities 
  // PRO type when using the NLS Class 2
  frame.setFrameType(INFORMATION_FRAME_CITIES_PRO);

  // Add sensor values
  frame.addSensor(SENSOR_CITIES_PRO_TC, temperature);
  frame.addSensor(SENSOR_CITIES_PRO_HUM, humidity);
  frame.addSensor(SENSOR_CITIES_PRO_PRES, pressure);
  frame.addSensor(SENSOR_CITIES_PRO_O3, concentration_o3);
  frame.addSensor(SENSOR_CITIES_PRO_NLS2_LAF, noiseClass2.LAF);
  frame.addSensor(SENSOR_CITIES_PRO_NLS2_LAS, noiseClass2.LAS);
  frame.addSensor(SENSOR_CITIES_PRO_NLS2_LAI, noiseClass2.LAI);
  frame.addSensor(SENSOR_CITIES_PRO_NLS2_LAEQ, noiseClass2.LAeq);

  // Show the frame
  frame.showFrame();

  ///////////////////////////////////////////
  // 7. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 2 minutes, Waspmote wakes up thanks to the RTC Alarm
  USB.println(F("Enter deep sleep mode"));
  PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);
  USB.ON();
  USB.println(F("wake up!!"));

}
