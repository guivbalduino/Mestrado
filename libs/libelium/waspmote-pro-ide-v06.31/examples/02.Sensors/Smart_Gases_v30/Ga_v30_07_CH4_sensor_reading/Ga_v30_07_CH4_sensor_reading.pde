/*  
 *  ------ [Ga_v30_7] CH4 Sensor reading for v30  -------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the CH4
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

// CH4 Sensor can be connected in SOCKET_6 or SOCKET_7
CH4SensorClass CH4Sensor(SOCKET_6); 

char node_ID[] = "CH4_example";

void setup() 
{  
  // Configure the USB port
  USB.ON();  
  USB.println(F("CH4 Sensor reading for v30..."));
  
  // Concentratios used in calibration process (in PPM)
  CH4Sensor.concentrations[POINT_1] = 100.0;  // <--- Ro value at this concentration
  CH4Sensor.concentrations[POINT_2] = 300.0 ;  
  CH4Sensor.concentrations[POINT_3] = 1000.0; 
  
  // Calibration resistances obtained during calibration process (in Kohms)
  CH4Sensor.values[POINT_1] = 230.30; // <-- Ro Resistance at 100 ppm. Necessary value.
  CH4Sensor.values[POINT_2] = 40.665; // 
  CH4Sensor.values[POINT_3] = 20.300; // 
  
  // Define the number of calibration points
  CH4Sensor.numPoints = 3;
  // Calculate the slope and the intersection of the logarithmic function
  CH4Sensor.setCalibrationPoints();

  ///////////////////////////////////////////
  // 1. Turn on the board and the SOCKET
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the sensor socket
  CH4Sensor.ON();
}

void loop()
{
  //////////////////////////////////////////
  // 2. Read sensors
  /////////////////////////////////////////

  float CH4Vol = CH4Sensor.readVoltage();           // Voltage value of the sensor
  float CH4Res = CH4Sensor.readResistance();        // Resistance of the sensor
  float CH4PPM = CH4Sensor.readConcentration();  // PPM value of CH4

  // Print of the results
  USB.print(F(" CH4 Sensor Voltage: "));
  USB.print(CH4Vol);
  USB.print(F(" V |"));

  // Print of the results
  USB.print(F(" CH4 Sensor Resistance: "));
  USB.print(CH4Res);
  USB.print(F(" Ohms |"));

  USB.print(F(" CH4 concentration Estimated: "));
  USB.print(CH4PPM);
  USB.println(F(" ppm"));
    
  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add CH4 PPM value
  frame.addSensor(SENSOR_GASES_CH4, CH4PPM);
  // Show the frame
  frame.showFrame();
  
  delay(5000); 
}


