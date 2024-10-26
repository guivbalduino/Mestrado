/*! \file WaspIndustry.h
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

#ifndef WaspIndustry_h
#define WaspIndustry_h

/*******************************************************************************
 * Includes
 ******************************************************************************/

#include <inttypes.h>
#include "./utility/MCP23008.h"
#include "./utility/ADC.h"
#include <BME280.h>
#include <UltrasoundSensor.h>
#include <TSL2561.h>
#include <SDI12.h>
#include "ModbusMaster.h"
#include <WaspUtils.h>

/*******************************************************************************
 * Definitions
 ******************************************************************************/

/*!
 * \def DEBUG_IND
 * \brief Possible values:
 * 	0: No debug mode enabled
 * 	1: debug mode enabled for error output messages
 * 	2: debug mode enabled for both error and ok messages
 */

#define DEBUG_IND			0
#define PRINT_IND(str)		USB.print(F("[IND] ")); USB.print(str);
#define PRINTLN_IND(str)	USB.print(F("[IND] ")); USB.println(str);

//#define MANUFACTURER_TEST

// Generic _socket definitions according to MCP GPIOs
#define IND_SOCKET_A		7
#define IND_SOCKET_B		6
#define IND_SOCKET_C		5
#define IND_SOCKET_D		4
#define IND_SOCKET_E		3
#define IND_SOCKET_F		2

#define MCP_GP1				1		// Unconneted MCP GPIO
#define MCP_GP0				0		// Unconneted MCP GPIO


// PIN Expander definitions
#define EXPAN_ISO_EN 		17 		// ANALOG4 pin used as Digital
#define I2C_SOCKETA_EN		2		// DIGITAL1
#define I2C_SOCKETD_EN		14		// ANALOG1
#define SPI_ISO_EN			3		// DIGITAL0

#define IND_12V				8		// DIGITAL2


// 3V3 power on _sockets
#define _3V3_SOCKETA 		19
#define _3V3_SOCKETB 		18
#define _3V3_SOCKETD 		15
#define _3V3_SOCKETE		5


// SDI-12 mux
#define MUX_A				7		// DIGITAL5
#define MUX_B				9		// DIGITAL4
#define MUX_EN				20 		// ANA6


#define SWITCH_ON 			1
#define SWITCH_OFF 			0

#define ENABLED				1
#define DISABLED 			0


// ADC channel definition.
#define ADC_CH0				0		// 4-20 mA	(B)
#define ADC_CH1				1		// 4-20 mA	(F)


#define C21_LOW_POWER_MODE 0
#define C21_NORMAL_POWER_MODE 1
#define C21_DISTANCE_IN_M 0
#define C21_DISTANCE_IN_FT 1
#define C21_TEMPERATURE_IN_C 0
#define C21_TEMPERATURE_IN_F 1

// EEPROM constants
const uint8_t manufacturer_code_address = 0xFA;
const uint8_t device_code_address = 0xFB;
const uint8_t serial_number_address = 0xFC;
const uint8_t ind_eeprom_address = 0x51;


/*******************************************************************************
 * Industry Classes
 ******************************************************************************/

/*!
 * \class WaspIndustry
 * \brief class for Industry board
 */
class WaspIndustry
{
	public:
		//! Constructor
		WaspIndustry();

		/*
		* Bit:		| 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
		* _socket: 	| A | B | C | D | E | F | - | - |
		*/
		uint8_t socketRegister;					//variable to store information about _sockets used by sensors
		uint8_t stateRegister12v;				//variable to store information about _sockets with 12v enabled
		bool redefinedSocket;					//flag to detect redefinitions of _socket by more than one sensor
		uint32_t readBoardSerialNumber();
		uint8_t writeEEPROM(uint8_t address, uint8_t value);
		int8_t readEEPROM(uint8_t address);
		uint8_t boardSerialNumber[4];			//Serial number in Industry board

	 	void ON();
	 	void ON(uint8_t power);
	 	void OFF();
	 	void set3v3(uint8_t _socket, uint8_t _state);
	 	void set12v(uint8_t _socket, uint8_t _state);
	 	void setMux(uint8_t _socket, uint8_t _state);

	private:


};
extern WaspIndustry Industry;

/*******************************************************************************
 * Example for SDI-12 sensor Class
 ******************************************************************************/
/*!
 * \class Aqualabo NTU
 * \brief class for NTU sensor
 */
class IndustrySDI12: public WaspSDI12
{
	public:
		// constructor
		IndustrySDI12(uint8_t _socket);

		uint8_t ON();
		void OFF();
		uint8_t readSerialNumber();
		void setPowerSocket(uint8_t _state);

	private:
		uint8_t socket;

};


/*******************************************************************************
 * Example for 4-20mA sensor Class
 ******************************************************************************/
/*!
 * \class _4_20mA
 * \brief class to manage 4-20mA sensor
 */
class Industry_4_20
{
	public:
		//! Constructor
		Industry_4_20(uint8_t _socket);



		//! Variable: stores measured current in float type
		float _current;

		uint8_t ON();
		void OFF();
		float read();

	private:
		uint8_t socket;
};

/*******************************************************************************
 * Example for Modbus sensor Class
 ******************************************************************************/

class IndustryModbus : public ModbusMaster
{
	public:
		// constructor
		IndustryModbus(uint8_t _socket, uint8_t _sensorAddr);

		uint8_t ON();
		void OFF();
		uint8_t read(uint16_t _registerAddr, uint16_t _numOfRegisters);
		void setBaudrate(unsigned long _baudrate);
		
		uint8_t sensorAddr;
		uint8_t socket;
		uint16_t response[64];

		uint32_t value;
		uint32_t baudrate = 9600;
		
		// For Modbus management
		void initCommunication();
		void setPowerSocket(uint8_t _state);

	private:

		void clearBuffer();

		union
		{
			uint16_t uint16t[2];
			uint32_t uint32t;
		}
		conversion;
};


/*******************************************************************************
 * Example for Modbus sensor Class
 ******************************************************************************/

class Industry485 : public Wasp232
{
	public:
		// constructor
		Industry485(unsigned long _baudrate);

		uint8_t ON();
		void OFF();
		uint8_t read(uint16_t _registerAddr, uint16_t _numOfRegisters);
		void setBaudrate(uint32_t _baudrate);
		void setPowerSocket(uint8_t _state);

		uint32_t value;

	private:

		void clearBuffer();
};



/*******************************************************************************
 * Example for Modbus sensor Class
 ******************************************************************************/

class Industry232 : public Wasp232
{
	public:
		// constructor
		Industry232(unsigned long _baudrate);

		uint8_t ON();
		void OFF();
		uint8_t read(uint16_t _registerAddr, uint16_t _numOfRegisters);
		void setBaudrate(uint32_t _baudrate);
		void setPowerSocket(uint8_t _state);
		
		uint32_t value;

	private:

		void clearBuffer();
};



#endif
