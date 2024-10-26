/*
    ------ [900HP_02] - send packets to a gateway --------

    Explanation: This program shows how to send packets to a gateway
    indicating the MAC address of the receiving XBee module

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
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

    Version:           3.0
    Design:            David Gascón
    Implementation:    Yuri Carmona
*/

#include <WaspXBee900HP.h>
#include <WaspFrame.h>
#include <WaspSensorXtr.h>


// Destination MAC address
//////////////////////////////////////////
char RX_ADDRESS[] = "0013A20041998C4F";
//////////////////////////////////////////

// Define the Waspmote ID
char node_id[] = "Ag_xtr_01";

// define variable
uint8_t error;

bme mySensor(XTR_SOCKET_A);

char temp[100];

unsigned long start;

void setup()
{
  // init USB port
  USB.ON();
  USB.println(F("Sending packets example"));

  // store Waspmote identifier in EEPROM memory
  frame.setID(node_id);

  // init XBee
  xbee900HP.ON();

  // init RTC
  RTC.ON();
  xbee900HP.setRTCfromMeshlium(RX_ADDRESS);
  USB.print(F("RTC Time:"));
  USB.println(RTC.getTime());

}


void loop()
{

  if (start + 60000 < millis()) {
    start = millis();
    ///////////////////////////////////////////
    // 1. Create ASCII frame
    ///////////////////////////////////////////

    mySensor.ON();

    int temperature = mySensor.getTemperature() * 100;
    int humidity = mySensor.getHumidity() * 10;
    int pressure = mySensor.getPressure();


    snprintf(temp, sizeof(temp), "Temp: %d Humi: %d Pres: %d", temperature, humidity, pressure);
    USB.println(temp);

    // Create new frame
    frame.setID(node_id);
    frame.createFrame(ASCII);

    frame.addSensor(SENSOR_STR, temp);
    frame.showFrame();


    ///////////////////////////////////////////
    // 2. Send packet
    ///////////////////////////////////////////

    // send XBee packet
    error = xbee900HP.send( RX_ADDRESS, frame.buffer, frame.length );

    // check TX flag
    if ( error == 0 )
    {
      USB.println(F("send ok"));

      // blink green LED
      Utils.blinkGreenLED();

    }
    else
    {
      USB.println(F("send error"));

      // blink red LED
      Utils.blinkRedLED();
    }


  }

}



