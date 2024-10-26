/*  
 *  ------   [900HP_09] - scan network     -------- 
 *  
 *  Explanation: This program shows how to scan the XBee's network
 *  in order to find other XBee modules. This example prints all
 *  available data within the API structures
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
 *  Implementation:    Yuri Carmona
 */

#include <WaspXBee900HP.h>


void setup()
{ 
  // init USB port
  USB.ON();
  USB.println(F("Scan network example"));

  // init XBee 
  xbee900HP.ON();
}


void loop()
{ 
  ////////////////////////////////
  // 1. scan network
  ////////////////////////////////
  xbee900HP.scanNetwork(); 

  ////////////////////////////////
  // 2. print info
  ////////////////////////////////  
  USB.print(F("\n\ntotalScannedBrothers:"));
  USB.println(xbee900HP.totalScannedBrothers,DEC); 

  // print all scanned nodes information
  printScanInfo();

}  


/*
 *  printScanInfo
 *
 *  This function prints all info related to the scan 
 *  process given by the XBee module
 */
void printScanInfo()
{  
  USB.println(F("----------------------------"));

  for(int i=0; i<xbee900HP.totalScannedBrothers; i++)
  {  
    USB.print(F("MAC:"));
    USB.printHex(xbee900HP.scannedBrothers[i].SH[0]);	
    USB.printHex(xbee900HP.scannedBrothers[i].SH[1]);	
    USB.printHex(xbee900HP.scannedBrothers[i].SH[2]);	
    USB.printHex(xbee900HP.scannedBrothers[i].SH[3]);
    USB.printHex(xbee900HP.scannedBrothers[i].SL[0]);	
    USB.printHex(xbee900HP.scannedBrothers[i].SL[1]);	
    USB.printHex(xbee900HP.scannedBrothers[i].SL[2]);	
    USB.printHex(xbee900HP.scannedBrothers[i].SL[3]);

    USB.print(F("\nNode ID:"));
    for(int j=0; j<20; j++)
    {      
      USB.print(xbee900HP.scannedBrothers[i].NI[j]);		
    } 

    USB.print(F("\nDevice Type:"));
    switch(xbee900HP.scannedBrothers[i].DT)
    {
    case 0: 
      USB.print(F("End Device"));
      break;
    case 1: 
      USB.print(F("Router"));
      break;
    case 2: 
      USB.print(F("Coordinator"));
      break;
    }

    USB.print(F("\nParent Network Address:"));
    USB.printHex(xbee900HP.scannedBrothers[i].PMY[0]);	
    USB.printHex(xbee900HP.scannedBrothers[i].PMY[1]);

    USB.print(F("\nProfile ID:"));
    USB.printHex(xbee900HP.scannedBrothers[i].PID[0]);	
    USB.printHex(xbee900HP.scannedBrothers[i].PID[1]);

    USB.print(F("\nManufacturer ID:"));
    USB.printHex(xbee900HP.scannedBrothers[i].MID[0]);	
    USB.printHex(xbee900HP.scannedBrothers[i].MID[1]);
    
    USB.println(F("\n----------------------------"));
    
  }
}






