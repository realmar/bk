# BuecherkastenBibliothek BK -- Installation Guide

## 1. Operating System
  1.  Debian
  2.  Install Debian Server as described in our RT Wiki

**NOTE: You can also run the InitializeProgram.sh script as root to complete the installation**

**NOTE: All operations have to be done as root or with root access**

## 2. Apt Packages
  1.  aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-486 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc

### for use with Apache2 and integrated in Apache2
  1.  aptitute install libapache2-mod-perl2 libplack-perl

NOTE: install the appropriate version of the linux-headers for your operating system

## 3. Install LabJack Drivers
  1.  mkdir /opt/drivers && cd /opt/drivers
  2.  Download Drivers
        1.  wget http://labjack.com/sites/default/files/2013/10/ljacklm.zip
        2.  wget https://github.com/labjack/exodriver/archive/master.zip
  3.  unzip ljacklm.zip && unzip master.zip
  4.  Edit exodriver-master/liblabjackusb/Makefile
      -  Add
         -  CFLAGS=-I/usr/src/linux-headers-3.2.0-4-common
            After
            ADD_LDCONFIG_PATH = ./add_ldconfig_path.sh
  5.  cd exodriver-master
  6.  ./install
  7.  cd ljacklm/libljacklm
  8.  make clean
  9.  make install
  10. cp {libljacklm.so.1.20.2,ljacklm.h} /usr/local/lib/
  11. mv /usr/local/lib/libljacklm.so.1.20.2 /usr/local/lib/libljacklm.so

NOTE: you may have to adapt the version number in the filename of the libljacklm.so file, the one here is just an example

## 4. Configure BK
### Standalone
  1.  Change the **"use lib"** Path in **BKFrontent.pl** and **BKFrontendWebSockets.pl** to the lib directory of the BK folder eg. /opt/BK/**lib**
  2.  Change the Hostname and the Port of the **"ws_path"** and the **"ajax_path"** variables in **"public/javascript/scripts/variables/VariablesDefinition.js"** to the Hostname of the BK Server
      -  recommeded Ports:
         -  ws_path: 3003
         -  ajax_path: 3000

NOTE: the ws_path describes the Host and the Port on which the WebSocket Server is, the ajax_path describes the Host and the Port on which the BK Server is, you also have to run those two servers on these Ports then

## 5. Set up Database
  1.  mkdir database && cd database
  2.  ./CreateDatabase.sh

## 6. Set up Log Directory
  1.  mkdir log && cd log
  2.  touch {message,error}\_log

### Apache2
#### Integrated in Apache2
  1.  use the **bk** and **bk-ssl** configuration files
  1.  a2enmod perl
  2.  a2enmod headers

#### Use a Proxy in Apache2
  1.  use the **bk_proxy** and **bk-ssl_proxy** configuration files
  2.  a2enmod headers
  3.  a2enmod proxy
  4.  a2enmod proxy_http

#### Setting Permissions only for use with Apache2
  1.  chmod a+rwx {log,database}
  2.  chmod a+rwx {log,database}/*
