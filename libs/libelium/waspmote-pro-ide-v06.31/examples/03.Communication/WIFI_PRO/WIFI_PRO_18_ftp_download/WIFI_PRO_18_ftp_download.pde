/*  
 *  ------ WIFI Example -------- 
 *  
 *  Explanation: This example shows how to perform FTP download.
 *  The file transferred has previously been created in the server. 
 *  The file is downloaded into the Waspmote's SD card.
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
 *  Design:            David Gascon 
 *  Implementation:    Yuri Carmona
 */

// Put your libraries here (#include ...)
#include <WaspWIFI_PRO.h> 


// choose socket (SELECT USER'S SOCKET)
///////////////////////////////////////
uint8_t socket = SOCKET0;
///////////////////////////////////////


// choose FTP server settings
///////////////////////////////////////
char SERVER[]   = "pruebas.libelium.com";
char PORT[]     = "21";
char USER[]     = "w@libelium.com";
char PASSWORD[] = "ftp1234";
///////////////////////////////////////
//char SERVER[]   = "speedtest.tele2.net";
//char PORT[]     = "21";
//char USER[]     = "anonymous";
//char PASSWORD[] = "anonymous";
//char SERVER_FILE[] = "100KB.zip";
//char SD_FILE[] = "100KB.zip";
///////////////////////////////////////

/////////////////////////////////////////////////////////////////////// 
// Define filenames for SD card and FTP server:
//  - If the file is in the root directory: "FILE.TXT" or "/FILE.TXT" 
//  - If the file is inside a folder: "/FOLDER/FILE.TXT"
///////////////////////////////////////////////////////////////////////
char SD_FILE[]     = "/FILE1.TXT";
char SERVER_FILE[] = "/FILE2.TXT";
///////////////////////////////////////////////////////////////////////


// define variables
uint8_t error;
uint8_t status;
unsigned long previous;
uint16_t ftp_handle = 0;


void setup() 
{
  USB.println(F("Start program"));  
  USB.println(F("***************************************"));  
  USB.println(F("Once the module is set with one or more"));
  USB.println(F("AP settings, it attempts to join the AP"));
  USB.println(F("automatically once it is powered on"));    
  USB.println(F("Refer to example 'WIFI_PRO_01' to configure"));  
  USB.println(F("the WiFi module with proper settings"));
  USB.println(F("***************************************")); 
}



void loop()
{ 

  // get actual time
  previous = millis();  

  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////  
  error = WIFI_PRO.ON(socket);

  if (error == 0)
  {    
    USB.println(F("1. WiFi switched ON"));
  }
  else
  {
    USB.println(F("1. WiFi did not initialize correctly"));
  }


  //////////////////////////////////////////////////
  // 2. Check if connected
  //////////////////////////////////////////////////  

  // check connectivity
  status =  WIFI_PRO.isConnected();

  // Check if module is connected
  if (status == true)
  {    
    USB.print(F("2. WiFi is connected OK"));
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);
  }
  else
  {
    USB.print(F("2. WiFi is connected ERROR")); 
    USB.print(F(" Time(ms):"));    
    USB.println(millis()-previous);      
  }



  //////////////////////////////////////////////////
  // 3. FTP
  //////////////////////////////////////////////////  

  // Check if module is connected
  if (status == true)
  {
    ////////////////////////////////////////////////
    // 3.1. Open FTP session
    ////////////////////////////////////////////////
    error = WIFI_PRO.ftpOpenSession( SERVER, PORT, USER, PASSWORD );

    // check response
    if (error == 0)
    {      
      // get FTP handle
      ftp_handle = WIFI_PRO._ftp_handle;
      
      USB.println(F("3.1. Open FTP session OK"));   

      //////////////////////////////////////////////
      // 3.2. get File Size
      //////////////////////////////////////////////
      error = WIFI_PRO.ftpFileSize(ftp_handle, SERVER_FILE);

      // check response
      if (error == 0)
      {
        USB.print(F("3.2. File size: "));  
        USB.println(WIFI_PRO._filesize,DEC);  


        ////////////////////////////////////////////
        // 3.3. download file
        ////////////////////////////////////////////
        USB.print(F("3.3. Downloading file: "));
        error = WIFI_PRO.ftpDownload(ftp_handle, SERVER_FILE, SD_FILE);

        // check response
        if (error == 0)
        {
          USB.println(F("OK"));
          
          USB.println(F("Show file contents:"));
          SD.ON();
          SD.showFile(SD_FILE);
          SD.OFF();
        }
        else
        {
          USB.println(F("ERROR")); 
          WIFI_PRO.printErrorCode();
        }    
      }
      else
      {
        USB.println(F("3.2. fileSize error")); 
        WIFI_PRO.printErrorCode();   
      }


      ////////////////////////////////////////////////
      // 3.4. Close FTP session
      ////////////////////////////////////////////////
      error = WIFI_PRO.ftpCloseSession(ftp_handle);

      // check response
      if (error == 0)
      {
        USB.println(F("3.4. Close FTP session OK"));   
      }
      else
      {
        USB.println(F("3.4. Error calling 'closeSessionFTP' function"));
        WIFI_PRO.printErrorCode();      
      }
    }
    else
    {
      USB.println(F("3.1. Error calling 'ftpOpenSession' function"));
      WIFI_PRO.printErrorCode();      
    }

  }

  USB.print(F("Time from OFF state (ms):"));    
  USB.println(millis()-previous);   


  //////////////////////////////////////////////////
  // 4. Switch OFF
  //////////////////////////////////////////////////  
  WIFI_PRO.OFF(socket);
  USB.println(F("4. WiFi switched OFF"));
  USB.println(F("Wait........\n\n"));
  delay(10000);

}














