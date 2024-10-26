/*  
 *  --[Ag_v30_08] - Weather Station sensor reading
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  Weather station every minute. Every time a new pluviometer 
 *  pulse is generated the interrruption is captured and stored
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
 *  Implementation:    Carlos Bello
 */

#include <WaspSensorAgr_v30.h>

// Variable to store the anemometer value
float anemometer;

// Variable to store the pluviometer value
float pluviometer1; //mm in current hour 
float pluviometer2; //mm in previous hour
float pluviometer3; //mm in last 24 hours

// Variable to store the vane value
int vane;

// variable to store the number of pending pulses
int pendingPulses;

// define node identifier
char nodeID[] = "node_WS";

//Instance object
weatherStationClass weather;

void setup()
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));

  // Turn on the sensor board
  Agriculture.ON();
  
  USB.print(F("Time:"));
  RTC.ON();
  USB.println(RTC.getTime());  
 
}



void loop()
{
  /////////////////////////////////////////////
  // 1. Enter sleep mode
  /////////////////////////////////////////////
  Agriculture.sleepAgr("00:00:00:10", RTC_ABSOLUTE, RTC_ALM1_MODE5, SENSOR_ON, SENS_AGR_PLUVIOMETER);
  
  /////////////////////////////////////////////
  // 2.1. check pluviometer interruption
  /////////////////////////////////////////////
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
  
  /////////////////////////////////////////////
  // 2.2. check RTC interruption
  /////////////////////////////////////////////
  if(intFlag & RTC_INT)
  {
    USB.println(F("+++ RTC interruption +++"));
    
    // switch on sensor board
    Agriculture.ON();
    
    RTC.ON();
    USB.print(F("Time:"));
    USB.println(RTC.getTime());    
        
    // measure sensors
    measureSensors();
    
    // Clear flag
    intFlag &= ~(RTC_INT); 
  }  
}




/*******************************************************************
 *
 *  measureSensors
 *
 *  This function reads from the sensors of the Weather Station and 
 *  then creates a new Waspmote Frame with the sensor fields in order 
 *  to prepare this information to be sent
 *
 *******************************************************************/
void measureSensors()
{  

  USB.println(F("------------- Measurement process ------------------"));
  
  /////////////////////////////////////////////////////
  // 1. Reading sensors
  ///////////////////////////////////////////////////// 

  // Read the anemometer sensor 
  anemometer = weather.readAnemometer();
  
  // Read the pluviometer sensor 
  pluviometer1 = weather.readPluviometerCurrent();
  pluviometer2 = weather.readPluviometerHour();
  pluviometer3 = weather.readPluviometerDay();
  
  /////////////////////////////////////////////////////
  // 2. USB: Print the weather values through the USB
  /////////////////////////////////////////////////////
  
  // Print the accumulated rainfall
  USB.print(F("Current hour accumulated rainfall (mm/h): "));
  USB.println( pluviometer1 );

  // Print the accumulated rainfall
  USB.print(F("Previous hour accumulated rainfall (mm/h): "));
  USB.println( pluviometer2 );

  // Print the accumulated rainfall
  USB.print(F("Last 24h accumulated rainfall (mm/day): "));
  USB.println( pluviometer3 );
  
  // Print the anemometer value
  USB.print(F("Anemometer: "));
  USB.print(anemometer);
  USB.println(F("km/h"));
    
  // Print the vane value
  char vane_str[10] = {0};
  switch(weather.readVaneDirection())
  {
  case  SENS_AGR_VANE_N   :  snprintf( vane_str, sizeof(vane_str), "N" );
                             break;
  case  SENS_AGR_VANE_NNE :  snprintf( vane_str, sizeof(vane_str), "NNE" );
                             break;  
  case  SENS_AGR_VANE_NE  :  snprintf( vane_str, sizeof(vane_str), "NE" );
                             break;    
  case  SENS_AGR_VANE_ENE :  snprintf( vane_str, sizeof(vane_str), "ENE" );
                             break;      
  case  SENS_AGR_VANE_E   :  snprintf( vane_str, sizeof(vane_str), "E" );
                             break;    
  case  SENS_AGR_VANE_ESE :  snprintf( vane_str, sizeof(vane_str), "ESE" );
                             break;  
  case  SENS_AGR_VANE_SE  :  snprintf( vane_str, sizeof(vane_str), "SE" );
                             break;    
  case  SENS_AGR_VANE_SSE :  snprintf( vane_str, sizeof(vane_str), "SSE" );
                             break;   
  case  SENS_AGR_VANE_S   :  snprintf( vane_str, sizeof(vane_str), "S" );
                             break; 
  case  SENS_AGR_VANE_SSW :  snprintf( vane_str, sizeof(vane_str), "SSW" );
                             break; 
  case  SENS_AGR_VANE_SW  :  snprintf( vane_str, sizeof(vane_str), "SW" );
                             break;  
  case  SENS_AGR_VANE_WSW :  snprintf( vane_str, sizeof(vane_str), "WSW" );
                             break; 
  case  SENS_AGR_VANE_W   :  snprintf( vane_str, sizeof(vane_str), "W" );
                             break;   
  case  SENS_AGR_VANE_WNW :  snprintf( vane_str, sizeof(vane_str), "WNW" );
                             break; 
  case  SENS_AGR_VANE_NW  :  snprintf( vane_str, sizeof(vane_str), "WN" );
                             break;
  case  SENS_AGR_VANE_NNW :  snprintf( vane_str, sizeof(vane_str), "NNW" );
                             break;  
  default                 :  snprintf( vane_str, sizeof(vane_str), "error" );
                             break;    
  }

  USB.println( vane_str );
  USB.println(F("----------------------------------------------------\n"));
  
}



