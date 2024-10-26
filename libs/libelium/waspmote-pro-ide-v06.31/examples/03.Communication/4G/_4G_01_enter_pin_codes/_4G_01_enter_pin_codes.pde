/*  
 *  --------------- 4G_01 - Setting PIN codes  --------------- 
 *  
 *  Explanation: This example shows how to check for the PIN code of
 *  the SIM card. In the case it is enabled, the program asks for the 
 *  PIN code in order to enter it and access.
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
 *  Implementation:    Alejandro Gállego
 */

#include <Wasp4G.h>


// define variables
uint8_t PIN_status;
char PIN_code[30];
uint8_t error;
int counter;
int temp;
uint32_t previous;

void setup()
{    
  USB.println(F("****************************************"));
  USB.println(F("This example inits the 4G module and"));
  USB.println(F("request the unlock codes if necessary"));
  USB.println(F("****************************************"));

  //////////////////////////////////////////////////
  // 1. Switch on the 4G module
  //////////////////////////////////////////////////
  previous = millis();
  error = _4G.ON();
  if (error == 0)  
  {
    USB.print(F("1. 4G module ready in "));	
    USB.print(millis()-previous);
    USB.println(F(" ms"));
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
    USB.print(F("Error code: "));
    USB.println(error, DEC);
  }
}



void loop()
{
  
  //////////////////////////////////////////////////
  // 2. Check PIN code
  //////////////////////////////////////////////////
  USB.println(F("2. Reading code..."));
  PIN_status = _4G.checkPIN();
  
  
  switch (PIN_status)
  {
  case 0:
    USB.println(F("SIM and module unlocked. Ready to use"));
    USB.println(F("The sketch will stop here"));
    while(1);
    break;

  case 1:
    USB.println(F("LE910 is awaiting SIM PIN."));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 2:
    USB.println(F("LE910 is awaiting SIM PUK"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 3:
    USB.println(F("LE910 is awaiting phone-to-SIM card password."));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 4:
    USB.println(F("LE910 is awaiting phone-to-very-first-SIM card password."));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 5:
    USB.println(F("LE910 is awaiting phone-to-very-first-SIM card unblocking password."));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 6:
    USB.println(F("LE910 is awaiting SIM PIN2"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 7:
    USB.println(F("LE910 is awaiting SIM PUK2"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 8:
    USB.println(F("LE910 is awaiting network personalization password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 9:
    USB.println(F("LE910 is awaiting network personalization unblocking password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 10:
    USB.println(F("LE910 is awaiting network subset personalization password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 11:
    USB.println(F("LE910 is awaiting network subset personalization unblocking password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 12:
    USB.println(F("LE910 is awaiting service provider personalization password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 13:
    USB.println(F("LE910 is awaiting service provider personalization unblocking password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 14:
    USB.println(F("LE910 is awaiting corporate personalization password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  case 15:
    USB.println(F("LE910 is awaiting corporate personalization unblocking password"));
    USB.println(F("Please, enter the code: "));
    readString(PIN_code);
    break;

  default: 
    USB.print(F("Error code: "));
    USB.println(PIN_status, DEC);
    break;
  }


  //////////////////////////////////////////////////
  // 3. Set PIN code
  //////////////////////////////////////////////////
  if ((PIN_status != 0) && (PIN_status < 16))
  {
    USB.print(F("3. Entering PIN code..."));
    if (_4G.enterPIN(PIN_code) == 0) 
    {
      USB.println(F("3. done"));
    }
    else
    {
      USB.println(F("3. error"));
    }
  }
}


/******************************************************************
*
* readString 
*
*
*
*******************************************************************/
void readString(char* message)
{
  int x = 0;	

  // clean input buffer
  USB.ON();
  USB.flush();
  
  // wait for incoming data from keyboard
  while(USB.available() == 0);

  // Treat all incoming bytes
  while (USB.available() > 0)
  {
    message[x] = USB.read();

    if( (message[x] == '\r') || (message[x] == '\n') )
    {
      message[x]='\0';
    }
    else
    {
      x++;
    }
  }
}





