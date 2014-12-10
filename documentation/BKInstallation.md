# BuecherkastenBibliothek BK -- Installation Guide

## 1. Operating System
  1.  Debian
  2.  Install Debian Server as described in our RT Wiki

**NOTE: You can also run the InitializeProgram.sh script as root to complete the installation**

**NOTE: All operations have to be done as root or with root access**

## 2. Apt Packages
  1.  aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-486 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc

NOTE: install the appropriate version of the linux-headers for your operating system

## 3. Install LabJack Drivers
  1.  mkdir /opt/drivers && cd /opt/drivers
  2.  Download Drivers
        1.  wget http://labjack.com/sites/default/files/2013/10/ljacklm.zip
  3.  unzip ljacklm.zip
  4.  cd ljacklm/libljacklm
  5.  make clean
  6.  make install
  7.  cp {libljacklm.so.1.20.2,ljacklm.h} /usr/local/lib/
  8.  mv /usr/local/lib/libljacklm.so.1.20.2 /usr/local/lib/libljacklm.so

NOTE: you may have to adapt the version number in the filename of the libljacklm.so file, the one here is just an example

## 4. Configure BK
  1.  Change the **"use lib"** Path in **BKFrontent.pl** and **BKFrontendWebSockets.pl** to the lib directory of the BK folder eg. /opt/BK/**lib**
  2.  Change the Hostname of the **"ws_path"** and the **"ajax_path"** variables in **"public/javascript/scripts/variables/VariablesDefinition.js"** to the Hostname of the BK Server

## 5. Set up Database
  1.  mkdir database && cd database
  2.  ./CreateDatabase.sh

## 6. Set up Log Directory
  1.  mkdir log
