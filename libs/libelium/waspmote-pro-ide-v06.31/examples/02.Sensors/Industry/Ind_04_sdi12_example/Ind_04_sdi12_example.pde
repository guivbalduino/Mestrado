/*
    ------ Waspmote Pro Code Example --------

    Explanation: Basic example that turns on, reads and turns off the
    modbus sensor. To read a modbus sensor over RS485 connect it to 
    the SOCKET E, to read a modbus sensor over RS232 connect it to the
    SOCKET F.

    Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L.
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
*/

#include <WaspIndustry.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - IND_SOCKET_A       _________
  - IND_SOCKET_B      |---------|
  - IND_SOCKET_C      | A  B  C |
  - IND_SOCKET_D      |_D__E__F_|


  Example: SDI12 sensor on socket A 
  [Sensor Class]    [Sensor Name] [Selected socket]
  IndustrySDI12     mySensor      (IND_SOCKET_A, address);
  
  Refer to the technical guide for information about possible combinations.
  
*/

// SDI12 most common command
char command_01[] = "%cM!"; // SDI-12 measurement
char command_02[] = "%cD0!";// SDI-12 data
char command_03[] = "Ab!";  // SDI-12 change address
char command_04[] = "?!";   // SDI-12 address query
char command_05[] = "?I!";  // SDI-12 info

// Instantiate IndustriesModbus object as slave ID address
IndustrySDI12 sensorSDI12(IND_SOCKET_A);

uint8_t error;
char command[30];
uint8_t response_length = 128;
uint32_t timeout = 500;
uint32_t waiting;
char waiting_str[] = "0000";

void setup()
{
  USB.println(F("SDI12 example for Smart Industries"));
  USB.println();
  
  sensorSDI12.ON();

  // Comment this line if the sensor has an external
  // power supply
  sensorSDI12.setPowerSocket(SWITCH_ON);

  // Delay to give time to the sensor to power up
  // This delay may vary between sensors
  delay(1000);
  
  // Check if the sensor is connected
  sensorSDI12.sendCommand(command_05, strlen(command_05));
  sensorSDI12.readCommandAnswer(response_length, timeout);

  USB.print(F("Sensor info: "));
  USB.println(sensorSDI12._rxBuffer);

  // Check if the sensor is connected
  sensorSDI12.sendCommand(command_04, strlen(command_04));
  sensorSDI12.readCommandAnswer(response_length, timeout);

  USB.print(F("Sensor address: "));
  USB.println(sensorSDI12._rxBuffer);

  // This address must be use in the following commands
  sensorSDI12.address = sensorSDI12._rxBuffer[0];

  // Create M! command with the address <address>M!
  sprintf(command, command_01, sensorSDI12.address);
  sensorSDI12.sendCommand(command, strlen(command));
  sensorSDI12.readCommandAnswer(5, LISTEN_TIME);
  
  USB.print(F("Time to wait until next measure: "));
  USB.println(sensorSDI12._rxBuffer);
  USB.println();
    
  // Parse time to wait
  for (uint8_t i=1; i<sizeof(waiting_str); i++)
  {
    waiting_str[i-1] = sensorSDI12._rxBuffer[i];
  }

  waiting = atoi(waiting_str)*1000;
  
  delay(waiting);
}


void loop()
{
  sprintf(command, command_02, sensorSDI12.address);
  // Check if the sensor is connected
  sensorSDI12.sendCommand(command, strlen(command));
  sensorSDI12.readCommandAnswer(response_length, timeout);

  USB.print(F("Data read from sensor: "));
  USB.println(sensorSDI12._rxBuffer);
  
  delay(10000);
}

