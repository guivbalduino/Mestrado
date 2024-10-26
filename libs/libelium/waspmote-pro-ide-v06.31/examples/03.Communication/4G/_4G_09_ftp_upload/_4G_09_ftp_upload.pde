/*
    --- 4G_09 - Uploading files to a FTP server  ---

    Explanation: This example shows how to upload a file to a FTP server
    from Waspmote

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
char SD_FILE[]     = "FILE1.TXT";
char SERVER_FILE[] = "FILE2.TXT";
///////////////////////////////////////////////////////////////////////

// define variables
int error;
uint32_t previous;
uint8_t sd_answer;

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


  //////////////////////////////////////////////////
  // 1. Create a new file to upload
  //////////////////////////////////////////////////

  ///////////////////////////////////
  // 1.1. Init SD card
  ///////////////////////////////////
  sd_answer = SD.ON();

  if (sd_answer == 1)
  {
    USB.println(F("1. SD init OK"));
  }
  else
  {
    USB.println(F("1. SD init ERROR"));
  }

  ///////////////////////////////////
  // 1.2. Delete file if exists
  ///////////////////////////////////
  sd_answer = SD.del(SD_FILE);

  if (sd_answer == 1)
  {
    USB.println(F("2. File deleted"));
  }
  else
  {
    USB.println(F("2. File NOT deleted"));
  }

  ///////////////////////////////////
  // 1.3. Create file
  ///////////////////////////////////
  sd_answer = SD.create(SD_FILE);

  if (sd_answer == 1)
  {
    USB.println(F("3. File created"));
  }
  else
  {
    USB.println(F("3. File NOT created"));
  }

  ///////////////////////////////////
  // 1.4. Append contents
  ///////////////////////////////////
  USB.println(F("4. Appending data..."));
  for (int i = 0; i < 90; i++)
  {
    sd_answer = SD.append( SD_FILE, "This is a new message\nThis is a new message\nThis is a new message\nThis is a new message\nThis is a new message\n");

    if (sd_answer != 1)
    {
      USB.println(F("SD append error"));
    }
    else
    {
      USB.println(F("SD append ok"));
    }
  }

  ///////////////////////////////////
  // 1.5. Close SD
  ///////////////////////////////////
  SD.OFF();
  USB.println(F("5. SD off"));
  USB.println(F("Setup done\n\n"));
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
    // 2.1. FTP open session
    ////////////////////////////////////////////////

    error = _4G.ftpOpenSession(ftp_server, ftp_port, ftp_user, ftp_pass);

    // check answer
    if (error == 0)
    {
      USB.println(F("2.1. FTP open session OK"));

      previous = millis();

      //////////////////////////////////////////////
      // 2.2. FTP upload
      //////////////////////////////////////////////

      error = _4G.ftpUpload(SERVER_FILE, SD_FILE);

      if (error == 0)
      {

        USB.print(F("2.2. Uploading SD file to FTP server done! "));
        USB.print(F("Upload time: "));
        USB.print((millis() - previous) / 1000, DEC);
        USB.println(F(" s"));
      }
      else
      {
        USB.print(F("2.2. Error calling 'ftpUpload' function. Error: "));
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
        USB.print(F("CMEE error: "));
        USB.println(_4G._errorCode, DEC);
      }
    }
    else
    {
      USB.print(F( "2.1. FTP connection error: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.println(F("1. 4G module not started"));
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


