/*  
 *  ------ Sigfox Code Example -------- 
 *  
 *  Explanation: This example shows how to send a Sigfox packet.
 *  In this example, the message to be sent is defined as an array 
 *  of bytes. It is necessary to indicate the length of this array.
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
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona  
 */
#include <WaspSigfox.h>

//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// define variable to create a speficic frame to be sent
uint8_t data[12];
uint8_t size;

// define error variable
uint8_t error;

// define vars for sensors
uint8_t battery;
uint8_t digitalPins;
uint8_t digital1;
uint8_t digital2;
uint8_t digital3;
uint8_t digital4;
uint8_t digital5;
uint8_t digital6;
uint8_t digital7;
uint8_t digital8;


void setup() 
{
  USB.ON();  
}


void loop() 
{
  //////////////////////////////////////////////
  // 1. switch on
  //////////////////////////////////////////////  
 
  USB.println(F("\n------------------------------")); 
  USB.println(F("1. Switch on the module:"));
  USB.println(F("------------------------------")); 
  
  error = Sigfox.ON(socket);
  
  // Check sending status
  if( error == 0 ) 
  {
    USB.println(F("Switch ON OK"));     
  }
  else 
  {
    USB.println(F("Switch ON ERROR")); 
  } 
  
  
  //////////////////////////////////////////////
  // 2. create array with sensor data
  // Sigfox Back-END device "Display type" must be: 
  // Battery::uint:8 Digital8::bool:7 Digital7::bool:6 Digital6::bool:5 Digital5::bool:4 Digital4::bool:3 Digital3::bool:2 Digital2::bool:1 Digital1::bool:0
  //////////////////////////////////////////////
  
  USB.println(F("\n------------------------------")); 
  USB.println(F("2. Reading sensors:"));
  USB.println(F("------------------------------")); 
   
  // 2.1. Battery level reading
  battery = PWR.getBatteryLevel();  
  USB.print(F("Battery (%): "));
  USB.println(battery,DEC);
  
  // 2.2. Digital pins reading
  digital1 = digitalRead(DIGITAL1);
  digital2 = digitalRead(DIGITAL2);
  digital3 = digitalRead(DIGITAL3);
  digital4 = digitalRead(DIGITAL4);
  digital5 = digitalRead(DIGITAL5);
  digital6 = digitalRead(DIGITAL6);
  digital7 = digitalRead(DIGITAL7);
  digital8 = digitalRead(DIGITAL8);
  
  digitalPins |= digital1;
  digitalPins |= digital2 << 1;
  digitalPins |= digital3 << 2;
  digitalPins |= digital4 << 3;
  digitalPins |= digital5 << 4;
  digitalPins |= digital6 << 5;
  digitalPins |= digital7 << 6;
  digitalPins |= digital8 << 7;  
  
  USB.print(F("Digital Pins (bitmap): "));
  USB.println(digitalPins, BIN);  
  
  // 2.3. Fill structure fields
  // fill 'data' buffer with data
  data[0] = battery;
  data[1] = digitalPins;
  size = 2;
         
  USB.print(F("Final Frame to send:"));    
  USB.printHexln(data, size);    
  
  
  //////////////////////////////////////////////
  // 3. send data
  //////////////////////////////////////////////
   
  USB.println(F("\n------------------------------")); 
  USB.println(F("3. Sending packet:"));
  USB.println(F("------------------------------")); 
  
  error = Sigfox.send(data,size);
  
  // Check sending status
  if( error == 0 )
  {
    USB.println(F("Sigfox packet sent OK"));     
  }
  else 
  {
    USB.println(F("Sigfox packet sent ERROR")); 
  }
  
  
  //////////////////////////////////////////////
  // 4. sleep
  //////////////////////////////////////////////
  USB.println("\nEnter sleep");
  PWR.deepSleep("00:01:00:00",RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
  USB.println("\n***************************************");
}
