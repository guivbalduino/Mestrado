/*
 *  ------------  [GP_v30_08] - Frame Class Utility  --------------
 *
 *  Explanation: This is the basic code to create a frame with some
 * 	Gases Pro Sensor Board sensors
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
 *  Version:		    3.2
 *  Design:             David Gascón
 *  Implementation:     Alejandro Gállego
 */

#include <WaspSensorGas_Pro.h>
#include <WaspFrame.h>
#include <WaspPM.h>


Gas O3(SOCKET_A);
Gas NO(SOCKET_B);
Gas NO2(SOCKET_C);
Gas CO(SOCKET_F);

float temperature;
float humidity;
float pressure;

float concO3;
float concNO;
float concNO2;
float concCO;

int OPC_status;
int OPC_measure;

char node_ID[] = "Node_01";


void setup()
{
	USB.ON();
	USB.println(F("Frame Utility Example for Gases Pro Sensor Board"));

	// Set the Waspmote ID
	frame.setID(node_ID);

}

void loop()
{
	///////////////////////////////////////////
	// 1. Turn on sensors and wait
	///////////////////////////////////////////

	//Power on gas sensors
	O3.ON();
	NO.ON();
	NO2.ON();
	CO.ON();

	// Sensors need time to warm up and get a response from gas
	// To reduce the battery consumption, use deepSleep instead delay
	// After 2 minutes, Waspmote wakes up thanks to the RTC Alarm
	PWR.deepSleep("00:00:02:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_ON);


	///////////////////////////////////////////
	// 2. Read sensors
	///////////////////////////////////////////

	// Read the sensors and compensate with the temperature internally
	concO3 = O3.getConc();
	concNO = NO.getConc();
	concNO2 = NO2.getConc();
	concCO = CO.getConc();

	// Read enviromental variables
	temperature = NO.getTemp();
	humidity = NO.getHumidity();
	pressure = NO.getPressure();

	///////////////////////////////////////////
	// 3. Turn off the sensors
	///////////////////////////////////////////

	//Power off sensors
	O3.OFF();
	NO.OFF();
	NO2.OFF();
	CO.OFF();

	///////////////////////////////////////////
	// 4. Read particle matter sensor
	///////////////////////////////////////////

	// Turn on the particle matter sensor
	OPC_status = PM.ON();
	if (OPC_status == 1)
	{
		USB.println(F("Particle sensor started"));
	}
	else
	{
		USB.println(F("Error starting the particle sensor"));
	}

	// Get measurement from the particle matter sensor
	if (OPC_status == 1)
	{
		// Power the fan and the laser and perform a measure of 5 seconds
		OPC_measure = PM.getPM(5000, 5000);
	}

	PM.OFF();


	///////////////////////////////////////////
	// 5. Create ASCII frame
	///////////////////////////////////////////

	// Create new frame (ASCII)
	frame.createFrame(ASCII);

	// Add temperature
	frame.addSensor(SENSOR_GASES_PRO_TC, temperature);
	// Add humidity
	frame.addSensor(SENSOR_GASES_PRO_HUM, humidity);
	// Add pressure value
	frame.addSensor(SENSOR_GASES_PRO_PRES, pressure);
	// Add O3 value
	frame.addSensor(SENSOR_GASES_PRO_O3, concO3);
	// Add NO value
	frame.addSensor(SENSOR_GASES_PRO_NO, concNO);
	// Add NO2 value
	frame.addSensor(SENSOR_GASES_PRO_NO2, concNO2);
	// Add CO value
	frame.addSensor(SENSOR_GASES_PRO_CO, concCO);
	// Add PM1
	frame.addSensor(SENSOR_GASES_PRO_PM1, PM._PM1);
	// Add PM2.5
	frame.addSensor(SENSOR_GASES_PRO_PM2_5, PM._PM2_5);
	// Add PM10
	frame.addSensor(SENSOR_GASES_PRO_PM10, PM._PM10);

	// Show the frame
	frame.showFrame();


	///////////////////////////////////////////
	// 4. Sleep
	///////////////////////////////////////////

	// Go to deepsleep
	// After 30 seconds, Waspmote wakes up thanks to the RTC Alarm
	PWR.deepSleep("00:00:00:30", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

}
