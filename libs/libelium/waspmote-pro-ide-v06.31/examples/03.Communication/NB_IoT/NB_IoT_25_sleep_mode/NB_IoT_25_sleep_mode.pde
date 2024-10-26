/*
 *  ------ NB_IoT 25 - sleep modes --------
 *
 *    sending HTTP GET and activating Sleep NB-IoT module mode (PSM)
 *
 *  Explanation: This example shows how to use HTTPS requests to send
    Waspmote frames from Waspmote to Meshlium. Therefore, the Meshlium
    will be able to parse the sensor data and insert it into the database
 *
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

uint8_t error;
uint32_t previous;

// APN settings
char apn[] = "";
char login[] = "";
char password[] = "";
/////////////////////////////////////////
// Operator selection
/////////////////////////////////////////
char network_operator[] = "";
/////////////////////////////////////////
// <Operator_type> options: 
// LALPHANUMERIC_OPERATOR	Long format alphanumeric <network_operator> which can be up to 16 characters long.
// SALPHANUMERIC_OPERATOR	Short format alphanumeric <network_operator>.
// NUMERIC_OPERATOR			Numeric <network_operator>. GSM location area identification number.
/////////////////////////////////////////
uint8_t operator_type = LALPHANUMERIC_OPERATOR;
/////////////////////////////////////////
// Band configuration
/////////////////////////////////////////
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
///////////////////////////////////////
char band[] = B20;
///////////////////////////////////////
// SERVER settings
///////////////////////////////////////
char host[] = "http://test.libelium.com";
uint16_t port = 80;
char resource[] = "/test-get-post.php?varA=1&varB=2&varC=3&varD=4&varE=5&varF=6&varG=7&varH=8&varI=9&varJ=10&varK=11&varL=12&varM=13&varN=14&varO=15";
///////////////////////////////////////

void setup()
{

  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  BG96.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  BG96.show_APN();

    //////////////////////////////////////////////////
  // 1. Switch on the BG96 module
  //////////////////////////////////////////////////
  previous = millis();
  USB.println("BG96 Module ON...");
  error = BG96.ON();
  if (error == 0)
  {
    USB.print(F("1. BG96 module ready in "));
    USB.print(millis()-previous);
    USB.println(F(" ms"));
  }
  else
  {
    USB.println(F("1. BG96 module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }
    ////////////////////////////////////////////////
    // 1.1. Hardware identification
    ////////////////////////////////////////////////
    error = BG96.getInfo(WaspBG96::INFO_HW);
    if (error == 0)
    {
      USB.print(F("1.1. Hardware identification: "));
      USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("1.1. Manufacturer identification ERROR"));
    }
    ////////////////////////////////////////////////
    // 1.2. Setting PSM parameters
    ////////////////////////////////////////////////
    error = BG96.nbiotSettingPSM("10001010","00000001");
    if (error == 0)
    {
      USB.println(F("1.2. PSM Status: OK - Disabled"));
    }
    else
    {
      USB.println(F("1.2.PSM ERROR ")); USB.println(error,DEC);
      USB.println(BG96._buffer, BG96._length);
    }

    ////////////////////////////////////////////////
    // 2. NB-IoT Connection
    ////////////////////////////////////////////////
    error = BG96.nbiotConnection(apn, band, network_operator, operator_type);
    if (error == 0)
    {
      USB.println(F("2. NB-IoT connection: OK "));
    }
    else
    {
      USB.println(F("2. ERROR ")); USB.println(error,DEC);
      USB.println(BG96._buffer, BG96._length);
    }

      ////////////////////////////////////////////////
      // 2.1 NB-IoT Context Activation
      ////////////////////////////////////////////////
      error = BG96.contextActivation(1,5);
      if (error == 0)
      {
        USB.println(F("2.1. NB-IoT context connection: OK "));
      }
      else
      {
        USB.println(F("2.1. Context connection ERROR ")); USB.println(error,DEC);
        USB.println(BG96._buffer, BG96._length);
      }
      ////////////////////////////////////////////////
      // 3. Setting DNS server
      ////////////////////////////////////////////////
      error = BG96.setDNSServer("8.8.8.8","8.8.4.4");
      if (error == 0)
      {
        USB.println(F("3. Setting DNS server: OK "));
      }
      else
      {
        USB.println(F("3. DNS error: ")); USB.println(error,DEC);
        USB.println(BG96._buffer, BG96._length);
      }

}

void loop()
{
    for (int i = 0; i<3;i++)
    {

      ////////////////////////////////////////////////
      // 4. Sending HTTP GET frame
      ////////////////////////////////////////////////
      error = BG96.http( WaspBG96::HTTP_GET, host, port, resource);
      // Check the answer
      if (error == 0)
      {
        USB.print(F("4. Done. HTTP code: "));
        USB.println(BG96._httpCode);
        USB.print("Server response: ");
        USB.println(BG96._buffer, BG96._length);
      }
      else
      {
        USB.print(F("4. Failed. Error code: "));
        USB.println(error, DEC);
      }

      ////////////////////////////////////////////////
      // 5. Sleep Mode
      ////////////////////////////////////////////////
      previous = millis();
      error = BG96.nbiotSleepMode(1);
      if (error == 0)
      {
        USB.println(F("5. NB-IoT module sleep mode activated!"));
        USB.print(F("Time: "));
        USB.println(millis()-previous);
      }
      else
      {
        USB.print(F("5.Error activating sleep mode. Error code: "));
        USB.println(error, DEC);
        USB.println(BG96._buffer, BG96._length);
      }

      //////////////////////////////////////////////////
      // 6. Entering Waspmote deep sleep mode
      //////////////////////////////////////////////////
      USB.println(F("6. Enter deep sleep..."));
      PWR.deepSleep("00:00:01:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

      USB.ON();
      USB.println(F("7. Waspmote Wake up!!\n\n"));

      ////////////////////////////////////////////////
      // 8. Sleep NB-IoT module mode OFF - NB-IoT WakeUp
      ////////////////////////////////////////////////
      previous = millis();
      error = BG96.nbiotSleepMode(0);
      if (error == 0)
      {
        USB.println(F("8. NB-IoT module sleep mode desactivated!"));
        USB.print(F("Time: "));
        USB.println(millis()-previous);
      }
      else
      {
        USB.print(F("8.Error disabling sleep mode. Error code: "));
        USB.println(error, DEC);
        USB.println(BG96._buffer, BG96._length);
      }
    }

   USB.println(F("iterations finished..."));
   ////////////////////////////////////////////////
   // 7. Power OFF the module
   ////////////////////////////////////////////////
   error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("9. Module is power off"));
      //USB.println(BG96._buffer, BG96._length);
    }
    else
    {
      USB.println(F("9. Power off ERROR"));
    }

    USB.println(F("Example is ended!"));
    while(1)
    {
      delay(10);
    }

}
