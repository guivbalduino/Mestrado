/*  
 *  ------ [Ga_v30_10] Solvent Vapors Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the SV
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

// Solvent Vapors Sensor must be connected physically in SOCKET_6 or SOCKET_7
SVSensorClass SVSensor(SOCKET_7); 

// Concentratios used in calibration process
#define POINT1_PPM_SV 10.0  // <-- Normal concentration in air
#define POINT2_PPM_SV 50.0 
#define POINT3_PPM_SV 100.0  

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_SV 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_SV 25.50
#define POINT3_RES_SV 3.55

// Define the number of calibration points
#define numPoints 3

float concentrations[] = { POINT1_PPM_SV, POINT2_PPM_SV, POINT3_PPM_SV };
float voltages[] =       { POINT1_RES_SV, POINT2_RES_SV, POINT3_RES_SV };

char node_ID[] = "SV_example";

void setup() 
{
  // Calculate the slope and the intersection of the logarithmic function
  SVSensor.setCalibrationPoints(voltages, concentrations, numPoints);
  
  // Configure the USB port
  USB.ON();
  USB.println(F("Solvent Vapors Sensor reading for v30..."));

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  SVSensor.ON();
}

void loop() 
{  
  //////////////////////////////////////////
  // 2. Read sensors
  /////////////////////////////////////////
  
  float SVVol = SVSensor.readVoltage();       // Voltage value of the sensor
  float SVRes = SVSensor.readResistance();    // Resistance of the sensor
  float SVPPM = SVSensor.readConcentration(); // PPM value of Solvent Vapor sensor

  // Print of the results
  USB.print(F("Solvent Vapors Sensor Voltage: "));
  USB.print(SVVol);
  USB.print(F(" V |"));
  
  // Print of the results
  USB.print(F(" Solvent Vapors Sensor Resistance: "));
  USB.print(SVRes);
  USB.print(F(" Ohms |"));

  // Print of the results
  USB.print(F(" Solvent Vapors concentration Estimated: "));
  USB.print(SVPPM);
  USB.println(F(" PPM"));

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_SV, SVPPM);
  // Show the frame
  frame.showFrame();
  
  delay(1000);  
}





