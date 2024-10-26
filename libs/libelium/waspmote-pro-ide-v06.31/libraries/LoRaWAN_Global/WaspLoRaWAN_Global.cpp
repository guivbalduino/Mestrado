/*
 *  Library for managing managing the LoRaWAN module
 *
 *  Copyright (C) 2022 Libelium Comunicaciones Distribuidas S.L.
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
 *  Version:		3.0
 *  Implementation:	Luis Miguel Martí
 */
#ifndef __WPROGRAM_H__
#include <WaspClasses.h>
#endif

#include "WaspLoRaWAN_Global.h"

/******************************************************************************
 * FLASH DEFINITIONS COMMANDS
 ******************************************************************************/
 const char command_00[]	PROGMEM	= 	"at+reboot\r";					
 const char command_01[]	PROGMEM	= 	"at+dev?\r";					
 const char command_02[]	PROGMEM	= 	"at+ver?\r";					
 const char command_03[]	PROGMEM	= 	"at\r";							      
 const char command_04[]	PROGMEM	= 	"at+facnew\r";					
 const char command_05[]	PROGMEM	= 	"at+deveui?\r";					
 const char command_06[]	PROGMEM	= 	"at+deveui=%s\r";					
 const char command_07[]	PROGMEM	= 	"at+rfparam?\r";					
 const char command_08[]	PROGMEM	= 	"at+mode=%u\r";					
 const char command_09[]	PROGMEM	= 	"at+join\r";					
 const char command_10[]	PROGMEM	= 	"at+pctx %u,%u\r%s";					
 const char command_11[]	PROGMEM	= 	"at+dformat=%u\r";					
 const char command_12[]	PROGMEM	= 	"at+band=%u\r";					
 const char command_13[]	PROGMEM	= 	"at+devaddr?\r";					
 const char command_14[]	PROGMEM	= 	"at+appeui?\r";					
 const char command_15[]	PROGMEM	= 	"at+nwkskey?\r";					
 const char command_16[]	PROGMEM	= 	"at+appskey?\r";					
 const char command_17[]	PROGMEM	= 	"at+appkey?\r";					
 const char command_18[]	PROGMEM	= 	"at+devaddr=%s\r";					
 const char command_19[]	PROGMEM	= 	"at+appeui=%s\r";					
 const char command_20[]	PROGMEM	= 	"at+nwkskey=%s\r";					
 const char command_21[]	PROGMEM	= 	"at+appskey=%s\r";					
 const char command_22[]	PROGMEM	= 	"at+appkey=%s\r";					
 const char command_23[]	PROGMEM	= 	"at+rfparam=%u,%lu,%u,%u\r";					
 const char command_24[]	PROGMEM	= 	"at+dr=%u\r";					
 const char command_25[]	PROGMEM	= 	"at+band?\r";					
 const char command_26[]	PROGMEM	= 	"at+dr?\r";						   
 const char command_27[]	PROGMEM	= 	"at+dwell=0,0\r";					
 const char command_28[]	PROGMEM	= 	"at+rfpower=%u,%u\r";					
 const char command_29[]	PROGMEM	= 	"at+rfpower?\r";					
 const char command_30[]	PROGMEM	= 	"at+putx %u,%u\r%s";					
 const char command_31[]	PROGMEM	= 	"at+adr?\r";					
 const char command_32[]	PROGMEM	= 	"at+adr=%u\r";					
 const char command_33[]	PROGMEM	= 	"at+rtynum?\r";					
 const char command_34[]	PROGMEM	= 	"at+rtynum=%u\r";					
 const char command_35[]	PROGMEM	= 	"at+lncheck\r";						
 const char command_36[]	PROGMEM	= 	"at+frmcnt?\r";					
 const char command_37[]	PROGMEM	= 	"at+frmcnt=%lu,%lu\r";					
 const char command_38[]	PROGMEM	= 	"at+rx2=%lu,%u\r";					
 const char command_39[]	PROGMEM	= 	"at+rx2?\r";					
 const char command_40[]	PROGMEM	= 	"at+delay=%d,%d,%d,%d\r";					
 const char command_41[]	PROGMEM	= 	"at+delay?\r";					
 const char command_42[]	PROGMEM	= 	"at+dformat?\r";					
 const char command_43[]	PROGMEM	= 	"at+msize?\r";					
 const char command_44[]	PROGMEM	= 	"at+chmask?\r";							
 const char command_45[]	PROGMEM	= 	"radio get rssi\r\n";						
 const char command_46[]	PROGMEM	= 	"at+dutycycle?\r";					
 const char command_47[]	PROGMEM	= 	"at+dutycycle=%u\r";					
 const char command_48[]	PROGMEM	= 	"at+cst?\r";					
 const char command_49[]	PROGMEM	= 	"at+cst=%u\r";					
 const char command_50[]	PROGMEM	= 	"at+rssith?\r";					
 const char command_51[]	PROGMEM	= 	"at+rssith=%d\r";					
 const char command_52[]	PROGMEM	= 	"at+rfq?\r";					
 const char command_53[]	PROGMEM	= 	"at+chmask=%s\r";	            
 const char command_54[]	PROGMEM	= 	"at+sleep?\r";	                
 const char command_55[]	PROGMEM	= 	"at+sleep=%u\r";	            
 const char command_56[]	PROGMEM	= 	"at+nwk=%u\r";	                
 const char command_57[]	PROGMEM	= 	"at+nwk?\r";	                
 const char command_58[]	PROGMEM	= 	"at+rfparam?\r";	            
 const char command_59[]	PROGMEM	= 	"at+maxeirp=%u\r";	            
 const char command_60[]	PROGMEM	= 	"at+maxeirp?\r";	            
 const char command_61[]	PROGMEM	= 	"at+class=%u\r";	            
 const char command_62[]	PROGMEM	= 	"at+class?\r";	 			      


const char* const table_LoRaWAN_COMMANDS[] PROGMEM=
{
	command_00,
	command_01,
	command_02,
	command_03,
	command_04,
	command_05,
	command_06,
	command_07,
	command_08,
	command_09,
	command_10,
	command_11,
	command_12,
	command_13,
	command_14,
	command_15,
	command_16,
	command_17,
	command_18,
	command_19,
	command_20,
	command_21,
	command_22,
	command_23,
	command_24,
	command_25,
	command_26,
	command_27,
	command_28,
	command_29,
	command_30,
	command_31,
	command_32,
	command_33,
	command_34,
	command_35,
	command_36,
	command_37,
	command_38,
	command_39,
	command_40,
	command_41,
	command_42,
	command_43,
	command_44,
	command_45,
	command_46,
	command_47,
	command_48,
	command_49,
	command_50,
	command_51,
	command_52,
	command_53,
	command_54,
	command_55,
	command_56,
	command_57,
	command_58,
	command_59,
	command_60,
	command_61,
	command_62,

};

/******************************************************************************
 * FLASH DEFINITIONS ANSWERS
 ******************************************************************************/
 const char answer_00[]	PROGMEM	=	"+EVENT=0,0";	
 const char answer_01[]	PROGMEM	=	"ABZ-093";		
 const char answer_02[]	PROGMEM	=	"+ERR=-1";		
 const char answer_03[]	PROGMEM	=	"+ERR=-2";		
 const char answer_04[]	PROGMEM	=	"+ERR=-3";		
 const char answer_05[]	PROGMEM	=	"+ERR=-4";		
 const char answer_06[]	PROGMEM	=	"+ERR=-5";		
 const char answer_07[]	PROGMEM	=	"+ERR=-6";		
 const char answer_08[]	PROGMEM	=	"+ERR=-7";		
 const char answer_09[]	PROGMEM	=	"+ERR=-8";		
 const char answer_10[]	PROGMEM	=	"+ERR=-9";		
 const char answer_11[]	PROGMEM	=	"+ERR=-10";		
 const char answer_12[]	PROGMEM	=	"+ERR=-11";		
 const char answer_13[]	PROGMEM	=	"+ERR=-12";		
 const char answer_14[]	PROGMEM	=	"+ERR=-13";		
 const char answer_15[]	PROGMEM	=	"+ERR=-14";		
 const char answer_16[]	PROGMEM	=	"+ERR=-14";		
 const char answer_17[]	PROGMEM	=	"+ERR=-16";		
 const char answer_18[]	PROGMEM	=	"+ERR=-17";		
 const char answer_19[]	PROGMEM	=	"+ERR=-18";		
 const char answer_20[]	PROGMEM	=	"+ERR=-19";		
 const char answer_21[]	PROGMEM	=	"+ERR=-20";		
 const char answer_22[]	PROGMEM	=	"+ERR=";		
 const char answer_23[]	PROGMEM	=	"+OK";			
 const char answer_24[]	PROGMEM	=	"+EVENT=0,1";	
 const char answer_25[]	PROGMEM	=	"+OK=";			
 const char answer_26[]	PROGMEM	=	"+EVENT=1,1";	
 const char answer_27[]	PROGMEM	=	"+ACK";			
 const char answer_28[]	PROGMEM	=	"+RECV=";		
 const char answer_29[]	PROGMEM	=	";%u,";			
 const char answer_30[]	PROGMEM	=	"+EVENT=2,";	
 const char answer_31[]	PROGMEM	=	"+ANS=2,";		
 const char answer_32[]	PROGMEM	=	"+EVENT=1,0";	
 const char answer_33[]	PROGMEM	=	"\r\n";		
 const char answer_34[]	PROGMEM	=	"on";		
 const char answer_35[]	PROGMEM	=	"off";		
 const char answer_36[]	PROGMEM	=	"\r\n,;";		




const char* const table_LoRaWAN_ANSWERS[] PROGMEM=
{
	answer_00,
	answer_01,
	answer_02,
	answer_03,
	answer_04,
	answer_05,
	answer_06,
	answer_07,
	answer_08,
	answer_09,
	answer_10,
	answer_11,
	answer_12,
	answer_13,
	answer_14,
	answer_15,
	answer_16,
	answer_17,
	answer_18,
	answer_19,
	answer_20,
	answer_21,
	answer_22,
	answer_23,
	answer_24,
	answer_25,
	answer_26,
	answer_27,
	answer_28,
	answer_29,
	answer_30,
	answer_31,
	answer_32,
	answer_33,
	answer_34,
	answer_35,
	answer_36,
	
};


/******************************************************************************
 * FLASH DEFINITIONS SUBBAND FOR AU AND US
 ******************************************************************************/
 const char subband_00[]	PROGMEM	=	"FF0000000000000001";		
 const char subband_01[]	PROGMEM	=	"00FF00000000000002";	
 const char subband_02[]	PROGMEM	=	"0000FF000000000004";	
 const char subband_03[]	PROGMEM	=	"000000FF0000000008";	
 const char subband_04[]	PROGMEM	=	"00000000FF00000010";	
 const char subband_05[]	PROGMEM	=	"0000000000FF000020";	
 const char subband_06[]	PROGMEM	=	"000000000000FF0040";	
 const char subband_07[]	PROGMEM	=	"00000000000000FF80";

const char* const table_sub_band[] PROGMEM=
{
	subband_00,
	subband_01,
	subband_02,
	subband_03,
	subband_04,
	subband_05,
	subband_06,
	subband_07,
	
};


/******************************************************************************
 * User API
 ******************************************************************************/


////////////////////////////////////////////////////////////////////////////////
// System functions
////////////////////////////////////////////////////////////////////////////////

/*!
 * @brief	This function powers on the module
 *
 * @param 	uint8_t	socket: socket to be used: SOCKET0 or SOCKET1
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::ON(uint8_t socket)
{
	uint8_t error;
	_baudrate = 19200;
	_uart = socket;

	// select multiplexer
    if (_uart == SOCKET0) 	Utils.setMuxSocket0();
    if (_uart == SOCKET1) 	Utils.setMuxSocket1();

	// Open UART
	beginUART();

    // power on the socket
    PWR.powerSocket(_uart, HIGH);

	delay(1000);
	error = check();
	
	getDeviceEUI();
	
	return error;
}

/*!
 * @brief	This function powers down the module
 *
 * @param 	uint8_t	socket: socket to be used: SOCKET0 or SOCKET1
 *
 * @return
 * 	@arg	'0' if OK
 */
uint8_t WaspLoRaWAN::OFF()
{

	// close uart
	closeUART();

	// unselect multiplexer
    if (_uart == SOCKET0) Utils.setMuxUSB();
    if (_uart == SOCKET1) Utils.muxOFF1();

	// switch module OFF
	PWR.powerSocket(_uart, LOW);

	return LORAWAN_ANSWER_OK;
}




/*!
 * @brief	This function resets and restart the stored internal configurations
 * 			will be loaded upon reboot and saves modules version.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *
 */
uint8_t WaspLoRaWAN::reset()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+reboot" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[0])));
	// create "+EVENT=0,0" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[0])));
	// create "+ERR=-1" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[2])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 1000);
	if (status == 1)
	{
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function resets the module's configuration data and user
 * 			EEPROM to factory default values, restarts the module and saves
 * 			modules version.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *
 */
uint8_t WaspLoRaWAN::factoryReset()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+facnew" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[4])));
	// create "+EVENT=0,0" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[0])));
	// create "+ERR=-1" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[2])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 5000);

	if (status == 1)
	{
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}



/*!
 * @brief	Checks if module is ready to use and saves which kind of
 * 			module has been plugged to Waspmote, either RN2483 or RN2903
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *
 */
uint8_t WaspLoRaWAN::check()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	char ans3[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+dev?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[1])));
	// create "ABZ-093" command
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[1])));
	// create "+ERR=-1" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[2])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2, 1000);

	if (status == 1)
	{
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}



/*!
 * @brief	Displays the module's firmware version via USB port
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *
 */
void WaspLoRaWAN::showFirmwareVersion()
{
    uint8_t status;
	char ans1[10];
    char ans2[10];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
    memset(ans2,0x00,sizeof(ans2));

	// create "at+ver?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[2])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,500);

	if (status == 1)
	{
		waitFor("\r\n", 500);
		USB.print(F("Firmware version: "));
		USB.print((char*)_buffer);
	}
}



////////////////////////////////////////////////////////////////////////////////
// LoRaWAN functions
////////////////////////////////////////////////////////////////////////////////

/*!
 * @brief	This function gets the MAC device EUI from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getDeviceEUI()
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+deveui?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[5])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		status = waitFor("\r\n", ans2, 500);

		char* pch = strtok((char*)_buffer,"\r\n");
		if (pch != NULL)
		{
			memset(_devEUI,0x00,sizeof(_devEUI));
			strncpy(_devEUI, pch, sizeof(_devEUI));
			USB.println(F("Device EUI: "));
			USB.println(_devEUI);
			return LORAWAN_ANSWER_OK;
		}
		else
		{
			//print error
			//~ waitFor("\r");
			//~ USB.print(F("Error: "));
			//~ USB.println((char*)_buffer);
			return LORAWAN_ANSWER_ERROR;
		}
	}
	else
	{
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function sets  MAC devAddress
 *
 * @param	char* addr: addr to be set
 *
 * @remarks	addr is a sequence of digit representing the value of addres
 * 			expressed in hexadecimal value (i.e. addr = 001A836D – address
 * 			is composed by the following byte stream: 0x00, 0x1A, 0x83, 0x6D
 * 			– 8 digit converted in 4 bytes).
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::setDeviceAddr(char* addr)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// check addr length
	if (strlen(addr)!=8) return LORAWAN_INPUT_ERROR;

	// check if addr is a hexadecimal string
	for (uint8_t i=0;i<8;i++)
	{
		if (((addr[i] < '0') || (addr[i] > '9')) &&
			((addr[i] < 'A') || (addr[i] > 'F')) &&
			((addr[i] < 'a') || (addr[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}

	// create "at+devaddr=" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[18])), addr);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(_devAddr,0x00,sizeof(_devAddr));
		strncpy(_devAddr,addr,sizeof(_devAddr));
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function gets the MAC device Address from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getDeviceAddr()
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+devaddr?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[13])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		status = waitFor("\r\n", ans2, 500);

		char* pch = strtok((char*)_buffer,"\r\n");
		if (pch != NULL)
		{
			memset(_devAddr,0x00,sizeof(_devAddr));
			strncpy(_devAddr, pch, sizeof(_devAddr));
			return LORAWAN_ANSWER_OK;
		}
		else
		{
			//print error
			//~ waitFor("\r");
			//~ USB.print(F("Error: "));
			//~ USB.println((char*)_buffer);
			return LORAWAN_ANSWER_ERROR;
		}
	}
	else
	{
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function sets  MAC Network Session Key
 *
 * @param	char* key: key to be set
 *
 * @remarks	key is a sequence of digit representing the value of NwkSKey
 * 			expressed in hexadecimal value (i.e. key = 000102030405060708091011121314
 *			32 digit converted in 16 bytes).
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::setNwkSessionKey(char* key)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// check key length
	if (strlen(key)!=32) return LORAWAN_INPUT_ERROR;

	// check if key is a hexadecimal string
	for (uint8_t i=0;i<32;i++)
	{
		if (((key[i] < '0') || (key[i] > '9')) &&
			((key[i] < 'A') || (key[i] > 'F')) &&
			((key[i] < 'a') || (key[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}

	// create "at+nwkskey=" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[20])), key);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(_nwkSKey,0x00,sizeof(_nwkSKey));
		strncpy(_nwkSKey,key,sizeof(_nwkSKey));
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function sets  MAC appEUI
 *
 * @param	char* EUI: EUI to be set
 *
 * @remarks	EUI is a sequence of digit representing the value of appEUI
 * 			expressed in hexadecimal value (i.e.: EUI = 0001020304050607
 *			16 digit converted in 8 bytes).
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::setAppEUI(char* eui)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// check eui length
	if (strlen(eui)!=16) return LORAWAN_INPUT_ERROR;

	//check if eui is a hexadecimal string
	for (uint8_t i=0;i<16;i++)
	{
		if (((eui[i] < '0') || (eui[i] > '9')) &&
			((eui[i] < 'A') || (eui[i] > 'F')) &&
			((eui[i] < 'a') || (eui[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}
	
	// create "at+appeui=" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[19])), eui);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(_appEUI,0x00,sizeof(_appEUI));
		strncpy(_appEUI,eui,sizeof(_appEUI));
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function gets the MAC AppEUI from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getAppEUI()
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+appeui?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[14])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		status = waitFor("\r\n", ans2, 500);

		char* pch = strtok((char*)_buffer,"\r\n");
		if (pch != NULL)
		{
			memset(_appEUI,0x00,sizeof(_appEUI));
			strncpy(_appEUI, pch, sizeof(_appEUI));
			return LORAWAN_ANSWER_OK;
		}
		else
		{
			return LORAWAN_ANSWER_ERROR;
		}
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function sets  MAC App Key
 *
 * @param	char* key: key to be set
 *
 * @remarks	key is a sequence of digit representing the value of AppKey
 * 			expressed in hexadecimal value (i.e.: key = 000102030405060708091011121314
 *			32 digit converted in 16 bytes).
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::setAppKey(char* key)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// check key length
	if (strlen(key)!=32) return LORAWAN_INPUT_ERROR;

	//check if key is a hexadecimal string
	for (uint8_t i=0;i<32;i++)
	{
		if (((key[i] < '0') || (key[i] > '9')) &&
			((key[i] < 'A') || (key[i] > 'F')) &&
			((key[i] < 'a') || (key[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}

	// create "at+appkey=" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[22])), key);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(_appKey,0x00,sizeof(_appKey));
		strncpy(_appKey,key,sizeof(_appKey));
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}




/*!
 * @brief	This function sets  MAC App Session Key
 *
 * @param	char* key: key to be set
 *
 * @remarks	key is a sequence of digit representing the value of AppSKey
 * 			expressed in hexadecimal value (i.e.: key = 000102030405060708091011121314
 *			32 digit converted in 16 bytes).
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::setAppSessionKey(char* key)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// check key length
	if (strlen(key)!=32) return LORAWAN_INPUT_ERROR;

	// check if key is a hexadecimal string
	for (uint8_t i=0;i<32;i++)
	{
		if (((key[i] < '0') || (key[i] > '9')) &&
			((key[i] < 'A') || (key[i] > 'F')) &&
			((key[i] < 'a') || (key[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}

	// create "at+appskey=" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[21])), key);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(_appSKey,0x00,sizeof(_appSKey));
		strncpy(_appSKey,key,sizeof(_appSKey));
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}




/*!
 * @brief	This function is used to configure the LoRaWAN RF power level
 *
 * @param	
 * uint8_t index: 
 *     		      AS923     AU915     EU868     KR920     IN865    US915
 *     		0:   16 dBm    20 dBm    14 dBm    14 dBm    20 dBm    N/A  
 *     		1:   14 dBm    18 dBm    12 dBm    12 dBm    18 dBm    N/A  
 *     		2:   12 dBm    16 dBm    10 dBm    10 dBm    16 dBm    N/A  
 *     		3:   10 dBm    14 dBm     8 dBm     8 dBm    14 dBm    N/A  
 *     		4:    8 dBm    12 dBm     6 dBm     6 dBm    12 dBm    N/A  
 *     		5:    6 dBm    10 dBm     4 dBm     4 dBm    10 dBm   20 dBm
 *     		6:    4 dBm     8 dBm     2 dBm     2 dBm     8 dBm   18 dBm
 *     		7:    2 dBm     6 dBm     0 dBm     0 dBm     6 dBm   16 dBm
 *     		8:    N/A       4 dBm     N/A       N/A       4 dBm   14 dBm
 *     		9:    N/A       2 dBm     N/A       N/A       2 dBm   12 dBm
 *     		10:   N/A       0 dBm     N/A       N/A       0 dBm   10 dBm
 * 
 * 
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'7' if input parameter error
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setPower(uint8_t index)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// Valid index from 0 to 10
	if (index > 10) return LORAWAN_INPUT_ERROR;
	// Valid index from 5 to 10 for US915
	if (index < 5 && _band == US915) return LORAWAN_INPUT_ERROR;
	// Valid index from 0 to 7 for AS923/AU915/EU868/KR920
	if (index > 7 && _band < IN865) return LORAWAN_INPUT_ERROR;

	getMaxEIRP();
	
	if (_maxEIRP == 30 && _band != US915) setMaxEIRP(20);
	
	if (_maxEIRP > 14)
	{
		// create "at+rfpower=1,%u\r" command
		sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[28])), 1, index);
		// create "+OK" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
		// create "+ERR=" answer
		sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

		//send command and wait for ans
		status = sendCommand(_command,ans1,ans2,100);
	}
	else
	{
		// create "at+rfpower=0,%u\r" command
		sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[28])), 0, index);
		// create "+OK" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
		// create "+ERR=" answer
		sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

		//send command and wait for ans
		status = sendCommand(_command,ans1,ans2,100);
	}

	if (status == 1)
	{
		_powerIndex = index;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to read the power index from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getPower()
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rfpower?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[29])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,100);
	if (status == 1)
	{
		waitFor(",",100);
		waitFor("\r",100);
	}

	if (status == 1)
	{
		_powerIndex = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to configure the LoRaWAN RF maximum
 * 			output power level
 *
 * @param	uint8_t EIRP in dBm
 *
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'7' if input parameter error
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setMaxEIRP(uint8_t EIRP)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+maxeirp=%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[59])), EIRP);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,100);

	if (status == 1)
	{
		_maxEIRP = EIRP;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to read the power index from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getMaxEIRP()
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+maxeirp?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[60])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,100);

	if (status == 1)
	{
		waitFor("\r\n");
		_maxEIRP = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to configure the LoRaWAN RF data rate
 *
 * @param	uint8_t index: data rate to be set
 * 		
 *	Band -> AS923
 *	@arg	0: SF = 12, BW = 125 kHz, BitRate =   250 bps
 *	@arg	1: SF = 11, BW = 125 kHz, BitRate =   440 bps
 *	@arg	2: SF = 10, BW = 125 kHz, BitRate =   980 bps
 *	@arg	3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
 *	@arg	4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
 *	@arg	5: SF =  7, BW = 125 kHz, BitRate =  5470 bps
 *	@arg	6: SF =  7, BW = 250 kHz, BitRate = 11000 bps
 *		
 *	Band -> AU915		
 *	@arg	0: SF = 12, BW = 125 kHz, BitRate =   250 bps
 *	@arg	1: SF = 11, BW = 125 kHz, BitRate =   440 bps
 *	@arg	2: SF = 10, BW = 125 kHz, BitRate =   980 bps
 *	@arg	3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
 *	@arg	4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
 *	@arg	5: SF =  7, BW = 125 kHz, BitRate =  5470 bps
 *	@arg	6: SF =  8, BW = 500 kHz, BitRate =  12500 bps
 *		
 *	Band -> EU868		
 *	@arg	0: SF = 12, BW = 125 kHz, BitRate =   250 bps
 *	@arg	1: SF = 11, BW = 125 kHz, BitRate =   440 bps
 *	@arg	2: SF = 10, BW = 125 kHz, BitRate =   980 bps
 *	@arg	3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
 *	@arg	4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
 *	@arg	5: SF =  7, BW = 125 kHz, BitRate =  5470 bps
 *	@arg	6: SF =  7, BW = 500 kHz, BitRate =  11000 bps
 *		
 *	Band -> KR920		
 *	@arg	0: SF = 12, BW = 125 kHz, BitRate =   250 bps
 *	@arg	1: SF = 11, BW = 125 kHz, BitRate =   440 bps
 *	@arg	2: SF = 10, BW = 125 kHz, BitRate =   980 bps
 *	@arg	3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
 *	@arg	4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
 *	@arg	5: SF =  7, BW = 125 kHz, BitRate =  5470 bps
 *		
 *	Band -> IN865		
 *	@arg	0: SF = 12, BW = 125 kHz, BitRate =   250 bps
 *	@arg	1: SF = 11, BW = 125 kHz, BitRate =   440 bps
 *	@arg	2: SF = 10, BW = 125 kHz, BitRate =   980 bps
 *	@arg	3: SF =  9, BW = 125 kHz, BitRate =  1760 bps
 *	@arg	4: SF =  8, BW = 125 kHz, BitRate =  3125 bps
 *	@arg	5: SF =  7, BW = 125 kHz, BitRate =  5470 bps
 *		
 *	Band -> US915		
 *	@arg	0: SF = 10, BW = 125 kHz, BitRate =   980 bps
 *	@arg	1: SF =  9, BW = 125 kHz, BitRate =  1760 bps
 *	@arg	2: SF =  8, BW = 125 kHz, BitRate =  3125 bps
 *	@arg	3: SF =  7, BW = 125 kHz, BitRate =  5470 bps
 *	@arg	4: SF =  8, BW = 500 kHz, BitRate =  12500 bps
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'7' if input parameter error
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setDataRate(uint8_t datarate)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));


	if (datarate > 7) return LORAWAN_INPUT_ERROR;

	// create "at+dr=%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[24])),datarate);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));
	
	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,300);

	if (status == 1)
	{
		_dataRate = datarate;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{	
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to read the data rate from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getDataRate()
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+dr?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[26])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_dataRate = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function configures the module join mode
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'3' if keys were not initiated
 */
uint8_t WaspLoRaWAN::setMode(Join_Mode mode)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	
	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+mode=<mode>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[8])),mode);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 1000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function joins module to a network
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'3' if keys were not initiated
 */
uint8_t WaspLoRaWAN::joinABP()
{
	setMode(ABP);
}


/*!
 * @brief	This function joins module to a network
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'3' if keys were not initiated
 */
uint8_t WaspLoRaWAN::joinOTAA()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	char ans3[15];
    char ans4[15];
	uint8_t dev_addr[] = {0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x00};
	uint8_t nwk_s_key[] = {0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x00};
	uint8_t app_s_key[] = {0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x00};

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));

	if (setMode(OTAA)) return LORAWAN_ANSWER_ERROR;
	
	// try to join via OTAA
	int retries = 3;
	do
	{
		memset(_command,0x00,sizeof(_command));
		memset(ans1,0x00,sizeof(ans1));
		memset(ans2,0x00,sizeof(ans2));
		memset(ans3,0x00,sizeof(ans3));

		// create "at+join" command
		sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[9])));
		// create "+EVENT=1,1" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[26])));
		// create "+EVENT=1,0" answer
		sprintf_P(ans3,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[32])));
		// create "+ERR" answer
		sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

		//send command and wait for ans
		status = sendCommand(_command, ans1, ans2, ans3, 15000);

		if (status == 1)
		{
			_OTAAError=0;
			delay(1000);
			return LORAWAN_ANSWER_OK;
		}
		else if (status == 2)
		{
			waitFor("\r\n");
			USB.print("Error: ");
			USB.println(_buffer, _bufferSize);
		}
		retries--;
		// Delay to avoid duty cycle transmission issues
		delay(5000);
	} while (retries > 0);
	
	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 3)
	{
		return LORAWAN_NOT_JOINED;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 *
 * @brief	This function sends a LoRaWAN packet and waits for ACK
 *
 * @param 	char* data:	data to be sent
 * 			uint8_t port: port number to send data
 *
 * @remarks	data is a sequence of digit representing the value of byte stream
 * 			expressed in hexadecimal value (i.e.: payload =12A435 – the payload
 * 			is composed by the following byte stream: 0x12, 0xA4, 0x35 – 6 digit
 * 			converted in 3 bytes). The maximum length of frame is 584 digit (292 Bytes).
 * 			User can check _datareceived to know if a downlink was performed
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'4' if data length error
 * 	@arg	'5' if error when sending data
 * 	@arg	'6' if module hasn't joined to a network
 *  @arg	'7' if input port parameter error
 */
uint8_t WaspLoRaWAN::sendConfirmed(uint8_t port, char* payload)
{
	uint8_t status;
	char ans1[20];
	char ans2[20];
	char ans3[20];
	char ans4[20];
	char carr[5];

	// clear data received flag
	_dataReceived = false;

	// clear buffers
	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));
	memset(ans4,0x00,sizeof(ans4));

	// check port
	if (port > 223) return LORAWAN_INPUT_ERROR;

	// check if payload is a hexadecimal string
	for (uint8_t i=0;i<strlen(payload);i++)
	{
		if (((payload[i] < '0') || (payload[i] > '9')) &&
			((payload[i] < 'A') || (payload[i] > 'F')) &&
			((payload[i] < 'a') || (payload[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}

	// create "at+pctx <port>,<length>\r<payload>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[10])),port,strlen(payload)/2,payload);
	// create "+ACK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[27])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 20000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));

		// create "+RECV=" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[28])));

		status = waitFor(ans1,200);

		if(status == 1)
		{
			waitFor("\r\n\r\n",500);

			char* pch = strtok((char*) _buffer,",");
			_port = atoi(pch);

			pch = strtok(NULL,"\r\n\r\n");
			int packetLength = atoi(pch);

			delay(100);
			readBuffer(packetLength*2);

			memset(_data,0x00,sizeof(_data));
			memcpy(_data, (char*) _buffer, sizeof(_data)-1);

			_dataReceived = true;
		}

		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 *
 * @brief	This function sends a LoRaWAN packet and waits for ACK
 *
 * @param 	char* data:	data to be sent
 * 			uint8_t port: port number to send data
 * 			uint16_t length: length of data array
 *
 * @remarks	data is a sequence of digit representing the value of byte stream
 * 			expressed in hexadecimal value (i.e.: payload =12A435 – the payload
 * 			is composed by the following byte stream: 0x12, 0xA4, 0x35 – 6 digit
 * 			converted in 3 bytes). The maximum length of frame is 584 digit (292 Bytes).
 * 			User can check _datareceived to know if a downlink was performed
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'4' if data length error
 * 	@arg	'5' if error when sending data
 * 	@arg	'6' if module hasn't joined to a network
 *  @arg	'7' if input port parameter error
 */
uint8_t WaspLoRaWAN::sendConfirmed(uint8_t port, uint8_t* payload, uint16_t length)
{
	uint8_t status;
	char ans1[20];
	char ans2[20];
	char ans3[20];
	char ans4[20];
	char byte2send[3];
	char carr[5];

	if (_dFormat != 1) setDataFormat(1);
	
	// clear data received flag
	_dataReceived = false;

	// clear buffers
	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));
	memset(ans4,0x00,sizeof(ans4));
	memset(byte2send,0x00,sizeof(byte2send));
	memset(carr,0x00,sizeof(carr));

	// check port
	if (port > 223) return LORAWAN_INPUT_ERROR;

	// create "at+pctx <port>,<length>\r<payload>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[10])),port,length*2,NULL);
	// create "+ACK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[27])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	printString(_command,_uart);
	for (uint16_t i=0; i<length;i++)
	{
		Utils.hex2str((uint8_t*)&payload[i], byte2send, 1);
		printByte(byte2send[0],_uart);
		printByte(byte2send[1],_uart);
	}
	status = waitFor(ans1, ans2, 20000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));

		// create "+RECV=" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[28])));

		status = waitFor(ans1,200);

		if(status == 1)
		{
			waitFor("\r\n\r\n",1000);

			char* pch = strtok((char*) _buffer,",");
			_port = atoi(pch);

			pch = strtok(NULL,"\r\n\r\n");
			int packetLength = atoi(pch);

			delay(100);
			readBuffer(packetLength*2);

			memset(_data,0x00,sizeof(_data));
			memcpy(_data, (char*) _buffer, sizeof(_data)-1);

			_dataReceived = true;
		}

		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 *
 * @brief	This function sends a LoRaWAN packet without ACK
 *
 * @param 	char* data:	data to be sent
 * 			uint8_t port: port number to send data
 *
 * @remarks	data is a sequence of digit representing the value of byte stream
 * 			expressed in hexadecimal value (i.e.: payload =12A435 – the payload
 * 			is composed by the following byte stream: 0x12, 0xA4, 0x35 – 6 digit
 * 			converted in 3 bytes). The maximum length of frame is 584 digit (292 Bytes).
 * 			User can check _datareceived to know if a downlink was performed
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'4' if data length error
 * 	@arg	'5' if error when sending data
 * 	@arg	'6' if module hasn't joined to a network
 *  @arg	'7' if input port parameter error
 */
uint8_t WaspLoRaWAN::sendUnconfirmed(uint8_t port, char* payload)
{
	uint8_t status;
	char ans1[20];
	char ans2[20];
	char ans3[20];
	char ans4[20];
	char carr[5];

	// clear data received flag
	_dataReceived = false;

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));
	memset(ans4,0x00,sizeof(ans4));

	// check port
	if (port > 223) return LORAWAN_INPUT_ERROR;

	// check if payload is a hexadecimal string
	for (uint8_t i=0;i<strlen(payload);i++)
	{
		if (((payload[i] < '0') || (payload[i] > '9')) &&
			((payload[i] < 'A') || (payload[i] > 'F')) &&
			((payload[i] < 'a') || (payload[i] > 'f')))
		{
			return LORAWAN_INPUT_ERROR;
		}
	}

	// create "at+putx <port>,<length>\r<payload>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[30])),port,strlen(payload)/2,payload);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 20000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));

		// create "+RECV=" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[28])));

		status = waitFor(ans1,200);

		if(status == 1)
		{
			waitFor("\r\n\r\n",1000);

			char* pch = strtok((char*) _buffer,",");
			_port = atoi(pch);

			pch = strtok(NULL,"\r\n\r\n");
			int packetLength = atoi(pch);

			delay(100);
			readBuffer(packetLength*2);

			memset(_data,0x00,sizeof(_data));
			memcpy(_data, (char*) _buffer, sizeof(_data)-1);

			_dataReceived = true;
		}

		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 *
 * @brief	This function sends a LoRaWAN packet and waits for ACK
 *
 * @param 	char* data:	data to be sent
 * 			uint8_t port: port number to send data
 * 			uint16_t length: length of data array
 *
 * @remarks	data is a sequence of digit representing the value of byte stream
 * 			expressed in hexadecimal value (i.e.: payload =12A435 – the payload
 * 			is composed by the following byte stream: 0x12, 0xA4, 0x35 – 6 digit
 * 			converted in 3 bytes). The maximum length of frame is 584 digit (292 Bytes).
 * 			User can check _datareceived to know if a downlink was performed
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'4' if data length error
 * 	@arg	'5' if error when sending data
 * 	@arg	'6' if module hasn't joined to a network
 *  @arg	'7' if input port parameter error
 */
uint8_t WaspLoRaWAN::sendUnconfirmed(uint8_t port, uint8_t* payload, uint16_t length)
{
	uint8_t status;
	char ans1[20];
	char ans2[20];
	char ans3[20];
	char ans4[20];
	char byte2send[3];
	char carr[5];

	if (_dFormat != 1) setDataFormat(1);

	// clear data received flag
	_dataReceived = false;

	// clear buffers
	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));
	memset(ans4,0x00,sizeof(ans4));
	memset(carr,0x00,sizeof(carr));
	memset(byte2send,0x00,sizeof(byte2send));

	// check port
	if (port > 223) return LORAWAN_INPUT_ERROR;

	// create "at+putx <port>,<length>\r<payload>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[30])),port,length*2,NULL);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	printString(_command,_uart);
	for (uint16_t i=0; i<length;i++)
	{
		Utils.hex2str((uint8_t*)&payload[i], byte2send, 1);
		printByte(byte2send[0],_uart);
		printByte(byte2send[1],_uart);
	}
	status = waitFor(ans1, ans2, 20000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));

		// create "+RECV=" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[28])));

		status = waitFor(ans1,200);

		if(status == 1)
		{
			waitFor("\r\n\r\n",1000);

			char* pch = strtok((char*) _buffer,",");
			_port = atoi(pch);

			pch = strtok(NULL,"\r\n\r\n");
			int packetLength = atoi(pch);

			delay(100);
			readBuffer(packetLength*2);

			memset(_data,0x00,sizeof(_data));
			memcpy(_data, (char*) _buffer, sizeof(_data)-1);

			_dataReceived = true;
		}

		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function is used to set the ADR status from module
 *
 * @param	char* state: "on"/"off"
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::setADR(ADR_Status state)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	// create "at+adr=<adr>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[32])),state);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_adr = state;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		waitFor("\r");
		USB.print(F("Error: "));
		USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function is used to read the ADR status from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getADR()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	char ans3[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));

	// create "at+adr?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[31])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_adr = (ADR_Status) parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function sets the frequency on the given channel ID
 *
 * @param	uint32_t freq: frequency to be set [863250000..869750000]
 * 											   [433250000..434550000]
 * 			uint8_t channel: channel to be set [3..15]
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 * 	@arg	'8' if module does not support function
 */
uint8_t WaspLoRaWAN::setChannelFreq(uint8_t channel, uint32_t freq)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	switch (_band)
	{
		case AS923:
			if (freq > 928000000) return LORAWAN_INPUT_ERROR;
			if (freq < 920600000) return LORAWAN_INPUT_ERROR;
			break;
			
		case AU915:
			return LORAWAN_INPUT_ERROR;
			break;
			
		case EU868:
			if (channel < 2) return LORAWAN_INPUT_ERROR;
			if (freq > 870000000) return LORAWAN_INPUT_ERROR;
			if (freq < 863000000) return LORAWAN_INPUT_ERROR;
			break;
			
		case KR920:
			if (freq > 923500000) return LORAWAN_INPUT_ERROR;
			if (freq < 917000000) return LORAWAN_INPUT_ERROR;
			break;
			
		case IN865:
			if (freq >= 867000000) return LORAWAN_INPUT_ERROR;
			if (freq < 865000000) return LORAWAN_INPUT_ERROR;
			break;
			
		case US915:
			return LORAWAN_INPUT_ERROR;
			break;
			
		default:
			break;
	}

	// create "at+rfparam=%u,%lu,%u,%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[23])),
														channel,
														freq,
														_drrMin[channel],
														_drrMax[channel]);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,300);

	if (status == 1)
	{
		_freq[channel] = freq;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_NO_ANSWER;
	}
}



/*!
 * @brief	This function gets the operating frequency on the given channel
 *
 * @param	uint8_t channel
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'7' if input parameter error
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::getChannelFreq(uint8_t channel)
{
	uint8_t status;
	char ans2[15];
	char ans1[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	if (channel > 15)
	{
		return LORAWAN_INPUT_ERROR;
	}

	// create "at+rfparam?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[7])));
	// create ";%u," answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[29])),channel);
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,"\r",10000);

	if (status == 1)
	{
		waitFor(",",100);

		_freq[channel] = parseValue(10);
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_NO_ANSWER;
	}
}




/*!
 * @brief	This function sets the data rate range on the given channel ID
 *
 * @param	uint8_t minDR: datarate to be set
 * 			uint8_t maxDR: datarate to be set
 * 			uint8_t channel: channel to be set
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'7' if input parameter error
 *	@arg	'8' unrecognized module
 */
uint8_t WaspLoRaWAN::setChannelDRRange(uint8_t channel, uint8_t minDR, uint8_t maxDR)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	
	getChannelDRRange(channel);
	
	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	
	switch (_band)
	{
		case AS923:
			if ((channel > 15) || (minDR > 7) || (maxDR > 7))
			return LORAWAN_INPUT_ERROR;
			break;
		case AU915:
			if ((channel > 64) || (minDR > 5) || (maxDR > 5))
			return LORAWAN_INPUT_ERROR;
			break;
		case EU868:
			if ((channel > 15) || (minDR > 5) || (maxDR > 5))
			return LORAWAN_INPUT_ERROR;
			break;
		case KR920:
			if ((channel > 15) || (minDR > 5) || (maxDR > 5))
			return LORAWAN_INPUT_ERROR;
			break;
		case IN865:
			if ((channel > 15) || (minDR > 5) || (maxDR > 5))
			return LORAWAN_INPUT_ERROR;
			break;
		case US915:
			if ((channel > 64) || (minDR > 5) || (maxDR > 5))
			return LORAWAN_INPUT_ERROR;
			break;
		default:
			return LORAWAN_INPUT_ERROR;
			break;
	}
	
	if ((channel > 15) || (minDR > 5) || (maxDR > 5))
	{
		return LORAWAN_INPUT_ERROR;
	}

	// create "at+rfparam=%u,%lu,%u,%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[23])),
														channel,
														_freq[channel],
														minDR,
														maxDR);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,300);

	if (status == 1)
	{
		_drrMin[channel] = minDR;
		_drrMax[channel] = maxDR;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function gets the data rate range on the given channel
 *
 * @param	uint8_t channel
 * 			For RN2483: channel [0..15]
 * 			For RN2903: channel [0..71]
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 *	@arg	'8' unrecognized module
 */
uint8_t WaspLoRaWAN::getChannelDRRange(uint8_t channel)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	if (channel > 15)
	{
		return LORAWAN_INPUT_ERROR;
	}

	// create "at+rfparam?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[7])));
	// create ";%u," answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[29])),channel);
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,"\r",3000);

	if (status == 1)
	{
		waitFor(",",100);
		// channel freq
		waitFor(",",100);
		_drrMin[channel] = parseValue(10);
		waitFor(",",100);
		_drrMax[channel] = parseValue(10);

		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function sets the status on the given subband
 *
 * @param	SubBandsLoRaWAN_AU_US subband:
 * 
 * 	@arg SUB_BAND_0	->	channels from 0 to 7 + 64
 * 	@arg SUB_BAND_1	->	channels from 8 to 15 + 65
 * 	@arg SUB_BAND_2	->	channels from 16 to 23 + 66
 * 	@arg SUB_BAND_3	->	channels from 24 to 31 + 67
 * 	@arg SUB_BAND_4	->	channels from 32 to 39 + 68
 * 	@arg SUB_BAND_5	->	channels from 40 to 47 + 69
 * 	@arg SUB_BAND_6	->	channels from 48 to 55 + 70
 * 	@arg SUB_BAND_7	->	channels from 56 to 63 + 71
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'7' if input parameter error
 *	@arg	'8' unrecognized module
 */
uint8_t WaspLoRaWAN::setChannelMask(SubBandsLoRaWAN_AU_US subband)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	char aux[18];
	
	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(aux,0x00,sizeof(aux));
	
	// create "at+rfparam=%s\r" command
	sprintf_P(aux,(char*)pgm_read_word(&(table_sub_band[subband])));
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[53])), aux);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,"\r",3000);

	if (status == 1)
	{
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function gets the status of the given channel
 *
 * @param	uint8_t channel
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'7' if input parameter error
 *	@arg	'8' unrecognized module
 */
uint8_t WaspLoRaWAN::getChannelStatus(uint8_t channel)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];
	char ans3[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	memset(ans3,0x00,sizeof(ans3));

	if (channel > 15)
	{
		return LORAWAN_INPUT_ERROR;
	}

	// create "at+chmask?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[44])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		waitFor("\r\n", 500);
		char* pch = strtok((char*)_buffer," \r\n");
		if (pch != NULL)
		{
			unsigned long int chmask_hex = strtoul(pch, NULL, 16);

			uint8_t lsb_mask = uint8_t (chmask_hex >> 8);
			uint8_t msb_mask = uint8_t (chmask_hex);

			chmask_hex = ((unsigned long int) msb_mask << 8) + lsb_mask;

			unsigned long int mask = 0x0001 << channel;

			if ((chmask_hex & mask) != 0)
			{
				_status[channel] = true;
				return LORAWAN_ANSWER_OK;
			}
			else
			{
				_status[channel] = false;
				return LORAWAN_ANSWER_OK;
			}
		}
		else
		{
			//print error
			//~ waitFor("\r");
			//~ USB.print(F("Error: "));
			//~ USB.println((char*)_buffer);
			return LORAWAN_ANSWER_ERROR;
		}
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function is used to configure number of retransmisions
 * 				for an uplink confirmed packet
 *
 * @param	uint8_t retries: number of retries [0..255]
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::setRetries(uint8_t retries)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rtynum=%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[34])), retries);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
	  return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_retries = retries;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function is used to read the power index from module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getRetries()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rtynum?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[33])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_retries = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}




/*!
 * @brief	This function gets current band of operation
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'8' module does not support function
 */
uint8_t WaspLoRaWAN::getBand()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+band?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[25])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);
		
		int band_aux = parseIntValue();
		
		_band = (LoRaWAN_Region) band_aux;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function gets the number of gateways that successfully
 * 			received the last Linck Check Request from the module
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getGatewayNumber()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+lncheck=0\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[35])));
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,300);

	if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));
		// create "+EVENT=2," answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[30])));

		waitFor(ans1,5000);
		waitFor("\r",100);

		if (parseValue(10) == 0)
		{
			_gwNumber = 0;
			_margin = 0;
			return LORAWAN_ANSWER_OK;
		}
		else
		{
			memset(ans1,0x00,sizeof(ans1));
			// create "+ANS=2," answer
			sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[31])));

			waitFor(ans1,5000);
			//get the margin
			waitFor(",",100);
			_margin = parseValue(10);

			//get the gateway number
			waitFor("\r",100);
			_gwNumber = parseValue(10);

			return LORAWAN_ANSWER_OK;
		}
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function sets the value of the uplink frame counter that will
 * 			be used for the next uplink transmission.
 *
 * @param	uint8_t counter:
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::setUpCounter(uint32_t counter)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+frmcnt=%lu,%lu\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[37])), counter, _downCounter);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
	  return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_upCounter = counter;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function is used to get the value of the uplink frame counter
 * 			that will be used for the next uplink transmission.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getUpCounter()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+frmcnt?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[36])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		waitFor(",",100);
		_upCounter = parseIntValue();

		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_downCounter = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function sets the value of the downlink frame counter that will
 * 			be used for the next downlink transmission.
 *
 * @param	uint8_t counter:
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::setDownCounter(uint32_t counter)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	
	// create "at+frmcnt=%lu,%lu\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[37])), _upCounter, counter);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_upCounter = counter;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function triggers the link check request feature and
 * 			stores the margin and number of gateways visible dor the 
 * 			module
 *
 * @param	uint8_t counter:
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::linkCheckRequest()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+lncheck\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[35])));
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "invalid_param" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,500);

	if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));
		// create "+EVENT=2" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[30])));
		waitFor(ans1,3000);
		if (status == 1)
		{
			status = (uint8_t)parseIntValue();
			switch (status)
			{
				case 0:
					USB.println(F("The link between modem and gateway is lost."));
					break;
				case 1:
					USB.println(F("The link between modem and gateway is connected."));
					break;
				case 2:
					USB.println(F("The modem doesn’t receive ACK for confirmed uplink message."));
					break;
			}
			
			memset(ans1,0x00,sizeof(ans1));
			// create "+ANS=2," answer
			sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[31])));
			
			// Discard "+ANS=2,"
			waitFor(ans1,5000);
			
			waitFor(",",100);
			_margin = parseValue(10);
			
			waitFor("\r",100);
			_gwNumber = parseValue(10);
			
			return LORAWAN_ANSWER_OK;
		}
		else if (status == 2)
		{
			return LORAWAN_ANSWER_ERROR;
		}
		else
		{
			return LORAWAN_NO_ANSWER;
		}
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to get the value of the downlink frame counter
 * 			that will be used for the next downlink transmission.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::getDownCounter()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+frmcnt?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[36])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		waitFor(",",100);
		_upCounter = parseIntValue();
		
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_downCounter = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}



/*!
 * @brief	This function sets data rate and frequency used for the
 * 			second receive window.
 *
 * @remarks	The configuration of the receive window parameters should
 * 			be in concordance with the server configuration
 *
 * @param	uint8_t datarate: datarate to be set [0..5]
 * 			uint32_t frequency: frequency to be set [863000000..870000000]
 * 													[433050000..434790000]
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'7' if input parameter error
 *	@arg	'8' unrecognized module
 */
uint8_t WaspLoRaWAN::setRX2Parameters(uint8_t datarate, uint32_t frequency)
{
	uint8_t status;
	float dutycycle;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	getBand();
	if (_band == 0)
	{
		if (frequency > 928000000 || frequency < 920600000) return LORAWAN_INPUT_ERROR;
	}
	if (_band == 6)
	{
		if (frequency < 920900000 || frequency > 923300000) return LORAWAN_INPUT_ERROR;
	}

	// create "at+rx2=%lu,%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[38])),frequency,datarate);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2);

	if (status == 1)
	{
		_rx2DataRate = datarate;
		_rx2Frequency = frequency;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function sets the delay used for the first receive window
 *
 * @param	uint16_t delay: delay to be set [0..65535]
 *
 * @remarks	The "dcycle" value that needs to be configured can be obtained
 * 			from the actual duty cycle X (in percentage) using the following formula:
 * 			dcycle = (100/X) – 1
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::setJoinDelay(uint16_t delay)
{
	uint8_t status;
	float dutycycle;
	char ans1[15];
	char ans2[15];

	getRXDelay();

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+delay=%d,%d,%d,%d\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[40])),
															delay,
															delay+1000, 
															_rx1Delay, 
															_rx2Delay);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERRR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2);

	if (status == 1)
	{
		_rx1Delay = delay;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function sets the delay used for the first receive window
 *
 * @param	uint16_t delay: delay to be set [0..65535]
 *
 * @remarks	The "dcycle" value that needs to be configured can be obtained
 * 			from the actual duty cycle X (in percentage) using the following formula:
 * 			dcycle = (100/X) – 1
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
uint8_t WaspLoRaWAN::setRX1Delay(uint16_t delay)
{
	uint8_t status;
	float dutycycle;
	char ans1[15];
	char ans2[15];

	getRXDelay();

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+delay=%d,%d,%d,%d\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[40])),
															_joinRx1Delay, 
															_joinRx2Delay, 
															delay,
															delay+1000);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERRR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2);

	if (status == 1)
	{
		_rx1Delay = delay;
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}



/*!
 * @brief	This function returns all channel status
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 */
void WaspLoRaWAN::showChannelConfig()
{
	uint8_t status;
	float dutycycle;
	char ans1[15];
	char ans2[15];
	uint8_t ch;

	for (uint8_t i=0; i<sizeof(_status); i++) _status[i] = false;

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rfparam?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[58])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERRR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2);

	if (status == 1)
	{
		waitFor(";");
		uint8_t num_channels = parseValue(10);
		
		for (uint8_t i = 0; i < num_channels; i++)
		{
			waitFor(",");
			ch = (uint8_t) parseValue(10);
			_status[ch] = true;
			waitFor(",");
			_freq[ch] = parseValue(10);
			waitFor(",");
			_drrMin[ch] = (uint8_t) parseValue(10);
			waitFor(";","\r\n");
			_drrMax[ch] = (uint8_t) parseValue(10);			
		}
	}
	
	USB.println(F("************************************************"));
	USB.println(F("****         Channel configuration          ****"));
	USB.println(F("************************************************"));
	
	for (uint8_t i = 0; i < sizeof(_status); i++)
	{
		if (_status[i] == true)
		{
			USB.printf("Channel number %u\t", i);
			USB.printf("Frequency: %lu\t", _freq[i]);
			USB.printf("DRR Min: %u\t", _drrMin[i]);
			USB.printf("DRR Max: %u\n", _drrMax[i]);	
		}
	}
	USB.println();
	USB.println();
	USB.println();
}



void WaspLoRaWAN::convertString(char* string2convert, char* outputString)
{
	Utils.hex2str((uint8_t*)string2convert, outputString, strlen(string2convert));
}

void WaspLoRaWAN::convertString(uint8_t* string2convert, char* outputString)
{
	Utils.hex2str(string2convert, outputString, strlen((char*)string2convert));
}


/*!
 * @brief	This function is used to get the first receive window delay
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *  @arg	'7' if input parameter error
 */
uint8_t WaspLoRaWAN::getRXDelay()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+delay?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[41])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,500);

	if (status == 1)
	{
		waitFor(",",100);
		_joinRx1Delay = parseIntValue();
		
		waitFor(",",100);
		_joinRx2Delay = parseIntValue();
		
		waitFor(",",100);
		_rx1Delay = parseIntValue();

		waitFor(",",100);
		_rx2Delay = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


uint8_t WaspLoRaWAN::getRX2Parameters()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rx2?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[39])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR=" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2);

	if (status == 1)
	{
		waitFor(",",100);
		_rx2Frequency = parseIntValue();
;
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[13])));
		
		waitFor(ans1,100);
		_rx2DataRate = parseIntValue();

		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function calculates the maximum payload for current settings
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 */
uint8_t WaspLoRaWAN::getMaxPayload()
{
	uint8_t error;
	_maxPayload = 0;

	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+msize?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[43])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_maxPayload = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function is used to configure the synchronization word
 *			for the LoRaWAN communication.
 *
 * @param	uint8_t sync: one byte long hexadecimal number that represents
 * 			the synchronization word
 */
uint8_t WaspLoRaWAN::setNetworkType(NetworkType network)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+nwk=%u\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[56])), network);
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,100);

	if (status == 1)
	{
		_network = network;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


/*!
 * @brief	This function is used to configure the synchronization word
 *			for the LoRaWAN communication.
 *
 * @param	uint8_t sync: one byte long hexadecimal number that represents
 * 			the synchronization word
 */
uint8_t WaspLoRaWAN::getNetworkType()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+nwk?\r" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[57])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1,ans2,100);

	if (status == 1) 
	{
		 if (parseValue(10) == 1)
		 {
			_network = PUBLIC;
		}
		else
		{
			_network = PRIVATE;
		}
		return LORAWAN_ANSWER_OK;
	}
	else if (status == 2)
	{
		return LORAWAN_ANSWER_ERROR;
	}
	else
	{
		return LORAWAN_NO_ANSWER;
	}
}


////////////////////////////////////////////////////////////////////////////////
// Private functions
////////////////////////////////////////////////////////////////////////////////

/*!
 * @brief	This function parses a value
 * @return	parsed value. '0' if nothing to parse
 */
uint32_t WaspLoRaWAN::parseValue(uint8_t base)
{
	char * pch;
	char carr[10];

	memset(carr,0x00,sizeof(carr));
	// create "\r\n,;" answer
	sprintf_P(carr,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[36])));
	
	pch = strtok((char*) _buffer, carr);
	if (pch != NULL)
	{
		return strtoul(pch,NULL, base);
	}
	return 0;
}


/*!
 * @brief	This function parses a int value
 * @return	parsed value. '0' if nothing to parse
 */
int32_t WaspLoRaWAN::parseIntValue()
{
	char * pch;
	char carr[10];

	memset(carr,0x00,sizeof(carr));
	// create "\r\n,;" answer
	sprintf_P(carr,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[36])));

	pch = strtok((char*) _buffer, carr);
	if (pch != NULL)
	{
		return atol(pch);
	}
	return 0;
}


/*!
 * @brief	This function parses a float value
 * @return	parsed value. '0' if nothing to parse
 */
float WaspLoRaWAN::parseFloatValue()
{
	char * pch;
	char carr[10];

	memset(carr,0x00,sizeof(carr));
	// create "\r\n,;" answer
	sprintf_P(carr,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[36])));

	pch = strtok((char*) _buffer, carr);
	if (pch != NULL)
	{
		return atof(pch);
	}
	return 0;
}


/*!
 * @brief	This function sets data format of sendings and receivin message.
 * Only for murata module.
 * 0: text ()default
 * 1: hex
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setDataFormat(uint8_t format)
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+dformat=<format>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[11])),format);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_dFormat = format;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function gets data format of sendings and receivin message.
 * Only for murata module.
 * 0: text ()default
 * 1: hex
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::getDataFormat()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+dformat?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[42])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_dFormat = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function configure the radio band.
 * Only for murata module.
 * 0: AS923
 * 1: AU915
 * 2, 3, 4: RFU
 * 5: EU868 (default)
 * 6: KR920
 * 7: IN865
 * 8: US915
 * 9: US915-HYBRID
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setBand(LoRaWAN_Region band)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));
	
	if ((band >= 2 && band <= 4) || band > 8) return LORAWAN_INPUT_ERROR;

	// create "at+band=<band>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[12])),band);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 1000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		memset(ans1,0x00,sizeof(ans1));

		// create "+EVENT=0,0" answer
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[0])));
		// create "+ERR" answer
		sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

		status = waitFor(ans1,ans2,10000);

		if (status == 0)
		{
			uint8_t error = getBand();
			if (error == 0)
			{
				if (band == _band) return LORAWAN_ANSWER_OK;
			}
			
			return LORAWAN_NO_ANSWER;
		}
		else if (status == 1)
		{
			_band = band;

			if (_band == AS923)
			{
				// give some time to the module after the previous event
				delay(10);

				// create "at+dwell=0,0" command
				sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[27])));
				// create "+OK" answer
				sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
				// create "+ERR" answer
				sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

				//send command and wait for ans
				status = sendCommand(_command,ans1, ans2, 1000);
			}

			if (status == 0)
			{
				return LORAWAN_NO_ANSWER;
			}
			else if (status == 1)
			{
				return LORAWAN_ANSWER_OK;
			}
			else
			{
				//print error
				//~ waitFor("\r");
				//~ USB.print(F("Error: "));
				//~ USB.println((char*)_buffer);
				return LORAWAN_ANSWER_ERROR;
			}
		}
		else
		{
			return LORAWAN_ANSWER_ERROR;
		}
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function configure duty cycle for EU868 band.
 * Only for murata module.
 * 0: off
 * 1: on (default)
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setDutyCycle(uint8_t state)
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

    // create "at+dutycycle=<state>" command
    sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[47])),state);
    // create "+OK" answer
    sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
    // create "+ERR" answer
    sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

    //send command and wait for ans
    status = sendCommand(_command,ans1, ans2, 500);

    if (status == 0)
    {
		return LORAWAN_NO_ANSWER;
    }
    else if (status == 1)
    {
		_dutyCycle = state;
		return LORAWAN_ANSWER_OK;
    }
    else
    {
		//print error
		waitFor("\r");
		USB.print(F("Error: "));
		USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
    }
}

/*!
 * @brief	This function gets duty cycle state for EU868 band.
 * Only for murata module.
 * 0: off
 * 1: on (default)
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::getDutyCycle()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+dutycycle?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[46])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_dutyCycle = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		waitFor("\r");
		USB.print(F("Error: "));
		USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function sets carrier sensor time (CST) used by LBT
 * Only for murata module.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setCST(uint16_t cst)
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+cst=<cst>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[49])), cst);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_cst = cst;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		waitFor("\r");
		USB.print(F("Error: "));
		USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function gets  carrier sensor time (CST) used by LBT
 * Only for murata module.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::getCST()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+cst?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[48])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_cst = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		waitFor("\r");
		USB.print(F("Error: "));
		USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function sets the threshold RSSI value used by LBT
 * Only for murata module.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setThresholdRSSI(int rssi)
{
	uint8_t status;
	char ans1[5];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rssith=<rssi>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[51])), rssi);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		_rssith = rssi;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

/*!
 * @brief	This function gets the threshold RSSI value used by LBT
 * Only for murata module.
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::getThresholdRSSI()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rssith?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[50])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);

		_rssith = parseIntValue();
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function gets current band of operation
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'8' module does not support function
 */
uint8_t WaspLoRaWAN::getRSSI()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+rfq?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[52])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" command
		waitFor(",");
		_rssi = (int8_t)parseIntValue();
		waitFor("\r\n\r\n");
		_snr = (int8_t)parseIntValue();
		
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function gets current band of operation
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 *	@arg	'8' module does not support function
 */
uint8_t WaspLoRaWAN::getClass()
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+class?" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[62])));
	// create "+OK=" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[25])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 500);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		// create "\r\n" answer
		memset(ans1,0x00,sizeof(ans1));
		sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[33])));

		waitFor(ans1,100);
		
		int lorawan_class = parseIntValue();
		
		_class = (LoRaWAN_Class) lorawan_class;
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}


/*!
 * @brief	This function configure the radio band.
 * Only for murata module.
 * 0: AS923
 * 1: AU915
 * 2, 3, 4: RFU
 * 5: EU868 (default)
 * 6: KR920
 * 7: IN865
 * 8: US915
 * 9: US915-HYBRID
 *
 * @return
 * 	@arg	'0' if OK
 * 	@arg	'1' if error
 * 	@arg	'2' if no answer
 * 	@arg	'8' if unrecognized module
 */
uint8_t WaspLoRaWAN::setClass(LoRaWAN_Class lorawan_class)
{
	uint8_t status;
	char ans1[15];
	char ans2[15];

	memset(_command,0x00,sizeof(_command));
	memset(ans1,0x00,sizeof(ans1));
	memset(ans2,0x00,sizeof(ans2));

	// create "at+class=<lorawan_class>" command
	sprintf_P(_command,(char*)pgm_read_word(&(table_LoRaWAN_COMMANDS[61])),lorawan_class);
	// create "+OK" answer
	sprintf_P(ans1,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[23])));
	// create "+ERR" answer
	sprintf_P(ans2,(char*)pgm_read_word(&(table_LoRaWAN_ANSWERS[22])));

	//send command and wait for ans
	status = sendCommand(_command,ans1, ans2, 1000);

	if (status == 0)
	{
		return LORAWAN_NO_ANSWER;
	}
	else if (status == 1)
	{
		return LORAWAN_ANSWER_OK;
	}
	else
	{
		//print error
		//~ waitFor("\r");
		//~ USB.print(F("Error: "));
		//~ USB.println((char*)_buffer);
		return LORAWAN_ANSWER_ERROR;
	}
}

// Preinstantiate Objects /////////////////////////////////////////////////////
WaspLoRaWAN LoRaWAN = WaspLoRaWAN();
