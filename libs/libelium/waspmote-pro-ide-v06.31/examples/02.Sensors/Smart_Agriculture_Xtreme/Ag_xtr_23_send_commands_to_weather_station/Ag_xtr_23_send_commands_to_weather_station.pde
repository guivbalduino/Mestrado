/*
    ----------- [Ag_xtr_23] - Send commands to weather station --------------------

    Explanation: Basic example that turns on and send commands to weather
    station. Please set DEBUG_XTR to 2 in order to print the answers
    by the serial monitor. This example permits to set Time and Date in Maximet 
    RTC very easily via USB port. There is an interface which asks the user
    to introduce the Date and Time as specified without any need to change 
    this code.

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
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

    Version:           3.2
    Design:            David Gascón
    Implementation:    J.Siscart, V.Boria
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_E           _________
                          |---------|
                          | A  B  C |
                          |_D__E__F_|


  Example: a 5TM sensor on socket A will be
  [Sensor Class] [Sensor Name] [Selected socket]
  Decagon_5TM    mySensor      (XTR_SOCKET_A);

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

int year;
int month;
int day;
int hour;
int minute;
int second;

// buffer to set the date and time
char buffer[100];
char input[100];

//   [Sensor Class] [Sensor Name]
weatherStation mySensor;

uint8_t response = 0;

void setup()
{
  USB.println(F("Weather station example for setting date and time"));
  USB.println(F("***********"));
  USB.println(F("Note: Please enable DEBUG_XTR to 2 in WaspSensorXtr.h to see the Maximet answers"));
  USB.println(F("***********"));
  
  //  Turn ON the sensor
  mySensor.ON();
     

  /////////////////////////////////
  //  YEAR
  /////////////////////////////////
  do
  {
    USB.print("Insert year [yy]:");    
  }
  while( getData(2) != true );
  
  year=atoi(input);
  USB.println(year);
  

  /////////////////////////////////
  //  MONTH
  /////////////////////////////////
  do
  {
    USB.print("Insert month [mm]:");    
  }
  while( getData(2) != true );
  
  month=atoi(input);
  USB.println(month);
  

  /////////////////////////////////
  //  DAY
  /////////////////////////////////
  do
  {
    USB.print("Insert day [dd]:");    
  }
  while( getData(2) != true );
  
  day=atoi(input);
  USB.println(day);
  

  /////////////////////////////////
  //  HOUR
  /////////////////////////////////
  do
  {
    USB.print("Insert Hour [HH]:");    
  }
  while( getData(2) != true );
  
  hour=atoi(input);
  USB.println(hour);

  /////////////////////////////////
  //  MINUTE
  /////////////////////////////////
  do
  {
    USB.print("Insert minute [MM]:");    
  }
  while( getData(2) != true );
  
  minute=atoi(input);
  USB.println(minute);

  /////////////////////////////////
  //  SECOND
  /////////////////////////////////
  do
  {
    USB.print("Insert second [SS]:");    
  }
  while( getData(2) != true );
  
  second=atoi(input);
  USB.println(second);
  
  
  /////////////////////////////////
  //  create buffer
  /////////////////////////////////
  sprintf(buffer, "TIME 20%02u-%02u-%02uT%02u:%02u:%02u",
                                                        year, 
                                                        month, 
                                                        day, 
                                                        hour, 
                                                        minute, 
                                                        second );
  USB.println(buffer);

  
  mySensor.enterCommand(buffer);
  delay(5000);



}

void loop()
{
  
  mySensor.enterCommand("TIME");
  delay(1000);
 
}




/*********************************
*
* get numBytes from USB port 
*
**********************************/
boolean getData(int numBytes)
{ 
  memset(input, 0x00, sizeof(input) );
  int i=0;
  USB.flush();
  int nRead=0;
  
  while(!USB.available());
  
  while(USB.available()>0)
  {
    input[i]=USB.read();
    
    if( (input[i]=='\r') && (input[i]=='\n') )
    {
      input[i]='\0';
    }
    else
    {
      i++;
    }
  }
  
  nRead=i;
  
  if(nRead != numBytes)
  {
    USB.print(F("must write "));
    USB.print(numBytes, DEC);
    USB.print(F(" characters. Read "));     
    USB.print(nRead, DEC);
    USB.println(F(" bytes")); 
    return false;
  }
  else
  {
    input[i]='\0';
    return true;
  }
  
}
