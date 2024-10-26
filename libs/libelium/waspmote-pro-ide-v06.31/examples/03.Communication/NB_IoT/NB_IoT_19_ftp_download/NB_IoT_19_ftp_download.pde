/*
    --- NB_IoT_19 - FTP DOWNLOAD - Downloading files to a FTP server  ---

    Explanation: This example shows how to upload a file to a FTP server
    from Waspmote

    Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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
    Implementation:    P.Moreno, J.Siscart
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
char ftp_server[] = "pruebas.libelium.com";
uint16_t ftp_port = 21;
char ftp_user[] = "t3g@libelium.com";
char ftp_pass[] = "ftp1234";
///////////////////////////////////////

///////////////////////////////////////////////////////////////////////
// Define filenames for SD card:
//  - If the file is in the root directory: "FILE.TXT" or "/FILE.TXT"
//  - If the file is inside a folder: "/FOLDER/FILE.TXT"
///////////////////////////////////////////////////////////////////////
char SD_FILE[]     = "FISD1.TXT";
///////////////////////////////////////////////////////////////////////
// Define filenames for FTP server:
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
  BG96.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // 2. Show APN settings via USB port
  //////////////////////////////////////////////////
  BG96.show_APN(); 
}


void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = BG96.ON();

  if (error == 0)
  {
    USB.println(F("1. NB-IoT module ready..."));

    ////////////////////////////////////////////////
    // 2.1. Check connection to network and continue
    ////////////////////////////////////////////////
    error = BG96.nbiotConnection(apn, band, network_operator, operator_type);
    if (error == 0)
    {
      USB.println(F("2.1. NB-IoT connection: OK "));

      ////////////////////////////////////////////////
      // 2.2.1 NB-IoT Context Activation
      ////////////////////////////////////////////////
      error = BG96.contextActivation(1,5);
      if (error == 0)
      {
        USB.println(F("2.2.1. NB-IoT context connection: OK "));
        USB.print(F("IP: ")); USB.println(BG96._ip);

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

        ////////////////////////////////////////////////
        // 4.1. FTP open session
        ////////////////////////////////////////////////
    
        error = BG96.ftpOpenSession(ftp_server, ftp_port, ftp_user, ftp_pass);
    
        // check answer
        if (error == 0)
        {
          USB.println(F("4.1. FTP open session OK"));
    
          previous = millis();

    
          //////////////////////////////////////////////
          // 4.2. FTP download
          //////////////////////////////////////////////
          
          error = BG96.ftpDownload(SD_FILE, SERVER_FILE);

          if (error == 0)
          {
    
            USB.print(F("4.2. Download SD file from FTP server done! "));
            USB.print(F("Download time: "));
            USB.print((millis() - previous) / 1000, DEC);
            USB.println(F(" s"));
          }
          else
          {
            USB.print(F("4.2. Error calling 'ftpDownload' function. Error: "));
            USB.println(error, DEC);
          }
          
    
          //////////////////////////////////////////////
          // 4.3. FTP close session
          //////////////////////////////////////////////
    
          error = BG96.ftpCloseSession();
    
          if (error == 0)
          {
            USB.println(F("4.3. FTP close session OK"));
          }
          else
          {
            USB.print(F("4.3. Error calling 'ftpCloseSession' function. error: "));
            USB.println(error, DEC);            
          }
        }
        else
        {
          USB.print(F( "4.1. FTP connection error: "));
          USB.println(error, DEC);          
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
  }
  


  ////////////////////////////////////////////////
  // 5. Powers off the NB-IoT module
  ////////////////////////////////////////////////
  USB.println(F("5. Switch OFF NB-IoT module"));

  error = BG96.OFF();
   if (error == 0)
    {
      USB.println(F("5. Module is power off"));      
    }
    else
    {
      USB.println(F("5. Power off ERROR"));
    }


  ////////////////////////////////////////////////
  // 6. Sleep
  ////////////////////////////////////////////////
  USB.println(F("6. Enter deep sleep..."));
  PWR.deepSleep("00:00:10:10", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("7. Wake up!!\n\n"));

}


