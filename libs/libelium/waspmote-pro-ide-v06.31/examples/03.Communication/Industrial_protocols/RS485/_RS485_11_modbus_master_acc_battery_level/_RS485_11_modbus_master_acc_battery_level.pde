/*
    ------ [RS-485_11] Modbus Master ACC and Battery level --------

    This sketch shows the use of the Modbus communication protocol over
    RS-485 standard, and the use of the main functions of the library.
  . Modbus allows for communication between many devices connected
    to the same network. There are many variants of Modbus protocols,
    but Waspmote implements the RTU format. Modbus RTU is the most
    common implementation available for Modbus.

    This example shows how to configure the Waspmote as a Modbus
    master  device. The Waspmote read the ACC values and the battery
    level from a Modbus slave.

    Note: See the example RS-485_10_modbus_slave_acc_battery_level

    Copyright (C) 2017 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.

    Version:          3.2
    Implementation:   Ahmad Saad
*/


// Include these libraries for using the RS-485 and Modbus functions
#include <ModbusMaster.h>

// Modbus slave ID and baudrate
//////////////////////////////////////////
const uint8_t slave_id = 1;
const uint32_t baud = 9600;
//////////////////////////////////////////

// Instantiate ModbusMaster object as slave ID 1
ModbusMaster slave(RS485_COM, slave_id);

// Define address for each register
#define accX 0
#define accY 1
#define accZ 2
#define batteryLevel 3

// Define the number of registers to read
#define numRegs  4

// Define variables for reading sensors
int x_acc;
int y_acc;
int z_acc;
int battery;

uint8_t answer;

void setup()
{
  // Power on the USB
  USB.ON();
  USB.println("Modbus master example over RS-485");

  // Initialize Modbus communication over RS-485
  answer = slave.begin(9600);

  if (answer == 0)
  {
    USB.println(F("RS-485 module started successfully"));
  }
  else
  {
    USB.println(F("RS-485 did not initialize correctly"));
  }
}


void loop()
{
  // This function returns the result of the communication
  // Result = 0 : no errors
  // Result = 1 : error occurred
  // Read 4 bytes
  int result =  slave.readHoldingRegisters(accX, numRegs);

  if (result != 0)
  {
    // If no response from the slave, print an error message
    USB.println("Communication error. Couldn't read from slave");
    delay(100);
  }
  else
  {
    // get the answer from the library variables
    x_acc = slave.getResponseBuffer(accX);
    y_acc = slave.getResponseBuffer(accY);
    z_acc = slave.getResponseBuffer(accZ);
    battery = slave.getResponseBuffer(batteryLevel);

    USB.println("\nACC_X\tACC_Y\tACC_Z\tBattery %");
    USB.print(x_acc, DEC);
    USB.print(F("\t"));
    USB.print(y_acc, DEC);
    USB.print(F("\t"));
    USB.print(z_acc, DEC);
    USB.print(F("\t"));
    USB.println(battery, DEC);
  }

  USB.print("\n");
  delay(1000);

  // Clear the response buffer
  slave.clearResponseBuffer();

}

