/*! \file 	WaspLoRaWAN.h
    \brief 	Library for managing the LoRaWAN module

    Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L.
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

    Version:		3.0
    Implementation:	Luis Miguel Martí

*/

#ifndef LoRaWAN_h
#define LoRaWAN_h

/******************************************************************************
 * Includes
 ******************************************************************************/
#include <inttypes.h>
#include <WaspUART.h>

/******************************************************************************
 * Definitions & Declarations
 ******************************************************************************/

/*! @enum AnswerTypesLoRaWAN
 * API answer messages
 */
enum AnswerTypesLoRaWAN
{
	LORAWAN_ANSWER_OK = 0,
	LORAWAN_ANSWER_ERROR = 1,
	LORAWAN_NO_ANSWER = 2,
	LORAWAN_INIT_ERROR = 3,
	LORAWAN_LENGTH_ERROR = 4,
	LORAWAN_SENDING_ERROR = 5,
	LORAWAN_NOT_JOINED = 6,
	LORAWAN_INPUT_ERROR = 7,
	LORAWAN_VERSION_ERROR = 8
};


/*! @enum SubBandsLoRaWAN_AU_US
 * API answer messages
 */
enum SubBandsLoRaWAN_AU_US
{
	SUB_BAND_0 = 0,	//	0
	SUB_BAND_1,    	//	1
	SUB_BAND_2,    	//	2
	SUB_BAND_3,    	//	3
	SUB_BAND_4,    	//	4
	SUB_BAND_5,    	//	5
	SUB_BAND_6,    	//	6
	SUB_BAND_7,    	//	7
};


/*! @enum LoRaWAN_Region
 * API ABZ bands
 */
enum LoRaWAN_Region
{
	AS923 = 0,	//	0
	AU915,		//	1
	RFU1,		//	2
	RFU2,		//	3
	RFU3,		//	4
	EU868,		//	5
	KR920,		//	6
	IN865,		//	7
	US915,		//	8
};

/*! @enum LoRaWAN_Class
 * 
 */
enum LoRaWAN_Class
{
	CLASS_A = 0,	//	0
	CLASS_ND,
	CLASS_C,		//	2
};


/*! @enum LoRaWAN_Region
 * API ABZ bands
 */
enum NetworkType
{
	PRIVATE = 0,//	0
	PUBLIC,		//	1
};

/*! @enum LoRaWAN_Region
 * API ABZ bands
 */
enum ADR_Status
{
	ADR_OFF = 0,	//	0
	ADR_ON,			//	1
};

/*! @enum LoRaWAN_Region
 * API ABZ bands
 */
enum Join_Mode
{
	ABP = 0,	//	0
	OTAA,		//	1
};

/******************************************************************************
 * Class
 ******************************************************************************/
class WaspLoRaWAN : public WaspUART
{
	// private methods //////////////////////////
	private:
		#define RADIO_LORAWAN_UART_SIZE 300
		uint8_t class_buffer[RADIO_LORAWAN_UART_SIZE];

		char _command[250];

	// public methods //////////////////////////
    public:

		ADR_Status _adr;
		bool _ar;
		char _devEUI[17];
		char _appEUI[17];
		char _nwkSKey[33];
		char _appSKey[33];
		char _appKey[33];
		char _devAddr[9];
		LoRaWAN_Region _band;
		LoRaWAN_Class _class;
		uint8_t _retries;
		uint8_t _margin;
		uint8_t _gwNumber;
		uint32_t _freq[72];
		uint32_t _radioFreq;
		uint32_t _radioFreqDev;
		uint16_t _preambleLength;
		uint16_t _dCycle[16];
		uint8_t _drrMin[72];
		uint8_t _drrMax[72];
		uint8_t _dCyclePS;
		char _radioMode[5];
		bool _crcStatus;
		uint8_t _powerIndex;
		uint8_t _maxEIRP;
		uint8_t _dataRate;
		char _radioSF[5];
		float _radioRxBW;
		uint32_t _radioBitRate;
		char _radioCR[4];
		uint32_t _radioWDT;
		uint16_t _radioBW;
		bool _status[72];
		uint16_t _supplyPower;
		uint32_t _upCounter;
		uint32_t _downCounter;
		uint8_t _port;
		char _data[101];
		bool _dataReceived;
		uint8_t _rx2DataRate;
		uint32_t _rx2Frequency;
		uint16_t _joinRx1Delay;
		uint16_t _joinRx2Delay;
		uint16_t _rx1Delay;
		uint16_t _rx2Delay;
		uint32_t _macStatus;
		uint8_t _maxPayload;
		NetworkType _network = PUBLIC;	//Default mode is public in this module
		int8_t _rssi;
		int8_t _snr;

		uint8_t _OTAAError;

		uint8_t _dFormat = 0;
		uint8_t _dutyCycle;
		uint16_t _cst;
		int _rssith;

		// constructor
		WaspLoRaWAN()
		{
			// assign class pointer to UART buffer
			_buffer = class_buffer;
			_bufferSize = RADIO_LORAWAN_UART_SIZE;
			_OTAAError=1;
			_upCounter = 0;
			_downCounter = 0;

			// initialize _drrMin and _drrMax
			for (uint8_t i=0;i<72;i++)
			{
				_status[i] = false;
				_drrMin[i] = 0;
				_drrMax[i] = 5;
			}
		};

		// System functions
		uint8_t ON(uint8_t socket);
		uint8_t OFF();
		uint8_t reset();
		uint8_t factoryReset();
		uint8_t check();


		// LoRaWAN functions
		uint8_t setBand(LoRaWAN_Region band);
		uint8_t getBand();
		uint8_t setClass(LoRaWAN_Class lorawan_class);
		uint8_t getClass();
		uint8_t setDeviceAddr(char* addr);
		uint8_t getDeviceAddr();
		uint8_t getDeviceEUI();
		uint8_t setAppEUI(char* eui);
		uint8_t getAppEUI();
		uint8_t setNwkSessionKey(char* key);
		uint8_t setAppSessionKey(char* key);
		uint8_t setAppKey(char* key);
		uint8_t joinABP();
		uint8_t joinOTAA();
		uint8_t linkCheckRequest();
		void showChannelConfig();
		void showChannelStatus(uint8_t channel);
		uint8_t setPower(uint8_t index);
		uint8_t getPower();
		uint8_t setNetworkType(NetworkType sync);
		uint8_t getNetworkType();
		uint8_t setADR(ADR_Status state);
		uint8_t getADR();
		uint8_t setDataRate(uint8_t datarate);
		uint8_t getDataRate();
		uint8_t setJoinDelay(uint16_t delay);
		uint8_t setRX1Delay(uint16_t delay);
		uint8_t setRX2Parameters(uint8_t datarate, uint32_t frequency);
		uint8_t setDutyCycle(uint8_t state);
		uint8_t getDutyCycle();
		uint8_t sendConfirmed(uint8_t port, char* payload);
		uint8_t sendUnconfirmed(uint8_t port, char* payload);
		uint8_t sendConfirmed(uint8_t port, uint8_t* payload, uint16_t length);
		uint8_t sendUnconfirmed(uint8_t port, uint8_t* payload, uint16_t length);
		uint8_t getRSSI();
		uint8_t setMaxEIRP(uint8_t EIRP);
		uint8_t getMaxEIRP();
		uint8_t setThresholdRSSI(int rssi);
		uint8_t getThresholdRSSI();
		uint8_t setCST(uint16_t cst);
		uint8_t getCST();
		uint8_t setChannelFreq(uint8_t channel, uint32_t freq);
		uint8_t getChannelFreq(uint8_t channel);
		uint8_t setChannelDRRange(uint8_t channel, uint8_t minDR, uint8_t maxDR);
		uint8_t getChannelDRRange(uint8_t channel);
		uint8_t setChannelStatus(uint8_t channel, char* state);
		uint8_t getChannelStatus(uint8_t channel);
		uint8_t setChannelMask(SubBandsLoRaWAN_AU_US subband);
		uint8_t setRetries(uint8_t retries);
		uint8_t getRetries();
		uint8_t getGatewayNumber();
		uint8_t setUpCounter(uint32_t counter);
		uint8_t getUpCounter();
		uint8_t setDownCounter(uint32_t counter);
		uint8_t getDownCounter();
		void convertString(char* string2convert, char* outputString);
		void convertString(uint8_t* string2convert, char* outputString);
		uint8_t getRXDelay();
		uint8_t getRX2Parameters(char* band);
		uint8_t getRX2Parameters();
		uint8_t getMaxPayload();
		void showFirmwareVersion();

	private:
		// Utils
		uint8_t setMode(Join_Mode mode);
		uint32_t parseValue(uint8_t base);
		int32_t parseIntValue();
		float parseFloatValue();
		uint8_t setDataFormat(uint8_t format);
		uint8_t getDataFormat();

};

extern WaspLoRaWAN LoRaWAN;
#endif
