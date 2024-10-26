/*
    ------ [RS-485_10] Modbus Slave ACC and Battery level --------

    This sketch shows the use of the Modbus communication protocol over
    RS-485 standard, and the use of the main functions of the library.
  . Modbus allows for communication between many devices connected
    to the same network. There are many variants of Modbus protocols,
    but Waspmote implements the RTU format. Modbus RTU is the most
    common implementation available for Modbus.

    This example shows how to configure the Waspmote as a Modbus
    slave  device. The Waspmote stores the ACC values and the battery
    level in  the Modbus register, and sends these values to the
    Master when  a request is received.

    Note: See the example RS-485_11_modbus_master_acc_battery_level

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

    Version:          3.1
    Implementation:   Ahmad Saad
*/

// Include these libraries for using the RS-485 and Modbus functions
#include <ModbusSlave.h>

// Modbus slave ID and baudrate
//////////////////////////////////////////
const uint8_t slave_id = 1;
const uint32_t baud = 9600;
//////////////////////////////////////////

// Create new mbs instance
ModbusSlave mbs(RS485_COM);


// Slave registers
enum {
  MB_0 = 0,   // Register 0
  MB_1 = 1,   // Register 1
  MB_2 = 2,   // Register 2
  MB_3 = 3,   // Register 3
};

// number of registers
#define MB_REGS 4

// define array
int regs[MB_REGS];

uint8_t answer;


void setup()
{
  // Power on the USB
  USB.ON();
  USB.println(F("Modbus Slave example over RS-485"));
  USB.println(F("-----------------------------------------------"));
  USB.println(F("Waspmote simulates a sensor device"));
  USB.println(F("which returns acceleration and battery"));
  USB.println(F("level via Modbus over RS-485"));
  USB.println(F("-----------------------------------------------"));

  // Power on the ACC
  ACC.ON();

  // Configure msb
  answer = mbs.configure(slave_id, baud);

  if (answer == 0)
  {
    USB.println(F("RS-485 module started successfully"));
    USB.println(F("\n\n-----------------------------------------------"));
    USB.println(F("Waspmote will continuously update the "));
    USB.println(F("library structures so a master device can read them"));
    USB.println(F("Please refer to the example RS485_11"));
    USB.println(F("-----------------------------------------------"));
  }
  else
  {
    USB.println(F("RS-485 did not initialize correctly"));
  }
}

void loop()
{
  // Read and store the values in the Modbus registers
  regs[MB_0] = ACC.getX();  // X Value
  regs[MB_1] = ACC.getY();  // Y Value
  regs[MB_2] = ACC.getZ();  // Z Value
  regs[MB_3] = PWR.getBatteryLevel(); // Battery level

  // Update current register values to mbs
  mbs.update(regs, MB_REGS);

}
