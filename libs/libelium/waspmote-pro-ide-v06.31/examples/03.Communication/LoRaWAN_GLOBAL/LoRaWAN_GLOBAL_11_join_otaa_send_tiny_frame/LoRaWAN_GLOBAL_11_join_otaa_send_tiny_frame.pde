/*
    ------ LoRaWAN Code Example --------

    Explanation: This example shows how to configure the module and
    send tiny frames to a LoRaWAN gateway with ACK after join a network
    using OTAA.

    This type of frame has been designed to create short frames with data.

    Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    Isabel Burillo
*/

#include <WaspLoRaWAN_Global.h>
#include <WaspFrame.h>

// socket to use
//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// Device parameters for Back-End registration
////////////////////////////////////////////////////////////
char APP_EUI[] = "0102030405060708";
char APP_KEY[] = "000102030405060708090A0B0C0D0E0F";
////////////////////////////////////////////////////////////

// Define port to use in Back-End: from 1 to 223
uint8_t PORT = 3;

// variable
uint8_t error;
uint8_t error_config = 0;

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
    error_config = 1;
  }

    
  //////////////////////////////////////////////
  // 2. Enable adaptive data rate
  //////////////////////////////////////////////

  error = LoRaWAN.setADR(ADR_ON);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Data rate set OK"));     
  }
  else 
  {
    USB.print(F("2. Data rate set error= ")); 
    USB.println(error, DEC);
     error_config = 2;
  }


  //////////////////////////////////////////////
  // 3. Set Application EUI
  //////////////////////////////////////////////

  error = LoRaWAN.setAppEUI(APP_EUI);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("3. Application EUI set OK"));     
  }
  else 
  {
    USB.print(F("3. Application EUI set error = ")); 
    USB.println(error, DEC);
    error_config = 4;
  }

  //////////////////////////////////////////////
  // 4. Set Application Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setAppKey(APP_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Application Key set OK"));     
  }
  else 
  {
    USB.print(F("4. Application Key set error = ")); 
    USB.println(error, DEC);
    error_config = 5;
  }

  /////////////////////////////////////////////////
  // 5. Join OTAA to negotiate keys with the server
  /////////////////////////////////////////////////
  
  error = LoRaWAN.joinOTAA();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5. Join network OK"));         
  }
  else 
  {
    USB.print(F("5. Join network error = ")); 
    USB.println(error, DEC);
    error_config = 6;
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
    error_config = 6;
  }

  //////////////////////////////////////////////
  //7. Switch off
  //////////////////////////////////////////////

  error = LoRaWAN.OFF();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("7. Switch OFF OK"));     
  }
  else 
  {
    USB.print(F("7. Switch OFF error = ")); 
    USB.println(error, DEC);
    error_config = 8;
  }
  
  if (error_config == 0){
    USB.println(F("\n---------------------------------------------------------------"));
    USB.println(F("Module configured"));
    USB.println(F("After joining through OTAA, the module and the network exchanged "));
    USB.println(F("the Network Session Key and the Application Session Key which "));
    USB.println(F("are needed to perform communications. After that, 'ABP mode' is used"));
    USB.println(F("to join the network and send messages after powering on the module"));
    USB.println(F("---------------------------------------------------------------\n"));
    USB.println();  
  }
  else{
    USB.println(F("\n---------------------------------------------------------------"));
    USB.println(F("Module not configured"));
    USB.println(F("Check OTTA parameters and restart the code."));
    USB.println(F("If you continue executing the code, frames might not be sent even"));
    USB.println(F("though the code prints: Send unconfirmed packet OK"));
    USB.println(F("\n---------------------------------------------------------------"));
    
  } 
  
  frame.setID(moteID);

}



void loop()
{

  //////////////////////////////////////////////
  // 1. Creating a new frame
  //////////////////////////////////////////////

  // init ACC
  ACC.ON();

  USB.println(F("1. Creating an BINARY frame"));

  // Create new frame
  frame.createFrame(BINARY);

  // set frame fields (Battery sensor - uint8_t)
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

  // set frame fields (multiple)
  frame.addSensor(SENSOR_ACC, ACC.getX(), ACC.getY(), ACC.getZ());

  // Prints frame
  frame.showFrame();

  // accelerometer OFF
  ACC.OFF();


  //////////////////////////////////////////////
  // 2. Switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if ( error == 0 )
  {
    USB.println(F("2. Switch ON OK"));
  }
  else
  {
    USB.print(F("2. Switch ON error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 3. Join network
  //////////////////////////////////////////////

  error = LoRaWAN.joinABP();

  // Check status
  if ( error == 0 )
  {
    USB.println(F("3. Join network OK"));

    error = LoRaWAN.getMaxPayload();

    if (error == 0)
    {
      //////////////////////////////////////////////
      // 4. Generate tiny frame
      //////////////////////////////////////////////

      USB.print(F("4.1. LoRaWAN maximum payload: "));
      USB.println(LoRaWAN._maxPayload, DEC);

      // set maximum payload
      frame.setTinyLength(LoRaWAN._maxPayload);

      boolean end = false;
      uint8_t pending_fields = 0;

      while (end == false)
      {
        pending_fields = frame.generateTinyFrame();

        USB.print(F("4.2. Tiny frame generated:"));
        USB.printHexln(frame.bufferTiny, frame.lengthTiny);


        //////////////////////////////////////////////
        // 5. Send confirmed packet
        //////////////////////////////////////////////

        USB.println(F("5. LoRaWAN confirmed sending..."));
        error = LoRaWAN.sendConfirmed( PORT, frame.bufferTiny, frame.lengthTiny);

        // Error messages:
        /*
          '6' : Module hasn't joined a network
          '5' : Sending error
          '4' : Error with data length
          '2' : Module didn't response
          '1' : Module communication error
        */
        // Check status
        if (error == 0)
        {
          USB.println(F("5.1. LoRaWAN send packet OK"));
          if (LoRaWAN._dataReceived == true)
          {
            USB.print(F("  There's data on port number: "));
            USB.print(LoRaWAN._port, DEC);
            USB.print(F("\r\n  Data: "));
            USB.println(LoRaWAN._data);
          }
        }
        else
        {
          USB.print(F("5.1. LoRaWAN send packet error = "));
          USB.println(error, DEC);
        }

        if (pending_fields > 0)
        {
          end = false;
          delay(10000);
        }
        else
        {
          end = true;
        }
      }
    }
    else
    {
      USB.println(F("4. LoRaWAN error getting the maximum payload"));
    }
  }
  else
  {
    USB.print(F("2. Join network error = "));
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 6. Switch off
  //////////////////////////////////////////////

  error = LoRaWAN.OFF();

  // Check status
  if ( error == 0 )
  {
    USB.println(F("6. Switch OFF OK"));
  }
  else
  {
    USB.print(F("6. Switch OFF error = "));
    USB.println(error, DEC);
  }


  USB.println();
  delay(10000);
}
