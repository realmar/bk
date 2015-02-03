# BK README

Author:
Anastassios Martakos

## What is this
This contains the Backend and the Frontend of BK. BK stands for BuecherKasten it controls the physical doors connected to a processing unit by reading user input from a barcode scanner.  
It also provides a web interface to manage which user has which door.  
Dedicated Project for the D-Phys Library at the ETH Zuerich 
but it can be expanded when nesseccary

## To Deploy
### Standalone
  1.  perl BKScanner.pl &
  2.  perl BK.pl daemon -m production -l ws://0.0.0.0:8008 &

### With Apache2
  1.  systemctl start bkscanner
  2.  systemctl start bk
  3.  systemctl start apache2

or a correspondand web server configuration  
or the RECOMMEDED VERSION run the config/InitializeProgram.sh script

## Installation
Follow the steps describes in config/InitializeProgram.sh or just run it and answer the questions  
All operations have to be done with root access  
  -  **Install the appropriate version of the linux-headers for your operating system**
  -  **look at the install script, which version of the libjacklm.so is compiled you may need to adapt the version number so it can be renamed correctly**  
There are some hardcoded variables in the code of BK which are adjustet by the install script if you do the installation manually you have to set those variables

## Log Files
  -  All three Apps log in the same log files **log/message_log** and **log/error_log**
  -  BK.pl logs also in the **log/development.log** or **log/production.log** depending on the running mode

## Components
  -  BK
  -  BKScanner
  -  SQLite Database
  -  JavaScript (Client)

### BK
This is the Mojolicious all in one frontend meaning, it is the webserver, door opener and reads / writes to the database.

There are different action (routes) which BK can process, this information is taken from the URL. The response is in most cases just the content of the bookboxes.

### BKScanner
Only get the user input from the barcode reader and makes an http request to localhost to BK.

### SQLite Database
Stores the informations which door is to which user assigned.

### JavaScript (Client)
Handles the things on the client. It has two connection modes: **AJAX** and **WebSockets** WebSockets is the prefered protocol. If WebSockets are not available it will fall back to AJAX also it starts with a AJAX connection which
then gets upgraded to a WebSockets connection. With upgrade we mean a new connection is made.

#### Delevoper Note
You can manually force to use AJAX if you set the **ws_path** to a incorrect URL and then call **program_handler.InitializeConnTypeAJAX** in the console of your browser. To go back just set the **ws_path** to the previous correct URL and then wait until it makes a connection (this can take up to 1 min, because of the retry interval).

## Services
There are two services (based on systemd service files) the **bk.service** and the **bkscanner.service** which runs the appropriate script, as the name of these services tells. They are configured that they will restart if they break down.

## Webserver
### Apache2
Apache2 runs a proxy on the Mojolicious Webserver

### Mojolicious
Is the actual webserver which delivers the data, runs only on localhost (recommeded by init script)

## LabJack
### Old System
Vorname: Stefan  
Nachname: Meyer  
Tel.: +41 44 633 20 72  
E-Mail 0: stefan.meyer@phys.ethz.ch  
E-Mail 1: meyer@phys.ethz.ch

### New System with BK
Hardware Name: LabJack U12  
Connection to Computer: USB  
Drivers: on LabJack Website  
Functionality: power is sent through the digital pins to the magnet on the door for a defined tim e to open the doors  
Programming Method 0: Perl  
Programming Method 1: ProfiLab

## 6 Things you should know
  1.  This project is developed by Anastassios Martakos (me) so don't search for the contact person (like me before)
  2.  Has 3 components BK (Mojolocious), BKScanner (just Perl) and JavaScript on the client side
  3.  Stores data in a SQLite database
  4.  The Install script is in config not bin
  5.  It has a GIT repository so use it
  6.  BK controlls a LabJack which needs drivers and they need to be compiled, it also is accessable through C code and other Languages

## Notes
### Issues
  -  When $self-{_db}->disconnect called an error is invoked therefore the DatabaseAccess destructor is commented out, is not that clean, should be fixed one day at the time
  -  WebSockets doesn't work on Safari clients, propably because Safari doesn't send the auth header with the wss protocol
