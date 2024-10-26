/*  
 *  ------ [Ga_v30_3] CO2 Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the CO2
 *  sensor every second, printing the result through the USB
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Version:           3.0
 *  Design:            David Gascón
 *  Implementation:    Ahmad Saad
 */

// Library include
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>

// CO2 Sensor must be connected physically in SOCKET_2
CO2SensorClass CO2Sensor;

// Concentratios used in calibration process (PPM Values)
#define POINT1_PPM_CO2 350.0  //   <-- Normal concentration in air
#define POINT2_PPM_CO2 1000.0
#define POINT3_PPM_CO2 3000.0

// Calibration vVoltages obtained during calibration process (Volts)
#define POINT1_VOLT_CO2 0.300
#define POINT2_VOLT_CO2 0.350
#define POINT3_VOLT_CO2 0.380

// Define the number of calibration points
#define numPoints 3

float concentrations[] = { POINT1_PPM_CO2, POINT2_PPM_CO2, POINT3_PPM_CO2 };
float voltages[] =       { POINT1_VOLT_CO2, POINT2_VOLT_CO2, POINT3_VOLT_CO2 };

char node_ID[] = "CO2_example";

void setup()
{    
  // Configure the USB port
  USB.ON();
  USB.println(F("CO2 Sensor reading for v30..."));

  // Calculate the slope and the intersection of the logarithmic function
  CO2Sensor.setCalibrationPoints(voltages, concentrations, numPoints);
  
  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the CO2 Sensor SOCKET_2
  CO2Sensor.ON();
}

void loop() 
{
  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////  

  // Voltage value of the sensor
  float CO2Vol = CO2Sensor.readVoltage();
  // PPM value of CO2
  float CO2PPM = CO2Sensor.readConcentration();

  // Print of the results
  USB.print(F("CO2 Sensor Voltage: "));
  USB.print(CO2Vol);
  USB.print(F("volts |"));
  
  USB.print(F(" CO2 concentration estimated: "));
  USB.print(CO2PPM);
  USB.println(F(" ppm"));

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 
  
  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add CO2 PPM value
  frame.addSensor(SENSOR_GASES_CO2, CO2PPM);
  // Show the frame
  frame.showFrame();
  
  delay(1000);
}


