/*
    --------------- NB_IoT_06 - HTTP GET  ---------------

    Explanation: This example shows how to send HTTP GET requests
    via NB-IoT module.

    *  Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L. 
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
    *  Version:           3.1
    *  Design:            David Gascón 
    *  Implementation:    P.Moreno, J.Siscart 
    */

#include <WaspBG96.h>

// APN settings
char apn[] = "";
char login[] = "";
char password[] = "";
///////////////////////////////////////
// Operator selection
///////////////////////////////////////
char network_operator[] = "";
///////////////////////////////////////
// <Operator_type> options: 
// LALPHANUMERIC_OPERATOR	Long format alphanumeric <network_operator> which can be up to 16 characters long.
// SALPHANUMERIC_OPERATOR	Short format alphanumeric <network_operator>.
// NUMERIC_OPERATOR			Numeric <network_operator>. GSM location area identification number.
///////////////////////////////////////
uint8_t operator_type = LALPHANUMERIC_OPERATOR;
///////////////////////////////////////
// Band configuration
///////////////////////////////////////
// NB-IoT & LTE-M1 bands:
// B1			
// B2			
// B3			
// B4			
// B5			
// B8			
// B12			
// B13			
// B18			
// B19			
// B20			
// B26			
// B28			
// B39			
// ------------------------------------
// GSM bands:
// GSM900 		
// GSM1800		
// GSM850		
// GSM1900		
// GSM_ANYBAND	
// NB_ANYBAND	
// M1_ANYBAND	
/////////////////////////////////////
char band[] = B20;
/////////////////////////////////////
// SERVER settings
///////////////////////////////////////
char host[] = "http://test.libelium.com";
uint16_t port = 80;
char resource[] = "/test-get-post.php?varA=1&varB=2&varC=3&varD=4&varE=5&varF=6&varG=7&varH=8&varI=9&varJ=10&varK=11&varL=12&varM=13&varN=14&varO=15";
///////////////////////////////////////

uint8_t error;

void setup()
{
  USB.ON();
  USB.println(F("Start program\n"));
  
  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  BG96.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  BG96.show_APN();
}


void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON the NB-IoT module
  //////////////////////////////////////////////////
  error = BG96.ON();

  if (error == 0)
  {
    USB.println(F("1. NB-IoT module ready"));

    ////////////////////////////////////////////////
    // 1.1. Check connection to network and continue
    ////////////////////////////////////////////////
    error = BG96.nbiotConnection(apn, band, network_operator, operator_type);
    if (error == 0)
    {
      USB.println(F("1.1. NB-IoT connection: OK "));

      ////////////////////////////////////////////////
      // 1.2.1 NB-IoT Context Activation
      ////////////////////////////////////////////////
      error = BG96.contextActivation(1,5);
      if (error == 0)
      {
        USB.println(F("1.1. NB-IoT context connection: OK "));
        USB.print(F("IP: ")); USB.println(BG96._ip);

        ////////////////////////////////////////////////
        // 2. Setting DNS server
        ////////////////////////////////////////////////
        error = BG96.setDNSServer("8.8.8.8","8.8.4.4");
        if (error == 0)
        {
          USB.println(F("2. Setting DNS server: OK "));      
        }
        else
        {
          USB.println(F("2. DNS error: ")); USB.println(error,DEC);
          USB.println(BG96._buffer, BG96._length);
        }

        ////////////////////////////////////////////////
        // 3. Sending HTTP GET frame
        ////////////////////////////////////////////////
        error = BG96.http( WaspBG96::HTTP_GET, host, port, resource);
        // Check the answer
        if (error == 0)
        {
          USB.print(F("3. Done. HTTP code: "));
          USB.println(BG96._httpCode);
          USB.print("Server response: ");
          USB.println(BG96._buffer, BG96._length);
        }
        else
        {
          USB.print(F("3. Failed. Error code: "));
          USB.println(error, DEC);
        }
      }
    }     
  }
  else
  {
    // Problem with the communication with the NB-IoT module
    USB.println(F("NB-IoT module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }

  //////////////////////////////////////////////////
  // 4. Switch OFF the NB-IoT module
  //////////////////////////////////////////////////
  error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("4. Module is power off"));      
    }
    else
    {
      USB.println(F("4. Power off ERROR"));
    }    


  //////////////////////////////////////////////////
  // 5. Sleep
  //////////////////////////////////////////////////
  USB.println(F("5. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("6. Wake up!!\n\n"));

}
