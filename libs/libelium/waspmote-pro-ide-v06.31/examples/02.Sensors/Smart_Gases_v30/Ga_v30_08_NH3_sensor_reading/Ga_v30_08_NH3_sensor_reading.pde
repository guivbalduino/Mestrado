/*  
 *  ------ [Ga_v30_8] NH3 Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the NH3
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

// NH3 Sensor must be connected physically in SOCKET_4
NH3SensorClass NH3Sensor; 

// Concentratios used in calibration process
#define POINT1_PPM_NH3 10.0   // <-- Normal concentration in air
#define POINT2_PPM_NH3 50.0   
#define POINT3_PPM_NH3 100.0 

// Calibration voltages obtained during calibration process (in KOHMs)
#define POINT1_RES_NH3 45.25  // <-- Rs at normal concentration in air
#define POINT2_RES_NH3 25.50
#define POINT3_RES_NH3 3.55

// Define the number of calibration points
#define numPoints 3

float concentrations[] = {POINT1_PPM_NH3, POINT2_PPM_NH3, POINT3_PPM_NH3};
float voltages[] =       {POINT1_RES_NH3, POINT2_RES_NH3, POINT3_RES_NH3};

char node_ID[] = "NH3_example";

void setup() 
{
  // Configure the USB port
  USB.ON();
  USB.println(F("NH3 Sensor reading for v30..."));

  // Calculate the slope and the intersection of the logarithmic function
  NH3Sensor.setCalibrationPoints(voltages, concentrations, numPoints);
  
  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  NH3Sensor.ON();  
}

void loop() 
{
  //////////////////////////////////////////
  // 2. Read sensors
  //////////////////////////////////////////

  // PPM value of NH3
  float NH3Vol = NH3Sensor.readVoltage();       // Voltage value of the sensor
  float NH3Res = NH3Sensor.readResistance();    // Resistance of the sensor
  float NH3PPM = NH3Sensor.readConcentration(); // PPM value of NH3

  // Print of the results
  USB.print(F(" NH3 Sensor Voltage: "));
  USB.print(NH3Vol);
  USB.print(F(" mV |"));
  
  // Print of the results
  USB.print(F(" NH3 Sensor Resistance: "));
  USB.print(NH3Res);
  USB.print(F(" Ohms |"));

  // Print of the results
  USB.print(F(" NH3 concentration Estimated: "));
  USB.print(NH3PPM);
  USB.println(F(" PPM"));

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add VOC PPM value
  frame.addSensor(SENSOR_GASES_NH3, NH3PPM);
  // Show the frame
  frame.showFrame();
  
  delay(5000);
}





