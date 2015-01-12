# BuecherkastenBibliothek BK -- Installation Guide

## 1. Operating System
  1.  Debian
  2.  Install Debian Server as described in our RT Wiki

**NOTE: You can also run the InitializeProgram.sh script as root to complete the installation, the InitializeProgram.sh script can also be use to reconfigure BK**

**NOTE: All operations have to be done as root or with root access**

## 2. Apt Packages
  1.  aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libinline-c-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-586 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc

### for use with Apache2 and integrated in Apache2
  1.  aptitute install apache2 libapache2-mod-perl2 libplack-perl

#### for use of a self-signed certificate
  1.  aptitude install openssl

NOTE: install the appropriate version of the linux-headers for your operating system

## 3. Install LabJack Drivers
  1.  mkdir /opt/drivers && cd /opt/drivers
  2.  Download Drivers
        1.  wget http://labjack.com/sites/default/files/2013/10/ljacklm.zip
        2.  wget https://github.com/labjack/exodriver/archive/master.zip
  3.  unzip ljacklm.zip && unzip master.zip
  4.  Edit exodriver-master/liblabjackusb/Makefile
      -  Add
         -  CFLAGS=-I/usr/src/linux-headers-3.16.0-4-common
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
  1.  Change the **"use lib"** Path in **BKFrontent.pl** and **BKFrontendWebSockets.pl** to the lib directory of the BK folder eg. /opt/BK/**lib**
  2.  Change the Hostname, Protocol and the Port of the **"ws_path"** and the **"ajax_path"** variables in **"public/javascript/scripts/variables/VariablesDefinition.js"** to the Hostname of the BK Server
      -  recommeded Protocols and Ports for non SSL:
         -  ws_path: ws ; 3003
         -  ajax_path: http ; 80
      -  recommeded Protocols and Ports for SSL:
         -  ws_path: wss ; 4443
         -  ajax_path: https ; 443

NOTE: the ws_path describes the Host and the Port on which the WebSocket Server is, the ajax_path describes the Host and the Port on which the BK Server is, you also have to run those two servers on these Ports then
NOTE: SSL is only recommeded when using BK in combination with a webserver
NOTE: Those Ports are only for use with CGI only recommeded and CGI doesn't work in combination with Mojolicious and WebSockets
NOTE: It is anyway recommeded when using a webserver to take the combined configuration of both CGI for Dancer and Proxy for Mojolicous and the WebSockets then use always the standard ports for the desired protocols (NON SSL: WS & BK => 80 || SSL: WS & BK => 443)

## 5. Set up Database
  1.  mkdir database && cd database
  2.  ./CreateDatabase.sh

## 6. Set up Log Directory
  1.  mkdir log{s,} && cd log
  2.  touch {message,error}\_log
  3.  touch {production,development}.log
  4.  cd ../logs && touch {production,development}.log

### Apache2
#### Integrated in Apache2
  1.  use the **bk** (no SSL), **bk_redirect_ssl** and **bk-ssl** (SSL) configuration files
  2.  a2enmod perl

##### Configuration
  1.  Change the Serveradmin and the BK_Path in the Apache2 configuration files

#### Use a Proxy in Apache2
  1.  use the **bk_proxy** (no SSL), **bk_redirect_ssl_proxy** and **bk-ssl_proxy** (SSL) configuration files
  2.  a2enmod proxy
  3.  a2enmod proxy_http
  4.  a2enmod proxy_wstunnel

##### Configuration
  1.  Change the Serveradmin and the BK_AJAX_Port in the Apache2 configuration files

#### Use SSL
##### Enable mods
  1.  a2enmod rewrite
  2.  a2enmod ssl
  3.  a2enmod ldap
  4.  a2enmod authnz_ldap

##### Create self-signed certificate if wanted
  1.  mkdir -p /etc/ssl/localcerts/apache2
  2.  openssl req -new -x509 -days 365 -nodes -out /etc/ssl/localcerts/apache2/bk_certificate.pem -keyout /etc/ssl/localcerts/apache2/bk_certificate.key
  3.  chmod 600 /etc/ssl/localcerts/apache2/bk*

##### Changing protocols in javascript
  1.  Change the WS_Protocol and the AJAX_Protocol in the VariablesDefinitions.js script

#### Configuring Apache2 itself
  1.  Use the given apache2.conf and ports.conf configuration files for Apache2
  2.  Add the ports on which Apache2 should listen to the ports.conf file, described above at the BK Configuration, port 80 and 3003 for non SSL and port 443 and 4443 for SSL

#### Configuring LDAP Auth
  1.  Add LDAP_USER username in bk_ldap_users_groups.conf
  2.  Add LDAP_GROUP group in bk_ldap_users_groups.conf

#### Setting Permissions only for use with Apache2
  1.  chmod a+rwx {log,logs,database}
  2.  chmod a+rwx {log,logs,database}/*
