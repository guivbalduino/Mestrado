/*
    ----------- [Ag_xtr_20] - Frame class utility --------------------

    Explanation:  This is the basic code to create a frame with some
    Smart Agriculture Xtreme sensors. 
    
    Measured parameters:
      - Multiple

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Version:           3.1
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>
#include <WaspFrame.h>

//Uncomment the next line if the GMX includes GPS
//#define GMX_GPS_OPTION


char node_ID[] = "Node_01";

//[Sensor Class] [Sensor Name] [Selected socket]
bme myBME280_A(XTR_SOCKET_A);
leafWetness myPhytos31_B;
Decagon_5TE my5TE_C(XTR_SOCKET_C);
luxes myTSL2561_D(XTR_SOCKET_D);
weatherStation myGMX240_E;
Apogee_SP510 mySP510_F(XTR_SOCKET_F);


void setup()
{
  USB.println(F("Frame utility example for Smart Agriculture Xtreme"));

  // set the Plug & Sense! node ID
  frame.setID(node_ID);

  // Weather station is turned ON on setup() and is not turned OFF
  myGMX240_E.ON();
}

void loop()
{
  ///////////////////////////////////////////
  //  1. Read the sensors
  ///////////////////////////////////////////

  // Socket A sensor
  // Turn ON the sensor
  myBME280_A.ON();
  // Read the sensor. Store parameters in variables
  float temperature_A = myBME280_A.getTemperature();
  float humidity_A = myBME280_A.getHumidity();
  float pressure_A = myBME280_A.getPressure();
  // Turn off the sensor
  myBME280_A.OFF();

  // Socket B sensor
  // Turn ON the sensor
  myPhytos31_B.ON();
  // Read the sensor
  myPhytos31_B.read();
  // Turn off the sensor
  myPhytos31_B.OFF();

  // Socket C sensor
  // Turn ON the sensor
  my5TE_C.ON();
  // Read the sensor
  my5TE_C.read();
  // Turn off the sensor
  my5TE_C.OFF();

  // Socket D sensor
  // Turn ON the sensor
  myTSL2561_D.ON();
  // Read the sensor. Store parameter in variable
  uint32_t luminosity_D = myTSL2561_D.getLuminosity();
  // Turn off the sensor
  myTSL2561_D.OFF();

  // Socket E sensor
  // Read the sensor
  myGMX240_E.read();

  // Socket F sensor
  // Turn ON the sensor and the heater and wait some time
  mySP510_F.ON();
  delay(10000);
  // Read the sensor
  mySP510_F.read();
  // Turn off the sensor and the heater
  mySP510_F.OFF();


  ///////////////////////////////////////////
  //  2. Create ASCII frame
  ///////////////////////////////////////////

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // It is mandatory to specify the Smart Agriculture Xtreme type
  frame.setFrameType(INFORMATION_FRAME_AGR_XTR);

  // add Socket A sensor values
  frame.addSensor(AGRX_TC_A, temperature_A);
  frame.addSensor(AGRX_HUM_A, humidity_A);
  frame.addSensor(AGRX_PRES_A, pressure_A);
  
  // add Socket B sensor values
  frame.addSensor(AGRX_LW, myPhytos31_B.wetness);
  
  // add Socket C sensor values
  frame.addSensor(AGRX_5TE_DP2_C, my5TE_C.sensor5TE.dielectricPermittivity);
  frame.addSensor(AGRX_5TE_EC2_C, my5TE_C.sensor5TE.electricalConductivity);
  frame.addSensor(AGRX_5TE_TC4_C, my5TE_C.sensor5TE.temperature);
  
  // add Socket D sensor values
  frame.addSensor(AGRX_LUXES_D, luminosity_D);
  
  // add Socket E sensor values
  frame.addSensor(AGRX_GMX_AWD, myGMX240_E.gmx.avgWindDirection);
  frame.addSensor(AGRX_GMX_AWS, myGMX240_E.gmx.avgWindSpeed);
  frame.addSensor(AGRX_GMX_PI, myGMX240_E.gmx.precipIntensity);
  frame.addSensor(AGRX_GMX_PT, myGMX240_E.gmx.precipTotal);

  // add Socket F sensor values
  frame.addSensor(AGRX_SR_F, mySP510_F.radiation);

  // Show the frame
  frame.showFrame();


  ///////////////////////////////////////////
  // 3. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 30 seconds, Waspmote wakes up thanks to the RTC Alarm
  PWR.deepSleep("00:00:00:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

}
