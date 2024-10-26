/*
    ----------- [Sw_xtr_04] - Frame class utility --------------------

    Explanation:  This is the basic code to create a frame with some
    Smart Water Xtreme sensors. 
    
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

    Version:           3.0
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>
#include <WaspFrame.h>



char node_ID[] = "Node_01";

//[Sensor Class] [Sensor Name] [Selected socket]
Aqualabo_OPTOD myOPTOD_A(XTR_SOCKET_A);
Aqualabo_PHEHT myPHEHT_B(XTR_SOCKET_B);
Aqualabo_NTU myNTU_C(XTR_SOCKET_C);
Aqualabo_CTZN myCTZN_D(XTR_SOCKET_D);
Aqualabo_MES5 myMES5_E(XTR_SOCKET_E);
//Aqualabo_C4E myC4E_E(XTR_SOCKET_E);

void setup()
{
  USB.println(F("Frame utility example for Smart Water Xtreme"));

  // set the Plug & Sense! node ID
  frame.setID(node_ID);

}

void loop()
{
  ///////////////////////////////////////////
  //  1. Read the sensors
  ///////////////////////////////////////////

  // Socket A sensor
  // Turn ON the sensor
  myOPTOD_A.ON();
  // Read the sensor
  myOPTOD_A.read();
  // Turn off the sensor
  myOPTOD_A.OFF();

  // Socket B sensor
  // Turn ON the sensor
  myPHEHT_B.ON();
  // Read the sensor
  myPHEHT_B.read();
  // Turn off the sensor
  myPHEHT_B.OFF();

  // Socket C sensor
  // Turn ON the sensor
  myNTU_C.ON();
  // Read the sensor
  myNTU_C.read();
  // Turn off the sensor
  myNTU_C.OFF();

  // Socket D sensor
  // Turn ON the sensor
  myCTZN_D.ON();
  // Read the sensor
  myCTZN_D.read();
  // Turn off the sensor
  myCTZN_D.OFF();

  // Socket E sensor
  // Turn ON the sensor
  myMES5_E.ON();
  // Read the sensor
  myMES5_E.read();
  // Turn off the sensor and the heater
  myMES5_E.OFF();

/*
  // Socket E sensor
  // Turn ON the sensor
  myC4E_E.ON();
  // Read the sensor
  myC4E_E.read();
  // Turn off the sensor and the heater
  myC4E_E.OFF();
*/

  ///////////////////////////////////////////
  //  2. Create ASCII frame
  ///////////////////////////////////////////

  // Create new frame (ASCII)
  frame.createFrame(ASCII);

  // It is mandatory to specify the Smart Agriculture Xtreme type
  frame.setFrameType(INFORMATION_FRAME_WTR_XTR);

  // add Socket A sensor values
  frame.addSensor(WTRX_OPTOD_TC1_A, myOPTOD_A.sensorOPTOD.temperature);
  frame.addSensor(WTRX_OPTOD_OS_A, myOPTOD_A.sensorOPTOD.oxygenSAT);
  frame.addSensor(WTRX_OPTOD_OM_A, myOPTOD_A.sensorOPTOD.oxygenMGL);
  frame.addSensor(WTRX_OPTOD_OP_A, myOPTOD_A.sensorOPTOD.oxygenPPM);
  
  // add Socket B sensor values
  frame.addSensor(WTRX_PHEHT_TC2_B, myPHEHT_B.sensorPHEHT.temperature);
  frame.addSensor(WTRX_PHEHT_PH_B, myPHEHT_B.sensorPHEHT.pH);
  frame.addSensor(WTRX_PHEHT_PM_B, myPHEHT_B.sensorPHEHT.pHMV);
  frame.addSensor(WTRX_PHEHT_RX_B, myPHEHT_B.sensorPHEHT.redox);
  
  // add Socket C sensor values
  frame.addSensor(WTRX_NTU_TC4_C, myNTU_C.sensorNTU.temperature);
  frame.addSensor(WTRX_NTU_TN_C, myNTU_C.sensorNTU.turbidityNTU);
  frame.addSensor(WTRX_NTU_TM_C, myNTU_C.sensorNTU.turbidityMGL);
  
  // add Socket D sensor values
  frame.addSensor(WTRX_CTZN_TC5_D, myCTZN_D.sensorCTZN.temperature);
  frame.addSensor(WTRX_CTZN_CN1_D, myCTZN_D.sensorCTZN.conductivity);
  frame.addSensor(WTRX_CTZN_SA1_D, myCTZN_D.sensorCTZN.salinity);
  frame.addSensor(WTRX_CTZN_CU_D, myCTZN_D.sensorCTZN.conductivityNotCompensated);
  
  // add Socket E sensor values
  frame.addSensor(WTRX_MES5_TC6_E, myMES5_E.sensorMES5.temperature);
  frame.addSensor(WTRX_MES5_SB_E, myMES5_E.sensorMES5.sludgeBlanket);
  frame.addSensor(WTRX_MES5_SS_E, myMES5_E.sensorMES5.suspendedSolids);
  frame.addSensor(WTRX_MES5_TF_E, myMES5_E.sensorMES5.turbidityFAU);

/*
  // add Socket E sensor values
  frame.addSensor(WTRX_C4E_TC3_E, myC4E_E.sensorC4E.temperature);
  frame.addSensor(WTRX_C4E_CN_E, myC4E_E.sensorC4E.conductivity);
  frame.addSensor(WTRX_C4E_SA_E, myC4E_E.sensorC4E.salinity);
  frame.addSensor(WTRX_C4E_TD_E, myC4E_E.sensorC4E.totalDissolvedSolids);
*/

  // Show the frame
  frame.showFrame();


  ///////////////////////////////////////////
  // 3. Sleep
  ///////////////////////////////////////////

  // Go to deepsleep
  // After 30 seconds, Waspmote wakes up thanks to the RTC Alarm
  PWR.deepSleep("00:00:00:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

}
