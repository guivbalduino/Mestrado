/*  
 *  ------ [Ga_v30_9] NO2 Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the NO2
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

// NO2 Sensor must be connected physically in SOCKET_3
NO2SensorClass NO2Sensor; 

// Concentrations used in calibration process
#define POINT1_PPM_NO2 10.0   // <-- Normal concentration in air
#define POINT2_PPM_NO2 50.0   
#define POINT3_PPM_NO2 100.0 

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_NO2 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_NO2 25.50
#define POINT3_RES_NO2 3.55

// Define the number of calibration points
#define numPoints 3

float concentrations[] = {POINT1_PPM_NO2, POINT2_PPM_NO2, POINT3_PPM_NO2};
float voltages[] =       {POINT1_RES_NO2, POINT2_RES_NO2, POINT3_RES_NO2};

char node_ID[] = "NO2_example";

void setup() 
{
  // Calculate the slope and the intersection of the logarithmic function
  NO2Sensor.setCalibrationPoints(voltages, concentrations, numPoints);
  // Configure the USB port
  USB.ON();
  USB.println(F("NO2 Sensor reading for v30..."));

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  NO2Sensor.ON();
}

void loop()
{  
  //////////////////////////////////////////
  // 2. Read sensors
  /////////////////////////////////////////
  
  // PPM value of NO2
  float NO2Vol = NO2Sensor.readVoltage();       // Voltage value of the sensor
  float NO2Res = NO2Sensor.readResistance();    // Resistance of the sensor
  float NO2PPM = NO2Sensor.readConcentration(); // PPM value of NO2

  // Print of the results
  USB.print(F("NO2 Sensor Voltage: "));
  USB.print(NO2Vol);
  USB.print(F(" V |"));
  
  // Print of the results
  USB.print(F(" NO2 Sensor Resistance: "));
  USB.print(NO2Res);
  USB.print(F(" Ohms |"));

  // Print of the results
  USB.print(F(" NO2 concentration Estimated: "));
  USB.print(NO2PPM);
  USB.println(F(" PPM"));

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_NO2, NO2PPM);
  // Show the frame
  frame.showFrame();
  
  delay(1000);  
}





