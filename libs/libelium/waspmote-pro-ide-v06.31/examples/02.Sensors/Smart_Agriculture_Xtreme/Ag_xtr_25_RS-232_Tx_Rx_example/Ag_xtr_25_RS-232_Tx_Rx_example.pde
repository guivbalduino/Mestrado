/*
    ----------- [Ag_xtr_25] - RS-232 Tx&Rx example --------------------

    Explanation: This code simply sends dummy data through the TX pin
    on SOCKET_F and looks for received data on RX pin.

    Placing a jumper wire between TX and RX you can echo the data and test
    the serial communication without any peripheral.

    It is mandatory to turn on the Board to use the RS-232.

    Note: This example has not been tested with other sensors or the full
    Waspmote ecosystem. It is just a basic demosntration of RS-232 usage on
    the Smart Agriculture Xtreme board. If you have any questions, please
    contact the Libelium technical service.

    Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Version:           3.0
    Design:            David Gascón
    Implementation:    Pablo Moreno, Javier Siscart
*/

#include <WaspSensorXtr.h>

/*
  SELECT THE RIGHT SOCKET FOR EACH SENSOR.

  Possible sockets for this sensor are:
  - XTR_SOCKET_F       _________
                      |---------|
                      | A  B  C |
                      |_D__E__F_|

  Refer to the technical guide for information about possible combinations.
  www.libelium.com/downloads/documentation/smart_agriculture_xtreme_sensor_board.pdf
*/

// Aux variables.
char dummy[50] = "I am Waspmote Agriculture Xtreme";
char rxBuffer[60] = "";
uint8_t i = 0;

void setup()
{
  USB.println(F("RS-232 Tx&Rx example for Smart Agriculture Xtreme"));
  USB.println();

  // It is mandatory to turn ON the board
  SensorXtr.ON();

  // basic configuration
  configureAgrRS232();
}

void loop()
{

  // send data through RS 232 transceiver on socket F
  // just use the printString function.
  printString(dummy,  1);

  // print Sent data
  USB.print(F("A_TX:\t"));
  USB.println(dummy);
  USB.println();

  // receive answer
  receiveData();

  // Print Received data
  USB.print(F("A_RX:\t"));
  USB.println(rxBuffer);
  USB.print(F("Buffer size: "));
  USB.print(strlen(rxBuffer));
  USB.println();
  USB.println();

  delay(2000);
}

// Basic method to reive data and save into a buffer.
void receiveData() {

  Utils.setMuxAux1();

  i = 0;
  memset(rxBuffer, 0x00, sizeof(rxBuffer));
  while (serialAvailable(1) > 0){

    rxBuffer[i] = serialRead(1);
    i++;

    if (i > 50)
    {
      break;
    }
    delay(1);
  }
}

// Prepare Wasp mux to talk with RS-232 and open UART at 115200
void configureAgrRS232() {

  Utils.setMuxAux1();
  beginSerial(115200, 1);

  // parity none
  cbi(UCSR1C, UPM11);
  cbi(UCSR1C, UPM10);

  // 1 stop bit
  cbi(UCSR1C, USBS1);

  serialFlush(1);

  delay(100);
}
