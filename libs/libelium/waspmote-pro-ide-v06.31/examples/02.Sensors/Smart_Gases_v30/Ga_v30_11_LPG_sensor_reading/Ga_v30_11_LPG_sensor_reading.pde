/*  
 *  ------ [Ga_v30_11] LPG Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the LPG
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
 *  Version:           3.0
 *  Design:            David Gascón 
 *  Implementation:    Ahmad Saad
 */

// Library include
#include <WaspSensorGas_v30.h>
#include <WaspFrame.h>


// LPG Sensor can be connected in SOCKET6 or SOCKET7
LPGSensorClass LPGSensor(SOCKET_7);

// Concentratios used in calibration process (PPM VALUE)
#define POINT1_PPM_LPG 10.0   //  <-- Normal concentration in air
#define POINT2_PPM_LPG 50.0   
#define POINT3_PPM_LPG 100.0
  
// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_LPG 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_LPG 25.50
#define POINT3_RES_LPG 3.55
  
// Define the number of calibration points
#define numPoints 3
  
float concentrations[] = {POINT1_PPM_LPG, POINT2_PPM_LPG, POINT3_PPM_LPG};
float resValues[] =      {POINT1_RES_LPG, POINT2_RES_LPG, POINT3_RES_LPG};

char node_ID[] = "LPG_example";

void setup() 
{
  // Configure the USB port
  USB.ON();  
  USB.println(F("LPG Sensor reading for v30..."));

  // Calculate the slope and the intersection of the logarithmic function
  LPGSensor.setCalibrationPoints(resValues, concentrations, numPoints);

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  LPGSensor.ON();
}

void loop()
{
  ///////////////////////////////////////////
  // 2. Read sensors
  /////////////////////////////////////////// 

  float LPGVol = LPGSensor.readVoltage();         // Voltage value of the sensor
  float LPGRes = LPGSensor.readResistance();      // Resistance of the sensor
  float LPGPPM = LPGSensor.readConcentration();   // PPM value of LPG

  // Print of the results
  USB.print(F("LPG Sensor Voltage: "));
  USB.print(LPGVol);
  USB.print(F(" V |"));

  // Print of the results
  USB.print(F(" LPG Sensor Resistance: "));
  USB.print(LPGRes);
  USB.print(F(" Ohms |"));

  USB.print(F(" LPG concentration Estimated: "));
  USB.print(LPGPPM);
  USB.println(F(" ppm"));
    
  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 
  
  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add LPG PPM value
  frame.addSensor(SENSOR_GASES_LPG, LPGPPM);
  // Show the frame
  frame.showFrame();
  
  delay(5000);

}


