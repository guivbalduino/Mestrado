/*
    ------ Ind 05: Modbus Example --------

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
  - XTR_SOCKET_E       _________
  - XTR_SOCKET_F      |---------|
                      | A  B  C |
                      |_D__E__F_|


  Example: Modbus sensor on socket E over RS485 will be
  [Sensor Class]    [Sensor Name] [Selected socket]
  IndustriesModbus  mySensor      (XTR_SOCKET_E, address);
  
  Example: Modbus sensor on socket E over RS232 will be
  [Sensor Class]    [Sensor Name] [Selected socket]
  IndustriesModbus  mySensor      (XTR_SOCKET_F, address);
  
  Refer to the technical guide for information about possible combinations.
  
*/

// Define one address for reading
#define address 40
// Define the number of bytes to read
#define bytesQty 4
// Instantiate IndustriesModbus object as slave ID address
IndustryModbus modbusSensor(IND_SOCKET_E, address);

uint8_t error;

void setup()
{
  USB.println(F("Modbus example for Smart Industries"));
  USB.println();

  // Modbus baudrate is set by default to 9600
  // If you are willing to use a sensor with a
  // different baudrate you need to use the 
  // function setBaudrate(uint32_t baudrate)
  modbusSensor.setBaudrate(9600);
  
  // Initialize Modbus communication baud rate
  modbusSensor.ON();
  
  // If the sensor is not power supplied externally
  // with this function sensor can be powered from 
  // the P&S!
  modbusSensor.setPowerSocket(IND_SOCKET_E,SWITCH_ON);
  
  modbusSensor.initCommunication();

  delay(1000);
}


void loop()
{
  modbusSensor.setTransmitBuffer(0, 0x000F);
  modbusSensor.writeMultipleRegisters(0x01,1);
  
  delay(1000);
  
  error = modbusSensor.read(0x53, 0x08);


  if (error == 0)
  {
    USB.print("Received from sensor: ");
    USB.print(modbusSensor.response[0],HEX);
    USB.print(modbusSensor.response[1],HEX);
    USB.print(modbusSensor.response[2],HEX);
    USB.println(modbusSensor.response[3],HEX);
  }
  else
  {
    USB.println(F("Error"));
  }

  delay(5000);
}
