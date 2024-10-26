/*  
 *  ------------  [AM_05] - Frame Class Utility  -------------- 
 *  
 *  Explanation: This is the basic code to create a frame with every
 * 	Ambient Control sensor
 *  
 *  Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Version:		 3.1
 *  Design:          David Gascón
 *  Implementation:  Luis Miguel Marti
 */

#include <WaspSensorAmbient.h>
#include <WaspFrame.h>

float temperature; 
float humidity; 
float pressure;
float analogLDRvoltage;
float digitalLuxes; 
char node_ID[] = "Node_01";


void setup() 
{
  USB.ON();
  USB.println(F("Frame Utility Example for Ambient Control"));  
  
  USB.println(F("******************************************************"));
  USB.println(F("WARNING: This example is valid only for Waspmote v15"));
  USB.println(F("If you use a Waspmote v12, you MUST use the correct "));
  USB.println(F("sensor field definitions"));
  USB.println(F("******************************************************"));

  // Set the Waspmote ID
  frame.setID(node_ID); 
}

void loop()
{
  ///////////////////////////////////////////
  // 1. Read sensors
  ///////////////////////////////////////////  

  // Read the temperature sensor
  temperature = SensorAmbient.getTemperatureBME();
  // Read the humidity sensor
  humidity = SensorAmbient.getHumidityBME();
  // Read the pressure sensor
  pressure = SensorAmbient.getPressureBME();
  //Sensor LDR reading
  analogLDRvoltage = SensorAmbient.getLuminosity();
  // Read the Luxes sensor
  digitalLuxes = SensorAmbient.getLuxes(OUTDOOR);



  ///////////////////////////////////////////
  // 2. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // Add temperature
  frame.addSensor(SENSOR_BME_TC, temperature);
  // Add humidity
  frame.addSensor(SENSOR_BME_HUM, humidity);
  // Add pressure
  frame.addSensor(SENSOR_BME_PRES, pressure);
  // Add LDR value
  frame.addSensor(SENSOR_AMBIENT_LUM, analogLDRvoltage);
  // Add Luxes
  frame.addSensor(SENSOR_AMBIENT_LUXES, digitalLuxes);


  // Show the frame
  frame.showFrame();

  //wait 2 seconds
  delay(2000);
}
