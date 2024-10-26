/*
    --- 4G_10 - Downloading files from a FTP server  ---

    Explanation: This example shows how to download a file from a FTP
    server to Waspmote SD card

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

///////////////////////////////////////////////////////////////////////
// Define filenames for SD card and FTP server:
//  - If the file is in the root directory: "FILE.TXT" or "/FILE.TXT"
//  - If the file is inside a folder: "/FOLDER/FILE.TXT"
///////////////////////////////////////////////////////////////////////
char SD_FILE[] = "/FILE1.TXT";
char SERVER_FILE[] = "/D20K.txt";
///////////////////////////////////////////////////////////////////////

int error;
uint32_t previous;


void setup()
{
  USB.ON();
  USB.println(F("Start program"));

  //////////////////////////////////////////////////
  // 1. sets operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();

}

void loop()
{

  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
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

    ////////////////////////////////////////////////
    // 2.1. FTP open session
    ////////////////////////////////////////////////

    error = _4G.ftpOpenSession(ftp_server, ftp_port, ftp_user, ftp_pass);

    if (error == 0)
    {
      USB.println(F("2.1. FTP open session OK"));

      previous = millis();


      //////////////////////////////////////////////
      // 2.2. FTP download
      //////////////////////////////////////////////
      error = _4G.ftpDownload(SD_FILE, SERVER_FILE);

      if (error == 0)
      {

        USB.print(F("2.2. Download SD file from FTP server done! "));
        USB.print(F("Download time: "));
        USB.print((millis() - previous) / 1000, DEC);
        USB.println(F(" s"));
      }
      else
      {
        USB.print(F("2.2. Error calling 'ftpDownload' function. Error: "));
        USB.println(error, DEC);
      }


      //////////////////////////////////////////////
      // 2.3. FTP close session
      //////////////////////////////////////////////

      error = _4G.ftpCloseSession();

      if (error == 0)
      {
        USB.println(F("2.3. FTP close session OK"));
      }
      else
      {
        USB.print(F("2.3. Error calling 'ftpCloseSession' function. error: "));
        USB.println(error, DEC);
      }
    }
    else
    {
      USB.print(F( "FTP connection error: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("4G module not started"));
  }

  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  _4G.OFF();


  ////////////////////////////////////////////////
  // 4. Sleep
  ////////////////////////////////////////////////
  USB.println(F("4. Enter deep sleep..."));
  PWR.deepSleep("00:00:00:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("5. Wake up!!\n\n"));

}

