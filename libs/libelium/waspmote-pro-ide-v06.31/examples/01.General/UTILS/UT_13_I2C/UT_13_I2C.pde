/*
 *  ------ [Ut_13] Waspmote Using I2C bus Example --------
 *
 *  Explanation: This example shows how to use some I2C functions and
 *  how to communicate with a BME280 sensor
 *  
 *  Tips: Use a BME280 sensor to test this example
 *        Open the Waspmote technical guide, page 59, section I/O
 *        to see how digital pins and bus pins are located
 *
 *  Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L. 
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
 *  Implementation:    Luis Miguel Martí
 */
  
 // Variable to store function returns
 uint8_t data_read;

 
void setup()
{
  //////////////////////////
  // 1. Start the I2C bus
  //////////////////////////
  I2C.begin();

  ////////////////////////////////////////////////////////
  // Power on the socket
  ////////////////////////////////////////////////////////
  // Connect device Vcc pin to the 3V3 SENSOR POWER pin
  // If the device requiers 5V power supply, the 5V SENSOR 
  // POWER pin may be enabled with:
  // PWR.setSensorPower(SENS_5V, SENS_ON);
  ////////////////////////////////////////////////////////
  PWR.setSensorPower(SENS_3V3,SENS_ON);
}

void loop()
{
  ///////////////////////////////////////////////////////////
  // 2. Read data from slave device connected to the I2C bus
  ///////////////////////////////////////////////////////////
  // 0x77 -> slave device address
  // 0xD0 -> register address to read data from
  // data_read -> variable to store data read
  // 1 -> size of data read
  
  I2C.read(0x77, (uint8_t)0xD0, &data_read, 1);

  USB.print(F("Data read from I2C device:"));
  USB.println(data_read,HEX); 

  delay(1000);

  /////////////////////////////////////////////////////////////
  // 3. Write data in the address register of the slave device
  /////////////////////////////////////////////////////////////
  // 0x77 -> slave device address
  // 0xD1 -> register address where data is written
  // 0x01 -> data stored into the register address of the device
  I2C.write(0x77, 0xD1, 0x01);

  delay(10000);
}

