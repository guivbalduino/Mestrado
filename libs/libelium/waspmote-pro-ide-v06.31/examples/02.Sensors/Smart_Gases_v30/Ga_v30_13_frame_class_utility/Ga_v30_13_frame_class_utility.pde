/*
    ------------  [Ga_13] - Frame Class Utility  --------------

    Explanation: This is the basic code to create a frame with some
  	Gases Sensor Board sensors

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
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

    Version:		   3.0
    Design:             David Gascón
    Implementation:     Ahmad Saad, Luis Miguel Marti
*/

#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>

#define NUM_OF_POINTS 3

//*********************************************************************************
// O2 Sensor must be connected in SOCKET1
//*********************************************************************************
O2SensorClass O2Sensor(SOCKET_1);

// Percentage values of Oxygen
#define POINT1_PERCENTAGE 0.0
#define POINT2_PERCENTAGE 5.0
// Calibration Voltage Obtained during calibration process (in mV)
#define POINT1_VOLTAGE 0.35
#define POINT2_VOLTAGE 2.0

float concentrations_o2[] = {POINT1_PERCENTAGE, POINT2_PERCENTAGE};
float voltages_o2[] =       {POINT1_VOLTAGE, POINT2_VOLTAGE};


//*********************************************************************************
// CO2 Sensor must be connected physically in SOCKET2
//*********************************************************************************
CO2SensorClass CO2Sensor;

// Concentratios used in calibration process
#define POINT1_PPM_CO2 350.0    // PPM VALUE <-- Normal concentration in air
#define POINT2_PPM_CO2 1000.0   // PPM VALUE
#define POINT3_PPM_CO2 3000.0   // PPM VALUE

// Calibration vVoltages obtained during calibration process
#define POINT1_VOLT_CO2 0.300
#define POINT2_VOLT_CO2 0.350
#define POINT3_VOLT_CO2 0.380

float concentrations_co2[] = {POINT1_PPM_CO2, POINT2_PPM_CO2, POINT3_PPM_CO2};
float voltages_co2[] =       {POINT1_VOLT_CO2, POINT2_VOLT_CO2, POINT3_VOLT_CO2};


//*********************************************************************************
// NO2 Sensor must be connected physically in SOCKET3
//*********************************************************************************
NO2SensorClass NO2Sensor;

// Concentratios used in calibration process
#define POINT1_PPM_NO2 10.0   // PPM VALUE <-- Normal concentration in air
#define POINT2_PPM_NO2 50.0   // PPM VALUE
#define POINT3_PPM_NO2 100.0  // PPM VALUE

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_NO2 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_NO2 25.50
#define POINT3_RES_NO2 3.55

float concentrations_no2[] = {POINT1_PPM_NO2, POINT2_PPM_NO2, POINT3_PPM_NO2};
float voltages_no2[] =       {POINT1_RES_NO2, POINT2_RES_NO2, POINT3_RES_NO2};


//*********************************************************************************
// CO Sensor must be connected physically in SOCKET4
//*********************************************************************************
COSensorClass COSensor;
// Concentratios used in calibration process
#define POINT1_PPM_CO 100.0   // PPM VALUE  <--- Ro value at this concentration
#define POINT2_PPM_CO 300.0   // PPM VALUE
#define POINT3_PPM_CO 1000.0  // PPM VALUE

// Calibration resistances obtained during calibration process
#define POINT1_RES_CO 230.30 // (in KOhms) <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_CO 40.665 // (in KOhms)
#define POINT3_RES_CO 20.300 // (in KOhms)

float concentrations_co[] = { POINT1_PPM_CO, POINT2_PPM_CO, POINT3_PPM_CO };
float resValues_co[] =      { POINT1_RES_CO, POINT2_RES_CO, POINT3_RES_CO };


//*********************************************************************************
// O3 Sensor definitios
//*********************************************************************************
O3SensorClass O3Sensor;

// Concentratios used in calibration process
#define POINT1_PPM_O3 100.0   // PPM VALUE  <--- Ro value at this concentration
#define POINT2_PPM_O3 300.0   // PPM VALUE
#define POINT3_PPM_O3 1000.0  // PPM VALUE

// Calibration resistances obtained during calibration process
#define POINT1_RES_O3 7.00 // (in KOhms) <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_O3 20.66 // (in KOhms)
#define POINT3_RES_O3 60.30 // (in KOhms)  

float concentrations_o3[] = { POINT1_PPM_O3, POINT2_PPM_O3, POINT3_PPM_O3 };
float resValues_o3[] =      { POINT1_RES_O3, POINT2_RES_O3, POINT3_RES_O3 };


//*********************************************************************************
// CH4 Sensor can be connected in SOCKET6 AND SOCKET7
//*********************************************************************************
LPGSensorClass LPGSensor; // <---- SOCKET7 Class used

// Concentratios used in calibration process
#define POINT1_PPM_LPG 10.0   // PPM VALUE <-- Normal concentration in air
#define POINT2_PPM_LPG 50.0   // PPM VALUE
#define POINT3_PPM_LPG 100.0  // PPM VALUE

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_LPG 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_LPG 25.50
#define POINT3_RES_LPG 3.55

float concentrations_lps[] = {POINT1_PPM_LPG, POINT2_PPM_LPG, POINT3_PPM_LPG};
float voltages_lps[] =       {POINT1_RES_LPG, POINT2_RES_LPG, POINT3_RES_LPG};


//*********************************************************************************
// CH4 Sensor can be connected in SOCKET6 AND SOCKET7
//*********************************************************************************
CH4SensorClass CH4Sensor; // <---- SOCKET6 Class used

// Concentratios used in calibration process
#define POINT1_PPM_CH4 10.0   // PPM VALUE <-- Normal concentration in air
#define POINT2_PPM_CH4 50.0   // PPM VALUE
#define POINT3_PPM_CH4 100.0  // PPM VALUE

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_CH4 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_CH4 25.50
#define POINT3_RES_CH4 3.55

float concentrations_ch4[] = {POINT1_PPM_CH4, POINT2_PPM_CH4, POINT3_PPM_CH4};
float voltages_ch4[] =       {POINT1_RES_CH4, POINT2_RES_CH4, POINT3_RES_CH4};


//*********************************************************************************
// BME280 Definitions
//*********************************************************************************
#include <BME280.h>

float temperature; // Stores the temperature in ºC
float humidity;    // Stores the realitve humidity in %RH
float pressure;    // Stores the pressure in Pa

//*********************************************************************************


char node_ID[] = "Node_01";


void setup()
{
  // Configure the calibration values
  O2Sensor.setCalibrationPoints(voltages_o2, concentrations_o2);
  // Configure the calibration values
  CO2Sensor.setCalibrationPoints(voltages_co2, concentrations_co2, NUM_OF_POINTS);
  // Configure the calibration values
  NO2Sensor.setCalibrationPoints(voltages_no2, concentrations_no2, NUM_OF_POINTS);
  // Configure the calibration values
  COSensor.setCalibrationPoints(resValues_co, concentrations_co, NUM_OF_POINTS);
  // Configure the calibration values
  O3Sensor.setCalibrationPoints(resValues_o3, concentrations_o3, NUM_OF_POINTS);
  // Configure the calibration values
  CH4Sensor.setCalibrationPoints(voltages_ch4, concentrations_ch4, NUM_OF_POINTS);
  // Configure the calibration values
  LPGSensor.setCalibrationPoints(voltages_lps, concentrations_lps, NUM_OF_POINTS);

  USB.ON();
  USB.println(F("Frame Utility Example for Gases Sensor Board"));

  // Set the Waspmote ID
  frame.setID(node_ID);

  ///////////////////////////////////////////
  // 1. Turn on the board
  ///////////////////////////////////////////
  
  //Power gases board and wait for stabilization and sensor response time
  Gases.ON();
}

void loop()
{

  //////////////////////////////////////////////////////////////////////
  // 2. Read Sensors
  //////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////
  // 2.1 Read Temperature, Humidity and Pressure Sensor (BME280)
  //////////////////////////////////////////////////////////////////////

  // Read enviromental variables
  temperature = Gases.getTemperature();
  humidity = Gases.getHumidity();
  pressure = Gases.getPressure();

  //////////////////////////////////////////////////////////////////////
  // 2.2 Read O2 Sensor - Connected in SOCKET1
  //////////////////////////////////////////////////////////////////////

  O2Sensor.ON();
  delay(1000);

   // Read the concentration value in %
  float O2Val = O2Sensor.readConcentration();

  O2Sensor.OFF();

  //////////////////////////////////////////////////////////////////////
  // 2.3 Read CO2 Sensor - Connected in SOCKET2
  //////////////////////////////////////////////////////////////////////

  CO2Sensor.ON();
  delay(1000);

  // PPM value of CO2
  float CO2PPM = CO2Sensor.readConcentration();

  CO2Sensor.OFF();

  //////////////////////////////////////////////////////////////////////
  // 2.4 Read NO2 Sensor - Connected in SOCKET3
  //////////////////////////////////////////////////////////////////////
  NO2Sensor.ON();
  delay(1000);

  // PPM value of NO2
  float NO2PPM = NO2Sensor.readConcentration();

  NO2Sensor.OFF();

  //////////////////////////////////////////////////////////////////////
  // 2.4 Read CO Sensor - Connected in SOCKET4
  //////////////////////////////////////////////////////////////////////

  COSensor.ON();
  delay(1000);

  // PPM value of CO
  float COPPM = COSensor.readConcentration();

  //////////////////////////////////////////////////////////////////////
  // 2.5 Read O3 Sensor - Connected in SOCKET5
  //////////////////////////////////////////////////////////////////////

  O3Sensor.ON();
  delay(1000);

  // PPM value of O3
  float O3PPM = O3Sensor.readConcentration(); 

  O3Sensor.OFF();

  //////////////////////////////////////////////////////////////////////
  // 2.6 Read CH4 Sensor - Connected in SOCKET6
  //////////////////////////////////////////////////////////////////////

  CH4Sensor.ON();
  delay(1000);

  // PPM value of CH4
  float CH4PPM = CH4Sensor.readConcentration();

  CH4Sensor.OFF();

  //////////////////////////////////////////////////////////////////////
  // 2.7 Read LPG Sensor - Connected in SOCKET7
  //////////////////////////////////////////////////////////////////////

  LPGSensor.ON();
  delay(500);

  // PPM value of CH4
  float LPGPPM = LPGSensor.readConcentration();

  LPGSensor.OFF();

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  ///////////////////////////////////////////

   // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);

  // Add Oxygen voltage value
  frame.addSensor(SENSOR_GASES_O2, O2Val);
  // Add CO2 PPM value
  frame.addSensor(SENSOR_GASES_CO2, NO2PPM);
  // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_NO2, NO2PPM);
  // Add CO PPM value
  frame.addSensor(SENSOR_GASES_CO, COPPM);
  // Add CO2 PPM value
  frame.addSensor(SENSOR_GASES_O3, O3PPM);
   // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_CH4, CH4PPM);
  // Add LPG PPM value
  frame.addSensor(SENSOR_GASES_LPG, LPGPPM);
  
  // Show the frame
  frame.showFrame();

  //wait 2 seconds
  delay(5000);
}
