/*
    --------------- 4G_19 - Sending e-mail ---------------

    Explanation: This example shows how to set up the module to send
    e-mails

    Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L.
    http://www.libelium.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Version:           3.0
    Design:            David Gascón
    Implementation:    Luis Miguel Martí
*/

#include <Wasp4G.h>

// APN settings
///////////////////////////////////////
char apn[] = "movistar.es";
char login[] = "movistar";
char password[] = "movistar";
///////////////////////////////////////


// E-mail sender parameters
//////////////////////////////////////////////////
char sender_address[] = "test1@libelium.com";
char sender_user[] = "test1@libelium.com";
char sender_password[] = "eHr73j";
//////////////////////////////////////////////////

// E-mail SMTP parameters
//////////////////////////////////////////////////
char smtp_server[] = "smtp.libelium.com";
uint8_t smtp_security = Wasp4G::EMAIL_NONSSL;
uint16_t smtp_port = 25;
//////////////////////////////////////////////////

// E-mail to send
//////////////////////////////////////////////////
char receiver_address[] = "receiver@email.box.com";
char subject[] = "Subject of email"; // maximum: 100 bytes
char message[] = "This is an e-mail message from Waspmote";
//////////////////////////////////////////////////

// variable
uint8_t error;


void setup()
{
  USB.ON();
  USB.println(F("Start program"));

  //////////////////////////////////////////////////
  // Set operator parameters
  //////////////////////////////////////////////////
  _4G.set_APN(apn, login, password);


  //////////////////////////////////////////////////
  // Show APN settings via USB port
  //////////////////////////////////////////////////
  _4G.show_APN();


  //////////////////////////////////////////////////
  // 1. Switch on the 4G module
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // 1.1. Reset e-mail parameters
    ////////////////////////////////////////////////
        
    error = _4G.emailReset();

    if (error == 0)
    {
      USB.println(F("1.1. Reset e-mail parameters OK"));
    }
    else
    {
      USB.print(F("1.1. Error reset configuration. Code: "));
      USB.println(error, DEC);
    }

    ////////////////////////////////////////////////
    // 1.2. Set SMTP server
    ////////////////////////////////////////////////
    error = _4G.emailSetServerSMTP(smtp_server);

    if (error == 0)
    {
      USB.println(F("1.2. SMTP server set OK"));
    }
    else
    {
      USB.print(F("1.2. Error set server. Code: "));
      USB.println(error, DEC);
    }

    ////////////////////////////////////////////////
    // 1.3. Configure SMTP server security and port
    ////////////////////////////////////////////////
    error = _4G.emailConfigureSMTP(smtp_security, smtp_port);

    if (error == 0)
    {
      USB.println(F("1.3. Configure SMTP server OK"));
    }
    else
    {
      USB.print(F("1.3. Error configuring SMTP server. Code: "));
      USB.println(error, DEC);
    }
    
    ////////////////////////////////////////////////
    // 1.4. Set sender address
    ////////////////////////////////////////////////
    error = _4G.emailSetSender(sender_address, sender_user, sender_password);

    if (error == 0)
    {
      USB.println(F("1.4. Sender addres set OK"));
    }
    else
    {
      USB.print(F("1.4. Error set address. Code: "));
      USB.println(error, DEC);
    }

    ////////////////////////////////////////////////
    // 1.5. Save e-mail configuration settings
    ////////////////////////////////////////////////
    error = _4G.emailSave();

    if (error == 0)
    {
      USB.println(F("1.5. Save configuration OK"));
    }
    else
    {
      USB.print(F("1.5. Error saving configuration. Code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    USB.print(F("1. Error starting module. Code: "));
    USB.println(error, DEC);
  }

  USB.println(F("*** Setup done ***\n\n"));
}




void loop()
{
  //////////////////////////////////////////////////
  // 1. Switch ON
  //////////////////////////////////////////////////
  error = _4G.ON();

  if (error == 0)
  {
    USB.println(F("1. 4G module ready..."));

    ////////////////////////////////////////////////
    // 2. Send e-mail
    ////////////////////////////////////////////////
    error = _4G.emailSend(receiver_address, subject, message);

    if (error == 0)
    {
      USB.println(F("2. Sending e-mail OK"));
    }
    else
    {
      USB.print(F("2. Error sending e-mail. Code: "));
      USB.println(error, DEC);
    }
  }
  else
  {
    // Problem with the communication with the 4G module
    USB.print(F("1. 4G module not started. Error code: "));
    USB.println(error, DEC);
  }

  ////////////////////////////////////////////////
  // 3. Powers off the 4G module
  ////////////////////////////////////////////////
  USB.println(F("3. Switch OFF 4G module"));
  _4G.OFF();


  ////////////////////////////////////////////////
  // 4. Sleep
  ////////////////////////////////////////////////
  USB.println(F("4. Enter deep sleep..."));
  PWR.deepSleep("00:00:10:00", RTC_OFFSET, RTC_ALM1_MODE1, ALL_OFF);

  USB.ON();
  USB.println(F("5. Wake up!!\n\n"));
}



