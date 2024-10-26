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

/////////////////////////////////////////////////////////////////////// 
// Define filenames for SD card and FTP server:
//  - If the file is in the root directory: "FILE.TXT" or "/FILE.TXT" 
//  - If the file is inside a folder: "/FOLDER/FILE.TXT"
///////////////////////////////////////////////////////////////////////
char SERVER_FILE[]   = "/FILE1.TXT";
char SD_FILE[]       = "/FILE2.TXT";
char SERVER_FOLDER[] = "/FOLDER";
///////////////////////////////////////////////////////////////////////


// define variables
uint8_t error;
uint8_t status;
unsigned long previous;
uint8_t sd_answer;
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
  for( int i=0; i<100; i++)
  {
    sd_answer = SD.append( SD_FILE, "This is a new message\n");

    if (sd_answer != 1)
    {
      USB.println(F("SD append error"));
    }
  }

  ///////////////////////////////////
  //1.5. Close SD
  ///////////////////////////////////
  SD.OFF();   
  USB.println(F("5. SD off"));
  USB.println(F("Setup done\n\n"));
  
  
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
      // 3.2. Make new directory in server
      //////////////////////////////////////////////
      error = WIFI_PRO.ftpMakeDir(ftp_handle, SERVER_FOLDER);

      // check response
      if (error == 0)
      {
        USB.print(F("3.2. Created new folder in server: "));
        USB.println(SERVER_FOLDER);
      }
      else
      {
        USB.println(F("3.2. Error calling 'ftpMakeDir' function")); 
        WIFI_PRO.printErrorCode();
      }


      //////////////////////////////////////////////
      // 3.3. Change Current Working Directory
      //////////////////////////////////////////////
      error = WIFI_PRO.ftpChangeCWD(ftp_handle, SERVER_FOLDER);

      // check response
      if (error == 0)
      {
        USB.print(F("3.3. Changed to new Current Working Directory:"));
        USB.println(SERVER_FOLDER);
      }
      else
      {
        USB.println(F("3.3. Error calling 'ftpChangeCWD' function")); 
        WIFI_PRO.printErrorCode();
      }
      

      ////////////////////////////////////////////
      // 3.4. Uploading file
      ////////////////////////////////////////////
      USB.print(F("3.4. Uploading file: "));
      error = WIFI_PRO.ftpUpload(ftp_handle, SERVER_FILE, SD_FILE);

      // check response
      if (error == 0)
      {
        USB.println(F("OK"));    
      }
      else
      {
        USB.println(F("ERROR")); 
        WIFI_PRO.printErrorCode();
      }    


      //////////////////////////////////////////////
      // 3.5. List Current Working Directory contents
      //////////////////////////////////////////////
      USB.println(F("3.5. List Current Working Directory contents:"));
      error = WIFI_PRO.ftpListing(ftp_handle);

      // check response
      if (error == 0)
      {
        SD.ON();
        SD.showFile(WIFI_PRO_LISTFILE);
        SD.OFF();
      }
      else
      {
        USB.println(F("Error calling 'ftpListing' function")); 
        WIFI_PRO.printErrorCode();
      }
      
      
      //////////////////////////////////////////////
      // 3.6. Change Current Working Directory
      //////////////////////////////////////////////
      error = WIFI_PRO.ftpChangeCWD(ftp_handle, "..");

      // check response
      if (error == 0)
      {
        USB.println(F("3.6. Moved to root directory"));
      }
      else
      {
        USB.println(F("3.6. Error calling 'ftpChangeCWD' function")); 
        WIFI_PRO.printErrorCode();
      }
      
      //////////////////////////////////////////////
      // 3.7. List Current Working Directory contents
      //////////////////////////////////////////////
      USB.println(F("3.7. List Current Working Directory contents:"));
      error = WIFI_PRO.ftpListing(ftp_handle);

      // check response
      if (error == 0)
      {
        SD.ON();
        SD.showFile(WIFI_PRO_LISTFILE);
        SD.OFF();
      }
      else
      {
        USB.println(F("Error calling 'ftpListing' function")); 
        WIFI_PRO.printErrorCode();
      }          


      ////////////////////////////////////////////////
      // 3.8. Close FTP session
      ////////////////////////////////////////////////
      error = WIFI_PRO.ftpCloseSession(ftp_handle);

      // check response
      if (error == 0)
      {
        USB.println(F("3.8. Close FTP session OK"));   
      }
      else
      {
        USB.println(F("3.8. Error calling 'closeSessionFTP' function"));
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
  USB.println(F("Wait...\n\n"));
  delay(10000);

}















