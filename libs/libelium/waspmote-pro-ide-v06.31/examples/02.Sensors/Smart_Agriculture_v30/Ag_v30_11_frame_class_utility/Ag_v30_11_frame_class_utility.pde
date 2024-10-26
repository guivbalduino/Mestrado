/*  
 *  ------------  [Ag_v30_11] - Frame Class Utility  -------------- 
 *  
 *  Explanation: This is the basic code to create frames with all sensors
 * 	used in the Agriculture Board v30
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
 *  Version:		    3.0
 *  Design:         David Gascón
 *  Implementation: Carlos Bello
 */

#include <WaspSensorAgr_v30.h>
#include <BME280.h>
#include <WaspFrame.h>

char node_ID[] = "Node_01";

//Instace sensor object
leafWetnessClass lwSensor;
radiationClass radSensor;
dendrometerClass dendSensor;
pt1000Class pt1000Sensor;
watermarkClass wmSensor1(SOCKET_1);
watermarkClass wmSensor2(SOCKET_2);
watermarkClass wmSensor3(SOCKET_3);
weatherStationClass weather;

//variables to store sensors readings
float temperature;
float humidity;
float pressure;
uint8_t wetness;
float UVvalue;
float radiation;
float dendrometer;
float pt1000Temperature;
float watermark1;
float watermark2;
float watermark3;
float anemometer;
float pluviometer1;
float pluviometer2;
float pluviometer3;
uint8_t vane;

// variable to store the number of pending pulses
int pendingPulses;

void setup() 
{
  USB.ON();
  USB.println(F("Start program"));
  
  // Turn on the sensor board
  Agriculture.ON();
  
  // Set the Waspmote ID
  frame.setID(node_ID); 
}

void loop()
{
  /////////////////////////////////////////////
  // 1. Enter sleep mode
  /////////////////////////////////////////////
  Agriculture.sleepAgr("00:00:00:10", RTC_ABSOLUTE, RTC_ALM1_MODE5, SENSOR_ON, SENS_AGR_PLUVIOMETER);

  /////////////////////////////////////////////
  // 2. Check interruptions
  /////////////////////////////////////////////
  //Check pluviometer interruption
  if( intFlag & PLV_INT)
  {
    USB.println(F("+++ PLV interruption +++"));

    pendingPulses = intArray[PLV_POS];

    USB.print(F("Number of pending pulses:"));
    USB.println( pendingPulses );

    for(int i=0 ; i<pendingPulses; i++)
    {
      // Enter pulse information inside class structure
      weather.storePulse();

      // decrease number of pulses
      intArray[PLV_POS]--;
    }

    // Clear flag
    intFlag &= ~(PLV_INT); 
  }
  
  //Check RTC interruption
  if(intFlag & RTC_INT)
  {
    USB.println(F("+++ RTC interruption +++"));
    
    // switch on sensor board
    Agriculture.ON();
    USB.print(F("Time:"));
    USB.println(RTC.getTime());        

    // measure sensors
    measureSensors();

    // Clear flag
    intFlag &= ~(RTC_INT); 
  }  
}

void measureSensors()
{  

  ///////////////////////////////////////////
  // 3. Read sensors
  ///////////////////////////////////////////  
  
  //It takes several minutes to read all sensors

  // Read the temperature sensor 
  temperature = Agriculture.getTemperature();
  // Read the humidity sensor
  humidity = Agriculture.getHumidity();
  // Read the pressure sensor
  pressure = Agriculture.getPressure();
  // Read the leaf wetness sensor 
  wetness = lwSensor.getLeafWetness();
  // Read the ultraviolet sensor 
  UVvalue = radSensor.readRadiation();
  // Conversion from voltage into umol·m-2·s-1
  radiation = UVvalue / 0.0002;
  // Read the dendrometer sensor 
  dendrometer = dendSensor.readDendrometer();
  // Read the PT1000 sensor 
  pt1000Temperature = pt1000Sensor.readPT1000();
  // Read the watermark 1 sensor 
  watermark1 = wmSensor1.readWatermark();
  // Read the watermark 2 sensor 
  watermark2 = wmSensor2.readWatermark();
  // Read the watermark 3 sensor 
  watermark3 = wmSensor3.readWatermark();  
  // Read the anemometer sensor 
  anemometer = weather.readAnemometer();
  // Read the pluviometer sensor 
  pluviometer1 = weather.readPluviometerCurrent();
  pluviometer2 = weather.readPluviometerHour();
  pluviometer3 = weather.readPluviometerDay();
  // Read the vane sensor 
  vane = weather.readVaneDirection();

  ///////////////////////////////////////////
  // 4. Create ASCII frame
  /////////////////////////////////////////// 

  // Create new frame (ASCII)
  frame.createFrame(ASCII);
  // Add temperature
  frame.addSensor(SENSOR_AGR_TC, temperature);
  // Add humidity
  frame.addSensor(SENSOR_AGR_HUM, humidity);
  // Add pressure
  frame.addSensor(SENSOR_AGR_PRES, pressure);
  // Add wetness
  frame.addSensor(SENSOR_AGR_LW, wetness);
  // Add radiation
  frame.addSensor(SENSOR_AGR_PAR, radiation);
  // Add dendrometer
  frame.addSensor(SENSOR_AGR_TD, dendrometer);
  // Add PT1000
  frame.addSensor(SENSOR_AGR_SOILTC, pt1000Temperature);
  // Add watermark 1
  frame.addSensor(SENSOR_AGR_SOIL1, watermark1);
  // Add watermark 1
  frame.addSensor(SENSOR_AGR_SOIL2, watermark2);
  // Add watermark 1
  frame.addSensor(SENSOR_AGR_SOIL3, watermark3);  
  // Add pluviometer value
  frame.addSensor( SENSOR_AGR_PLV1, pluviometer1 );
  // Add pluviometer value
  frame.addSensor( SENSOR_AGR_PLV2, pluviometer2 );
  // Add pluviometer value
  frame.addSensor( SENSOR_AGR_PLV3, pluviometer3 );
  // Add anemometer value
  frame.addSensor( SENSOR_AGR_ANE, anemometer );
  // Add pluviometer value
  frame.addSensor( SENSOR_AGR_WV, vane );
  
  // Show the frame
  frame.showFrame();

  // wait 2 seconds
  delay(2000);
}
