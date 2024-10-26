/*  
 *  ------ [Ga_v30_12] AP1 Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the Air Pollutans
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

// Air Pollutans Sensor can be connected in SOCKET6 or SOCKET7
APSensorClass APPSensor(SOCKET_7); // 

char node_ID[] = "APP_example";

void setup() 
{
  // Concentratios used in calibration process (in PPM)
  APPSensor.concentrations[POINT_1] = 10.0;  // <--- Ro value at this concentration
  APPSensor.concentrations[POINT_2] = 50.0 ;  
  APPSensor.concentrations[POINT_3] = 100.0; 
  
  // Calibration resistances obtained during calibration process (in Kohms)
  APPSensor.values[POINT_1] = 45.25; // <-- Ro Resistance at 100 ppm. Necessary value.
  APPSensor.values[POINT_2] = 25.665;  
  APPSensor.values[POINT_3] = 2.300;

  // Define the number of calibration points
  APPSensor.numPoints = 3;
  // Calculate the slope and the intersection of the logarithmic function
  APPSensor.setCalibrationPoints();

  // Configure the USB port
  USB.ON();  
  USB.println(F("Air Pollutans Sensor reading for v30..."));

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  APPSensor.ON();
}

void loop() 
{
  ///////////////////////////////////////////
  // 2. Read sensors
  /////////////////////////////////////////// 

  float APPVol = APPSensor.readVoltage();         // Voltage value of the sensor
  float APPRes = APPSensor.readResistance();      // Resistance of the sensor
  float APP_PPM = APPSensor.readConcentration();  // PPM value of AP1

  // Print of the results
  USB.print(F("Air Pollutans Sensor Voltage: "));
  USB.print(APPVol);
  USB.print(F(" V |"));

  // Print of the results
  USB.print(F(" Air Pollutans Sensor Resistance: "));
  USB.print(APPRes);
  USB.print(F(" Ohms |"));

  USB.print(F(" Air Pollutans concentration Estimated: "));
  USB.print(APP_PPM);
  USB.println(F(" ppm"));
    
  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 
  
  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add CO2 PPM value
  frame.addSensor(SENSOR_GASES_AP1, APP_PPM);
  // Show the frame
  frame.showFrame();
  
  delay(5000);
}


