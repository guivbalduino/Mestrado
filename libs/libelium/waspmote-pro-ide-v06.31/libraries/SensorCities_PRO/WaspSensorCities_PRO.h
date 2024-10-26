/*! \file WaspSensorCitiesPRO.h
    \brief Library for managing the Smart Cities PRO Sensor Board

    Copyright (C) 2018 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 2.1 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Version:		3.6
    Design:			David Gascón
    Implementation:	Alejandro Gállego, Ahmad Saad

 */


 /*! \def WaspSensorCitiesPRO_h
    \brief The library flag

  */
#ifndef WaspSensorCitiesPRO_h
#define WaspSensorCitiesPRO_h

/******************************************************************************
 * Includes
 ******************************************************************************/
#include <inttypes.h>
#include <WaspConstants.h>
#include <BME280.h>
#include <UltrasoundSensor.h>
#include <TSL2561.h>

#ifndef WaspSensorGas_Pro_h
#include <WaspSensorGas_Pro.h>
#endif

/******************************************************************************
 * Definitions & Declarations
 ******************************************************************************/
// I2C pins (sockets prepared for I2C connection)
#define SCP_I2C_MAIN_EN		ANA0 		// GP_I2C_MAIN_EN
#define SCP_I2C_SOCKET_1_C	DIGITAL4	// GP_I2C_SOCKET_1_C
#define SCP_I2C_SOCKET_3_F	DIGITAL8	// GP_I2C_SOCKET_3_F
#define SCP_I2C_SOCKET_5_B	ANA3		// GP_I2C_SOCKET_5_B

// PWR pins (sockets prepared for I2C connection)
#define SCP_PWR_SOCKET_1_C	DIGITAL3	// GP_PWR_SOCKET_1_C
#define SCP_PWR_SOCKET_3_F	DIGITAL7	// GP_PWR_SOCKET_3_F
#define SCP_PWR_SOCKET_5_B	ANA4		// GP_PWR_SOCKET_5_B

// PWR pins (to give power supply to socket)
#define SCP_PWR_3V3_SOCKET_1_C	ANA2
#define SCP_PWR_3V3_SOCKET_2_E	DIGITAL5
#define SCP_PWR_3V3_SOCKET_3_F	ANA5
#define SCP_PWR_3V3_SOCKET_4_A	ANA6
#define SCP_PWR_3V3_SOCKET_5_B	ANA1
#define NOISE_SENSOR_POWER_D DIGITAL1



//! DEBUG MODE
/*! 0: No debug mode enabled
 * 	1: debug mode enabled for error output messages
 * 	2: debug mode enabled for both error and ok messages
 */
#define DEBUG_CITIES_PRO		0

#define PRINT_CITIES_PRO(str)			USB.print(F("[CITIES_PRO] ")); USB.print(str);
#define PRINT_CITIES_PRO_VAL(val)		USB.print(float(val));
#define PRINTLN_CITIES_PRO(str)			USB.print(F("[CITIES_PRO] ")); USB.println(str);
#define PRINTLN_CITIES_PRO_VAL(val)		USB.println(float(val));


extern volatile uint8_t	pwrCitiesPRORegister;
extern volatile uint8_t	pwrGasPRORegister;

/******************************************************************************
 * Class
 ******************************************************************************/

//! WaspSensorCitiesPRO Class
/*!
	WaspSensorCitiesPRO Class defines all the variables and functions used for
	managing the Smart Cities PRO Sensor Board
 */
class WaspSensorCitiesPRO
{

private:

public:

	WaspSensorCitiesPRO();

	void ON(uint8_t socket_sensor);
	void OFF(uint8_t socket_sensor);

};

extern WaspSensorCitiesPRO SensorCitiesPRO;

#endif

/******************************************************************************
 * Class
 ******************************************************************************/
#ifndef NOISESENSORV2_H

#define LAF_MODE	0x00 //FAST MODE 125 ms
#define LAS_MODE	0x01 //SLOW MODE 1 second

class noiseSensorV2 : public WaspUART
{
	private:
		#define SENSOR_NOISE_UART_SIZE 20
		uint8_t class_buffer[SENSOR_NOISE_UART_SIZE];
		
	public:		
	
		uint8_t _socket;

		// Constructor
		noiseSensorV2(uint8_t sensor_socket);
		//Noise ON
		uint8_t ON();
		//Noise OFF
		void OFF();
		// Sound Pressure Level with A-Weighting
		float SPLA;
		// Noise Sensor Serial Number
		char SerialN[20];
		// Get a new measure of SPLA
		uint8_t get();
		// Get a new measure of SPLA with SLOW or FAST configuration
		uint8_t get(uint8_t);
		// Get a new measure of SPLA with EQUIVALENT configuration
		uint8_t getAverage(uint32_t);
		// Configure the UART for communicating with the sensor
		void configure();
		// Get serial number
		uint8_t getInfo();
		//Calibrate noise sensor
		uint8_t calibrate(char*);

};

extern noiseSensorV2 noiseV2;

#endif



/******************************************************************************
 * Class
 ******************************************************************************/
#ifndef NOISESENSOR_H

#define FAST_MODE	0x00
#define SLOW_MODE	0x01

class noiseSensor : public WaspUART
{
	private:
		#define SENSOR_NOISE_UART_SIZE 20
		uint8_t class_buffer[SENSOR_NOISE_UART_SIZE];
		
	public:		

		// Constructor
		noiseSensor();
		// Sound Pressure Level with A-Weighting
		float SPLA;
		// Get a new measure of SPLA
		uint8_t getSPLA();
		// Get a new measure of SPLA with SLOW or FAST configuration
		uint8_t getSPLA(uint8_t);
		// Configure the UART for communicating with the sensor
		void configure();

};

extern noiseSensor noise;

#endif




/******************************************************************************
 * Class
 ******************************************************************************/
#ifndef BME_CITIES_SENSOR_H

class bmeCitiesSensor: WaspSensorCitiesPRO
{
	private:
	public:

		uint8_t _socket;

		// Constructor
		bmeCitiesSensor(uint8_t socket);

		void ON();
		void OFF();

		float getTemperature();
		float getHumidity();
		float getPressure();
};


#endif



/******************************************************************************
 * Class
 ******************************************************************************/
#ifndef ULTRASOUND_CITIES_SENSOR_H

class ultrasoundCitiesSensor: WaspSensorCitiesPRO
{
	private:
	public:

		uint8_t _socket;

		// Constructor
		ultrasoundCitiesSensor(uint8_t socket);

		void ON();
		void OFF();
		uint16_t getDistance();
};


#endif



/******************************************************************************
 * Class
 ******************************************************************************/
#ifndef LUXES_CITIES_SENSOR_H

class luxesCitiesSensor: WaspSensorCitiesPRO
{
	private:
	public:

		uint8_t _socket;

		// Constructor
		luxesCitiesSensor(uint8_t socket);

		void ON();
		void OFF();
		uint32_t getLuminosity();
		uint32_t getLuminosity(bool gain);
		uint32_t getLuminosity(bool gain, uint8_t res);
};


#endif


/******************************************************************************
 * Class
 ******************************************************************************/
#ifndef NLS_class2_h
#define NLS_class2_h

/******************************************************************************
 * Includes
 ******************************************************************************/

/*! 0: Soundmeter not simulated (default)
 * 	1: Simulate Soundmeter (debug purposes)
 */
# define SIMULATE_SOUNDMETER 0

#define MAX_COMMAND_SIZE	50		// FIX:
#define MAX_PAYLOAD_SIZE	20		// FIX:

/* packet format -
 *
 *  FIELD:   | STX    |   ID   |  ATTR  | COMMAND 							|  EXT   |  BCC   |   CR   |   LF   |
 *  LENGTH:  | 1 byte | 1 byte | 1 byte |  n bit  							| 1 byte | 1 byte | 1 byte | 1 byte |
 *  EXAMPLE:   03				01			 43     44 53 4C 37 20 31 20 3F   03  		21  			0D  		0A
*/

const uint8_t STX PROGMEM = 0x02; // Start byte
const uint8_t ID PROGMEM = 0x01;  // Default Address
const uint8_t ATTR_COMMAND PROGMEM = 0x43;
const uint8_t ATTR_ANSWER = 0x41;
const uint8_t ATTR_ACK PROGMEM = 0x06;
const uint8_t ATTR_ERROR = 0x15;
const uint8_t EXT PROGMEM = 0x03; // End byte

const char DEFAULT_ANSWER[] = {STX, ID, ATTR_ANSWER, '\0'};
const char DEFAULT_ACK[] = {STX, ID, ATTR_ACK, '\0'};
const char DEFAULT_ERROR[] = {STX, ID, ATTR_ERROR, '\0'};
const char NLS_PRO_END_COMMAND[] = {'\r', '\n', '\0'}; //{EXT, BCC, '\r', '\n', '\0'};

/******************************************************************************
 * COMMANDS (FLASH Definitions)
 ******************************************************************************/
 // NOTE: Commands should not exceed MAX_PAYLOAD_SIZE
const char NLS2_command_00[]	PROGMEM = "DSL%u %u ?";					// Query data
const char NLS2_command_01[]	PROGMEM = "BAT?";						// Query BAT
const char NLS2_command_02[]	PROGMEM = "OPM?";						// Query Boot mode
const char NLS2_command_03[]	PROGMEM = "VER?";						// Query information
const char NLS2_command_04[]	PROGMEM = "RES";						// Restore Factory settings
const char NLS2_command_05[] 	PROGMEM = "STA%u";						// Start/Stop measurement
const char NLS2_command_06[]  	PROGMEM = "OPM%u";						// Set boot mode
const char NLS2_command_07[]  	PROGMEM = "BSE%u %u %u %u %u %u %u";	// Measurement configuration
const char NLS2_command_08[]  	PROGMEM = "DAT%u %u %u %u";				// Date configuration
const char NLS2_command_09[]  	PROGMEM = "DAT?";						// Query date
const char NLS2_command_10[]  	PROGMEM = "HOR%u %u %u";				// Time configuration
const char NLS2_command_11[]  	PROGMEM = "HOR?";						// Query time

const char* const table_NLS2[] PROGMEM =
{
	NLS2_command_00,
	NLS2_command_01,
	NLS2_command_02,
	NLS2_command_03,
	NLS2_command_04,
	NLS2_command_05,
	NLS2_command_06,
	NLS2_command_07,
	NLS2_command_08,
	NLS2_command_09,
	NLS2_command_10,
	NLS2_command_11,
};


class noiseSensorClass2 : public WaspUART
{
	private:

		#define SENSOR_NOISE_CLASS_2_UART_SIZE 100	//FIX: adjust size to save a few bytes
		uint8_t class_buffer[SENSOR_NOISE_CLASS_2_UART_SIZE];

		char command[MAX_COMMAND_SIZE];	//FIX: not needed. use _buffer to save MAX_COMMAND_SIZE bytes
		char payload[MAX_PAYLOAD_SIZE];

		// neccessary time for soundmeter initialization
		const uint32_t INIT_TIMEOUT = 25000;
		
		uint32_t classNumber;
		uint32_t serialNumber;
		char type[15];
		char version[15];
		char hwid[15];

		//! This function calculates the BCC field
		/*!
		\return		0 if not ready
					1 if  ready
		*/
		uint8_t getBCC(char* _aux, uint16_t lenght);

		//! Format a string to be sent, adding headers, CRC, etc.
		/*!
		\return		1 if ok. 0 if overflow in size
		*/
		uint8_t buildNLSCommand(char* _payload);

	public:

		// Constructor
		noiseSensorClass2();

		// Data variables, separated in groups
		// SPL - group 0
		float LAF;
		float LAS;
		float LAI;
		float LBF;
		float LBS;
		float LBI;
		float LCF;
		float LCS;
		float LCI;
		float LZF;
		float LZS;
		float LZI;
		// SD - group 1
		float LAFsd;
		float LASsd;
		float LAIsd;
		float LBFsd;
		float LBSsd;
		float LBIsd;
		float LCFsd;
		float LCSsd;
		float LCIsd;
		float LZFsd;
		float LZSsd;
		float LZIsd;
		// SEL - group 2
		float LAsel;
		float LBsel;
		float LCsel;
		float LZsel;
		// E - group 3
		float LAe;
		float LBe;
		float LCe;
		float LZe;
		// Max - group 4
		float LAFmax;
		float LASmax;
		float LAImax;
		float LBFmax;
		float LBSmax;
		float LBImax;
		float LCFmax;
		float LCSmax;
		float LCImax;
		float LZFmax;
		float LZSmax;
		float LZImax;
		// Min - group 5
		float LAFmin;
		float LASmin;
		float LAImin;
		float LBFmin;
		float LBSmin;
		float LBImin;
		float LCFmin;
		float LCSmin;
		float LCImin;
		float LZFmin;
		float LZSmin;
		float LZImin;
		// Peak - group 6
		float LApeak;
		float LBpeak;
		float LCpeak;
		float LZpeak;
		// Leq - group 7
		float LAeq;
		float LBeq;
		float LCeq;
		float LZeq;
		// LN - group 8
		float L10;
		float L20;
		float L30;
		float L40;
		float L50;
		float L60;
		float L70;
		float L80;
		float L90;
		float L99;

		// Turns ON the sensor and ensures communication
		uint8_t ON();
		
		// Soundometer version and info
		uint8_t getVersion();
	
		uint8_t setMeasurement(uint8_t mode);
		uint8_t getBootMode();
		
		uint8_t meas_delay;
		uint8_t meas_integral;
		uint16_t meas_repeat;
		uint8_t meas_swn_logger;
		uint8_t meas_swn_logger_step;
		uint8_t meas_csd_logger;
		uint8_t meas_csd_logger_step;
	
		// Read group of data
		uint8_t getData(uint8_t data_group);
		
		// Read data
		uint8_t getAllData();
		uint8_t getSPL();
		uint8_t getSD();
		uint8_t getSEL();
		uint8_t getE();
		uint8_t getMax();
		uint8_t getMin();
		uint8_t getPeak();
		uint8_t getLeq();
		uint8_t getLN();
		
		// Measurement setup
		uint8_t setMeasurementSetup(uint8_t delay, uint8_t integral, uint16_t repeat);
		uint8_t setMeasurementSetup(uint8_t delay, uint8_t integral, uint16_t repeat, uint8_t swn_logger, uint8_t swn_logger_step, uint8_t csd_logger, uint8_t csd_logger_step);
		uint8_t getMeasurementSetup();
		
		// Set integral period
		uint8_t setIntegralPeriod(uint8_t integral_period);

		// Configure the UART for communicating with the sensor
		void configure();
		
		// Configure PCE-428 with proper settings
		uint8_t configureSettings();
		uint8_t configureSettings(uint8_t delay, uint8_t integral, uint16_t repeat);
		uint8_t configureSettings(uint8_t integral);
		
		// Configure date and time
		uint16_t day;
		uint16_t month;
		uint32_t year;
		uint16_t hour;
		uint16_t minute;
		uint16_t second;
		uint8_t setDate(uint8_t dd, uint8_t mm, uint32_t yy);
		uint8_t getDate();
		uint8_t setTime(uint8_t h, uint8_t min, uint8_t sec);
		uint8_t getTime();
		void printDateTime();
		
		// Print Sensor information
		void printSensorInfo();

		// For debugging purposes
		void sendRawCommand(uint8_t* command, uint16_t length);
		
		// Groups of different data
		enum DataGroup
		{
			SPL_data = 0,
			SD_data = 1,
			SEL_data = 2,
			E_data = 3,
			Max_data = 4,
			Min_data = 5,
			Peak_data = 6,
			Leq_data = 7,
			LN_data = 8,
		};

		enum MeasurementMode
		{
			STA_START = 1,
			STA_STOP = 0,
		};

		enum BootMode
		{
			OPM_NORMAL = '0',
			OPM_POWER_AND_BOOT = '1',
			OPM_BOOT_AND_AUTOMEASURE = '2',
		};
	
};

extern noiseSensorClass2 noiseClass2;

#endif

