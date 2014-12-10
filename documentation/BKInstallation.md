# BuecherkastenBibliothek BK -- Installation Guide

## 1. Operating System
  1.  Debian
  2.  Install Debian Server as described in our RT Wiki

## 2. Apt Packages
  1.  aptitude install perl
  2.  aptitude install git
  3.  aptitude install libdancer-perl
  4.  aptitude install libmojolicious-perl
  5.  aptitude install libinline-perl
  6.  aptitude install libjson-perl
  7.  aptitude install libtemplate-perl
  8.  aptitude install libdbi-perl
  9.  aptitude install libdbd-sqlite3-perl
  10. aptitude install unzip
  11. aptitude install gcc

## 3. Install LabJack Drivers
  1.  mkdir /opt/drivers && cd /opt/drivers
  2.  Download Drivers
        -  wget http://labjack.com/sites/default/files/2013/10/ljacklm.zip
        -  https://github.com/labjack/exodriver/archive/master.zip
  3.  unzip ljacklm.zip && unzip master.zip
  4.  cd exodriver-master
  5.  ./install.sh

## 4. Configure BK
  1.  Change the **"use lib"** Path in **BKFrontent.pl** and **BKFrontendWebSockets.pl** to the lib directory of the BK folder eg. /opt/BK/**lib**
  2.  Change the Hostname of the **"ws_path"** and the **"ajax_path"** variables in **"public/javascript/scripts/variables/VariablesDefinition.js"** to the Hostname of the BK Server
