/*  
 *  ------ [SW_05] - Conductivity sensor Reading for Smart Water-------- 
 *  
 *  Explanation: Turn on the Smart Water Board and reads the Dissolved Oxygen
 *  sensor printing the result through the USB
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

#include <WaspSensorSW.h>


float ECRes;
float ECValue;

// Value 1 used to calibrate the sensor
#define point1_cond 10500
// Value 2 used to calibrate the sensor
#define point2_cond 40000

// Point 1 of the calibration 
#define point1_cal 197.00
// Point 2 of the calibration 
#define point2_cal 150.00

conductivityClass ConductivitySensor;



void setup()
{ 
  USB.ON();
  USB.println(F("EC example for Smart Water..."));
  
  // Configure the calibration parameters
  ConductivitySensor.setCalibrationPoints(point1_cond, point1_cal, point2_cond, point2_cal);

  ///////////////////////////////////////////
  // 1. Turn ON the Smart Water sensor board 
  ///////////////////////////////////////////  
  Water.ON(); 
}

void loop()
{
  ///////////////////////////////////////////
  // 2. read the sensors
  ///////////////////////////////////////////
  
  // Reading of the Conductivity sensor
  ECRes = ConductivitySensor.readConductivity();
  // Conversion from resistance into us/cm
  ECValue = ConductivitySensor.conductivityConversion(ECRes);

  ///////////////////////////////////////////
  // 3. Print the output values
  ///////////////////////////////////////////

  // Print of the results
  USB.print(F("Conductivity Output Resistance: "));
  USB.print(ECRes);
  
  // Print of the results
  USB.print(F(" Conductivity of the solution (uS/cm): "));
  USB.println(ECValue);

  
}
