/*  
 *  ------ [Ga_v30_6] VOC Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the VOC
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

// VOC Sensor must be connected in SOCKET_5
VOCSensorClass VOCSensor;

// Concentratios used in calibration process (PPM VALUE)
#define POINT1_PPM_VOC 100.0   //  <--- Ro value at this concentration
#define POINT2_PPM_VOC 300.0   
#define POINT3_PPM_VOC 1000.0 

// Calibration resistances obtained during calibration process
#define POINT1_RES_VOC 230.30 // <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_VOC 40.665 // 
#define POINT3_RES_VOC 20.300 // 

// Define the number of calibration points
#define numPoints 3

float concentrations[] = { POINT1_PPM_VOC, POINT2_PPM_VOC, POINT3_PPM_VOC };
float resValues[] =      { POINT1_RES_VOC, POINT2_RES_VOC, POINT3_RES_VOC };

char node_ID[] = "VOC_example";

void setup() 
{
  // Configure the USB port
  USB.ON();  
  USB.println(F("VOC Sensor reading for v30..."));

  // Calculate the slope and the intersection of the logarithmic function
  VOCSensor.setCalibrationPoints(resValues, concentrations, numPoints);

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  VOCSensor.ON();  
}

void loop() 
{
  //////////////////////////////////////////
  // 2. Read sensors
  //////////////////////////////////////////

  float VOCVol = VOCSensor.readVoltage();       // Voltage value of the sensor
  float VOCRes = VOCSensor.readResistance();    // Resistance of the sensor
  float VOCPPM = VOCSensor.readConcentration(); // PPM value of VOC

  // Print of the results
  USB.print(F("VOC Sensor Voltage: "));
  USB.print(VOCVol);
  USB.print(F(" V |"));

  // Print of the results
  USB.print(F(" VOC Sensor Resistance: "));
  USB.print(VOCRes);
  USB.print(F(" Ohms |"));

  USB.print(F(" VOC concentration Estimated: "));
  USB.print(VOCPPM);
  USB.println(F(" ppm"));
    
  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_VOC, VOCPPM);
  // Show the frame
  frame.showFrame();
  
  delay(1000);  
}


