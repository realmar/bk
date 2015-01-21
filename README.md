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

## Log Files
  -  All three Apps log in the same log files **log/message_log** and **log/error_log**
  -  BKFrontentWebSockets.pl logs also in the **log/development.log** or **log/production.log** depending on the running mode
