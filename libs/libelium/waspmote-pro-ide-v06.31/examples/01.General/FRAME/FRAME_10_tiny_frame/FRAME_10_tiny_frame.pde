/*
 *  ------ FRAME_10_tiny_frame - WaspFrame Generate Tiny Frame --------
 *
 *  Explanation: This type of frame has been designed to create short
 *  frames with data. The purpose of implementing tiny frames is to be
 *  able to create sensor data frames which can be send via short-payload
 *  protocols, like Sigfox or LoRaWAN.
 *
 *  Meshlium does not support this frame format.
 *
 *  Copyright (C) 2020 Libelium Comunicaciones Distribuidas S.L.
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
 *  Implementation:    Isabel Burillo
 */

#include <WaspFrame.h>


void setup()
{
  // Init USB port
  USB.ON();
  USB.println(F("Start program"));

  // init ACC
  ACC.ON();

}

void loop()
{
  // Create new frame
  frame.createFrame(BINARY);

  // set frame fields (multiple)
  frame.addSensor(SENSOR_ACC, ACC.getX(), ACC.getY(), ACC.getZ());

  // set frame fields
  frame.addSensor(SENSOR_BAT, PWR.getBatteryLevel());

  // Print frame
  frame.showFrame();

  // Generate Tiny Frame
  frame.generateTinyFrame();

  USB.print(F("- Tiny frame generated:"));
  USB.printHexln(frame.bufferTiny, frame.lengthTiny);

  delay(5000);
}
