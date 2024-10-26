/*
 *  ------------  [GP_v30_04] - Particle Matter Sensor  --------------
 *
 *  Explanation: This is a complete code to manage and read the particle
 *  sensor.
 *
 *  Copyright (C) 2019 Libelium Comunicaciones Distribuidas S.L.
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
 *  Version:           3.1
 *  Design:            David Gascón
 *  Implementation:    Isabel Burillo
 */

#include <WaspPM.h>
#include <WaspFrame.h>

/*
 * P&S! Possibilities for this sensor:
 * 	- SOCKET_D
 */

 char info_string[61];
 char serial_number[61];
 int status;
 int measure;

 void setup()
 {
   USB.println(F("Particle Matter Sensor example"));

   // switch on sensor
   status = PM.ON();

   // check answer
   if (status == 1)
   {
     // get info from sensor
     status = PM.getInfoString(info_string);

     if (status == 1)
     {
       USB.println(F("Information string extracted:"));
       USB.println(info_string);
     }
     else
     {
       USB.println(F("Error reading the particle sensor"));
     }

     // read serial number from sensor. That funtion isn't avalable for OPC-N2 sensor
     status = PM.readSerialNumber(serial_number);
     if (status == 1)
     {
       USB.print(F("Serial number: "));
       USB.println(serial_number);

     }
     else
     {
       USB.println(F("Error reading the serial number"));
     }

     // switch off sensor
     PM.OFF();
   }
   else
   {
     USB.println(F("Error starting the particle sensor"));
   }
 }


 void loop()
 {
   ///////////////////////////////////////////
   // 1. Turn on the sensor
   ///////////////////////////////////////////

   // Power on the PM sensor
   status = PM.ON();

   // check answer
   if (status == 1)
   {
     USB.println(F("Particle sensor started"));

   }
   else
   {
     USB.println(F("Error starting the particle sensor"));
   }


   ///////////////////////////////////////////
   // 2. Read sensor
   ///////////////////////////////////////////
   if (status == 1)
   {
     // Power the fan and the laser and perform a measure of 5 seconds
     measure = PM.getPM(5000, 5000);

     // check answer
     if (measure == 1)
     {
       USB.println(F("Measure performed"));
       USB.print(F("PM 1: "));
       USB.printFloat(PM._PM1, 3);
       USB.println(F(" ug/m3"));
       USB.print(F("PM 2.5: "));
       USB.printFloat(PM._PM2_5, 3);
       USB.println(F(" ug/m3"));
       USB.print(F("PM 10: "));
       USB.printFloat(PM._PM10, 3);
       USB.println(F(" ug/m3"));
       USB.print(F("Temp: "));
       USB.print(PM._temp);
       USB.println(F(" ºC"));
       USB.print(F("Hum: "));
       USB.print(PM._hum);
       USB.println(F(" %RH"));
       USB.print("Bin: ");
       for (int i = 0; i < 24; i++)
       {
         USB.print(PM._bin[i]);
         USB.print(";");
       }
       USB.println();
     }
     else
     {
       USB.print(F("Error performing the measure. Error code:"));
       USB.println(measure, DEC);
     }
   }


   ///////////////////////////////////////////
   // 3. Turn off the sensor
   ///////////////////////////////////////////

   // Power off the PM sensor. If there aren't other sensors powered,
   // turn off the board automatically
   PM.OFF();

   ///////////////////////////////////////////
   // 4. Create ASCII frame
   ///////////////////////////////////////////

   if (measure == 1) {

     // Create new frame (ASCII)
     frame.createFrame(ASCII);
     // Add sensor values
     frame.addSensor(SENSOR_GASES_PRO_PM1, PM._PM1);
     frame.addSensor(SENSOR_GASES_PRO_PM2_5, PM._PM2_5);
     frame.addSensor(SENSOR_GASES_PRO_PM10, PM._PM10);
     frame.addSensor(SENSOR_GASES_PRO_TC, PM._temp);
     frame.addSensor(SENSOR_GASES_PRO_HUM, PM._hum);
      // Show the frame
     frame.showFrame();

      // Create new frame (ASCII)
     frame.createFrame(ASCII);
     // Add first 16 bins
     frame.addSensor(SENSOR_GASES_PRO_PM_BINL, PM._binL);
     // Add last 8 bins
     frame.addSensor(SENSOR_GASES_PRO_PM_BINH, PM._binH);
     // Show the frame
     frame.showFrame();

   }

   ///////////////////////////////////////////
   // 5. Sleep
   ///////////////////////////////////////////

   // Go to deepsleep
   // After 3 minutes, Waspmote wakes up thanks to the RTC Alarm
   PWR.deepSleep("00:00:03:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

 }
