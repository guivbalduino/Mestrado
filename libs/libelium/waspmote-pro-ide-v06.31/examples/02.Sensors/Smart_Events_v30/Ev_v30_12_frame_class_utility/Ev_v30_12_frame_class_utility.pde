/*
    --[Ev_v30_12] - Frame Class Utility

    Explanation: This is the basic code to create a frame with every
  	input of Events Board

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Carlos Bello
*/
#include <WaspSensorEvent_v30.h>
#include <WaspFrame.h>

// Variable to store the read value
float flow;
int   pir;
int   levelControl;
int   hallEffect;
int   waterPoint;
int   mainSupply;

//Instance objects
relayClass relay;
pirSensorClass pirSensor(SOCKET_1);
liquidLevelClass liquidLevel(SOCKET_2);
hallSensorClass hall(SOCKET_3);
liquidPresenceClass liquidPresence(SOCKET_4);
flowClass yfs401(SENS_FLOW_YFS401);

char node_ID[] = "Node_1_Events";

void setup()
{
  USB.ON();
  USB.println(F("Frame Utility Example for Events Board 3.0"));

  // Turn on the sensor board
  Events.ON();

  // Set the Waspmote ID
  frame.setID(node_ID);

  // Enable interruptions from the board
  Events.attachInt();
  yfs401.enableFlowInt();
}



void loop()
{
  ///////////////////////////////////////
  // 1. Go to deep sleep mode
  ///////////////////////////////////////
  USB.println(F("enter deep sleep"));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, SENSOR_ON);

  USB.ON();
  USB.println(F("wake up\n"));


  ///////////////////////////////////////
  // 2. Check Interruption Flags
  ///////////////////////////////////////

  // Check interruption from RTC alarm
  if ( intFlag & RTC_INT )
  {
    USB.println(F("-----------------------------"));
    USB.println(F("RTC INT captured"));
    USB.println(F("-----------------------------"));

    // clear flag
    intFlag &= ~(RTC_INT);
  }
  
  // Check interruption from Sensor Board
  if (intFlag & SENS_INT)
  {
    interrupt_function();
  }
}



/**********************************************

   interrupt_function()

   Local function to treat the sensor interruption


 ***********************************************/
void interrupt_function()
{
  // Disable interruptions from the board
  Events.detachInt();
  // Load the interruption flag
  Events.loadInt();

  if (yfs401.getInt())
  {
    USB.println(F("--------------------------------------"));
    USB.println(F("Interruption from Water flow"));
    USB.println(F("--------------------------------------"));
  }
  
  if (pirSensor.getInt())
  {
    USB.println(F("--------------------------------------"));
    USB.println(F("Interruption from PIR"));
    USB.println(F("--------------------------------------"));
  }
  
  if (liquidLevel.getInt())
  {
    USB.println(F("--------------------------------------"));
    USB.println(F("Interruption from Liquid Level"));
    USB.println(F("--------------------------------------"));
  }
  
  if (hall.getInt())
  {
    USB.println(F("--------------------------------------"));
    USB.println(F("Interruption from Hall effect"));
    USB.println(F("--------------------------------------"));
  }
  
  if (liquidPresence.getInt())
  {
    USB.println(F("--------------------------------------"));
    USB.println(F("Interruption from Liquid Presence"));
    USB.println(F("--------------------------------------"));
  }
  
  if (relay.getInt())
  {
    USB.println(F("--------------------------------------"));
    USB.println(F("Interruption from Relay Input"));
    USB.println(F("--------------------------------------"));
  }



  // Read flow input
  flow = yfs401.flowReading();
  // Read Input 4
  pir = pirSensor.readPirSensor();
  // Read Input 1
  levelControl = liquidLevel.readliquidLevel();
  // Read Input 2
  hallEffect = hall.readHallSensor();
  // Read Input 3
  waterPoint = liquidPresence.readliquidPresence();
  // Read Relay In
  mainSupply = relay.readInRel();


  ///////////////////////////////////////////
  // Create ASCII frame
  ///////////////////////////////////////////
  frame.createFrame(ASCII);
  // Flow sensor YFS401
  frame.addSensor(SENSOR_EVENTS_WF, flow);
  // Pir Sensor
  frame.addSensor(SENSOR_EVENTS_PIR, pir);
  // Level Control
  frame.addSensor(SENSOR_EVENTS_LL, levelControl);
  // Hall Effect
  frame.addSensor(SENSOR_EVENTS_HALL, hallEffect);
  // Water Leakage (Point)
  frame.addSensor(SENSOR_EVENTS_LP, waterPoint);
  // Relay Input
  frame.addSensor(SENSOR_EVENTS_RELAY_IN, mainSupply);
  // Show the frame
  frame.showFrame();
}
