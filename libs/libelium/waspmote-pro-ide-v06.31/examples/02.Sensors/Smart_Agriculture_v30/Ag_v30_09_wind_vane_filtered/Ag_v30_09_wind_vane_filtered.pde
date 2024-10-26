/*  
 *  --[Ag_v30_09] - Wind Vane filtered sensor reading
 *  
 *  Explanation: Turn on the Agriculture v30 board and read the 
 *  Wind Vane Sensor calling the special 'getVaneFiltered' function 
 *  in order to calculate the mean value of sucesive measurement of 
 *  the wind vane direction sensor. The Wind Vane value will be stored 
 *  in the inner attribute: 'vaneDirection'
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

//Instance object
weatherStationClass vaneSensor;

void setup()
{
  // Turn on the USB and print a start message
  USB.ON();
  USB.println(F("Start program"));  
  
  // Turn on the sensor board
  Agriculture.ON();
}
 
void loop()
{
  // Part 1: Sensor reading
  // Read the Wind Vane sensor calling the special 'getVaneFiltered' 
  // function in order to calculate the mean value of sucesive 
  // measurement of the wind vane direction sensor. The Wind Vane 
  // value will be stored in the inner attribute: 'vaneSensor.vaneDirection'
  vaneSensor.getVaneFiltered();

  
  // Part 2: USB printing 
  switch(vaneSensor.vaneDirection)
  {
    case  SENS_AGR_VANE_N   :  USB.println("N");
                               break;
    case  SENS_AGR_VANE_NNE :  USB.println("NNE");
                               break;
    case  SENS_AGR_VANE_NE  :  USB.println("NE");
                               break;
    case  SENS_AGR_VANE_ENE :  USB.println("ENE");
                               break;
    case  SENS_AGR_VANE_E   :  USB.println("E");
                               break;
    case  SENS_AGR_VANE_ESE :  USB.println("ESE");
                               break;
    case  SENS_AGR_VANE_SE  :  USB.println("SE");
                               break;
    case  SENS_AGR_VANE_SSE :  USB.println("SSE");
                               break;
    case  SENS_AGR_VANE_S   :  USB.println("S");
                               break;
    case  SENS_AGR_VANE_SSW :  USB.println("SSW");
                               break;
    case  SENS_AGR_VANE_SW  :  USB.println("SW");
                               break;
    case  SENS_AGR_VANE_WSW :  USB.println("WSW");
                               break;
    case  SENS_AGR_VANE_W   :  USB.println("W");
                               break;
    case  SENS_AGR_VANE_WNW :  USB.println("WNW");
                               break;
    case  SENS_AGR_VANE_NW  :  USB.println("WN");
                               break;
    case  SENS_AGR_VANE_NNW :  USB.println("NNW");
                               break;
  }  
  delay(1000);
}
