/*  
 *  ------------  [SW_07] - Frame Class Utility  -------------- 
 *  
 *  Explanation: This is the basic code to create a frame with every
 *  Smart Water sensor
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
 *  Version:            3.0
 *  Design:             David Gascón
 *  Implementation:     Luis Miguel Marti
 */

#include <WaspSensorSW.h>
#include <WaspFrame.h>

float value_pH;
float value_temp;
float value_pH_calculated;
float value_orp;
float value_orp_calculated;
float value_di;
float value_do;
float value_do_calculated;
float value_cond;
float value_cond_calculated;

// Calibration values
#define cal_point_10 1.985
#define cal_point_7 2.070
#define cal_point_4 2.227
// Temperature at which calibration was carried out
#define cal_temp 23.7
// Offset obtained from sensor calibration
#define calibration_offset 0.0
// Calibration of the sensor in normal air
#define air_calibration 2.65
// Calibration of the sensor under 0% solution
#define zero_calibration 0.0
// Value 1 used to calibrate the sensor
#define point1_cond 10500
// Value 2 used to calibrate the sensor
#define point2_cond 40000
// Point 1 of the calibration 
#define point1_cal 197.00
// Point 2 of the calibration 
#define point2_cal 150.00

char node_ID[] = "Node_01";

pHClass pHSensor;
ORPClass ORPSensor;
DIClass DISensor;
DOClass DOSensor;
conductivityClass ConductivitySensor;
pt1000Class TemperatureSensor;

void setup() 
{
  USB.ON();
  USB.println(F("Frame Utility Example for Smart Water"));
  USB.println(F("******************************************************"));
  USB.println(F("WARNING: This example is valid only for Waspmote v15"));
  USB.println(F("If you use a Waspmote v12, you MUST use the correct "));
  USB.println(F("sensor field definitions"));
  USB.println(F("******************************************************"));

  // Set the Waspmote ID
  frame.setID(node_ID); 
  
  // Configure the calibration values
  pHSensor.setCalibrationPoints(cal_point_10, cal_point_7, cal_point_4, cal_temp);
  DOSensor.setCalibrationPoints(air_calibration, zero_calibration);
  ConductivitySensor.setCalibrationPoints(point1_cond, point1_cal, point2_cond, point2_cal);  
}

void loop()
{
  ///////////////////////////////////////////
  // 1. Turn on the board
  /////////////////////////////////////////// 

  Water.ON();
  delay(2000);

  ///////////////////////////////////////////
  // 2. Read sensors
  ///////////////////////////////////////////  

  // Read the ph sensor
  value_pH = pHSensor.readpH();
  // Read the temperature sensor
  value_temp = TemperatureSensor.readTemperature();
  // Convert the value read with the information obtained in calibration
  value_pH_calculated = pHSensor.pHConversion(value_pH,value_temp);  
  // Reading of the ORP sensor
  value_orp = ORPSensor.readORP();
  // Apply the calibration offset
  value_orp_calculated = value_orp - calibration_offset;
  // Reading of the DI sensor
  value_di = DISensor.readDI();
  // Reading of the ORP sensor
  value_do = DOSensor.readDO();
  // Conversion from volts into dissolved oxygen percentage
  value_do_calculated = DOSensor.DOConversion(value_do);
  // Reading of the Conductivity sensor
  value_cond = ConductivitySensor.readConductivity();
  // Conversion from resistance into ms/cm
  value_cond_calculated = ConductivitySensor.conductivityConversion(value_cond);  
  
  ///////////////////////////////////////////
  // 3. Turn off the sensors
  /////////////////////////////////////////// 

   Water.OFF();

  ///////////////////////////////////////////
  // 4. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII);
  
  // Add temperature
  frame.addSensor(SENSOR_WATER_WT, value_temp);
  // Add PH
  frame.addSensor(SENSOR_WATER_PH, value_pH_calculated);
  // Add ORP value
  frame.addSensor(SENSOR_WATER_ORP, value_orp_calculated);
    // Add DO value
  frame.addSensor(SENSOR_WATER_DO, value_do_calculated);
  // Add conductivity value
  frame.addSensor(SENSOR_WATER_COND, value_cond_calculated);

  // Show the frame
  frame.showFrame();

  //wait 2 seconds
  delay(2000);
}
