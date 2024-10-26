/*
     --- 4G_20 - OTA  ---

    Explanation: This example shows how perform OTA programming using the
    4G module. It is necessary to setup an FTP server and change the
    parameters defined in the example.

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
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
    Design:            David Gascón
    Implementation:    Alejandro Gállego
*/

#include <Wasp4G.h>


// APN settings
///////////////////////////////////////
char apn[] = "";
char login[] = "";
char password[] = "";
///////////////////////////////////////

// SERVER settings
///////////////////////////////////////
char ftp_server[] = "pruebas.libelium.com";
uint16_t ftp_port = 21;
char ftp_user[] = "t3g@libelium.com";
char ftp_pass[] = "ftp1234";
///////////////////////////////////////

uint8_t error;
uint8_t status;
char programID[10];


void setup()
{
  USB.ON();
  USB.println(F("Start program"));

  //////////////////////////////////////////////////
  // 1. Check if the program has been programmed ok
  //////////////////////////////////////////////////
  status = Utils.checkNewProgram();

  switch (status)
  {
    case 0:
      USB.println(F("REPROGRAMMING ERROR"));
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
  USB.println(F("-----------------------------"));
  USB.print(F("Program id: "));
  USB.println(programID);

  // show program version number
  USB.print(F("Program version: "));
  USB.println(Utils.getProgramVersion(), DEC);
  USB.println(F("-----------------------------"));


  // sets operator parameters
  _4G.set_APN(apn, login, password);

  // Show APN settings via USB port
  _4G.show_APN();


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
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // Enter PIN code
    ////////////////////////////////////////////////
    /*
      USB.println(F("Enter PIN code..."));

      if (_4G.enterPIN("****") == 1)
      {
      USB.println(F("PIN code accepted"));
      }
      else
      {
      USB.println(F("PIN code incorrect"));
      }
    */

    //////////////////////////////
    // 4.3. Request OTA
    //////////////////////////////
    USB.println(F("==> Request OTA..."));
    error = _4G.requestOTA(ftp_server, ftp_port, ftp_user, ftp_pass);

    if (error != 0)
    {
      USB.print(F("OTA request failed. Error code: "));
      printError(error);
    }

    // blink RED led
    Utils.blinkRedLED(300, 3);

  }
  else
  {
    USB.println(F("4G module not started"));
  }


  ////////////////////////////////////////////////
  // 5. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("5. Switch OFF 4G module"));
  _4G.OFF();


  ////////////////////////////////////////////////
  // 6. Sleep
  ////////////////////////////////////////////////
  USB.println(F("6.1. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("6.1. Wake up!!\n\n"));
}


/**********************************************************

   printError - prints the error related to OTA


 ************************************************************/
void printError(uint8_t err)
{
  switch (err)
  {
    case 1:  USB.println(F("SD not present"));
      break;
    case 2:  USB.println(F("error downloading UPGRADE.TXT"));
      break;
    case 3:  USB.println(F("error opening FTP session"));
      break;
    case 4:  USB.println(F("filename is different to 7 bytes"));
      break;
    case 5:  USB.println(F("no 'FILE' pattern found"));
      break;
    case 6:  USB.println(F("'NO_FILE' is the filename"));
      break;
    case 7:  USB.println(F("no 'PATH' pattern found"));
      break;
    case 8:  USB.println(F("no 'SIZE' pattern found"));
      break;
    case 9:  USB.println(F("no 'VERSION' pattern found"));
      break;
    case 10: USB.println(F("invalid program version number"));
      break;
    case 11: USB.println(F("file size does not match in UPGRADE.TXT and server"));
      break;
    case 12: USB.println(F("error downloading binary file: server file size is zero"));
      break;
    case 13: USB.println(F("error downloading binary file: reading the file size"));
      break;
    case 14: USB.println(F("error downloading binary file: SD not present"));
      break;
    case 15: USB.println(F("error downloading binary file: error creating the file in SD"));
      break;
    case 16: USB.println(F("error downloading binary file: error opening the file"));
      break;
    case 17: USB.println(F("error downloading binary file: error setting the pointer of the file"));
      break;
    case 18: USB.println(F("error downloading binary file: error opening the GET connection"));
      break;
    case 19: USB.println(F("error downloading binary file: error module returns error code after requesting data"));
      break;
    case 20: USB.println(F("error downloading binary file: error  getting packet size"));
      break;
    case 21: USB.println(F("error downloading binary file: packet size mismatch"));
      break;
    case 22: USB.println(F("error downloading binary file: error writing SD"));
      break;
    case 23: USB.println(F("error downloading binary file: no more retries getting data"));
      break;
    case 24: USB.println(F("error downloading binary file: size mismatch"));
      break;
    default : USB.println(F("unknown"));

  }
}

