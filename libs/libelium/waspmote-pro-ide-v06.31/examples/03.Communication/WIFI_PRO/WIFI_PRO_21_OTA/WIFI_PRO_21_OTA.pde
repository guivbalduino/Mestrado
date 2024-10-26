/*
 *  ------ WIFI Example -------- 
 *
 *  Explanation: This example shows how perform OTA programming using the
 *  WiFi module. It is necessary to specify the correct AP settings. 
 *  Besides, it is necessary to setup an FTP server and change the parameters
 *  defined in the example.
 *
 *  Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Version:                3.1
 *  Design:                 David Gascon
 *  Implementation:         Yuri Carmona
 */

// include WiFi library
#include <WaspWIFI_PRO.h>


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////

// FTP server settings 
/////////////////////////////////
char server[] = "10.10.10.1";
char port[] = "21";
char user[] = "ota";
char password[] = "libelium";
/////////////////////////////////


// define variables
uint8_t error;
uint8_t status;
unsigned long previous;
int8_t answer;
char programID[10];

void setup()
{
  USB.ON();
  USB.println(F("Start program"));  
  USB.println(F("***************************************"));  
  USB.println(F("Once the module is set with one or more"));
  USB.println(F("AP settings, it attempts to join the AP"));
  USB.println(F("automatically once it is powered on"));    
  USB.println(F("Refer to example 'WIFI_PRO_01' to configure"));  
  USB.println(F("the WiFi module with proper settings"));
  USB.println(F("***************************************"));
  
  //////////////////////////////////////////////////
  // 1. Check if the program has been programmed ok
  //////////////////////////////////////////////////
  answer = Utils.checkNewProgram();   
 
  switch (answer)
  {
  case 0:  
    USB.print(F("REPROGRAMMING ERROR"));
    Utils.blinkRedLED(300, 3);
    break;   

  case 1:  
    USB.println(F("REPROGRAMMING OK"));
    Utils.blinkGreenLED(300, 3);
    break; 

  default: 
    USB.println(F("RESTARTING"));
    Utils.blinkGreenLED(500, 1);
  }      


  // show program ID 
  Utils.getProgramID(programID);
  USB.println(F("-------------------------------"));
  USB.print(F("Program id: "));
  USB.println(programID);

  // show program version number
  USB.print(F("Program version: "));
  USB.println(Utils.getProgramVersion(),DEC);
  USB.println(F("-------------------------------"));
  

  //////////////////////////////////////////////////
  // 2. User setup
  //////////////////////////////////////////////////

  // Put your setup code here, to run once:

}


void loop()
{   
  //////////////////////////////////////////////////
  // 3. User loop program
  //////////////////////////////////////////////////

  // put your main code here, to run repeatedly:



  //////////////////////////////////////////////////
  // 4. OTA request
  //////////////////////////////////////////////////

  //////////////////////////////
  // 4.1. Switch ON
  //////////////////////////////
  error = WIFI_PRO.ON(socket);

  if (error == 0)
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }


  //////////////////////////////
  // 4.2. Check if connected
  //////////////////////////////
  // get actual time
  previous = millis();

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  {    
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);
      

    USB.println(F("2.1. Connection Status:"));
    USB.println(F("-------------------------------"));
    USB.print(F("Rate (Mbps):"));
    USB.println(WIFI_PRO._rate);
    USB.print(F("Signal Level (%):"));
    USB.println(WIFI_PRO._level);
    USB.print(F("Link Quality(%):"));
    USB.println(WIFI_PRO._quality);
    USB.println(F("-------------------------------"));

    //////////////////////////////
    // 4.3. Request OTA
    //////////////////////////////    
    USB.println(F("2.2. Request OTA..."));
    error = WIFI_PRO.requestOTA(server, port, user, password);

    // If OTA fails, show the error code     
    WIFI_PRO.printErrorCode();
    Utils.blinkRedLED(300, 3);

  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);
    Utils.blinkRedLED(100, 10);
  }


  //////////////////////////////////////////////////
  // 5. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO.OFF(socket);
  USB.println(F("3. WiFi switched OFF"));
  USB.println(F("Wait...\n\n"));
  delay(10000);


}

