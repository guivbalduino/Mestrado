/*  
 *  --------- [Ga_v30_2] O2 Sensor reading for v30  -------------- 
 *  
 *  Explanation: Turn on the Gases Board v30 and read the O2
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

// O2 Sensor must be connected in SOCKET_1
O2SensorClass O2Sensor(SOCKET_1);

// Percentage values of Oxygen
#define POINT1_PERCENTAGE 0.0    
#define POINT2_PERCENTAGE 5.0  

// Calibration Voltage Obtained during calibration process (in mV)
#define POINT1_VOLTAGE 0.35
#define POINT2_VOLTAGE 2.0

float concentrations[] = {POINT1_PERCENTAGE, POINT2_PERCENTAGE};
float voltages[] =       {POINT1_VOLTAGE, POINT2_VOLTAGE};

char node_ID[] = "O2_example";

void setup() 
{ 
  // Configure the USB port
  USB.ON();
  USB.println(F("O2 Sensor reading example"));

  O2Sensor.setCalibrationPoints(voltages, concentrations);
   
  ///////////////////////////////////////////
  // 1. Turn on the board
  /////////////////////////////////////////// 
  
  // Switch ON and configure the Gases Board
  Gases.ON();  
  // Switch ON the SOCKET_1
  O2Sensor.ON();
}

void loop()
{
  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////  

  // O2 Sensor does not need power suplly
  float O2Vol = O2Sensor.readVoltage();
  
  USB.print(F("O2 concentration Estimated: "));
  USB.print(O2Vol);
  USB.print(F(" mV | "));
  delay(100);

  // Read the concentration value in %
  float O2Val = O2Sensor.readConcentration();
  
  USB.print(F(" O2 concentration Estimated: "));
  USB.print(O2Val);
  USB.println(F(" %"));  

  ///////////////////////////////////////////
  // 3. Create ASCII frame
  /////////////////////////////////////////// 
  
  // Create new frame (ASCII)
  frame.createFrame(ASCII, node_ID);
  // Add Oxygen concentration value
  frame.addSensor(SENSOR_GASES_O2, O2Val);  
  // Show the frame
  frame.showFrame();

  delay(5000);   
}


