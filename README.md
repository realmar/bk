# BK README

Author:
Anastassios Martakos

## What is this
This contains the Backend and the Frontend of BK. BK stands for BuecherKasten it controls the physical doors connected to a processing unit by reading user input from a barcode scanner.  
It also provides a web interface to manage which user has which door.  
Dedicated Project for the D-Phys Library at the ETH Zuerich 
but it can be expanded when nesseccary

## To Deploy
  1.  perl BKBackend.pl &
  2.  perl BKFrontend.pl --environment production &
  3.  perl BKFrontendWebSockets.pl daemon -m production -l ws://0.0.0.0:3003 &

or a correspondand web server configuration

or the RECOMMEDED VERSION run the InitializeProgram.sh script

ADDITIONALLY adapt the enviroment config files locatet in the environments folder

## Installation
Follow the steps describes in InitializeProgram.sh or just run it and answer the questions  
All operations have to be done with root access  
  -  **Install the appropriate version of the linux-headers for your operating system**
  -  **look at the install script, which version of the libjacklm.so is compiled you may need to adapt the version number so it can be renamed correctly**  
There are some hardcoded variables in the code of BK which are adjustet by the install script if you do the installation manually you have to set those variables

## Log Files
  -  All three Apps log in the same log files **log/message_log** and **log/error_log**
  -  BKFrontentWebSockets.pl logs also in the **log/development.log** or **log/production.log** depending on the running mode

## Components
  -  BK
  -  BKScanner
  -  SQLite Database

### BK
This is the all in one frontend meaning, it is the webserver, door opener and reads / writes to the database

### BKScanner
Only get the user input from the barcode reader and makes an http request to localhost to BK

### SQLite Database
Stores the informations which door is to which user assigned

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
