/*
 *  ------ NB_IoT 03 - Getting network information --------
 *
 *  Explanation: This example shows how to switch on the NB-IoT / Cat-M
    module, connect it to the network and get the operator name.
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

uint8_t connection_status;
char operator_name[20];

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
    // 2. Check connection to network and continue
    ////////////////////////////////////////////////

    error = BG96.nbiotConnection(apn, band, network_operator, operator_type);
    if (error == 0)
    {
      USB.println(F("2.1. NB-IoT connection: OK "));

      ////////////////////////////////////////////////
      // 2.1. NB-IoT Context Activation
      ////////////////////////////////////////////////
      error = BG96.contextActivation(1,5);
      if (error == 0)
      {
        USB.println(F("2.2. NB-IoT context connection: OK "));
        USB.print(F("IP: ")); USB.println(BG96._ip);
        USB.println(F("Module is connected!"));

          //////////////////////////////////////////////
          // 2.2. Get RSSI
          //////////////////////////////////////////////
          error = BG96.getRSSI();
          if (error == 0)
          {
            USB.print(F("3.1. RSSI: "));
            USB.print(BG96._rssi, DEC);
            USB.println(F(" dBm"));
          }
          else
          {
            USB.println(F("3.1. Error calling 'getRSSI' function"));
          }

          //////////////////////////////////////////////
          // 3.1. Get Operator name
          //////////////////////////////////////////////
          memset(operator_name, '\0', sizeof(operator_name));
          error = BG96.getOperator(operator_name);

          if (error == 0)
          {
            USB.print(F("3.2. Operator: "));
            USB.println(operator_name);
          }
          else
          {
            USB.println(F("3.2. Error calling 'getOperator' function"));
          }

          ////////////////////////////////////////////////
          // 3.3. Revision identification
          ////////////////////////////////////////////////
          error = BG96.getInfo(WaspBG96::INFO_QNWINFO);
          if (error == 0)
          {
            USB.print(F("3.3. QNWINFO: "));
            USB.println(BG96._buffer, BG96._length);
          }
          else
          {
            USB.println(F("3.3. QNWINFO ERROR"));
          }

          ////////////////////////////////////////////////
          // 3.4. Revision identification
          ////////////////////////////////////////////////
          error = BG96.getInfo(WaspBG96::INFO_QCSQ);
          if (error == 0)
          {
            USB.print(F("3.4. QCSQ: "));
            USB.println(BG96._buffer, BG96._length);
          }
          else
          {
            USB.println(F("3.4. QCSQ ERROR"));
          }

          ////////////////////////////////////////////////
          // 3.5. Revision identification
          ////////////////////////////////////////////////
          error = BG96.getInfo(WaspBG96::INFO_QSPN);
          if (error == 0)
          {
            USB.print(F("3.5. QSPN: "));
            USB.println(BG96._buffer, BG96._length);
          }
          else
          {
            USB.println(F("3.5. QSPN ERROR"));
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
  PWR.deepSleep("00:00:01:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("6. Wake up!!\n\n"));

}
