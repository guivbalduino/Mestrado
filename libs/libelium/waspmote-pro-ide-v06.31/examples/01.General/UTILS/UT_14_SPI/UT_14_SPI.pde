/*
 *  ------ [Ut_13] Waspmote Using SPI bus Example --------
 *
 *  Explanation: This example shows how to use some SPI functions and
 *  how to configure read and configure
 *  
 *  Tips: This example was developed with a LoRa module
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
 uint32_t value = 0;
 uint8_t byte1 = 0;
 uint8_t byte2 = 0;
 uint8_t byte3 = 0;
 uint8_t address = 0;
 
void setup()
{
  ////////////////////////////////////////////////////////////
  // 1. Set SPI configuration to communicate with the device
  ////////////////////////////////////////////////////////////
  SPI.begin();

  ////////////////////////////////////////////////////////
  // Power on the socket
  ////////////////////////////////////////////////////////
  // Connect device Vcc pin to the 3V3 SENSOR POWER pin
  // If the device requiers 5V power supply, the 5V SENSOR 
  // POWER pin may be enabled with:
  // PWR.setSensorPower(SENS_5V, SENS_ON);
  ////////////////////////////////////////////////////////
  PWR.setSensorPower(SENS_3V3,SENS_ON);

  // Set RESET pin and CS pin as outputs
  pinMode(DIGITAL1,OUTPUT);
  pinMode(DIGITAL2,OUTPUT);

  // Set both pins to high
  digitalWrite(DIGITAL1,HIGH);
  digitalWrite(DIGITAL2,HIGH);

  delay(10);

  //////////////////////////////////
  // 2. Write bytes into the device
  //////////////////////////////////
  USB.println(F("/////////////////////"));
  USB.println(F("/// Writing bytes ///"));
  USB.println(F("/////////////////////"));
  USB.println(F("Byte to write 1: 0x6B"));
  USB.println(F("Byte to write 2: 0xA0"));
  USB.println(F("Byte to write 3: 0x12"));
  
  // Set CS pin to low, enable device
  digitalWrite(DIGITAL1,LOW);
  delay(10);

  // Set register address to write into
  address = 0x06;
  // Bit 7 set to 1 to write in register
  bitSet(address, 7);
  // Start sending to address
  SPI.transfer(address);
  // Send data
  SPI.transfer(0x6B);

  // Enable device with the CS pin
  delay(10);
  digitalWrite(DIGITAL1,HIGH);
  delay(10);
  digitalWrite(DIGITAL1,LOW);

  // Set register address to write into
  address = 0x07;
  // Bit 7 set to 1 to write in register
  bitSet(address, 7);
  // Start sending to address
  SPI.transfer(address);
  // Send data
  SPI.transfer(0xA0);

  // Enable device with the CS pin
  delay(10);
  digitalWrite(DIGITAL1,HIGH);
  delay(10);
  digitalWrite(DIGITAL1,LOW);

  // Set register address to write into
  address = 0x08;
  // Bit 7 set to 1 to write in register
  bitSet(address, 7);
  // Start sending to address
  SPI.transfer(address);
  // Send data
  SPI.transfer(0x12);
  
  delay(100);

}


void loop()
{
  ////////////////////////////////////////
  // 3. Read stored bytes from the device
  ////////////////////////////////////////

  USB.println(F("///////////////////"));
  USB.println(F("// Bytes to read //"));
  USB.println(F("///////////////////"));

  // Enable device with the CS pin
  digitalWrite(DIGITAL1,HIGH);
  delay(10);
  digitalWrite(DIGITAL1,LOW);  
  delay(10);

  // Set register address to write into
  address = 0x06;
  // Bit 7 cleared to read in registers
  bitClear(address, 7); 
  // Start sending to address
  SPI.transfer(address);
  // Start reading
  byte1 = SPI.transfer(0x00);

  USB.print(F("Byte 1: "));
  USB.println(byte1,HEX);


  // Enable device with the CS pin
  digitalWrite(DIGITAL1,HIGH);
  delay(10);
  digitalWrite(DIGITAL1,LOW);
  delay(10);
  
  // Set register address to write into
  address = 0x07;
  // Bit 7 cleared to read in registers
  bitClear(address, 7); 
  // Start sending to address
  SPI.transfer(address);
  // Start reading
  byte2 = SPI.transfer(0x00);

  USB.print(F("Byte 2: "));
  USB.println(byte2,HEX);

  // Enable device with the CS pin
  digitalWrite(DIGITAL1,HIGH);
  delay(10);
  digitalWrite(DIGITAL1,LOW);
  delay(10);

  // Set register address to write into
  address = 0x08;
  // Bit 7 cleared to read in registers
  bitClear(address, 7); 
  // Start sending to address
  SPI.transfer(address);
  // Start reading
  byte3 = SPI.transfer(0x00);
 
  USB.print(F("Byte 3: "));
  USB.println(byte3,HEX);
  delay(10000);


  
}

