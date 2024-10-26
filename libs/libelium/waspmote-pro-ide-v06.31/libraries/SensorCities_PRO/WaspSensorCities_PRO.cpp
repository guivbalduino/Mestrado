/*
 *  Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
 *  http://www.libelium.com
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 2.1 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.

 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Version:		3.8
 *  Design:			David Gascón
 *  Implementation: Alejandro Gállego, Ahmad Saad
 */


#ifndef __WPROGRAM_H__
  #include <WaspClasses.h>
#endif

#include "WaspSensorCities_PRO.h"

// Constructors ///////////////////////////////////////////////////////////

/*!
 * @brief It initializes the different digital pins
 * @param void
 * @return void
 */
WaspSensorCitiesPRO::WaspSensorCitiesPRO()
{
	// I2C main pin
	pinMode(SCP_I2C_MAIN_EN, OUTPUT);
	digitalWrite(SCP_I2C_MAIN_EN, LOW);

	// switch off socket 3v3/i2c isolators
	pinMode(SCP_PWR_3V3_SOCKET_1_C, OUTPUT);
	pinMode(SCP_PWR_3V3_SOCKET_2_E, OUTPUT);
	pinMode(SCP_PWR_3V3_SOCKET_3_F, OUTPUT);
	pinMode(SCP_PWR_3V3_SOCKET_4_A, OUTPUT);
	pinMode(SCP_PWR_3V3_SOCKET_5_B, OUTPUT);
	digitalWrite(SCP_PWR_3V3_SOCKET_1_C, LOW);
	digitalWrite(SCP_PWR_3V3_SOCKET_2_E, LOW);
	digitalWrite(SCP_PWR_3V3_SOCKET_3_F, LOW);
	digitalWrite(SCP_PWR_3V3_SOCKET_4_A, LOW);
	digitalWrite(SCP_PWR_3V3_SOCKET_5_B, LOW);

	// disable probe i2c lines
	pinMode(SCP_I2C_SOCKET_1_C, OUTPUT);
	pinMode(SCP_I2C_SOCKET_3_F, OUTPUT);
	pinMode(SCP_I2C_SOCKET_5_B, OUTPUT);
	digitalWrite(SCP_I2C_SOCKET_1_C, LOW);
	digitalWrite(SCP_I2C_SOCKET_3_F, LOW);
	digitalWrite(SCP_I2C_SOCKET_5_B, LOW);

	// switch off all probe power lines
	pinMode(SCP_PWR_SOCKET_1_C, OUTPUT);
	pinMode(SCP_PWR_SOCKET_3_F, OUTPUT);
	pinMode(SCP_PWR_SOCKET_5_B, OUTPUT);
	digitalWrite(SCP_PWR_SOCKET_1_C, HIGH);
	digitalWrite(SCP_PWR_SOCKET_3_F, HIGH);
	digitalWrite(SCP_PWR_SOCKET_5_B, HIGH);

	// update Waspmote Control Register
	WaspRegisterSensor |= REG_CITIES_PRO;
	pwrCitiesPRORegister = 0;
	pwrGasPRORegister = 0;
}

// Private Methods ////////////////////////////////////////////////////////


// Public Methods //////////////////////////////////////////////////////////////


/*!
 * @brief Turns ON the sensor/socket
 * @param uint8_t socket_sensor:
 * 		@arg SOCKET_1
 * 		@arg SOCKET_2
 * 		@arg SOCKET_3
 * 		@arg SOCKET_4
 * 		@arg SOCKET_5
 * 		@arg SOCKET_A
 * 		@arg SOCKET_B
 * 		@arg SOCKET_C
 * 		@arg SOCKET_E
 * 		@arg SOCKET_F
 * @return void
 */
void WaspSensorCitiesPRO::ON(uint8_t socket_sensor)
{
	// Power on 3V3 and/or 5V if necessary
	if ((WaspRegister & REG_3V3) == 0)
	{
		#if DEBUG_CITIES_PRO>0
			PRINTLN_CITIES_PRO(F("3V3 to ON"));
		#endif
		PWR.setSensorPower(SENS_3V3, SENS_ON);
		digitalWrite(SCP_I2C_MAIN_EN, HIGH);	// I2C main pin
	}

	switch(socket_sensor)
	{
		case SOCKET_1:
		case SOCKET_C:
			pwrCitiesPRORegister |= (1 << 0x01);
			digitalWrite(SCP_PWR_3V3_SOCKET_1_C, HIGH);
			break;

		case SOCKET_2:
		case SOCKET_E:
			pwrCitiesPRORegister |= (1 << 0x02);
			digitalWrite(SCP_PWR_3V3_SOCKET_2_E, HIGH);
			break;

		case SOCKET_3:
		case SOCKET_F:
			pwrCitiesPRORegister |= (1 << 0x03);
			digitalWrite(SCP_PWR_3V3_SOCKET_3_F, HIGH);
			break;

		case SOCKET_4:
		case SOCKET_A:
			pwrCitiesPRORegister |= (1 << 0x04);
			digitalWrite(SCP_PWR_3V3_SOCKET_4_A, HIGH);
			break;

		case SOCKET_5:
		case SOCKET_B:
			pwrCitiesPRORegister |= (1 << 0x05);
			digitalWrite(SCP_PWR_3V3_SOCKET_5_B, HIGH);
			break;
		
		case SOCKET_6:
		case SOCKET_D:
			#if DEBUG_CITIES_PRO>0
				PRINTLN_CITIES_PRO(F("5V to ON"));
			#endif
			PWR.setSensorPower(SENS_5V, SENS_ON);
			pinMode(NOISE_SENSOR_POWER_D,OUTPUT);
			digitalWrite(NOISE_SENSOR_POWER_D,HIGH);
			break;
		

		default:
			break;
	}

	#if DEBUG_CITIES_PRO>1
		PRINT_CITIES_PRO(F("pwrCitiesPRORegister="));
		USB.println(pwrCitiesPRORegister, BIN);
		PRINT_CITIES_PRO(F("pwrGasPRORegister="));
		USB.println(pwrGasPRORegister, BIN);
	#endif

}

/*!
 * @brief Turns OFF the sensor/socket
 * @param uint8_t socket_sensor:
 * 		@arg SOCKET_1
 * 		@arg SOCKET_2
 * 		@arg SOCKET_3
 * 		@arg SOCKET_4
 * 		@arg SOCKET_5
 * 		@arg SOCKET_A
 * 		@arg SOCKET_B
 * 		@arg SOCKET_C
 * 		@arg SOCKET_E
 * 		@arg SOCKET_F
 * @return void
 */
void WaspSensorCitiesPRO::OFF(uint8_t socket_sensor)
{
	uint8_t mask;

	// Check I2C isolator
	if ((pwrCitiesPRORegister == 0) && ((pwrGasPRORegister & 0xFE) == 0))
	{
		// Disable I2C isolator
		digitalWrite(SCP_I2C_MAIN_EN, LOW);
	}

	switch(socket_sensor)
	{

		case SOCKET_1:
		case SOCKET_C:
			digitalWrite(SCP_PWR_3V3_SOCKET_1_C, LOW);

			// Set the flags
			pwrCitiesPRORegister &= ~(1 << 0x01);
			break;

		case SOCKET_2:
		case SOCKET_E:
			digitalWrite(SCP_PWR_3V3_SOCKET_2_E, LOW);

			// Set the flags
			pwrCitiesPRORegister &= ~(1 << 0x02);
			break;

		case SOCKET_3:
		case SOCKET_F:
			digitalWrite(SCP_PWR_3V3_SOCKET_3_F, LOW);

			// Set the flags
			pwrCitiesPRORegister &= ~(1 << 0x03);
			break;

		case SOCKET_4:
		case SOCKET_A:
			digitalWrite(SCP_PWR_3V3_SOCKET_4_A, LOW);

			// Set the flags
			pwrCitiesPRORegister &= ~(1 << 0x04);
			break;

		case SOCKET_5:
		case SOCKET_B:
			digitalWrite(SCP_PWR_3V3_SOCKET_5_B, LOW);

			// Set the flags
			pwrCitiesPRORegister &= ~(1 << 0x05);
			break;
			
		case SOCKET_6:
		case SOCKET_D:			
			PWR.setSensorPower(SENS_5V, SENS_OFF);
			digitalWrite(NOISE_SENSOR_POWER_D,LOW);
			break;
			
			

		default:
			break;
	}
	#if DEBUG_CITIES_PRO>1
		PRINT_CITIES_PRO(F("pwrCitiesPRORegister="));
		USB.println(pwrCitiesPRORegister, BIN);
		PRINT_CITIES_PRO(F("pwrGasPRORegister="));
		USB.println(pwrGasPRORegister, BIN);
	#endif

	if ((pwrGasPRORegister == 0x00) &&
		(pwrCitiesPRORegister == 0x00) &&
		((WaspRegister & REG_3V3) != 0))
	{
		#if DEBUG_CITIES_PRO>0
			PRINTLN_CITIES_PRO(F("3V3 to OFF"));
		#endif
		PWR.setSensorPower(SENS_3V3, SENS_OFF);
	}
}

WaspSensorCitiesPRO SensorCitiesPRO=WaspSensorCitiesPRO();


//************************************************************************************
// Noise Sensor Class functions
//************************************************************************************

/*!
 * @brief	Constructor of the class
 * @param 	void
 * @return	void
 */
noiseSensor::noiseSensor()
{
	// store the UART to be used
	_uart = SOCKET1;
	_baudrate = 115200;
	_def_delay = 50;
	
	// assign class pointer to UART buffer
	_buffer = class_buffer;
	_bufferSize = SENSOR_NOISE_UART_SIZE;
	
	_mux_state = WaspUtils::MUX_UART1_AUX1;
}


/*!
 * @brief	Get a new measure of SPLA
 * @param
 * @return	uint8_t: Status of the last communication
 */
uint8_t noiseSensor::getSPLA(void)
{
	getSPLA(FAST_MODE);
}


/*!
 * @brief	Get a new measure of SPLA
 * @param
 * @return	uint8_t: Status of the last communication
 */
uint8_t noiseSensor::getSPLA(uint8_t mode)
{
	uint8_t status;

	if (mode == SLOW_MODE)
	{
		// Send command for getting a new measure
		status = sendCommand("ATSLOW", "OK", 5000);
	}
	else
	{
		// Send command for getting a new measure
		status = sendCommand("ATFAST", "OK", 5000);
	}

	// Request 8 bytes from the UART buffer
	readBuffer(7, 1);

	if (status == 0)
	{
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO(F("Timeout: No response from the Noise Sensor"));
		#endif

		return 1;
	}
	else
	{
		status = parseFloat(&SPLA, "\r\n");

		if (status == 0)
		{
			#if DEBUG_CITIES_PRO > 1
				PRINTLN_CITIES_PRO(F("Successful communication. Value stored in SPLA variable."));
				PRINTLN_CITIES_PRO(F("Value Stored in SPLA: "));
				PRINTLN_CITIES_PRO_VAL(SPLA);
			#endif

			return status;
		}
		else
		{
			#if DEBUG_CITIES_PRO > 0
				PRINTLN_CITIES_PRO(F("Wrong response. Can't read data."));
			#endif
		}

		return status;
	}
}


/*!
 * @brief	Configure the UART for communicating with the sensor
 * @param 	void
 * @return	void
 */
void noiseSensor::configure()
{
	// open mcu uart
	beginUART();
	// set Auxiliar1 socket
	Utils.setMuxAux1();
	// flush uart
	serialFlush(_uart);
}

// Instance of the class
noiseSensor noise = noiseSensor();





//************************************************************************************
// Noise Sensor V2 Class functions
//************************************************************************************

// Instance of the class

/*!
 * @brief	Constructor of the class
 * @param 	void
 * @return	void
 */
noiseSensorV2::noiseSensorV2(uint8_t sensor_socket)
{
	_socket = sensor_socket;

	// store the UART to be used
	_uart = SOCKET1;
	_baudrate = 9600;
	_def_delay = 50;

	// assign class pointer to UART buffer
	_buffer = class_buffer;
	_bufferSize = SENSOR_NOISE_UART_SIZE;

	if(_socket == SOCKET_A)
	{	
		_mux_state = WaspUtils::MUX_UART1_AUX1;
	}
	else if (_socket == SOCKET_D)
	{
		_mux_state = WaspUtils::MUX_UART1_AUX2;
	}
}


/*!
 * @brief	Configure the UART for communicating with the sensor
 * @param 	void
 * @return	void
 */
uint8_t noiseSensorV2::ON()
{

	if (_socket == SOCKET_A)
	{
		configure();
		return 0;
	}
	else if(_socket == SOCKET_D)
	{
		SensorCitiesPRO.ON(_socket);
		configure();
		delay(5000);
		return 0;
	}	

	return 1;
}


/*!
 * @brief	Configure the UART for communicating with the sensor
 * @param 	void
 * @return	void
 */
void noiseSensorV2::OFF()
{
	if(_socket == SOCKET_D)
	{
		SensorCitiesPRO.OFF(_socket);
	}	
}

/*!
 * @brief	Configure the UART for communicating with the sensor
 * @param 	void
 * @return	void
 */
uint8_t noiseSensorV2::calibrate(char noiseLevel[])
{
	
	char command[50];
	
	snprintf(command, sizeof(command), "SPL:SYS:CAL %s\r",noiseLevel);
	
	// Send command for getting a new measure
	uint8_t status = sendCommand(command, "OK", 5000);
	
	if (status == 1)
	{
		#if DEBUG_CITIES_PRO > 1
			PRINTLN_CITIES_PRO(F("Successful calibration."));
		#endif
		
		delay(2000);
		status = get();
		
		if(status == 0)
		{
			USB.println(F("Successful communication. Value stored in SPLA variable."));
			USB.println(F("Value Stored in SPLA: "));
			USB.printFloat(SPLA,2);
			USB.println(F("dB"));		
			
			return 0;
		}
		else
		{
			USB.println(F("Wrong response. Can't read data."));
			
			return 1;
		}
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO(F("Wrong calibration."));
		#endif
			
		return 1;
	}
}



/*!
 * @brief	Configure the UART for communicating with the sensor
 * @param 	void
 * @return	void
 */
void noiseSensorV2::configure()
{
	// open mcu uart
	beginUART();
	
	if (_socket == SOCKET_A)
	{
		// set Auxiliar1 socket
		Utils.setMuxAux1();
	}
	else if(_socket == SOCKET_D)
	{
		// set Auxiliar2 socket
		Utils.setMuxAux2();
	}	

	// flush uart
	serialFlush(_uart);
	delay(200);
}


/*!
 * @brief	Get a new measure of SPLA
 * @param
 * @return	uint8_t: Status of the last communication
 */
uint8_t noiseSensorV2::getInfo(void)
{
	uint8_t status;
	
	// Send command for getting a new measure
	status = sendCommand("SPL:SYS:INFO SERIALNUM\r", "\r\n", 5000);

	if (status == 0)
	{
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO(F("Timeout: No response from the Noise Sensor"));
		#endif

		return 1;
	}
	else
	{
		uint8_t i=0;
		while(i < _bufferSize)
		{
			SerialN[i]=_buffer[i];	
			i=i+1;
		}
		
		if (status == 1)
		{
			#if DEBUG_CITIES_PRO > 1
				PRINTLN_CITIES_PRO(F("Successful communication."));
				PRINTLN_CITIES_PRO(F("Serial Number: "));
				PRINTLN_CITIES_PRO(SerialN);
			#endif
			delay(100);

			return 0;
		}
		else
		{
			#if DEBUG_CITIES_PRO > 0
				PRINTLN_CITIES_PRO(F("Wrong response. Can't read data."));
			#endif
			
			return 1;
		}
	}
		
}

/*!
 * @brief	Get a new measure of SPLA
 * @param
 * @return	uint8_t: Status of the last communication
 */
uint8_t noiseSensorV2::get(void)
{
	get(LAS_MODE);
}


/*!
 * @brief	Get a new measure of SPLA
 * @param
 * @return	uint8_t: Status of the last communication
 */
uint8_t noiseSensorV2::get(uint8_t mode)
{
	uint8_t status;

	if (mode == LAS_MODE)
	{
		// Send command for getting a new measure
		status = sendCommand("SPL:GET LAS\r", "\r", 5000);
	}
	else if (mode == LAF_MODE)
	{
		// Send command for getting a new measure
		status = sendCommand("SPL:GET LAF\r", "\r", 5000);
	}

	// Request 8 bytes from the UART buffer
	//readBuffer(7, 1);

	if (status == 0)
	{
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO(F("Timeout: No response from the Noise Sensor"));
		#endif

		return -1;
	}
	else
	{
		status = parseFloat(&SPLA, "\r\n");
		

		if (status == 0)
		{
			#if DEBUG_CITIES_PRO > 1
				PRINTLN_CITIES_PRO(F("Successful communication. Value stored in SPLA variable."));
				PRINTLN_CITIES_PRO(F("Value Stored in SPLA: "));
				PRINTLN_CITIES_PRO_VAL(SPLA);
			#endif

			return status;
		}
		else
		{
			#if DEBUG_CITIES_PRO > 0
				PRINTLN_CITIES_PRO(F("Wrong response. Can't read data."));
			#endif
		}

		return status;
	}
}


uint8_t noiseSensorV2::getAverage(uint32_t time)
{
	uint8_t status;

	// Send command for getting a new measure
	status = sendCommand("SPL:GET RESET\r", "OK", 5000);
		
	uint32_t previous = millis();

	while((millis()-previous) < time){
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO(F("Taking average measurements - 30 seconds"));
		#endif
	}
	
	status = sendCommand("SPL:GET LAEq\r", "\r", 5000);

	if (status == 0)
	{
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO(F("Timeout: No response from the Noise Sensor"));
		#endif

		return -1;
	}
	else
	{
		status = parseFloat(&SPLA, "\r\n");
		

		if (status == 0)
		{
			#if DEBUG_CITIES_PRO > 1
				PRINTLN_CITIES_PRO(F("Successful communication. Value stored in SPLA variable."));
				PRINTLN_CITIES_PRO(F("Value Stored in SPLA: "));
				PRINTLN_CITIES_PRO_VAL(SPLA);
			#endif

			return status;
		}
		else
		{
			#if DEBUG_CITIES_PRO > 0
				PRINTLN_CITIES_PRO(F("Wrong response. Can't read data."));
			#endif
		}
		return status;
	}
}


//******************************************************************************
// BME Sensor Class functions
//******************************************************************************

/*!
 * @brief	Constructor of the class
 * @param 	void
 * @return	void
 */
bmeCitiesSensor::bmeCitiesSensor(uint8_t socket)
{
	_socket = socket;
}



/*!
 * @brief	switch on the corresponding 3v3 switch
 * @param 	void
 * @return	void
 */
void bmeCitiesSensor::ON()
{
	WaspSensorCitiesPRO::ON(_socket);

	// switch ON I2C
	digitalWrite(SCP_I2C_MAIN_EN, HIGH);

	// init BME
	BME.ON();
}



/*!
 * @brief	switch off the corresponding 3v3 switch
 * @param 	void
 * @return	void
 */
void bmeCitiesSensor::OFF()
{
	WaspSensorCitiesPRO::OFF(_socket);
	delay(100);
}


/*!
 *  @brief Read BME temperature value
 *  @return	temperature value
 *
 */
float bmeCitiesSensor::getTemperature()
{
	float value = 0;
	uint8_t error;
	uint8_t retries;

	// switch ON I2C
	digitalWrite(SCP_I2C_MAIN_EN, HIGH);

	///////////////////////////////////////////////////////////////////
	// configure the BME280 Sensor (Temperature, Humidity and Pressure)
	///////////////////////////////////////////////////////////////////
	retries = 3;
	do
	{
		error = BME.ON();
		retries--;

		if (error != 1)
		{
			I2C.recover();
		}
	} while ((error != 1) && (retries > 0));

	delay(100);

	///////////////////////////////////////////////////////////////////
	// read temperature	from the BME280 Sensor
	///////////////////////////////////////////////////////////////////
	retries = 3;
	do
	{
		value = BME.getTemperature(BME280_OVERSAMP_1X, 0);
		retries--;

		if (value == -1000.0)
		{
			I2C.recover();
		}
	} while ((value != -1000.0) && (retries > 0));

	#if DEBUG_CITIES_PRO>0
		PRINT_CITIES_PRO(F("Temperature:"));
		USB.println(value);
		PRINT_CITIES_PRO(F("BME280_OVERSAMP_1X"));
		USB.println(BME280_OVERSAMP_1X);
	#endif

	delay(100);

	return value;
}


/*!
 *  @brief Read BME humidity value
 *  @return	humidity value
 *
 */
float bmeCitiesSensor::getHumidity()
{
	float value = 0;
	uint8_t error;
	uint8_t retries;

	// switch ON I2C
	digitalWrite(SCP_I2C_MAIN_EN, HIGH);

	///////////////////////////////////////////////////////////////////
	// configure the BME280 Sensor (Temperature, Humidity and Pressure)
	///////////////////////////////////////////////////////////////////
	retries = 3;
	do
	{
		error = BME.ON();
		retries--;

		if (error != 1)
		{
			I2C.recover();
		}
	} while ((error != 1) && (retries > 0));

	delay(100);

	///////////////////////////////////////////////////////////////////
	// read the humidity from the BME280 Sensor
	///////////////////////////////////////////////////////////////////
	retries = 3;
	do
	{
		value = BME.getHumidity(BME280_OVERSAMP_1X);
		retries--;

		if (value == -1000.0)
		{
			I2C.recover();
		}
	} while ((value != -1000.0) && (retries > 0));

	#if DEBUG_CITIES_PRO>0
		PRINT_CITIES_PRO(F("Humidity:"));
		USB.println(value);
		PRINT_CITIES_PRO(F("BME280_OVERSAMP_1X"));
		USB.println(BME280_OVERSAMP_1X);
	#endif
	delay(100);

	return value;
}


/*!
 *  @brief Read BME pressure value
 *  @return	pressure value
 *
 */
float bmeCitiesSensor::getPressure()
{
	float value = 0;
	uint8_t error;
	uint8_t retries;

	// switch ON I2C
	digitalWrite(SCP_I2C_MAIN_EN, HIGH);

	///////////////////////////////////////////////////////////////////
	// configure the BME280 Sensor (Temperature, Humidity and Pressure)
	///////////////////////////////////////////////////////////////////
	retries = 3;
	do
	{
		error = BME.ON();
		retries--;

		if (error != 1)
		{
			I2C.recover();
		}
	} while ((error != 1) && (retries > 0));

	delay(100);

	///////////////////////////////////////////////////////////////////
	// read the pressure from the BME280 Sensor
	///////////////////////////////////////////////////////////////////
	retries = 3;
	do
	{
		value = BME.getPressure(BME280_OVERSAMP_1X, 0);
		retries--;

		if (value == -1000.0)
		{
			I2C.recover();
		}
	} while ((value != -1000.0) && (retries > 0));


	#if DEBUG_CITIES_PRO>0
		PRINT_CITIES_PRO(F("Pressure:"));
		USB.println(value);
		PRINT_CITIES_PRO(F("BME280_OVERSAMP_1X"));
		USB.println(BME280_OVERSAMP_1X);
	#endif

	delay(100);

	return value;
}






//******************************************************************************
// Ultrasound Sensor Class functions
//******************************************************************************

/*!
 * @brief	Constructor of the class
 * @param 	void
 * @return	void
 */
ultrasoundCitiesSensor::ultrasoundCitiesSensor(uint8_t socket)
{
	_socket = socket;
}



/*!
 * @brief	switch on the corresponding 3v3 switch
 * @param 	void
 * @return	void
 */
void ultrasoundCitiesSensor::ON()
{
	WaspSensorCitiesPRO::ON(_socket);
	delay(500);
}



/*!
 * @brief	switch off the corresponding 3v3 switch
 * @param 	void
 * @return	void
 */
void ultrasoundCitiesSensor::OFF()
{
	WaspSensorCitiesPRO::OFF(_socket);
	delay(100);
}


/*!
 * @brief 	This function performs a distance measurement
 * @return 	distance in cm.
 * 		  	9000 if error reading the distance
 * 			10000 if error reading the sensor
 */
uint16_t ultrasoundCitiesSensor::getDistance()
{
	return Ultrasound.getDistance();
}






//******************************************************************************
// Luxes Sensor Class functions
//******************************************************************************

/*!
 * @brief	Constructor of the class
 * @param 	void
 * @return	void
 */
luxesCitiesSensor::luxesCitiesSensor(uint8_t socket)
{
	_socket = socket;
}



/*!
 * @brief	switch on the corresponding 3v3 switch
 * @param 	void
 * @return	void
 */
void luxesCitiesSensor::ON()
{
	WaspSensorCitiesPRO::ON(_socket);
	delay(100);

	// init luxes sensor
	TSL.ON();
}



/*!
 * @brief	switch off the corresponding 3v3 switch
 * @param 	void
 * @return	void
 */
void luxesCitiesSensor::OFF()
{
	WaspSensorCitiesPRO::OFF(_socket);

	// switch off delay for better preformance before
	// entering sleep mode after calling this function
	delay(100);
}


/*!
 * @brief 	This function performs a luxes measurement
 * @return 	luxes if ok
 * 			-1 if error
 */
uint32_t luxesCitiesSensor::getLuminosity()
{
  return getLuminosity(TSL2561_GAIN_1, TSL2561_HIGH_RES);
}

/*!
 * @brief 	This function performs a luxes measurement
 * @return 	luxes if ok
 * 			-1 if error
 */
uint32_t luxesCitiesSensor::getLuminosity(bool gain)
{
  return getLuminosity(gain, TSL2561_HIGH_RES);
}

/*!
 * @brief 	This function performs a luxes measurement
 * @param   Resolution. Available options: TSL2561_HIGH_RES,
 *          TSL2561_MED_RES, TSL2561_LOW_RES
 * @return 	luxes if ok
 * 			-1 if error
 */
uint32_t luxesCitiesSensor::getLuminosity(bool gain, uint8_t res)
{
	uint8_t error;
	uint8_t retries = 3;

	do
	{
		// get luminosity
		error = TSL.getLuminosity(res, gain);

		if (error == 0)
		{
			return TSL.lux;
		}
		retries--;
		I2C.recover();
	}
	while(retries > 0);

	return (uint32_t)-1;
}





//******************************************************************************
// Noise Level Sensor Class 2 functions
//******************************************************************************

/******************************************************************************
 * Constructors
 ******************************************************************************/
/*!
 * @brief	Constructor of the class
 * @param 	void
 * @return	void
 */
noiseSensorClass2::noiseSensorClass2()
{
  // Serial paramaters
	_uart = SOCKET1;
	_baudrate = 9600;
	_def_delay = 1000;   // under 1000 ms the answer may not be parsed correctly
	_def_timeout = 2000; // max timeout of soundmeter

	// assign class pointer to UART buffer
	_buffer = class_buffer;
	_bufferSize = SENSOR_NOISE_CLASS_2_UART_SIZE;
	
	_mux_state = WaspUtils::MUX_UART1_AUX1;
}

/******************************************************************************
 * FUNCTIONS                                                                  *
 ******************************************************************************/

/*!
  * @brief	Turn ON the soundmeter and ensures communication
  * @param payload
  * @param length
  * @return	uint8_t: 1 if ok. error code otherwise
*/
uint8_t noiseSensorClass2::ON()
{
  uint8_t answer = 0;
  char* pointer;
  memset(payload, 0x00, sizeof(payload));

  // Serial initialization
  configure();
	
  // First, ensure it is not taking measurements.
  sprintf_P(payload, (char*)pgm_read_word(&(table_NLS2[5])), 0); // stop command
  buildNLSCommand(payload);

  // Get actual instant
  uint32_t previous = millis();

  // Note: The soundmeter takes around 20 seconds for initialization after power on.
  // Check available data for 'timeout' milliseconds
  while( (millis() - previous) < INIT_TIMEOUT )
  {
    // Send command to verify communication
    answer = sendCommand(command, (char*)DEFAULT_ACK, (char*)DEFAULT_ERROR);

    if (answer == 1)
    {
      // communication OK, soundmeter initialized
      #if DEBUG_CITIES_PRO > 0
        PRINTLN_CITIES_PRO("Sensor found. Measures stopped");
      #endif
      break;
    }

    // avoid saturate serial
    delay(500);

    // Condition to avoid an overflow (DO NOT REMOVE)
    if( millis() < previous) previous = millis();
  }

  // if soundmeter is not detected, exit
  if (answer == 0)
  {
    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("No response from the Noise Level Sensor Class 2");
    #endif
    return answer;
  }

  // Error code received
  if (answer == 2)
  {
    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("Unknown sensor state");
    #endif

    // FIX: Recover state if needed
  }

  // check version & read Serial Number for Quality Control purposes.
  // Build & send command
  memset(payload, 0x00, sizeof(payload));
  sprintf_P(payload, (char*)pgm_read_word(&(table_NLS2[3])));
  buildNLSCommand(payload);
  answer = sendCommand(command, "PCE", (char*)DEFAULT_ERROR); // look for model

  #if SIMULATE_SOUNDMETER > 0
  answer = 1;
  #endif

  if (answer != 1)
  {
    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("Sensor not recognized or wrong state");
      PRINT_CITIES_PRO("errorCode: ");
      USB.println(answer, DEC);
    #endif
    return answer;
  }
  else
  {
    // read the remaining bytes (it is variable, so max is read)
    readBuffer(SENSOR_NOISE_CLASS_2_UART_SIZE);

    #if DEBUG_CITIES_PRO > 1
      PRINT_CITIES_PRO("RX[ASCII]: ");
      USB.println((char*)_buffer);
    #endif

    // parse serial Number
    pointer = strtok((char*)_buffer, ",");
    pointer = strtok(NULL, ",");
    serialNumber = atol(pointer);
    pointer = strtok(NULL, ",");
    snprintf(version, sizeof(version), pointer);
    pointer = strtok(NULL, ",");
    snprintf(hwid, sizeof(hwid), pointer);

    #if DEBUG_CITIES_PRO > 0
      printSensorInfo();
    #endif

  }

  // check boot mode. Build & send command
  // Note: this step is not really necessary.
  memset(payload, 0x00, sizeof(payload));
  sprintf_P(payload, (char*)pgm_read_word(&(table_NLS2[2]))); // Query boot command
  buildNLSCommand(payload);
  answer = sendCommand(command, (char*)DEFAULT_ANSWER, (char*)DEFAULT_ERROR);

  if (answer != 1)
  {
    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("Wrong state");
      PRINT_CITIES_PRO("errorCode: ");
      USB.println(answer, DEC);
    #endif
    return answer;
  }
  else
  {
    // parse boot mode. Should be 2
    readBuffer(4);
    if (_buffer[0] != 0x32)
    {
      #if DEBUG_CITIES_PRO > 0
        PRINTLN_CITIES_PRO("Boot mode incorrect");
        PRINT_CITIES_PRO("boot_mode: ");
        USB.printHex(_buffer[0]);
        USB.println();
      #endif

    }
  }
  
  // get measurement setup
  getMeasurementSetup();

  // START measures again. Build & send command
  memset(payload, 0x00, sizeof(payload));
  sprintf_P(payload, (char*)pgm_read_word(&(table_NLS2[5])), 1); // Start command
  buildNLSCommand(payload);
  answer = sendCommand(command, (char*)DEFAULT_ACK, (char*)DEFAULT_ERROR);

  #if DEBUG_CITIES_PRO > 0
  if (answer == 1){PRINTLN_CITIES_PRO("Measures started");}
  else
  {
      PRINTLN_CITIES_PRO("Initialization error");
      PRINT_CITIES_PRO("errorCode: ");
      USB.println(answer, DEC);
  }
  #endif

  return answer;
}



/*!
* @brief	Calculate BCC field as XOR of the payload
* @param payload
* @param length
* @return	uint8_t: BCC if ok. 0 if error
*/
uint8_t noiseSensorClass2::getBCC(char* _aux, uint16_t length)
{

  uint8_t BCC = _aux[0];
  uint16_t _auxLength = strlen(_aux);

  // avoid payload overflow
  if (length > _auxLength + 1)
  {
    #if DEBUG_CITIES_PRO > 1
    PRINTLN_CITIES_PRO("BCC error");
    PRINT_CITIES_PRO("_payloadLength: ");
    USB.println(_auxLength);
    PRINT_CITIES_PRO("length: ");
    USB.println(length, DEC);
    #endif

    return 0;
  }

  for (uint16_t i = 1; i < length; i++)
  {
   BCC = BCC ^ _aux[i];
  }

  return BCC;
}



/*!
 * @brief	Get a new SPL data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getSPL()
{
	return getData(SPL_data);
}



/*!
 * @brief	Get a new SD data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getSD()
{
	return getData(SD_data);
}



/*!
 * @brief	Get a new SEL data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getSEL()
{
	return getData(SEL_data);
}



/*!
 * @brief	Get a new E data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getE()
{
	return getData(E_data);
}



/*!
 * @brief	Get a new Max data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getMax()
{
	return getData(Max_data);
}



/*!
 * @brief	Get a new Min data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getMin()
{
	return getData(Min_data);
}



/*!
 * @brief	Get a new Peak data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getPeak()
{
	return getData(Peak_data);
}



/*!
 * @brief	Get a new Leq data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getLeq()
{
	return getData(Leq_data);
}



/*!
 * @brief	Get a new LM data measure
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getLN()
{
	return getData(LN_data);
}



/*!
 * @brief	Get a new measure
 * @param group of data to read
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getData(uint8_t data_group)
{
  uint8_t answer = 0;
  uint8_t return_mode = 1;
  char* pointer;
  
  // Serial initialization
  configure();

  // DSL%u %u ?
  sprintf_P(payload, (char*)pgm_read_word(&(table_NLS2[0])), data_group, return_mode);
  buildNLSCommand(payload);

  // Send command for getting a new measure
  answer = sendCommand(command, (char*)DEFAULT_ANSWER, (char*)(DEFAULT_ERROR));

  #if SIMULATE_SOUNDMETER > 0

    // Example answer where LEQ data: LAeq=065.0dB, LBeq=066.2dB; LCeq=067.0dB; LZeq=067.2dB
    // 02 01 41 30 36 35 2E 30 2C 30 36 36 2E 32 2C 30 36 37 2E 30 2C 30 36 37 2E 32 03 6E 0D 0A
    // (ASCII): A065.0,066.2,067.0,067.2n  // Values are separated by comas (0x2C)
    uint8_t fake_buffer[] = {0x02, 0x01, 0x41, 0x30, 0x36, 0x35, 0x2E, 0x30,
      0x2C, 0x30, 0x36, 0x36, 0x2E, 0x32, 0x2C, 0x30, 0x36, 0x37, 0x2E, 0x30,
      0x2C, 0x30, 0x36, 0x37, 0x2E, 0x32, 0x03, 0x6E, 0x0D, 0x0A};

    memcpy(_buffer, fake_buffer, 30); // fake_buffer should not be > _buffer

    PRINT_CITIES_PRO("FAKE RX[ASCII]: ");
    USB.print((char*)_buffer);

    PRINT_CITIES_PRO("FAKE RX[HEX]: ");
    for(uint8_t i = 0; i < 30; i++)
    {
      USB.printHex(_buffer[i]);
      USB.print(F(" "));
    }
    USB.println();

    answer = 1;

  #endif

  if (answer == 0)
  {
    // No answer. FIX: RESEND command if timming issues detected
    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("No response from the Noise Level Sensor");
      PRINT_CITIES_PRO("Failed reading data from group: ");
      USB.println(data_group);
    #endif
    return answer;
  }

  if (answer == 1)
  {
    // read the remaining bytes (it is variable, so max is read)
    readBuffer(SENSOR_NOISE_CLASS_2_UART_SIZE);

    #if DEBUG_CITIES_PRO > 1
      PRINT_CITIES_PRO("RX[ASCII]: ");
      USB.println((char*)_buffer);
    #endif

    // parse the answer in _buffer
    // FIX: STX, ID and BCC should be checked for security. Now are skipped
    //pointer = strtok((char*)_buffer, "A");
    //pointer = strtok(NULL, "A");
    //pointer = strtok(pointer, ",");


    switch(data_group)
    {
  	  case SPL_data:
  		pointer = strtok((char*)_buffer, ",");
		LAF = atof(pointer);
		pointer = strtok(NULL, ",");
		LAS = atof(pointer);
		pointer = strtok(NULL, ",");
		LAI = atof(pointer);
		pointer = strtok(NULL, ",");
		LBF = atof(pointer);
		pointer = strtok(NULL, ",");
		LBS = atof(pointer);
		pointer = strtok(NULL, ",");
		LBI = atof(pointer);
		pointer = strtok(NULL, ",");
		LCF = atof(pointer);
		pointer = strtok(NULL, ",");
		LCS = atof(pointer);
		pointer = strtok(NULL, ",");
		LCI = atof(pointer);
		pointer = strtok(NULL, ",");
		LZF = atof(pointer);
		pointer = strtok(NULL, ",");
		LZS = atof(pointer);
		pointer = strtok(NULL, ",");
		LZI = atof(pointer);
		#if DEBUG_CITIES_PRO > 0
		  PRINT_CITIES_PRO(F("LAF = "));
		  USB.printFloat(LAF, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LAS = "));
		  USB.printFloat(LAS, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LAI = "));
		  USB.printFloat(LAI, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBF = "));
		  USB.printFloat(LBF, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBS = "));
		  USB.printFloat(LBS, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBI = "));
		  USB.printFloat(LBI, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCF = "));
		  USB.printFloat(LCF, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCS = "));
		  USB.printFloat(LCS, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCI = "));
		  USB.printFloat(LCI, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LZF = "));
		  USB.printFloat(LZF, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LZS = "));
		  USB.printFloat(LZS, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LZI = "));
		  USB.printFloat(LZI, 1);
		  USB.println(" dB");
		#endif
		  break;
  	  case SD_data:
		pointer = strtok((char*)_buffer, ",");
  		LAFsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LASsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LAIsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBFsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBSsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBIsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCFsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCSsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCIsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZFsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZSsd = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZIsd = atof(pointer);
		#if DEBUG_CITIES_PRO > 0
		  PRINT_CITIES_PRO(F("LAFsd = "));
		  USB.printFloat(LAFsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LASsd = "));
		  USB.printFloat(LASsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LAIsd = "));
		  USB.printFloat(LAIsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBFsd = "));
		  USB.printFloat(LBFsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBSsd = "));
		  USB.printFloat(LBSsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBIsd = "));
		  USB.printFloat(LBIsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCFsd = "));
		  USB.printFloat(LCFsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCSsd = "));
		  USB.printFloat(LCSsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCIsd = "));
		  USB.printFloat(LCIsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LZFsd = "));
		  USB.printFloat(LZFsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LZSsd = "));
		  USB.printFloat(LZSsd, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LZIsd = "));
		  USB.printFloat(LZIsd, 1);
		  USB.println(" dB");
		#endif
  		  break;
  	  case SEL_data:
  		pointer = strtok((char*)_buffer, ",");
  		LAsel = atof(pointer);
		pointer = strtok(NULL, ",");
		LBsel = atof(pointer);
		pointer = strtok(NULL, ",");
		LCsel = atof(pointer);
		pointer = strtok(NULL, ",");
		LZsel = atof(pointer);
		#if DEBUG_CITIES_PRO > 0
  		  PRINT_CITIES_PRO(F("LAsel = "));
  		  USB.printFloat(LAsel, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBsel = "));
  		  USB.printFloat(LBsel, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCsel = "));
  		  USB.printFloat(LCsel, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZsel = "));
  		  USB.printFloat(LZsel, 1);
  		  USB.println(" dB");
  		#endif
  		  break;
  	  case E_data:
		pointer = strtok((char*)_buffer, ",");
		LAe = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBe = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCe = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZe = atof(pointer);
  		#if DEBUG_CITIES_PRO > 0
		  PRINT_CITIES_PRO(F("LAe = "));
		  USB.printFloat(LAe, 10);
		  USB.println("");
		  PRINT_CITIES_PRO(F("LBe = "));
		  USB.printFloat(LBe, 10);
		  USB.println("");
		  PRINT_CITIES_PRO(F("LCe = "));
		  USB.printFloat(LCe, 10);
		  USB.println("");
		  PRINT_CITIES_PRO(F("LZe = "));
		  USB.printFloat(LZe, 10);
		  USB.println("");
		#endif
		  break;
  	  case Max_data:
		pointer = strtok((char*)_buffer, ",");
  		LAFmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LASmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LAImax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBFmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBSmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBImax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCFmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCSmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCImax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZFmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZSmax = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZImax = atof(pointer);
  		#if DEBUG_CITIES_PRO > 0
  		  PRINT_CITIES_PRO(F("LAFmax = "));
  		  USB.printFloat(LAFmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LASmax = "));
  		  USB.printFloat(LASmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LAImax = "));
  		  USB.printFloat(LAImax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBFmax = "));
  		  USB.printFloat(LBFmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBSmax = "));
  		  USB.printFloat(LBSmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBImax = "));
  		  USB.printFloat(LBImax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCFmax = "));
  		  USB.printFloat(LCFmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCSmax = "));
  		  USB.printFloat(LCSmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCImax = "));
  		  USB.printFloat(LCImax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZFmax = "));
  		  USB.printFloat(LZFmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZSmax = "));
  		  USB.printFloat(LZSmax, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZImax = "));
  		  USB.printFloat(LZImax, 1);
  		  USB.println(" dB");
  		#endif
  		  break;
  	  case Min_data:
    	pointer = strtok((char*)_buffer, ",");
  		LAFmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LASmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LAImin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBFmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBSmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LBImin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCFmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCSmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LCImin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZFmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZSmin = atof(pointer);
  		pointer = strtok(NULL, ",");
  		LZImin = atof(pointer);
  		#if DEBUG_CITIES_PRO > 0
  		  PRINT_CITIES_PRO(F("LAFmin = "));
  		  USB.printFloat(LAFmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LASmin = "));
  		  USB.printFloat(LASmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LAImin = "));
  		  USB.printFloat(LAImin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBFmin = "));
  		  USB.printFloat(LBFmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBSmin = "));
  		  USB.printFloat(LBSmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBImin = "));
  		  USB.printFloat(LBImin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCFmin = "));
  		  USB.printFloat(LCFmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCSmin = "));
  		  USB.printFloat(LCSmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCImin = "));
  		  USB.printFloat(LCImin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZFmin = "));
  		  USB.printFloat(LZFmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZSmin = "));
  		  USB.printFloat(LZSmin, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZImin = "));
  		  USB.printFloat(LZImin, 1);
  		  USB.println(" dB");
  		#endif
  		  break;
  	  case Peak_data:
		pointer = strtok((char*)_buffer, ",");
		LApeak = atof(pointer);
		pointer = strtok(NULL, ",");
		LBpeak = atof(pointer);
		pointer = strtok(NULL, ",");
		LCpeak = atof(pointer);
		pointer = strtok(NULL, ",");
		LZpeak = atof(pointer);
  		#if DEBUG_CITIES_PRO > 0
  		  PRINT_CITIES_PRO(F("LApeak = "));
  		  USB.printFloat(LApeak, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LBpeak = "));
  		  USB.printFloat(LBpeak, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LCpeak = "));
  		  USB.printFloat(LCpeak, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("LZpeak = "));
  		  USB.printFloat(LZpeak, 1);
  		  USB.println(" dB");
  		#endif
  		  break;
  	  case Leq_data:
  	    pointer = strtok((char*)_buffer, ",");
  	    LAeq = atof(pointer);
  	    pointer = strtok(NULL, ",");
  	    LBeq = atof(pointer);
  	    pointer = strtok(NULL, ",");
  	    LCeq = atof(pointer);
  	    pointer = strtok(NULL, ",");
  	    LZeq = atof(pointer);
		#if DEBUG_CITIES_PRO > 0
		  PRINT_CITIES_PRO(F("LAeq = "));
		  USB.printFloat(LAeq, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LBeq = "));
		  USB.printFloat(LBeq, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO(F("LCeq = "));
		  USB.printFloat(LCeq, 1);
		  USB.println(" dB");
		  PRINT_CITIES_PRO("LZeq = ");
		  USB.printFloat(LZeq, 1);
		  USB.println(" dB");
		#endif
		  break;
  	  case LN_data:
		pointer = strtok((char*)_buffer, ",");
  		L10 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L20 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L30 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L40 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L50 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L60 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L70 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L80 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L90 = atof(pointer);
  		pointer = strtok(NULL, ",");
  		L99 = atof(pointer);
  		#if DEBUG_CITIES_PRO > 0
  		  PRINT_CITIES_PRO(F("L10 = "));
  		  USB.printFloat(L10, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L20 = "));
  		  USB.printFloat(L20, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L30 = "));
  		  USB.printFloat(L30, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L40 = "));
  		  USB.printFloat(L40, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L50 = "));
  		  USB.printFloat(L50, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L60 = "));
  		  USB.printFloat(L60, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L70 = "));
  		  USB.printFloat(L70, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L80 = "));
  		  USB.printFloat(L80, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L90 = "));
  		  USB.printFloat(L90, 1);
  		  USB.println(" dB");
  		  PRINT_CITIES_PRO(F("L99 = "));
  		  USB.printFloat(L99, 1);
  		  USB.println(" dB");
  		#endif
		  break;
  	  default:
  		  break;
	}
	
    return answer;

  }
  else
  {

    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("Wrong state");
      PRINT_CITIES_PRO("errorCode: ");
      USB.println(answer, DEC);

      #if DEBUG_CITIES_PRO > 1
        // read the remaining bytes (it is variable, so max is read)
        readBuffer(SENSOR_NOISE_CLASS_2_UART_SIZE);
        PRINT_CITIES_PRO("RX[ASCII]: ");
        USB.println((char*)_buffer);
      #endif
    #endif
    return answer;

  }

}


/*!
 * @brief	Get all data groups
 * @param group of data to read
 * @return	uint8_t: 1 on success. error if error
 */
uint8_t noiseSensorClass2::getAllData()
{
	if(getSPL() && getSD() && getSEL()  && getE() && getMax() 
	&& getMin() && getPeak() && getLeq() && getLN())
	{
		return 1;
	}
	return 0;
}



/*!
 * @brief	Build the command according to packet format
 * @param payload
 * @return	uint8_t: 1 on success. error if payload not valid
 */
uint8_t noiseSensorClass2::buildNLSCommand(char* _payload)
{
  // Payload
  uint8_t payloadLenght = strlen(_payload);

  // double check sizes to avoid overflow. Check packet format for more info.
  if ((payloadLenght > MAX_PAYLOAD_SIZE) || (payloadLenght > (MAX_COMMAND_SIZE - 8)))
  {
    #if DEBUG_CITIES_PRO > 0
      PRINTLN_CITIES_PRO("Command size overflow");
    #endif
    return 0;
  }

  // exaple command to query data: DSLp1_p2_?
  // p1 = 7 and p2 = 1
  // 02 01 43 44 53 4C 37 20 31 20 3F 03 21 0D 0A

  /* packet format -
   *
   *  FIELD:   | STX    |   ID   |  ATTR  | PAYLOAD 							  |  EXT   |  BCC   |   CR   |   LF   |
   *  LENGTH:  | 1 byte | 1 byte | 1 byte |  n bit  							  | 1 byte | 1 byte | 1 byte | 1 byte |
   *  EXAMPLE:   02				01			 43       44 53 4C 37 20 31 20 3F   03  		21  			0D  		0A
  */

  /* payload format -
   *
   *  FIELD:   | COMMAND  |   P1   | SPACE |  P2    | SPACE | QUERY |
   *  LENGTH:  | 3 bytes  | 1 to 3 |   1   | 1 to 3 |   1   |   1   |
   *  ASCII:   | DSL      | 7      |       | 1      |       |   ?   |
   *  HEX:     | 44 53 4C   37       20      31       20       3F   |
  */

  uint8_t index = 0;

  // clear variable
  memset(command, 0x00, sizeof(command));

  command[index++] = STX;
  command[index++] = ID;
  command[index++] = ATTR_COMMAND;

  strncat(command,_payload, payloadLenght);
  index = index + payloadLenght;

  command[index++] = EXT;
  command[index++] = getBCC(command, index);
  command[index++] = 0x0D;
  command[index++] = 0x0A;

  command[index] =  '\0';

  #if DEBUG_CITIES_PRO > 1
    PRINT_CITIES_PRO("TX[ASCII]: ");
    USB.println(command);
    PRINT_CITIES_PRO("TX[HEX]: ");
    for(uint8_t i = 0; i < index; i++)
    {
      USB.printHex(command[i]);
      USB.print(F(" "));
    }
    USB.println();
  #endif

  return 1;
}


/*!
 * @brief	Send a command directly to the sensor. For test purposes only
 * @param command as byte array
 @param length of the command
 * @return	void
 */
void noiseSensorClass2::sendRawCommand(uint8_t* command, uint16_t length)
{
  #if DEBUG_NLS2 > 1
    PRINT_CITIES_PRO("TX[ASCII]: ");
    for(uint8_t i = 0; i < length; i++)
    {
      USB.print(command[i]);
    }
    PRINT_CITIES_PRO("TX[HEX]: ");
    for(uint8_t i = 0; i < length; i++)
    {
      USB.printHex(command[i]);
      USB.print(F(" "));
    }
    USB.println();
  #endif

  sendCommand(command, length);

  // Necessary
  delay(_def_delay);

  // read the remaining bytes (it is variable, so max is read)
  readBuffer(SENSOR_NOISE_CLASS_2_UART_SIZE);
  #if DEBUG_CITIES_PRO > 0
    PRINT_CITIES_PRO("RX[ASCII]: ");
    USB.println((char*)_buffer);
  #endif
  #if DEBUG_CITIES_PRO > 1
    PRINT_CITIES_PRO("RX[HEX]: ");
    for(uint8_t i = 0; i < _length; i++)
    {
      USB.printHex(_buffer[i]);
      USB.print(F(" "));
    }
    USB.println();
  #endif

}

/*!
 * @brief	Configure integral period of the sensor
 * @param 	integral period
 * @return	void
 */
uint8_t noiseSensorClass2::setIntegralPeriod(uint8_t integral_period)
{
	return setMeasurementSetup(1, integral_period, 0);
}


/*!
 * @brief	Configure the UART for communicating with the sensor
 * @param 	void
 * @return	void
 */
void noiseSensorClass2::configure()
{
	// Open mcu uart
	beginUART();
	// Set Auxiliar1 socket
	Utils.setMuxAux1();
	// Flush uart
	serialFlush(_uart);
}


/*!
 * @brief	Sets new date
 * @param 	Day, month and year
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::setDate(uint8_t dd, uint8_t mm, uint32_t yy)
{
	uint8_t answer = 0;
	uint8_t date_format = 2; // 0:yy/mm/dd 1:mm/dd/yy 2: dd/yy/mm
	
	configure();
	
	memset(payload, 0x00, sizeof(payload));

	sprintf(payload, "DAT%u %lu %u %u", date_format, yy, mm, dd);
	buildNLSCommand(payload);

	#if DEBUG_CITIES_PRO > 1
	PRINT_CITIES_PRO("Command to send: ");
		USB.println(command);

	for (int i = 0; i < strlen(command); i++)
	{
		printf("%02X", command[i]);
	}
	printf("\r\n");
	#endif
	
	answer = sendCommand(command, (char*)DEFAULT_ACK, (char*)DEFAULT_ERROR);

	#if DEBUG_NLS_PRO > 1
	printf("Response: ");
	for (int i = 0; i < _length; i++)
		{
			printf("%02X", _buffer[i]);
		}
	printf("\r\n");
	#endif

	if (answer == 1)
	{
		day = dd;
		month = mm;
		year = yy;
		
		#if DEBUG_CITIES_PRO > 0
		PRINT_CITIES_PRO("Sensor found. Date configured OK: ");
		if(day<10) 
		{
		  USB.print("0");      
		}
		USB.print(day);
		USB.print("/");
		if(month<10) 
		{
		  USB.print("0");      
		}
		USB.print(month);
		USB.print("/");
		USB.println(year);
		#endif
		
		return 0;
	}
	else if (answer == 0)
	{
		// if soundmeter is not detected, exit
		PRINTLN_CITIES_PRO("No response from the Noise Level Sensor Class 2");
		return 1;
	}
	else if (answer == 2)
	{
		// Error code received
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Unknown sensor state");
		#endif
	}

	return 2;
}


/**
 * @brief Gets date
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::getDate()
{
	uint8_t answer = 0;
	char* pointer;
	
	configure();
	
	memset(payload, 0x00, sizeof(payload));

	buildNLSCommand((char*)"DAT?");
	answer = sendCommand(command, (char*)NLS_PRO_END_COMMAND, (char*)DEFAULT_ERROR);

	if (answer != 1)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Sensor not recognized or wrong state");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(answer);
		#endif

		#if DEBUG_CITIES_PRO > 1
		PRINT_CITIES_PRO("RX[ASCII]: ");
		USB.println((char*)_buffer);
		#endif

		return 1;
	}
	
	#if DEBUG_CITIES_PRO > 1
	PRINT_CITIES_PRO("RX[ASCII]: ");
	USB.println((char*)_buffer);
	#endif
	
	pointer = strtok((char*)_buffer, ",");
	pointer = strtok(NULL, "/");
	year = atoi(pointer);
	pointer = strtok(NULL, "/");
	month = atoi(pointer);	
	pointer = strtok(NULL, "_");
	day = atoi(pointer);
	
	#if DEBUG_CITIES_PRO > 0
	PRINT_CITIES_PRO("Date: ");
	if(day<10) 
    {
      USB.print("0");      
    }
	USB.print(day);
	USB.print("/");
	if(month<10) 
    {
      USB.print("0");      
    }
	USB.print(month);
	USB.print("/");
	USB.println(year);
	#endif
	
	return 0;
}


/*!
 * @brief	Sets new time
 * @param 	Hous, minutes and seconds
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::setTime(uint8_t h, uint8_t min, uint8_t sec)
{
	uint8_t answer = 0;
	
	configure();
	
	memset(payload, 0x00, sizeof(payload));

	sprintf(payload, "HOR%u %u %u", h, min, sec);
	buildNLSCommand(payload);

	#if DEBUG_CITIES_PRO > 1
	PRINT_CITIES_PRO("Command to send: ");
		USB.println(command);

	for (int i = 0; i < strlen(command); i++)
	{
		printf("%02X", command[i]);
	}
	printf("\r\n");
	#endif
	
	answer = sendCommand(command, (char*)DEFAULT_ACK, (char*)DEFAULT_ERROR);
	
	#if DEBUG_NLS_PRO > 1
	printf("Response: ");
	for (int i = 0; i < _length; i++)
		{
			printf("%02X", _buffer[i]);
		}
	printf("\r\n");
	#endif
	
	if (answer == 1)
	{
		hour = h;
		minute = min;
		second = sec;
		
		#if DEBUG_CITIES_PRO > 0
		PRINT_CITIES_PRO("Sensor found. Time configured OK: ");
		if(hour<10) 
		{
		  USB.print("0");      
		}
		USB.print(hour);
		USB.print(":");
		if(minute<10) 
		{
		  USB.print("0");      
		}
		USB.print(minute);
		USB.print(":");
		if(second<10) 
		{
		  USB.print("0");      
		}
		USB.println(second);
		#endif
		
		return 0;
	}
	else if (answer == 0)
	{
		// if soundmeter is not detected, exit
		PRINTLN_CITIES_PRO("No response from the Noise Level Sensor Class 2");
		return 1;
	}
	else if (answer == 2)
	{
		// Error code received
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Unknown sensor state");
		#endif
	}

	return 2;
}


/**
 * @brief Gets time
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::getTime()
{
	uint8_t answer = 0;
	char* pointer;
	
	configure();
	
	memset(payload, 0x00, sizeof(payload));

	buildNLSCommand((char*)"HOR?");
	answer = sendCommand(command, (char*)NLS_PRO_END_COMMAND, (char*)DEFAULT_ERROR);

	if (answer != 1)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Sensor not recognized or wrong state");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(answer);
		#endif

		#if DEBUG_CITIES_PRO > 1
		PRINT_CITIES_PRO("RX[ASCII]: ");
		USB.println((char*)_buffer);
		#endif

		return 1;
	}
	
	#if DEBUG_CITIES_PRO > 1
	PRINT_CITIES_PRO("RX[ASCII]: ");
	USB.println((char*)_buffer);
	#endif

	pointer = strtok((char*)_buffer, "A");
	pointer = strtok(NULL, ":");
	hour = atoi(pointer);
	pointer = strtok(NULL, ":");
	minute = atoi(pointer);	
	pointer = strtok(NULL, "");
	second = atoi(pointer);
	
	#if DEBUG_CITIES_PRO > 0
	PRINT_CITIES_PRO("Time: ");
	if(hour<10) 
    {
      USB.print("0");      
    }
	USB.print(hour);
	USB.print(":");
	if(minute<10) 
    {
      USB.print("0");      
    }
	USB.print(minute);
	USB.print(":");
	if(second<10) 
    {
      USB.print("0");      
    }
	USB.println(second);
	#endif
	
	return 0;
}


/*!
 * @brief	Prints date and time
 * @param 	void
 * @return	void
 */
void noiseSensorClass2::printDateTime()
{
	// Date
	getDate();
	
	PRINT_CITIES_PRO("Date: ");
	if(day<10) 
    {
      USB.print("0");      
    }
	USB.print(day);
	USB.print("/");
	if(month<10) 
    {
      USB.print("0");      
    }
	USB.print(month);
	USB.print("/");
	USB.println(year);
	
	// Time
	getTime();
	
	PRINT_CITIES_PRO("Time: ");
	if(hour<10) 
    {
      USB.print("0");      
    }
	USB.print(hour);
	USB.print(":");
	if(minute<10) 
    {
      USB.print("0");      
    }
	USB.print(minute);
	USB.print(":");
	if(second<10) 
    {
      USB.print("0");      
    }
	USB.println(second);
}


/*!
 * @brief	Prints sensor information
 * @param 	void
 * @return	void
 */
void noiseSensorClass2::printSensorInfo()
{
  PRINT_CITIES_PRO("Serial number: ");
  USB.println(serialNumber);
  PRINT_CITIES_PRO("Version: ");
  USB.println(version);
  PRINT_CITIES_PRO("HWID: ");
  USB.println(hwid);
}



/**
 * @brief Check if PCE-428 is communicating OK
 * @return
 * 	@arg '0' Configured OK
 * 	@arg '1' error
 */
uint8_t noiseSensorClass2::getVersion()
{
	configure();
	
	uint8_t answer = 0;
	char* pointer;

	// check version & read Serial Number for Quality Control purposes.
	// Build & send command
	buildNLSCommand((char*)"VER?");
	answer = sendCommand(command, (char*)NLS_PRO_END_COMMAND, (char*)DEFAULT_ERROR); // look for model

#if SIMULATE_SOUNDMETER > 0
	answer = 1;
#endif

	if (answer != 1)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Sensor not recognized or wrong state");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(answer);
		#endif

		#if DEBUG_CITIES_PRO > 0
		PRINT_CITIES_PRO("RX[ASCII]: ");
		USB.println((char*)_buffer);
		#endif

		return 1;
	}
	else
	{
		#if DEBUG_CITIES_PRO > 1
		PRINT_CITIES_PRO("RX[ASCII]: ");
		USB.println((char*)_buffer);
		#endif

		char delimiters[] = {',', 0x02, 0x01, 0x03, '\0'};

		// parse
		pointer = strtok((char*)_buffer, delimiters);
		snprintf(type, sizeof(type), pointer);

		pointer = strtok(NULL, delimiters);
		classNumber = atol(pointer);

		pointer = strtok(NULL, delimiters);
		serialNumber = atol(pointer);

		pointer = strtok(NULL, delimiters);
		snprintf(version, sizeof(version), pointer);

		pointer = strtok(NULL, delimiters);
		snprintf(hwid, sizeof(hwid), pointer);

		#if DEBUG_CITIES_PRO > 0
		printSensorInfo();
		#endif

		return 0;
	}
}


/**
 * @brief Configure PCE-428 with proper settings
 * @return
 * 	@arg '0' Configured OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::configureSettings()
{
	return configureSettings(1, 60, 0);
}


/**
 * @brief Configure PCE-428 with proper settings
 * @return
 * 	@arg '0' Configured OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::configureSettings(uint8_t integral)
{
	if (integral < 143)
	{
		return configureSettings(1, integral, 0);
	}
	
	return 1;
}



/**
 * @brief Configure PCE-428 with proper settings
 * @return
 * 	@arg '0' Configured OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::configureSettings(uint8_t delay, uint8_t integral, uint16_t repeat)
{
	uint8_t error = 0;

	// 1. Ensure it is not taking measurements.
	error = setMeasurement(STA_STOP);

	if (error == 0)
	{
		#if DEBUG_CITIES_PRO > 1
		PRINTLN_CITIES_PRO("Measurements stopped");
		#endif
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Measures start error");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(error);
		#endif
		return 1;
	}

	// 2. Check PCE-428 is communicating OK
	error = getVersion();

	if (error != 0)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("PCE-428 not detected");
		#endif
		return 2;
	}

	// 3. Check boot mode. Build & send command
	error = getBootMode();

	if (error == 0)
	{
		#if DEBUG_CITIES_PRO > 1
		PRINTLN_CITIES_PRO("Boot mode and auto-measurement OK");
		#endif
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Boot mode and auto-measurement error");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(error);
		#endif
		return 3;
	}

	// 4. Set Measurement Setup
	error = setMeasurementSetup(delay, integral, repeat);

	if (error == 0)
	{
		#if DEBUG_CITIES_PRO > 1
		PRINTLN_CITIES_PRO("Set measurement Setup OK");
		#endif
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Set measurement Setup error");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(error);
		#endif
		return 4;
	}

	error = getMeasurementSetup();

	if (error == 0)
	{
		#if DEBUG_CITIES_PRO > 1
		PRINTLN_CITIES_PRO("Get measurement Setup OK");
		#endif

		PRINT_CITIES_PRO("Measurement delay: ");
		USB.println(meas_delay);
		PRINT_CITIES_PRO("Measurement integral period: ");
		USB.println(meas_integral);
		PRINT_CITIES_PRO("Measurement repeat: ");
		USB.println(meas_repeat);
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Get Measurement Setup error");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(error);
		#endif
	}

	// 5. Start measures again. Build & send command
	error = setMeasurement(STA_START);

	if (error == 0)
	{
		#if DEBUG_CITIES_PRO > 1
		PRINTLN_CITIES_PRO("Measurements started");
		#endif
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Measures start error");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(error);
		#endif
		return 5;
	}

	return 0;
}


/**
 * @brief Start/Stop measurement
 * @param mode:
 * 	@arg STA_START
 * 	@arg STA_STOP
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::getBootMode()
{
	configure();
	
	uint8_t answer = 0;
	memset(payload, 0x00, sizeof(payload));

	buildNLSCommand((char*)"OPM?");
	answer = sendCommand(command, (char*)DEFAULT_ANSWER, (char*)DEFAULT_ERROR);

	if (answer != 1)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINT_CITIES_PRO("Wrong state. errorCode: ");
		USB.println(answer);
		#endif
		return 1;
	}
	else
	{
		// parse boot mode. Should be 2
		readBuffer(4); //TODO: mejorar parseo controlando lo que recibimos
		if (_buffer[0] != OPM_BOOT_AND_AUTOMEASURE)
		{
			#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO("Boot mode incorrect");
			PRINT_CITIES_PRO("boot_mode: ");
			USB.println(_buffer[0]);
			#endif

			return 2;
		}

		return 0;
	}
}


/**
 * @brief Start/Stop measurement
 * @param mode:
 * 	@arg STA_START
 * 	@arg STA_STOP
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::setMeasurement(uint8_t mode)
{
	configure();
	
	uint8_t answer = 0;
	memset(payload, 0x00, sizeof(payload));

	sprintf(payload, "STA%u", mode);
	buildNLSCommand(payload);
	answer = sendCommand(command, (char*)DEFAULT_ACK, (char*)DEFAULT_ERROR);

	if (answer == 1)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINT_CITIES_PRO("Sensor found. Measurement mode configured OK: ");
		USB.println(mode);
		#endif

		return 0;
	}
	else if (answer == 0)
	{
		// if soundmeter is not detected, exit
		PRINTLN_CITIES_PRO("No response from the Noise Level Sensor Class 2");
		return 1;
	}
	else if (answer == 2)
	{
		// Error code received
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Unknown sensor state");
		#endif
	}

	return 2;
}



/**
 * @brief Set the delay, integral period, repeat, and logger setup
 * @param mode:
 * 	@arg delay
 * 	@arg integral
 * 	@arg repeat
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::setMeasurementSetup(uint8_t delay, uint8_t integral, uint16_t repeat)
{
	return setMeasurementSetup(
			delay,
			integral,
			repeat,
			0,
			3,
			0,
			59);
}

/**
 * @brief Set the delay, integral period, repeat, and logger setup
 * @param mode:
 * 	@arg delay
 * 	@arg integral
 * 	@arg repeat
 * 	@arg swn_logger
 * 	@arg swn_logger_step
 * 	@arg csd_logger
 * 	@arg csd_logger_step
 * @return
 * 	@arg '0' OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::setMeasurementSetup(
		uint8_t delay,
		uint8_t integral,
		uint16_t repeat,
		uint8_t swn_logger,
		uint8_t swn_logger_step,
		uint8_t csd_logger,
		uint8_t csd_logger_step)
{
	configure();
	
	uint8_t answer = 0;
	memset(payload, 0x00, sizeof(payload));

	snprintf(payload, sizeof(payload), "BSE%u %u %u %u %u %u %u",
			delay,
			integral,
			repeat,
			swn_logger,
			swn_logger_step,
			csd_logger,
			csd_logger_step);

	this->buildNLSCommand(payload);

	#if DEBUG_NLS_PRO > 1
	PRINT_CITIES_PRO("Command to send: ");
		USB.println(command);

	for (int i = 0; i < strlen(command); i++)
	{
		printf("%02X", command[i]);
	}
	printf("\r\n");
	#endif

	answer = sendCommand(command, (char*)DEFAULT_ANSWER, (char*)DEFAULT_ERROR, 3000);

	#if DEBUG_NLS_PRO > 1
	printf("Response: ");
	for (int i = 0; i < _length; i++)
		{
			printf("%02X", _buffer[i]);
		}
	printf("\r\n");
	#endif

	if (answer == 1)
	{
		#if DEBUG_CITIES_PRO > 0
			PRINTLN_CITIES_PRO("Sensor found. Measurement setup configured OK");
		#endif

		return 0;
	}
	else if (answer == 0)
	{
		// if soundmeter is not detected, exit
		PRINTLN_CITIES_PRO("No response from the Noise Level Sensor Class 2");
		return 1;
	}
	else if (answer == 2)
	{
		// Error code received
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Unknown sensor state");
		#endif
	}

	return 2;
}



/**
 * @brief Query Measurement Setup
 *
 * @return
 * 	@arg '0' Configured OK
 * 	@arg 'x' error
 */
uint8_t noiseSensorClass2::getMeasurementSetup()
{
	configure();
	
	uint8_t answer = 0;
	char* pointer;

	// Build & send command
	buildNLSCommand((char*)"BSE?");
	answer = sendCommand(command, (char*)NLS_PRO_END_COMMAND, (char*)DEFAULT_ERROR); // look for model

#if SIMULATE_SOUNDMETER > 0
	answer = 1;
#endif

	if (answer == 1)
	{
		#if DEBUG_CITIES_PRO > 1
		PRINT_CITIES_PRO("RX[ASCII]: ");
		USB.println((char*)_buffer);
		#endif

		char delimiters[] = {',', 0x02, 0x01, 0x03, '\0'};

		meas_delay = 0;
		meas_integral = 0;
		meas_repeat = 0;
		meas_swn_logger = 0;
		meas_swn_logger_step = 0;
		meas_csd_logger = 0;
		meas_csd_logger_step = 0;

		// parse field 1
		pointer = strtok((char*)_buffer, delimiters);
		if (pointer != NULL) meas_delay = atoi(pointer);

		// parse field 2
		pointer = strtok(NULL, delimiters);
		if (pointer != NULL) meas_integral = atoi(pointer);

		// parse field 3
		pointer = strtok(NULL, delimiters);
		if (pointer != NULL) meas_repeat = atoi(pointer);

		// parse field 4
		pointer = strtok(NULL, delimiters);
		if (pointer != NULL) meas_swn_logger = atoi(pointer);

		// parse field 5
		pointer = strtok(NULL, delimiters);
		if (pointer != NULL) meas_swn_logger_step = atoi(pointer);

		// parse field 6
		pointer = strtok(NULL, delimiters);
		if (pointer != NULL) meas_csd_logger = atoi(pointer);

		// parse field 7
		pointer = strtok(NULL, delimiters);
		if (pointer != NULL) meas_csd_logger_step = atoi(pointer);

		#if DEBUG_NLS_PRO > 1
		PRINT_CITIES_PRO("meas_delay: ");
		USB.println(meas_delay);
		PRINT_CITIES_PRO("meas_integral: ");
		USB.println(meas_integral);
		PRINT_CITIES_PRO("meas_repeat: : ");
		USB.println(meas_repeat);
		PRINT_CITIES_PRO("meas_swn_logger: ");
		USB.println(meas_swn_logger);
		PRINT_CITIES_PRO("meas_swn_logger_step: ");
		USB.println(meas_swn_logger_step);
		PRINT_CITIES_PRO("meas_csd_logger: ");
		USB.println(meas_csd_logger);
		PRINT_CITIES_PRO("meas_csd_logger_step: ");
		USB.println(meas_csd_logger_step);
		#endif

		return 0;
	}
	else if (answer == 2)
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("Sensor not recognized or wrong state");
		PRINT_CITIES_PRO("errorCode: ");
		USB.println(answer);
		PRINT_CITIES_PRO("RX[ASCII]: ");
		USB.println((char*)_buffer);
		#endif
		return 2;
	}
	else
	{
		#if DEBUG_CITIES_PRO > 0
		PRINTLN_CITIES_PRO("No answer from soundmeter");
		#endif
		return 1;
	}
}



// Instance of the class
noiseSensorClass2 noiseClass2 = noiseSensorClass2();
