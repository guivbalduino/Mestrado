/*  
 *  ------ [Ga_v30_5] CO Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the CO
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


// CO Sensor must be connected physically in SOCKET_4
COSensorClass COSensor; 

// Concentratios used in calibration process
#define POINT1_PPM_CO 100.0   // <--- Ro value at this concentration
#define POINT2_PPM_CO 300.0   // 
#define POINT3_PPM_CO 1000.0  // 

// Calibration resistances obtained during calibration process
#define POINT1_RES_CO 230.30 // <-- Ro Resistance at 100 ppm. Necessary value.
#define POINT2_RES_CO 40.665 //
#define POINT3_RES_CO 20.300 //

// Define the number of calibration points
#define numPoints 3

float concentrations[] = { POINT1_PPM_CO, POINT2_PPM_CO, POINT3_PPM_CO };
float resValues[] =      { POINT1_RES_CO, POINT2_RES_CO, POINT3_RES_CO };

char node_ID[] = "CO_example";

void setup() 
{
  // Configure the USB port
  USB.ON();
  USB.println(F("CO Sensor reading for v30..."));

  // Calculate the slope and the intersection of the logarithmic function
  COSensor.setCalibrationPoints(resValues, concentrations, numPoints);

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  COSensor.ON();
}

void loop()
{ 
  //////////////////////////////////////////
  // 2. Read sensors
  //////////////////////////////////////////
  
  float COVol = COSensor.readVoltage();          // Voltage value of the sensor
  float CORes = COSensor.readResistance();       // Resistance of the sensor
  float COPPM = COSensor.readConcentration(); // PPM value of CO

  // Print of the results
  USB.print(F("CO Sensor Voltage: "));
  USB.print(COVol);
  USB.print(F(" mV |"));

  // Print of the results
  USB.print(F(" CO Sensor Resistance: "));
  USB.print(CORes);
  USB.print(F(" Ohms |"));

  USB.print(F(" CO concentration Estimated: "));
  USB.print(COPPM);
  USB.println(F(" ppm"));

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add CO PPM value
  frame.addSensor(SENSOR_GASES_CO, COPPM);
  // Show the frame
  frame.showFrame();    
}


