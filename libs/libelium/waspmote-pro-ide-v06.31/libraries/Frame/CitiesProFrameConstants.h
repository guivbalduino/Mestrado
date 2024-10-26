/*! \file CitiesProFrameConstants.h
    \brief Header file for Smart Cities Pro Frame Constants

    Copyright (C) 2021 Libelium Comunicaciones Distribuidas S.L.
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

    Version:		1.0

*/

#ifndef CitiesProFrameConstants_h
#define CitiesProFrameConstants_h

#include <avr/pgmspace.h>

////////////////////////////////////////////////////////////////////////////////
// Cities PRO v30 frame definitions
////////////////////////////////////////////////////////////////////////////////

#define SENSOR_CITIES_PRO_CO					0
#define SENSOR_CITIES_PRO_CO2					1
#define SENSOR_CITIES_PRO_O2					2
#define SENSOR_CITIES_PRO_CH4					3
#define SENSOR_CITIES_PRO_O3 					4
#define SENSOR_CITIES_PRO_NH3					5
#define SENSOR_CITIES_PRO_NO2					6
#define SENSOR_CITIES_PRO_NO 					12
#define SENSOR_CITIES_PRO_CL2					13
#define SENSOR_CITIES_PRO_ETO					14
#define SENSOR_CITIES_PRO_H2 					15
#define SENSOR_CITIES_PRO_H2S					16
#define SENSOR_CITIES_PRO_HCL					17
#define SENSOR_CITIES_PRO_HCN					18
#define SENSOR_CITIES_PRO_PH3					19
#define SENSOR_CITIES_PRO_SO2					20
#define SENSOR_CITIES_PRO_NOISE					21
#define SENSOR_CITIES_PRO_SOCKET_B				31
#define SENSOR_CITIES_PRO_SOCKET_C				32
#define SENSOR_CITIES_PRO_SOCKET_F				35
#define SENSOR_CITIES_PRO_PM1					70
#define SENSOR_CITIES_PRO_PM2_5					71
#define SENSOR_CITIES_PRO_PM10					72
#define SENSOR_CITIES_PRO_TC					74
#define SENSOR_CITIES_PRO_TF					75
#define SENSOR_CITIES_PRO_HUM					76
#define SENSOR_CITIES_PRO_PRES					77
#define SENSOR_CITIES_PRO_LUXES					78
#define SENSOR_CITIES_PRO_US					79
#define SENSOR_CITIES_PRO_NLS2_LAF				100
#define SENSOR_CITIES_PRO_NLS2_LAS				101
#define SENSOR_CITIES_PRO_NLS2_LAI				102
#define SENSOR_CITIES_PRO_NLS2_LBF				103
#define SENSOR_CITIES_PRO_NLS2_LBS				104
#define SENSOR_CITIES_PRO_NLS2_LBI				105
#define SENSOR_CITIES_PRO_NLS2_LCF				106
#define SENSOR_CITIES_PRO_NLS2_LCS				107
#define SENSOR_CITIES_PRO_NLS2_LCI				108
#define SENSOR_CITIES_PRO_NLS2_LZF				109
#define SENSOR_CITIES_PRO_NLS2_LZS				110
#define SENSOR_CITIES_PRO_NLS2_LZI				111
#define SENSOR_CITIES_PRO_NLS2_LAFSD			112
#define SENSOR_CITIES_PRO_NLS2_LASSD			113
#define SENSOR_CITIES_PRO_NLS2_LAISD			114
#define SENSOR_CITIES_PRO_NLS2_LBFSD			115
#define SENSOR_CITIES_PRO_NLS2_LBSSD			116
#define SENSOR_CITIES_PRO_NLS2_LBISD			117
#define SENSOR_CITIES_PRO_NLS2_LCFSD			118
#define SENSOR_CITIES_PRO_NLS2_LCSSD			119
#define SENSOR_CITIES_PRO_NLS2_LCISD			120
#define SENSOR_CITIES_PRO_NLS2_LZFSD			121
#define SENSOR_CITIES_PRO_NLS2_LZSSD			122
#define SENSOR_CITIES_PRO_NLS2_LZISD			123
#define SENSOR_CITIES_PRO_NLS2_LASEL			124
#define SENSOR_CITIES_PRO_NLS2_LBSEL			125
#define SENSOR_CITIES_PRO_NLS2_LCSEL			126
#define SENSOR_CITIES_PRO_NLS2_LZSEL			127
#define SENSOR_CITIES_PRO_NLS2_LAE				128
#define SENSOR_CITIES_PRO_NLS2_LBE				129
#define SENSOR_CITIES_PRO_NLS2_LCE				130
#define SENSOR_CITIES_PRO_NLS2_LZE				131
#define SENSOR_CITIES_PRO_NLS2_LAFMAX			132
#define SENSOR_CITIES_PRO_NLS2_LASMAX			133
#define SENSOR_CITIES_PRO_NLS2_LAIMAX			134
#define SENSOR_CITIES_PRO_NLS2_LBFMAX			135
#define SENSOR_CITIES_PRO_NLS2_LBSMAX			136
#define SENSOR_CITIES_PRO_NLS2_LBIMAX			137
#define SENSOR_CITIES_PRO_NLS2_LCFMAX			138
#define SENSOR_CITIES_PRO_NLS2_LCSMAX			139
#define SENSOR_CITIES_PRO_NLS2_LCIMAX			140
#define SENSOR_CITIES_PRO_NLS2_LZFMAX			141
#define SENSOR_CITIES_PRO_NLS2_LZSMAX			142
#define SENSOR_CITIES_PRO_NLS2_LZIMAX			143
#define SENSOR_CITIES_PRO_NLS2_LAFMIN			144
#define SENSOR_CITIES_PRO_NLS2_LASMIN			145
#define SENSOR_CITIES_PRO_NLS2_LAIMIN			146
#define SENSOR_CITIES_PRO_NLS2_LBFMIN			147
#define SENSOR_CITIES_PRO_NLS2_LBSMIN			148
#define SENSOR_CITIES_PRO_NLS2_LBIMIN			149
#define SENSOR_CITIES_PRO_NLS2_LCFMIN			150
#define SENSOR_CITIES_PRO_NLS2_LCSMIN			151
#define SENSOR_CITIES_PRO_NLS2_LCIMIN			152
#define SENSOR_CITIES_PRO_NLS2_LZFMIN			153
#define SENSOR_CITIES_PRO_NLS2_LZSMIN			154
#define SENSOR_CITIES_PRO_NLS2_LZIMIN			155
#define SENSOR_CITIES_PRO_NLS2_LAPEAK			156
#define SENSOR_CITIES_PRO_NLS2_LBPEAK			157
#define SENSOR_CITIES_PRO_NLS2_LCPEAK			158
#define SENSOR_CITIES_PRO_NLS2_LZPEAK			159
#define SENSOR_CITIES_PRO_NLS2_LAEQ				160
#define SENSOR_CITIES_PRO_NLS2_LBEQ				161
#define SENSOR_CITIES_PRO_NLS2_LCEQ				162
#define SENSOR_CITIES_PRO_NLS2_LZEQ				163
#define SENSOR_CITIES_PRO_NLS2_L10				164
#define SENSOR_CITIES_PRO_NLS2_L20				165
#define SENSOR_CITIES_PRO_NLS2_L30				166
#define SENSOR_CITIES_PRO_NLS2_L40				167
#define SENSOR_CITIES_PRO_NLS2_L50				168
#define SENSOR_CITIES_PRO_NLS2_L60				169
#define SENSOR_CITIES_PRO_NLS2_L70				170
#define SENSOR_CITIES_PRO_NLS2_L80				171
#define SENSOR_CITIES_PRO_NLS2_L90				172
#define SENSOR_CITIES_PRO_NLS2_L99				173
#define SENSOR_CITIES_PRO_NLS2_INT_PER			174
#define SENSOR_CITIES_PRO_PM_BIN     			190
#define SENSOR_CITIES_PRO_PM_BINL     			191
#define SENSOR_CITIES_PRO_PM_BINH     			192
#define SENSOR_CITIES_PRO_NOISE_V2     			193

/// Flash defines //////////////////////////////////////////////////////////////

/*******************************************************************************
 * The following Flash strings define the tags for Noise Level Sensor class 2.
 * These TAGs are used in ASCII frames in order to indicate every sensor field
 * that has been included inside the frame.
 ******************************************************************************/


// Cities PRO sensors
const char	cities_pro_frame_00[] 	PROGMEM	= "CO";
const char 	cities_pro_frame_01[] 	PROGMEM	= "CO2";
const char 	cities_pro_frame_02[] 	PROGMEM	= "O2";
const char 	cities_pro_frame_03[] 	PROGMEM	= "CH4";
const char 	cities_pro_frame_04[] 	PROGMEM	= "O3";
const char 	cities_pro_frame_05[] 	PROGMEM	= "NH3";
const char 	cities_pro_frame_06[] 	PROGMEM	= "NO2";
const char 	cities_pro_frame_07[] 	PROGMEM	= "NO";
const char 	cities_pro_frame_08[] 	PROGMEM	= "CL2";
const char 	cities_pro_frame_09[] 	PROGMEM	= "ETO";
const char 	cities_pro_frame_10[] 	PROGMEM	= "H2";
const char 	cities_pro_frame_11[] 	PROGMEM	= "H2S";
const char 	cities_pro_frame_12[] 	PROGMEM	= "HCL";
const char 	cities_pro_frame_13[] 	PROGMEM	= "HCN";
const char 	cities_pro_frame_14[] 	PROGMEM	= "PH3";
const char 	cities_pro_frame_15[] 	PROGMEM	= "SO2";
const char 	cities_pro_frame_16[] 	PROGMEM	= "NOISE";
const char	cities_pro_frame_17[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_18[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_19[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_20[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_21[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_22[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_23[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_24[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_25[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_26[]  PROGMEM = ""; 		// reserved
const char	cities_pro_frame_27[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_28[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_29[]  PROGMEM = "";		// reserved
const char 	cities_pro_frame_30[] 	PROGMEM	= "";		// reserved
const char 	cities_pro_frame_31[] 	PROGMEM	= "GP_B";
const char 	cities_pro_frame_32[] 	PROGMEM	= "GP_C";
const char 	cities_pro_frame_33[] 	PROGMEM	= "";		// reserved
const char 	cities_pro_frame_34[] 	PROGMEM	= "";		// reserved
const char 	cities_pro_frame_35[] 	PROGMEM	= "GP_F";
const char	cities_pro_frame_36[]  PROGMEM = ""; 		// reserved
const char	cities_pro_frame_37[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_38[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_39[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_40[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_41[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_42[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_43[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_44[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_45[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_46[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_47[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_48[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_49[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_50[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_51[]  PROGMEM = "";		// reserved

// Additional data and common sensors
const char	cities_pro_frame_52[] 	PROGMEM	= "BAT";
const char	cities_pro_frame_53[] 	PROGMEM	= "GPS";
const char	cities_pro_frame_54[] 	PROGMEM	= "RSSI";
const char	cities_pro_frame_55[] 	PROGMEM	= "MAC";
const char	cities_pro_frame_56[] 	PROGMEM	= "NA";
const char	cities_pro_frame_57[] 	PROGMEM	= "NID";
const char	cities_pro_frame_58[] 	PROGMEM	= "DATE";
const char	cities_pro_frame_59[] 	PROGMEM	= "TIME";
const char	cities_pro_frame_60[] 	PROGMEM	= "GMT";
const char	cities_pro_frame_61[] 	PROGMEM	= "RAM";
const char	cities_pro_frame_62[] 	PROGMEM	= "IN_TEMP"; // (deprecated for Waspv15)
const char	cities_pro_frame_63[]	PROGMEM = "ACC";
const char	cities_pro_frame_64[]  PROGMEM = "MILLIS";
const char	cities_pro_frame_65[]  PROGMEM = "STR";
const char	cities_pro_frame_66[]  PROGMEM = ""; 		// reserved
const char	cities_pro_frame_67[]  PROGMEM = ""; 		// reserved
const char	cities_pro_frame_68[]  PROGMEM = "UID";
const char	cities_pro_frame_69[]  PROGMEM = "RB";
const char	cities_pro_frame_70[]  PROGMEM = "PM1";
const char	cities_pro_frame_71[]  PROGMEM = "PM2_5";
const char	cities_pro_frame_72[]  PROGMEM = "PM10";
const char	cities_pro_frame_73[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_74[]  PROGMEM = "TC";
const char	cities_pro_frame_75[]  PROGMEM = "TF";
const char	cities_pro_frame_76[]  PROGMEM = "HUM";
const char	cities_pro_frame_77[]  PROGMEM = "PRES";
const char	cities_pro_frame_78[]  PROGMEM = "LUX";
const char	cities_pro_frame_79[]  PROGMEM = "US";
const char	cities_pro_frame_80[]  PROGMEM = ""; 		// reserved
const char	cities_pro_frame_81[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_82[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_83[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_84[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_85[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_86[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_87[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_88[]  PROGMEM = "";		// reserved
const char	cities_pro_frame_89[]  PROGMEM = "SPEED_OG";
const char	cities_pro_frame_90[]  PROGMEM = "COURSE_OG";
const char	cities_pro_frame_91[]  PROGMEM = "ALT";
const char	cities_pro_frame_92[]  PROGMEM = "HDOP";
const char	cities_pro_frame_93[]  PROGMEM = "VDOP";
const char	cities_pro_frame_94[]  PROGMEM = "PDOP";
const char	cities_pro_frame_95[]  PROGMEM = "TST";
const char	cities_pro_frame_96[]  PROGMEM = "";     		// reserved
const char	cities_pro_frame_97[]  PROGMEM = "VAPI";
const char	cities_pro_frame_98[]  PROGMEM = "VPROG";
const char	cities_pro_frame_99[]  PROGMEM = "VBOOT";

// NLS class 2
const char	cities_pro_frame_100[] PROGMEM	= "LAF";
const char	cities_pro_frame_101[] PROGMEM	= "LAS";
const char	cities_pro_frame_102[] PROGMEM	= "LAI";
const char	cities_pro_frame_103[] PROGMEM	= "LBF";
const char	cities_pro_frame_104[] PROGMEM	= "LBS";
const char	cities_pro_frame_105[] PROGMEM	= "LBI";
const char	cities_pro_frame_106[] PROGMEM	= "LCF";
const char	cities_pro_frame_107[] PROGMEM	= "LCS";
const char	cities_pro_frame_108[] PROGMEM	= "LCI";
const char	cities_pro_frame_109[] PROGMEM	= "LZF";
const char	cities_pro_frame_110[] PROGMEM	= "LZS";
const char	cities_pro_frame_111[] PROGMEM	= "LZI";
const char	cities_pro_frame_112[] PROGMEM	= "LAFSD";
const char	cities_pro_frame_113[] PROGMEM	= "LASSD";
const char	cities_pro_frame_114[] PROGMEM	= "LAISD";
const char	cities_pro_frame_115[] PROGMEM	= "LBFSD";
const char	cities_pro_frame_116[] PROGMEM	= "LBSSD";
const char	cities_pro_frame_117[] PROGMEM	= "LBISD";
const char	cities_pro_frame_118[] PROGMEM	= "LCFSD";
const char	cities_pro_frame_119[] PROGMEM	= "LCSSD";
const char	cities_pro_frame_120[] PROGMEM	= "LCISD";
const char	cities_pro_frame_121[] PROGMEM	= "LZFSD";
const char	cities_pro_frame_122[] PROGMEM	= "LZSSD";
const char	cities_pro_frame_123[] PROGMEM	= "LZISD";
const char	cities_pro_frame_124[] PROGMEM	= "LASEL";
const char	cities_pro_frame_125[] PROGMEM	= "LBSEL";
const char	cities_pro_frame_126[] PROGMEM	= "LCSEL";
const char	cities_pro_frame_127[] PROGMEM	= "LZSEL";
const char	cities_pro_frame_128[] PROGMEM	= "LAE";
const char	cities_pro_frame_129[] PROGMEM	= "LBE";
const char	cities_pro_frame_130[] PROGMEM	= "LCE";
const char	cities_pro_frame_131[] PROGMEM	= "LZE";
const char	cities_pro_frame_132[] PROGMEM	= "LAFMAX";
const char	cities_pro_frame_133[] PROGMEM	= "LASMAX";
const char	cities_pro_frame_134[] PROGMEM	= "LAIMAX";
const char	cities_pro_frame_135[] PROGMEM	= "LBFMAX";
const char	cities_pro_frame_136[] PROGMEM	= "LBSMAX";
const char	cities_pro_frame_137[] PROGMEM	= "LBIMAX";
const char	cities_pro_frame_138[] PROGMEM	= "LCFMAX";
const char	cities_pro_frame_139[] PROGMEM	= "LCSMAX";
const char	cities_pro_frame_140[] PROGMEM	= "LCIMAX";
const char	cities_pro_frame_141[] PROGMEM	= "LZFMAX";
const char	cities_pro_frame_142[] PROGMEM	= "LZSMAX";
const char	cities_pro_frame_143[] PROGMEM	= "LZIMAX";
const char	cities_pro_frame_144[] PROGMEM	= "LAFMIN";
const char	cities_pro_frame_145[] PROGMEM	= "LASMIN";
const char	cities_pro_frame_146[] PROGMEM	= "LAIMIN";
const char	cities_pro_frame_147[] PROGMEM	= "LBFMIN";
const char	cities_pro_frame_148[] PROGMEM	= "LBSMIN";
const char	cities_pro_frame_149[] PROGMEM	= "LBIMIN";
const char	cities_pro_frame_150[] PROGMEM	= "LCFMIN";
const char	cities_pro_frame_151[] PROGMEM	= "LCSMIN";
const char	cities_pro_frame_152[] PROGMEM	= "LCIMIN";
const char	cities_pro_frame_153[] PROGMEM	= "LZFMIN";
const char	cities_pro_frame_154[] PROGMEM	= "LZSMIN";
const char	cities_pro_frame_155[] PROGMEM	= "LZIMIN";
const char	cities_pro_frame_156[] PROGMEM	= "LAPEAK";
const char	cities_pro_frame_157[] PROGMEM	= "LBPEAK";
const char	cities_pro_frame_158[] PROGMEM	= "LCPEAK";
const char	cities_pro_frame_159[] PROGMEM	= "LZPEAK";
const char	cities_pro_frame_160[] PROGMEM	= "LAEQ";
const char	cities_pro_frame_161[] PROGMEM	= "LBEQ";
const char	cities_pro_frame_162[] PROGMEM	= "LCEQ";
const char	cities_pro_frame_163[] PROGMEM	= "LZEQ";
const char	cities_pro_frame_164[] PROGMEM	= "L10";
const char	cities_pro_frame_165[] PROGMEM	= "L20";
const char	cities_pro_frame_166[] PROGMEM	= "L30";
const char	cities_pro_frame_167[] PROGMEM	= "L40";
const char	cities_pro_frame_168[] PROGMEM	= "L50";
const char	cities_pro_frame_169[] PROGMEM	= "L60";
const char	cities_pro_frame_170[] PROGMEM	= "L70";
const char	cities_pro_frame_171[] PROGMEM	= "L80";
const char	cities_pro_frame_172[] PROGMEM	= "L90";
const char	cities_pro_frame_173[] PROGMEM	= "L99";

const char	cities_pro_frame_174[] PROGMEM = "INT_PERIOD"; 		// reserved
const char	cities_pro_frame_175[] PROGMEM = "";		// reserved
const char	cities_pro_frame_176[] PROGMEM = "";		// reserved
const char	cities_pro_frame_177[] PROGMEM = "";		// reserved
const char	cities_pro_frame_178[] PROGMEM = "";		// reserved
const char	cities_pro_frame_179[] PROGMEM = "";		// reserved
const char	cities_pro_frame_180[] PROGMEM = "";		// reserved
const char	cities_pro_frame_181[] PROGMEM	= ""; 		// reserved
const char	cities_pro_frame_182[] PROGMEM	= ""; 		// reserved
const char	cities_pro_frame_183[] PROGMEM	= ""; 		// reserved
const char	cities_pro_frame_184[] PROGMEM = ""; 		// reserved
const char	cities_pro_frame_185[] PROGMEM = "";		// reserved
const char	cities_pro_frame_186[] PROGMEM = "";		// reserved
const char	cities_pro_frame_187[] PROGMEM = "";		// reserved
const char	cities_pro_frame_188[] PROGMEM = "";		// reserved
const char	cities_pro_frame_189[] PROGMEM = "";		// reserved

// OPC N3 sensor
const char	cities_pro_frame_190[]  PROGMEM = "PM_BIN";
const char	cities_pro_frame_191[]  PROGMEM = "PM_BINL";
const char	cities_pro_frame_192[]  PROGMEM = "PM_BINH";
const char	cities_pro_frame_193[] PROGMEM	= "NOISE_V2"; 		// reserved
const char	cities_pro_frame_194[] PROGMEM = ""; 		// reserved
const char	cities_pro_frame_195[] PROGMEM = "";		// reserved
const char	cities_pro_frame_196[] PROGMEM = "";		// reserved
const char	cities_pro_frame_197[] PROGMEM = "";		// reserved
const char	cities_pro_frame_198[] PROGMEM = "";		// reserved
const char	cities_pro_frame_199[] PROGMEM = "";		// reservedz



/*******************************************************************************
 * SENSOR_TABLE - Sensor label table
 *
 * This table specifies the tag for each sensor. Every tag has been previously
 * defined in Flash memory
 ******************************************************************************/
const char* const CITIES_PRO_TABLE[] PROGMEM=
{
	cities_pro_frame_00,
	cities_pro_frame_01,
	cities_pro_frame_02,
	cities_pro_frame_03,
	cities_pro_frame_04,
	cities_pro_frame_05,
	cities_pro_frame_06,
	cities_pro_frame_07,
	cities_pro_frame_08,
	cities_pro_frame_09,
	cities_pro_frame_10,
	cities_pro_frame_11,
	cities_pro_frame_12,
	cities_pro_frame_13,
	cities_pro_frame_14,
	cities_pro_frame_15,
	cities_pro_frame_16,
	cities_pro_frame_17,
	cities_pro_frame_18,
	cities_pro_frame_19,
	cities_pro_frame_20,
	cities_pro_frame_21,
	cities_pro_frame_22,
	cities_pro_frame_23,
	cities_pro_frame_24,
	cities_pro_frame_25,
	cities_pro_frame_26,
	cities_pro_frame_27,
	cities_pro_frame_28,
	cities_pro_frame_29,
	cities_pro_frame_30,
	cities_pro_frame_31,
	cities_pro_frame_32,
	cities_pro_frame_33,
	cities_pro_frame_34,
	cities_pro_frame_35,
	cities_pro_frame_36,
	cities_pro_frame_37,
	cities_pro_frame_38,
	cities_pro_frame_39,
	cities_pro_frame_40,
	cities_pro_frame_41,
	cities_pro_frame_42,
	cities_pro_frame_43,
	cities_pro_frame_44,
	cities_pro_frame_45,
	cities_pro_frame_46,
	cities_pro_frame_47,
	cities_pro_frame_48,
	cities_pro_frame_49,
	cities_pro_frame_50,
	cities_pro_frame_51,
	cities_pro_frame_52,
	cities_pro_frame_53,
	cities_pro_frame_54,
	cities_pro_frame_55,
	cities_pro_frame_56,
	cities_pro_frame_57,
	cities_pro_frame_58,
	cities_pro_frame_59,
	cities_pro_frame_60,
	cities_pro_frame_61,
	cities_pro_frame_62,
	cities_pro_frame_63,
	cities_pro_frame_64,
	cities_pro_frame_65,
	cities_pro_frame_66,
	cities_pro_frame_67,
	cities_pro_frame_68,
	cities_pro_frame_69,
	cities_pro_frame_70,
	cities_pro_frame_71,
	cities_pro_frame_72,
	cities_pro_frame_73,
	cities_pro_frame_74,
	cities_pro_frame_75,
	cities_pro_frame_76,
	cities_pro_frame_77,
	cities_pro_frame_78,
	cities_pro_frame_79,
	cities_pro_frame_80,
	cities_pro_frame_81,
	cities_pro_frame_82,
	cities_pro_frame_83,
	cities_pro_frame_84,
	cities_pro_frame_85,
	cities_pro_frame_86,
	cities_pro_frame_87,
	cities_pro_frame_88,
	cities_pro_frame_89,
	cities_pro_frame_90,
	cities_pro_frame_91,
	cities_pro_frame_92,
	cities_pro_frame_93,
	cities_pro_frame_94,
	cities_pro_frame_95,
	cities_pro_frame_96,
	cities_pro_frame_97,
	cities_pro_frame_98,
	cities_pro_frame_99,
	cities_pro_frame_100,
	cities_pro_frame_101,
	cities_pro_frame_102,
	cities_pro_frame_103,
	cities_pro_frame_104,
	cities_pro_frame_105,
	cities_pro_frame_106,
	cities_pro_frame_107,
	cities_pro_frame_108,
	cities_pro_frame_109,
	cities_pro_frame_110,
	cities_pro_frame_111,
	cities_pro_frame_112,
	cities_pro_frame_113,
	cities_pro_frame_114,
	cities_pro_frame_115,
	cities_pro_frame_116,
	cities_pro_frame_117,
	cities_pro_frame_118,
	cities_pro_frame_119,
	cities_pro_frame_120,
	cities_pro_frame_121,
	cities_pro_frame_122,
	cities_pro_frame_123,
	cities_pro_frame_124,
	cities_pro_frame_125,
	cities_pro_frame_126,
	cities_pro_frame_127,
	cities_pro_frame_128,
	cities_pro_frame_129,
	cities_pro_frame_130,
	cities_pro_frame_131,
	cities_pro_frame_132,
	cities_pro_frame_133,
	cities_pro_frame_134,
	cities_pro_frame_135,
	cities_pro_frame_136,
	cities_pro_frame_137,
	cities_pro_frame_138,
	cities_pro_frame_139,
	cities_pro_frame_140,
	cities_pro_frame_141,
	cities_pro_frame_142,
	cities_pro_frame_143,
	cities_pro_frame_144,
	cities_pro_frame_145,
	cities_pro_frame_146,
	cities_pro_frame_147,
	cities_pro_frame_148,
	cities_pro_frame_149,
	cities_pro_frame_150,
	cities_pro_frame_151,
	cities_pro_frame_152,
	cities_pro_frame_153,
	cities_pro_frame_154,
	cities_pro_frame_155,
	cities_pro_frame_156,
	cities_pro_frame_157,
	cities_pro_frame_158,
	cities_pro_frame_159,
	cities_pro_frame_160,
	cities_pro_frame_161,
	cities_pro_frame_162,
	cities_pro_frame_163,
	cities_pro_frame_164,
	cities_pro_frame_165,
	cities_pro_frame_166,
	cities_pro_frame_167,
	cities_pro_frame_168,
	cities_pro_frame_169,
	cities_pro_frame_170,
	cities_pro_frame_171,
	cities_pro_frame_172,
	cities_pro_frame_173,
	cities_pro_frame_174,
	cities_pro_frame_175,
	cities_pro_frame_176,
	cities_pro_frame_177,
	cities_pro_frame_178,
	cities_pro_frame_179,
	cities_pro_frame_180,
	cities_pro_frame_181,
	cities_pro_frame_182,
	cities_pro_frame_183,
	cities_pro_frame_184,
	cities_pro_frame_185,
	cities_pro_frame_186,
	cities_pro_frame_187,
	cities_pro_frame_188,
	cities_pro_frame_189,
	cities_pro_frame_190,
	cities_pro_frame_191,
	cities_pro_frame_192,
	cities_pro_frame_193,
	cities_pro_frame_194,
	cities_pro_frame_195,
	cities_pro_frame_196,
	cities_pro_frame_197,
	cities_pro_frame_198,
	cities_pro_frame_199,

};


/*******************************************************************************
* SENSOR_TYPE_TABLE - Binary frames sensor types
*
* This table specifies the type of sensor depending on the type of value the
* user must put as input. These are the possibilities:
*
*	0: uint8_t
*	1: int (the same as int16_t)
*	2: double (the same as float)
*	3: char*
*  	4: uint32_t
*  	5: uint8_t*
******************************************************************************/
const uint8_t CITIES_PRO_TYPE_TABLE[] PROGMEM=
{
	2,		// 0
	2, 		// 1
	2, 		// 2
	2, 		// 3
	2, 		// 4
	2, 		// 5
	2, 		// 6
	0, 		// 7
	0, 		// 8
	0, 		// 9
	0, 		// 10
	0, 		// 11
	2, 		// 12
	2, 		// 13
	2, 		// 14
	2, 		// 15
	2, 		// 16
	2, 		// 17
	2, 		// 18
	2, 		// 19
	2, 		// 20
	2, 		// 21
	0,		// 22
	0,		// 23
	0,		// 24
	0,		// 25
	0,		// 26
	0,		// 27
	0,		// 28
	0,		// 29
	0,		// 30
	2,		// 31
	2,		// 32
	0,		// 33
	0,		// 34
	2,		// 35
	0,		// 36
	0,		// 37
	0,		// 38
	0,		// 39
	0,		// 40
	0,		// 41
	0,		// 42
	0,		// 43
	0,		// 44
	0,		// 45
	0,		// 46
	0,		// 47
	0,		// 48
	0,		// 49
	0,		// 50
	0,		// 51
	0, 		// 52
	2, 		// 53
	1, 		// 54
	3, 		// 55
	3, 		// 56
	3, 		// 57
	0, 		// 58
	0, 		// 59
	1, 		// 60
	1, 		// 61
	2, 		// 62
	1, 		// 63
	4, 		// 64
	3, 		// 65
	0,		// 66
	0,		// 67
	3,  	// 68
	3,  	// 69
	2,		// 70
	2,		// 71
	2,		// 72
	0,		// 73
	2,		// 74
	2,		// 75
	2,		// 76
	2,		// 77
	4,		// 78
	1,		// 79
	0,		// 80
	0,		// 81
	0,		// 82
	0,		// 83
	0,		// 84
	0,		// 85
	0,		// 86
	0,		// 87
	0,		// 88
	2,		// 89
	2,		// 90
	2,		// 91
	2,		// 92
	2,		// 93
	2,		// 94
	4,		// 95
	0,		// 96
	0,		// 97
	0,		// 98
	0,		// 99
	2,		// 100
	2, 		// 101
	2, 		// 102
	2, 		// 103
	2, 		// 104
	2, 		// 105
	2, 		// 106
	2, 		// 107
	2, 		// 108
	2, 		// 109
	2, 		// 110
	2, 		// 111
	2, 		// 112
	2, 		// 113
	2, 		// 114
	2, 		// 115
	2, 		// 116
	2, 		// 117
	2, 		// 118
	2, 		// 119
	2, 		// 120
	2, 		// 121
	2,		// 122
	2,		// 123
	2,		// 124
	2,		// 125
	2,		// 126
	2,		// 127
	2,		// 128
	2,		// 129
	2,		// 130
	2,		// 131
	2,		// 132
	2,		// 133
	2,		// 134
	2,		// 135
	2,		// 136
	2,		// 137
	2,		// 138
	2,		// 139
	2,		// 140
	2,		// 141
	2,		// 142
	2,		// 143
	2,		// 144
	2,		// 145
	2,		// 146
	2,		// 147
	2,		// 148
	2,		// 149
	2,		// 150
	2,		// 151
	2, 		// 152
	2, 		// 153
	2, 		// 154
	2, 		// 155
	2, 		// 156
	2, 		// 157
	2, 		// 158
	2, 		// 159
	2, 		// 160
	2, 		// 161
	2, 		// 162
	2, 		// 163
	2, 		// 164
	2, 		// 165
	2,		// 166
	2,		// 167
	2,  	// 168
	2,  	// 169
	2,		// 170
	2,		// 171
	2,		// 172
	2,		// 173
	0,		// 174
	0,		// 175
	0,		// 176
	0,		// 177
	0,		// 178
	0,		// 179
	0,		// 180
	0,		// 181
	0,		// 182
	0,		// 183
	0,		// 184
	0,		// 185
	0,		// 186
	0,		// 187
	0,		// 188
	0,		// 189
	1,		// 190
	1,		// 191
	1,		// 192
	2,		// 193
	0,		// 194
	0,		// 195
	0,		// 196
	0,		// 197
	0,		// 198
	0,		// 199

};



/*******************************************************************************
* SENSOR_FIELD_TABLE - Sensor fields
*
* This table specifies the number of fields per sensor.
*
* For example, a temperature sensor indicates the temperature in a single field.
* On the other hand, the GPS module indicates the position with two fields:
* latitude and longitude
******************************************************************************/
const uint8_t CITIES_PRO_FIELD_TABLE[] PROGMEM=
{
	1,		// 0
	1,		// 1
	1, 		// 2
	1, 		// 3
	1, 		// 4
	1, 		// 5
	1, 		// 6
	1, 		// 7
	1, 		// 8
	1, 		// 9
	1, 		// 10
	1, 		// 11
	1, 		// 12
	1, 		// 13
	1, 		// 14
	1, 		// 15
	1, 		// 16
	1, 		// 17
	1, 		// 18
	1, 		// 19
	1, 		// 20
	1, 		// 21
	1,		// 22
	1,		// 23
	1,		// 24
	1,		// 25
	1,		// 26
	1,		// 27
	1,		// 28
	1,		// 29
	1,		// 30
	1,		// 31
	1,		// 32
	1,		// 33
	1,		// 34
	1,		// 35
	1,		// 36
	1,		// 37
	1,		// 38
	1,		// 39
	1,		// 40
	1,		// 41
	1,		// 42
	1,		// 43
	1,		// 44
	1,		// 45
	1,		// 46
	1,		// 47
	1,		// 48
	1,		// 49
	1,		// 50
	1,		// 51
	1,		// 52
	2,		// 53
	1,		// 54
	1,		// 55
	1,		// 56
	1,		// 57
	3,		// 58
	3,		// 59
	1,		// 60
	1,		// 61
	1,		// 62
	3,		// 63
	1,		// 64
	1, 		// 65
	1, 		// 66
	1, 		// 67
	1, 		// 68
	1, 		// 69
	1,		// 70
	1,		// 71
	1,		// 72
	0,		// 73
	1,		// 74
	1,		// 75
	1,		// 76
	1,		// 77
	1,		// 78
	1,		// 79
	1,		// 80
	1,		// 81
	1,		// 82
	1,		// 83
	1,		// 84
	1,		// 85
	1,		// 86
	1,		// 87
	1,		// 88
	1,		// 89
	1,		// 90
	1,		// 91
	1,		// 92
	1,		// 93
	1,		// 94
	1,		// 95
	1,		// 96
	1,		// 97
	1,		// 98
	1,		// 99
	1,		// 100
	1,		// 101
	1, 		// 102
	1, 		// 103
	1, 		// 104
	1, 		// 105
	1, 		// 106
	1, 		// 107
	1, 		// 108
	1, 		// 109
	1, 		// 110
	1, 		// 111
	1, 		// 112
	1, 		// 113
	1, 		// 114
	1, 		// 115
	1, 		// 116
	1, 		// 117
	1, 		// 118
	1, 		// 119
	1, 		// 120
	1, 		// 121
	1,		// 122
	1,		// 123
	1,		// 124
	1,		// 125
	1,		// 126
	1,		// 127
	1,		// 128
	1,		// 129
	1,		// 130
	1,		// 131
	1,		// 132
	1,		// 133
	1,		// 134
	1,		// 135
	1,		// 136
	1,		// 137
	1,		// 138
	1,		// 139
	1,		// 140
	1,		// 141
	1,		// 142
	1,		// 143
	1,		// 144
	1,		// 145
	1,		// 146
	1,		// 147
	1,		// 148
	1,		// 149
	1,		// 150
	1,		// 151
	1,		// 152
	1,		// 153
	1,		// 154
	1,		// 155
	1,		// 156
	1,		// 157
	1,		// 158
	1,		// 159
	1,		// 160
	1,		// 161
	1,		// 162
	1,		// 163
	1,		// 164
	1, 		// 165
	1, 		// 166
	1, 		// 167
	1, 		// 168
	1, 		// 169
	1,		// 170
	1,		// 171
	1,		// 172
	1,		// 173
	1,		// 174
	1,		// 175
	1,		// 176
	1,		// 177
	1,		// 178
	1,		// 179
	1,		// 180
	1,		// 181
	1,		// 182
	1,		// 183
	1,		// 184
	1,		// 185
	1,		// 186
	1,		// 187
	1,		// 188
	1,		// 189
	24,		// 190
	16,		// 191
	8,		// 192
	1,		// 193
	1,		// 194
	1,		// 195
	1,		// 196
	1,		// 197
	1,		// 198
	1,		// 199

};



/*******************************************************************************
* DECIMAL_TABLE - number of default decimals for each sensor for ASCII frames
*
* This table specifies the number of decimals for each sensor for ASCII frames
******************************************************************************/
const uint8_t CITIES_PRO_DECIMAL_TABLE[] PROGMEM =
{
	3,		// 0
	3,		// 1
	3, 		// 2
	3, 		// 3
	3, 		// 4
	3, 		// 5
	3, 		// 6
	0, 		// 7
	0, 		// 8
	0, 		// 9
	0, 		// 10
	0, 		// 11
	3, 		// 12
	3, 		// 13
	3, 		// 14
	3, 		// 15
	3, 		// 16
	3, 		// 17
	3, 		// 18
	3, 		// 19
	3, 		// 20
	2, 		// 21
	0,		// 22
	0,		// 23
	0,		// 24
	0,		// 25
	0,		// 26
	0,		// 27
	0,		// 28
	0,		// 29
	0,		// 30
	3,		// 31
	3,		// 32
	0,		// 33
	0,		// 34
	3,		// 35
	0,		// 36
	0,		// 37
	0,		// 38
	0,		// 39
	0,		// 40
	0,		// 41
	0,		// 42
	0,		// 43
	0,		// 44
	0,		// 45
	0,		// 46
	0,		// 47
	0,		// 48
	0,		// 49
	0,		// 50
	0,		// 51
	0,		// 52
	6,		// 53
	0,		// 54
	0,		// 55
	0,		// 56
	0,		// 57
	0,		// 58
	0,		// 59
	0,		// 60
	0,		// 61
	2,		// 62
	0,		// 63
	0,		// 64
	0, 		// 65
	0, 		// 66
	0, 		// 67
	0, 		// 68
	0, 		// 69
	4,		// 70
	4,		// 71
	4,		// 72
	0,		// 73
	2,		// 74
	2,		// 75
	1,		// 76
	2,		// 77
	0,		// 78
	0,		// 79
	0,		// 80
	0,		// 81
	0,		// 82
	0,		// 83
	0,		// 84
	0,		// 85
	0,		// 86
	0,		// 87
	0,		// 88
	2,		// 89
	2,		// 90
	2,		// 91
	3,		// 92
	3,		// 93
	3,		// 94
	0,		// 95
	0,		// 96
	0,		// 97
	0,		// 98
	0,		// 99
	1,		// 100
	1,		// 101
	1, 		// 102
	1, 		// 103
	1, 		// 104
	1, 		// 105
	1, 		// 106
	1, 		// 107
	1, 		// 108
	1, 		// 109
	1, 		// 110
	1, 		// 111
	1, 		// 112
	1, 		// 113
	1, 		// 114
	1, 		// 115
	1, 		// 116
	1, 		// 117
	1, 		// 118
	1, 		// 119
	1, 		// 120
	1, 		// 121
	1,		// 122
	1,		// 123
	1,		// 124
	1,		// 125
	1,		// 126
	1,		// 127
	1,		// 128
	1,		// 129
	1,		// 130
	1,		// 131
	1,		// 132
	1,		// 133
	1,		// 134
	1,		// 135
	1,		// 136
	1,		// 137
	1,		// 138
	1,		// 139
	1,		// 140
	1,		// 141
	1,		// 142
	1,		// 143
	1,		// 144
	1,		// 145
	1,		// 146
	1,		// 147
	1,		// 148
	1,		// 149
	1,		// 150
	1,		// 151
	1,		// 152
	1,		// 153
	1,		// 154
	1,		// 155
	1,		// 156
	1,		// 157
	1,		// 158
	1,		// 159
	1,		// 160
	1,		// 161
	1,		// 162
	1,		// 163
	1,		// 164
	1, 		// 165
	1, 		// 166
	1, 		// 167
	1, 		// 168
	1, 		// 169
	1,		// 170
	1,		// 171
	1,		// 172
	1,		// 173
	0,		// 174
	0,		// 175
	0,		// 176
	0,		// 177
	0,		// 178
	0,		// 179
	0,		// 180
	0,		// 181
	0,		// 182
	0,		// 183
	0,		// 184
	0,		// 185
	0,		// 186
	0,		// 187
	0,		// 188
	0,		// 189
	0,		// 190
	0,		// 191
	0,		// 192
	2,		// 193
	0,		// 194
	0,		// 195
	0,		// 196
	0,		// 197
	0,		// 198
	0,		// 199

};

#endif
