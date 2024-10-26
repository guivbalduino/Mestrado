/*  
 *  ------ LoRaWAN Code Example -------- 
 *  
 *  Explanation: This example shows how to configure the module
 *  and send frames to a LoRaWAN gateway with ACK after join a network
 *  using ABP
 *  
 *  Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Implementation:    Luismi Marti  
 */

#include <WaspLoRaWAN_Global.h>
#include <WaspFrame.h>

// socket to use
//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// Device parameters for Back-End registration
////////////////////////////////////////////////////////////
char DEVICE_ADDR[] = "01020304";
char NWK_SESSION_KEY[] = "000102030405060708090A0B0C0D0E0F";
char APP_SESSION_KEY[] = "000102030405060708090A0B0C0D0E0F";
////////////////////////////////////////////////////////////

// Define port to use in Back-End: from 1 to 223
uint8_t PORT = 3;

// variable
uint8_t error;

// define the Waspmote ID 
char moteID[] = "node_01";


void setup() 
{
  USB.ON();
  USB.println(F("LoRaWAN example - Send Confirmed packets (ACK)\n"));


  USB.println(F("------------------------------------"));
  USB.println(F("Module configuration"));
  USB.println(F("------------------------------------\n"));

  USB.println(F("---------------------------------------"));
  USB.println(F("***************************************"));
  USB.println(F("The Libelium LoRaWAN Global module has"));
  USB.println(F("already defined its unique identifier"));
  USB.println(F("by the manufacturer. It is not possible"));
  USB.println(F("to modify it via Libelium API. Keep in"));
  USB.println(F("the user needs to set the same EUI "));
  USB.println(F("provided by this code in the LoRaWAN"));
  USB.println(F("Network server where the module is "));
  USB.println(F("going to be sending data to."));
  USB.println(F("***************************************"));
  USB.println(F("---------------------------------------\n"));

  //////////////////////////////////////////////
  // 1. Switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }

  LoRaWAN.factoryReset();

  //////////////////////////////////////////////
  // 2. Set Device Address
  //////////////////////////////////////////////

  error = LoRaWAN.setADR(ADR_ON);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Device address set OK"));     
  }
  else 
  {
    USB.print(F("2. Device address set error = ")); 
    USB.println(error, DEC);
  }

  //////////////////////////////////////////////
  // 3. Set Device Address
  //////////////////////////////////////////////

  error = LoRaWAN.setDeviceAddr(DEVICE_ADDR);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("3. Device address set OK"));     
  }
  else 
  {
    USB.print(F("3. Device address set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Set Network Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setNwkSessionKey(NWK_SESSION_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Network Session Key set OK"));     
  }
  else 
  {
    USB.print(F("4. Network Session Key set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 5. Set Application Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setAppSessionKey(APP_SESSION_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5. Application Session Key set OK"));     
  }
  else 
  {
    USB.print(F("5. Application Session Key set error = ")); 
    USB.println(error, DEC);
  }

  /////////////////////////////////////////////////
  // 6. Join OTAA to negotiate keys with the server
  /////////////////////////////////////////////////
  
  error = LoRaWAN.setDataRate(5);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("\n---------------------------------------------------------------"));
    USB.println(F("6. Set data rate OK"));
    USB.println(F("In order to send large ammount of data such as frames, "));
    USB.println(F("data rate must be set properly because of LoRaWAN protocol"));
    USB.println(F("limitations. We strongly recommend to use tiny frame in"));
    USB.println(F("order to able to use the whole range of data rates regardles"));
    USB.println(F("the region configured in the device."));
    USB.println(F("---------------------------------------------------------------\n"));
    USB.println();  
  }
  else 
  {
    USB.print(F("6. Set data rate error = ")); 
    USB.println(error, DEC);
  }

  USB.println(F("\n------------------------------------"));
  USB.println(F("Module configured"));
  USB.println(F("------------------------------------\n"));

  LoRaWAN.getDeviceEUI();
  USB.print(F("Device EUI: "));
  USB.println(LoRaWAN._devEUI);  

  LoRaWAN.getDeviceAddr();
  USB.print(F("Device Address: "));
  USB.println(LoRaWAN._devAddr);  

  USB.println();  

  frame.setID(moteID);
  
}



void loop() 
{
  
  //////////////////////////////////////////////
  // 1. Creating a new frame
  //////////////////////////////////////////////
  USB.println(F("Creating an ASCII frame"));

  // Create new frame (ASCII)
  frame.createFrame(ASCII); 

  // set frame fields (String - char*)
  frame.addSensor(SENSOR_STR, (char*) "this_is_a_string");
  // set frame fields (Battery sensor - uint8_t)
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

  // Prints frame
  frame.showFrame();
  
    
  //////////////////////////////////////////////
  // 2. Switch on LoRaWAN
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 3. Join network
  //////////////////////////////////////////////

  error = LoRaWAN.joinABP();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Join network OK"));   

    //////////////////////////////////////////////
    // 4. Send confirmed packet 
    //////////////////////////////////////////////

    error = LoRaWAN.sendConfirmed( PORT, frame.buffer,frame.length);

    // Error messages:
    /*
     * '6' : Module hasn't joined a network
     * '5' : Sending error
     * '4' : Error with data length    
     * '2' : Module didn't response
     * '1' : Module communication error   
     */
    // Check status
    if( error == 0 ) 
    {
      USB.println(F("3. Send Confirmed packet OK")); 
      if (LoRaWAN._dataReceived == true)
      { 
        USB.print(F("   There's data on port number "));
        USB.print(LoRaWAN._port,DEC);
        USB.print(F(".\r\n   Data: "));
        USB.println(LoRaWAN._data);
      }
    }
    else 
    {
      USB.print(F("3. Send Confirmed packet error = ")); 
      USB.println(error, DEC);
    }
  }
  else 
  {
    USB.print(F("2. Join network error = ")); 
    USB.println(error, DEC);
  }



  //////////////////////////////////////////////
  // 5. Switch off
  //////////////////////////////////////////////

  error = LoRaWAN.OFF();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Switch OFF OK"));     
  }
  else 
  {
    USB.print(F("4. Switch OFF error = ")); 
    USB.println(error, DEC);
  }


  USB.println();
  delay(5000);



}
