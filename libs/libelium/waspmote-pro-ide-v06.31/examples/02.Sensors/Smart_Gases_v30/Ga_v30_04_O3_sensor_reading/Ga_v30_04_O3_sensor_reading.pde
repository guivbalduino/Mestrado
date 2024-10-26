/*  
 *  ------ [Ga_v30_4] O3 Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the O3
 *  sensor every five seconds, printing the result through the USB
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
 *   Version:           3.0
 *   Design:            David Gascón
 *   Implementation:    Ahmad Saad  
 */

// Library include
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>

// O3 Sensor can be connected in SOCKET_5
O3SensorClass O3Sensor;

// Concentratios used in calibration process (PPM VALUE)
#define POINT1_PPM_O3 100.0   //  <--- Ro value at this concentration
#define POINT2_PPM_O3 300.0   
#define POINT3_PPM_O3 1000.0  

// Calibration resistances obtained during calibration process (in KOhms)
#define POINT1_RES_O3 7.00  //  <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_O3 20.66 
#define POINT3_RES_O3 60.30

// Define the number of calibration points
#define numPoints 3

float concentrations[] = { POINT1_PPM_O3, POINT2_PPM_O3, POINT3_PPM_O3 };
float resValues[] =      { POINT1_RES_O3, POINT2_RES_O3, POINT3_RES_O3 };

char node_ID[] = "O3_example";

void setup()
{
  // Configure the USB port
  USB.ON();
  USB.println(F("O3 Sensor reading for v30..."));

  // Calculate the slope and the intersection of the logarithmic function
  O3Sensor.setCalibrationPoints(resValues, concentrations, numPoints);
  
  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  O3Sensor.ON();
}

void loop()
{
  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////  

  float O3Vol = O3Sensor.readVoltage();       // Voltage value of the sensor
  float O3Res = O3Sensor.readResistance();    // Resistance of the sensor
  float O3PPM = O3Sensor.readConcentration(); // PPM value of O3

  // Print of the results
  USB.print(F("O3 Sensor Voltage: "));
  USB.print(O3Vol);
  USB.print(F(" V |"));

  // Print of the results
  USB.print(F(" O3 Sensor Resistance: "));
  USB.print(O3Res);
  USB.print(F(" Ohms |"));

  // Print of the results
  USB.print(F(" O3 concentration Estimated: "));
  USB.print(O3PPM);
  USB.println(F(" ppm"));

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 
  
  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add CO2 PPM value
  frame.addSensor(SENSOR_GASES_O3, O3PPM);
  // Show the frame
  frame.showFrame();
  
  delay(5000);
}


