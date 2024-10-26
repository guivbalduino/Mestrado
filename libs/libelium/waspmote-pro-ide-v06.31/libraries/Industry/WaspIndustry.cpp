/*!	\file WaspIndustry.cpp
	\brief Library for managing the Industry sensor board

	Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L.
	http://www.libelium.com

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published by
	the Free Software Foundation, either version 2.1 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
	GNU Lesser General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program.	If not, see <http://www.gnu.org/licenses/>.

	Version:		3.0
*/

#ifndef __WPROGRAM_H__
#include "WaspClasses.h"
#endif


#include "WaspIndustry.h"


//! class constructor
WaspIndustry::WaspIndustry()
{
	// Update Waspmote Control Register
	WaspRegisterSensor |= REG_IND;

	// init variables
	// INDUSTRY MUX -> done in main.cpp
	//pinMode(MUX_EN, OUTPUT);
	//digitalWrite(MUX_EN, HIGH);

	// pin configuration
	pinMode(MUX_A, OUTPUT);
	pinMode(MUX_B, OUTPUT);
	digitalWrite(MUX_A, LOW);
	digitalWrite(MUX_B, LOW);

	// 3v3 pins of adgs
	pinMode(_3V3_SOCKETA, OUTPUT);
	digitalWrite(_3V3_SOCKETA, LOW);
	pinMode(_3V3_SOCKETB, OUTPUT);
	digitalWrite(_3V3_SOCKETB, LOW);
	pinMode(_3V3_SOCKETD, OUTPUT);
	digitalWrite(_3V3_SOCKETD, LOW);
	pinMode(_3V3_SOCKETE, OUTPUT);
	digitalWrite(_3V3_SOCKETE, LOW);

	// DC DC
	pinMode(IND_12V, OUTPUT);
	digitalWrite(IND_12V, LOW);

	// I2C isolators
	pinMode(EXPAN_ISO_EN, OUTPUT);
	digitalWrite(EXPAN_ISO_EN, LOW);
	pinMode(I2C_SOCKETA_EN, OUTPUT);
	digitalWrite(I2C_SOCKETA_EN, LOW);
	pinMode(I2C_SOCKETD_EN, OUTPUT);
	digitalWrite(I2C_SOCKETD_EN, LOW);

	// SPI isolator
	pinMode(SPI_ISO_EN, OUTPUT);
	digitalWrite(SPI_ISO_EN, LOW);

	// State registers
	socketRegister = 0;
	stateRegister12v = 0;
	redefinedSocket = 0;
}


// Private Methods /////////////////////////////////////////////////////////////





// Public Methods //////////////////////////////////////////////////////////////

/*!
	\brief Turns ON the Industry board
	\param void
	\return void
*/
void WaspIndustry::ON()
{
	ON(REG_5V & REG_3V3);
}



/*!
	\brief Turns ON the Industry board
	\param power select between 5V, 3V3 or both
	\return void
*/
void WaspIndustry::ON(uint8_t power)
{
	switch (power)
	{
		case REG_5V:
			PWR.setSensorPower(SENS_5V, SENS_ON);
			break;

		case REG_3V3:
			PWR.setSensorPower(SENS_3V3, SENS_ON);
			break;

		case (REG_5V & REG_3V3):
			PWR.setSensorPower(SENS_3V3, SENS_ON);
			PWR.setSensorPower(SENS_5V, SENS_ON);
			break;

		default:
			break;
	}
	delay(10);
}

/*!
	\brief Turns OFF the Industry board
	\param void
	\return void
*/
void WaspIndustry::OFF()
{
	//Only turn OFF 3V3 if every 12V register if OFF
	//3V3 is neccessary for 3v3 socket selecter pin expasor
	if (((WaspRegister & REG_3V3) != 0) && Industry.stateRegister12v == 0)
	{
#if DEBUG_IND == 2
		PRINTLN_IND(F("3V3 OFF"));
#endif
		PWR.setSensorPower(SENS_3V3, SENS_OFF);
	}
	if ((WaspRegister & REG_5V) != 0)
	{
#if DEBUG_IND == 2
		PRINTLN_IND(F("5V OFF"));
#endif
		PWR.setSensorPower(SENS_5V, SENS_OFF);
	}

}



/*!
	\brief Manages the 3v3 power supplies of Industry board
	\param socket socket to be powered
	\param state desired state of the selected power supply
	\return void
*/
void WaspIndustry::set3v3(uint8_t socket, uint8_t _state)
{

	if (_state == SWITCH_ON)
	{
		switch (socket)
		{
			case IND_SOCKET_A:
				digitalWrite(_3V3_SOCKETA, HIGH);
				break;

			case IND_SOCKET_B:
				digitalWrite(_3V3_SOCKETB, HIGH);
				break;

			case IND_SOCKET_D:
				digitalWrite(_3V3_SOCKETD, HIGH);
				break;

			case IND_SOCKET_E:
				digitalWrite(_3V3_SOCKETE, HIGH);
				break;

			default:
				break;
		}
	}
	else
	{
		switch (socket)
		{
			case IND_SOCKET_A:
				digitalWrite(_3V3_SOCKETA, LOW);
				break;

			case IND_SOCKET_B:
				digitalWrite(_3V3_SOCKETB, LOW);
				break;

			case IND_SOCKET_D:
				digitalWrite(_3V3_SOCKETD, LOW);
				break;

			case IND_SOCKET_E:
				digitalWrite(_3V3_SOCKETE, LOW);
				break;

			default:
				break;
		}
	}

}

/*!
	\brief Manages the 12v power supplies of Industry board
	\param state desired state
	\return void
*/
void WaspIndustry::set12v(uint8_t socket, uint8_t state)
{
	MCP23008 mcp;	// object to manage internal circuitry

	// enable I2C in pin expansor enabling isolator
	digitalWrite(EXPAN_ISO_EN, HIGH);
	delay(10);

	// enable DC-DC
	digitalWrite(IND_12V, HIGH);

	// Pin expander modes
	mcp.pinMode(IND_SOCKET_A, OUTPUT);
	mcp.pinMode(IND_SOCKET_B, OUTPUT);
	mcp.pinMode(IND_SOCKET_C, OUTPUT);
	mcp.pinMode(IND_SOCKET_D, OUTPUT);
	mcp.pinMode(IND_SOCKET_E, OUTPUT);
	mcp.pinMode(IND_SOCKET_F, OUTPUT);
	mcp.pinMode(MCP_GP0, INPUT);
	mcp.pinMode(MCP_GP1, INPUT);

	// update Industry.stateRegister12v
	if (state == SWITCH_ON)
	{
		//Industry.stateRegister12v update
		bitSet(Industry.stateRegister12v, socket);
	}
	else
	{
		//Industry.stateRegister12v update
		bitClear(Industry.stateRegister12v, socket);
	}

	// update every pin in expander
	for (int i = 2; i < 8; i++)
	{
		bool bit_state = bitRead(Industry.stateRegister12v, i);
		mcp.digitalWrite(i, bit_state);
	}

	uint8_t n = Industry.stateRegister12v;
	uint8_t sockets_on;

	while (n) {
        sockets_on += n & 1;
        n >>= 1;
    }

	// if all 12v supplies are ON print warning to avoid overcurrents.
	if (sockets_on > 2)
	{
		PRINTLN_IND(F("WARNING - Possible overcurrent, 12V is ON in more than two sockets"));
	}

	//If every 12V register if OFF, then turn OFF DC-DC
	if (Industry.stateRegister12v == 0)
	{
#if DEBUG_IND == 2
		PRINTLN_IND(F("12V OFF"));
#endif
		// disable DC-DC
		digitalWrite(IND_12V, LOW);
		delay(10);
	}

	// disable I2C in pin expansor disabling isolator
	digitalWrite(EXPAN_ISO_EN, LOW);
	delay(10);

}

/*!
	\brief Controls the on board multiplexor acording to socket selected
		OUT - socket - INPUT (A,B)
		Y0		- Data B -	(0,0)
		Y1		- Data C -	(1,0)
		Y2		- Data D -	(0,1)
		Y3		- Data A -	(1,1)
	\return void
*/
void WaspIndustry::setMux(uint8_t socket, uint8_t state)
{
	if (state == ENABLED)
	{
		// enable mux
		digitalWrite(MUX_EN, LOW);

		// set multiplexor according socket and turn on power if necessary
		switch (socket)
		{
			case IND_SOCKET_A:
				digitalWrite(MUX_A, HIGH);
				digitalWrite(MUX_B, HIGH);
				break;

			case IND_SOCKET_B:
				digitalWrite(MUX_A, LOW);
				digitalWrite(MUX_B, LOW);
				break;

			case IND_SOCKET_C:
				digitalWrite(MUX_A, HIGH);
				digitalWrite(MUX_B, LOW);
				break;

			case IND_SOCKET_D:
				digitalWrite(MUX_A, LOW);
				digitalWrite(MUX_B, HIGH);
				break;

			default:
				break;
		}
	}
	else
	{
		// disable mux
		digitalWrite(MUX_EN, HIGH);
	}

	delay(10);
}

/*!
	\brief Read the EEPROM memory serial number
	\param void
	\return 1 if OK, 0 otherwise.
*/
uint32_t WaspIndustry::readBoardSerialNumber()
{
	uint8_t manufacturer_code = 0;
	uint8_t device_code = 0;

	memset(boardSerialNumber, 0x00, sizeof(boardSerialNumber));

	uint8_t flag3v3 = 0;

	if ((WaspRegister & REG_3V3) == 0)
	{
		flag3v3 = 1;
		PWR.setSensorPower(SENS_3V3, SENS_ON);
	}

	// Enable EEPROM memory
	pinMode(EXPAN_ISO_EN, OUTPUT);
	digitalWrite(EXPAN_ISO_EN, HIGH);
	delay(100);

	I2C.begin();
	if (I2C.scan(ind_eeprom_address) == 0)
	{
		// Reading manufacturer code (should be 0x29)
		I2C.read(ind_eeprom_address, manufacturer_code_address, &manufacturer_code, 1);

		// Reading device code (should be 0x41)
		I2C.read(ind_eeprom_address, device_code_address, &device_code, 1);

		if ((manufacturer_code == 0x29) && (device_code == 0x41))
		{
			I2C.read(ind_eeprom_address, serial_number_address, boardSerialNumber, 4);

			// Disable EEPROM memory
			digitalWrite(EXPAN_ISO_EN, LOW);
			if (flag3v3)
			{
				PWR.setSensorPower(SENS_3V3, SENS_OFF);
			}

			return 1;
		}
	}

	// If here, there was an error while reading
	// Disable EEPROM memory
	digitalWrite(EXPAN_ISO_EN, LOW);
	if (flag3v3)
	{
		PWR.setSensorPower(SENS_3V3, SENS_OFF);
	}

	return 0;
}


/*!
	\brief Write the I2C EEPROM
	\param void
	\return 0 if OK, otherwise error.
*/
uint8_t WaspIndustry::writeEEPROM(uint8_t address, uint8_t value)
{
	uint8_t flag3v3 = 0;

	// reserved addresses below 0x50
	if ( address >= 0x50 )
	{
		if ((WaspRegister & REG_3V3) == 0)
		{
			flag3v3 = 1;
			PWR.setSensorPower(SENS_3V3, SENS_ON);
		}

		// Enable EEPROM memory
		pinMode(EXPAN_ISO_EN, OUTPUT);
		digitalWrite(EXPAN_ISO_EN, HIGH);
		delay(100);

		I2C.begin();
		if (I2C.scan(ind_eeprom_address) == 0)
		{
			int rv = I2C.write(ind_eeprom_address, address, value);

			digitalWrite(EXPAN_ISO_EN, LOW);
			if (flag3v3) {
				PWR.setSensorPower(SENS_3V3, SENS_OFF);
			}
			return rv;
		}
	}

	digitalWrite(EXPAN_ISO_EN, LOW);
	if (flag3v3) {
		PWR.setSensorPower(SENS_3V3, SENS_OFF);
	}
	return 1;
}

/*!
	\brief Read the I2C EEPROM
	\param void
	\return data if OK, otherwise -1.
*/
int8_t WaspIndustry::readEEPROM(uint8_t address)
{
	uint8_t flag3v3 = 0;

	if ((WaspRegister & REG_3V3) == 0)
	{
		flag3v3 = 1;
		PWR.setSensorPower(SENS_3V3, SENS_ON);
	}

	// Enable EEPROM memory
	pinMode(EXPAN_ISO_EN, OUTPUT);
	digitalWrite(EXPAN_ISO_EN, HIGH);
	delay(100);

	I2C.begin();
	if (I2C.scan(ind_eeprom_address) == 0)
	{
		uint8_t rdata = 0;
		I2C.read(ind_eeprom_address, address, &rdata, 1);

		digitalWrite(EXPAN_ISO_EN, LOW);
		if (flag3v3) {
			PWR.setSensorPower(SENS_3V3, SENS_OFF);
		}
		return rdata;
	}

	digitalWrite(EXPAN_ISO_EN, LOW);
	if (flag3v3) {
		PWR.setSensorPower(SENS_3V3, SENS_OFF);
	}
	return -1;
}



//******************************************************************************
// IndustryModbus Class functions
//******************************************************************************

/*	exampleModbusSensor Class constructor
	Parameters: void
	Return: void
*/
IndustryModbus::IndustryModbus(uint8_t _socket, uint8_t _sensorAddr) : ModbusMaster(RS232_COM, _sensorAddr)
{
	// store sensor location
	socket = _socket;
	sensorAddr = _sensorAddr;
}

/*!
	\brief Turns on the sensor
	\param void
	\return 1 if ok, 0 if something fails
*/
uint8_t IndustryModbus::ON()
{
	switch (socket)
	{
		case IND_SOCKET_E:
			Industry.ON(REG_3V3); //RS-485 only needs 3v3
			//Enable RS-485 chip on (shared with 3v3 pin)
			Industry.set3v3(socket, SWITCH_ON);
			break;
		case IND_SOCKET_F:
			Industry.ON(); //RS-232 needs both 3v3 and 5v
			//Enable RS-232 chip on
			Industry.set3v3(socket, SWITCH_ON);
			break;
		default:
			PRINTLN_IND(F("Error selecting socket"));
			break;
	}
	return 1;
}

/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void IndustryModbus::OFF()
{

	//Disable RS-485 chip on (shared with 3v3 pin)
	Industry.set3v3(socket, SWITCH_OFF);

	Industry.OFF();
}

/*! 
	\brief Reads the sensor data
	\param void
	\return void
*/
uint8_t IndustryModbus::read(uint16_t _registerAddr, uint16_t _numOfRegisters)
{
	initCommunication();
	delay(200);
	uint8_t status = 0xFF;
	uint8_t retries = 0;

	status =  readHoldingRegisters(_registerAddr, _numOfRegisters);
	
	if (status == 0)
	{
		uint8_t i=0;
		do
		{
			response[i] = getResponseBuffer(_numOfRegisters);
			i++; 
		}while (_numOfRegisters--);
	}
	else
	{
		#if DEBUG_IND > 0
			PRINTLN_IND(F("Error reading modbus value"));
		#endif

		return 1;
	}

	return status;
}


void IndustryModbus::initCommunication()
{

	// Modbus tipically uses 9600 bps speed communication
	begin(baudrate, 1);
	
	switch (socket)
	{
		case IND_SOCKET_E:
			// set Auxiliar2 socket
			Utils.setMuxAux2();
			break;
		case IND_SOCKET_F:
			// set Auxiliar2 socket
			Utils.setMuxAux1();
			break;
		default:
			break;
	}
	
	clearBuffer();
}


void IndustryModbus::setBaudrate(unsigned long _baudrate)
{
	// Modbus tipically uses 9600 bps speed communication
	baudrate = _baudrate;
}

/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void IndustryModbus::setPowerSocket(uint8_t state)
{
	//Turn off the sensor and the heater
	Industry.set12v(socket, state);
}

//!*************************************************************
//!	Name:	clearBuffer()
//!	Description: Flushes the buffers.
//!	Param : void
//!	Returns: void
//!*************************************************************
void IndustryModbus::clearBuffer()
{
	// Clear Response Buffer
	clearResponseBuffer();
	clearTransmitBuffer();
	delay(10);
}

//******************************************************************************
// Industry485 Class functions
//******************************************************************************

/*	exampleModbusSensor Class constructor
	Parameters: void
	Return: void
*/
Industry485::Industry485(unsigned long baudrate)
{
	// set baudrate
	_baudrate = baudrate;
	// set uart
	_uart = SOCKET1;
}


/*!
	\brief Turns on the sensor
	\param void
	\return 1 if ok, 0 if something fails
*/
uint8_t Industry485::ON()
{
	Industry.ON(REG_3V3); //RS-485 only needs 3v3
	//Enable RS-485 chip on (shared with 3v3 pin)
	Industry.set3v3(IND_SOCKET_E, SWITCH_ON);
	
	Utils.setMuxAux2();
	
	// Open UART
	beginUART();
	
    // wait stabilization time
	delay(100);
	
	// Configure the parity bit as disabled 
	parityBit(DISABLE);
	// Use one stop bit configuration 
	stopBitConfig(1); 
	
	return 1;
}


/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void Industry485::OFF()
{
	Wasp232::OFF();
	
	//Disable RS-485 chip on (shared with 3v3 pin)
	Industry.set3v3(IND_SOCKET_E, SWITCH_OFF);

	Industry.OFF();
}

/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void Industry485::setPowerSocket(uint8_t _state)
{
	//Turn off the sensor and the heater
	Industry.set12v(IND_SOCKET_E, _state);
}


//******************************************************************************
// Industry232 Class functions
//******************************************************************************

/*	exampleModbusSensor Class constructor
	Parameters: void
	Return: void
*/
Industry232::Industry232(unsigned long baudrate)
{
	// set baudrate
	_baudrate = baudrate;
	// set uart
	_uart = SOCKET1;
}


/*!
	\brief Turns on the sensor
	\param void
	\return 1 if ok, 0 if something fails
*/
uint8_t Industry232::ON()
{
	Industry.ON(); //RS-232 needs 3v3 and 5V
	//Enable RS-485 chip on (shared with 3v3 pin)
	Industry.set3v3(IND_SOCKET_F, SWITCH_ON);
	
	Utils.setMuxAux1();
	
	// Open UART
	beginUART();
	
    // wait stabilization time
	delay(100);
	
	
	// Configure the parity bit as disabled 
	parityBit(DISABLE);
	// Use one stop bit configuration 
	stopBitConfig(1); 
	
	return 1;
}


/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void Industry232::OFF()
{
	Wasp232::OFF();
	
	//Disable RS-485 chip on (shared with 3v3 pin)
	Industry.set3v3(IND_SOCKET_F, SWITCH_OFF);

	Industry.OFF();
}

/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void Industry232::setPowerSocket(uint8_t _state)
{
	//Turn off the sensor and the heater
	Industry.set12v(IND_SOCKET_F, _state);
}


//******************************************************************************
// IndustrySDI12 Class functions
//******************************************************************************

/*	exampleModbusSensor Class constructor
	Parameters: void
	Return: void
*/
IndustrySDI12::IndustrySDI12(uint8_t _socket): WaspSDI12(ANA2)
{
	// set baudrate
	socket = _socket;
}


/*!
	\brief Turns on the sensor
	\param void
	\return 1 if ok, 0 if something fails
*/
uint8_t IndustrySDI12::ON()
{
	if (socket == IND_SOCKET_E || socket == IND_SOCKET_F)
	{
		PRINTLN_IND(F("Socket error, SDI12 works on sockets A to D"));
		return 0;
	}
	
	//Before switching on 5v it's necessary disabling Mux (it works with 5V)
	Industry.setMux(socket, DISABLED);
	
	//SDI12 needs both 3v3 and 5v
	Industry.ON();
	
	//neccessary delay after powering the sensor
	delay(300);
	
	Industry.setMux(socket, ENABLED);
	
	return 1;
}


/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void IndustrySDI12::OFF()
{
	//Turn off the sensor and the heater
	Industry.set12v(socket, SWITCH_OFF);
	Industry.OFF();
}


/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void IndustrySDI12::setPowerSocket(uint8_t _state)
{
	//Turn off the sensor and the heater
	Industry.set12v(socket, _state);
}


//******************************************************************************
// 4-20mA Sensor Class functions
//******************************************************************************

/*!
	\brief 4-20mA Class constructor
	\param socket selected socket for sensor
*/
Industry_4_20::Industry_4_20(uint8_t _socket)
{
	socket = _socket;

	if (bitRead(Industry.socketRegister, socket) == 1)
	{
		//Redefinition of socket by two sensors detected
		Industry.redefinedSocket = 1;
	}
	else
	{
		bitSet(Industry.socketRegister, socket);
	}
}

/*!
	\brief Turns on the sensor
	\param void
	\return 1 if ok, 0 if something fails
*/
uint8_t Industry_4_20::ON()
{
	char message[70];

	if (Industry.redefinedSocket == 1)
	{
		USB.println(F("More than one sensor was declared in this socket, check your code"));
		return 0;
	}

	if ((socket == IND_SOCKET_A)
			|| (socket == IND_SOCKET_C)
			|| (socket == IND_SOCKET_D)
			|| (socket == IND_SOCKET_E))
	{
		PRINT_IND("WARNING - The following sensor can not work in the defined socket:");
		USB.println(F("4-20mA"));

		return 0;
	}

	Industry.ON(REG_3V3);
	Industry.set12v(socket, SWITCH_ON);

	//neccessary delay after powering the sensor
	delay(10);

	return 1;
}

/*!
	\brief Turns off the sensor
	\param void
	\return void
*/
void Industry_4_20::OFF()
{
	Industry.set12v(socket, SWITCH_OFF);
	Industry.OFF();
}


/*!
	\brief Reads the 4-20mA sensor
	\param void
	\return 0 if invalid data. Current value Otherwise.
*/
float Industry_4_20::read()
{
	LTC ltc;			// object to manage ADC

	//Enable SPI isolator for using the ADC
	digitalWrite(SPI_ISO_EN, HIGH);

	// ADC setup
	ltc.begin();


	// necessary for the sensor
	delay(10);

	if (socket == IND_SOCKET_F)
	{
		ltc.readADC(ADC_CH1);
		_current = ltc.readADC(ADC_CH1)*10.0;
	}
	else if (socket == IND_SOCKET_B)
	{
		ltc.readADC(ADC_CH0);
		_current = ltc.readADC(ADC_CH0)*10.0;
	}
	else
	{
#if DEBUG_IND == 1
		PRINT_IND(F("wrong 4.20 socket "));
		USB.println(socket, DEC);
#endif
		return 0;
	}

	//Disable SPI isolator for using the ADC
	digitalWrite(SPI_ISO_EN, LOW);

#if DEBUG_IND == 1
	PRINT_IND(F("4.20: "));
	USB.printFloat(_current, 4);
	USB.println();
#endif

	if ((_current < 0) || (_current > 20 ))
	{
#if DEBUG_IND == 1
		PRINTLN_IND(F("Unknown 4.20 error"));
#endif
		return 0;
	}
	else
	{
		return _current;
	}

}



// Preinstantiate Objects //////////////////////////////////////////////////////

WaspIndustry Industry = WaspIndustry();

////////////////////////////////////////////////////////////////////////////////
