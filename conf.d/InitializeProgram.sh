#!/bin/bash

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Bash
##  Created For / At: ETH Zuerich Department Physics
#########################################################

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

/bin/echo '-------------------------------------------------------------------------'
/bin/echo 'Welcome to BK - BuecherKasten'
/bin/echo 'Thank you for choosing our software solution'
/bin/echo ''
/bin/echo 'Author: Anastassios Martakos / ISG D-PHYS / ETH Zuerich Hoenggerberg'
/bin/echo '-------------------------------------------------------------------------'
/bin/echo ''
read -p 'Do you want to install BK - Buecherkasten? [Y/n]: ' INSTBK
if [[ $INSTBK =~ ^(yes|y) ]] || [[ -z $INSTBK ]]; then
    /bin/echo ''
    read -p 'Enter the Path where BK is located (BK and BKScanner) [/opt/BK]: ' PA
    if [[ -z $PA ]]; then
        PA=/opt/BK
    fi

    read -p 'Do you want to install the required packages? [Y/n]: ' INSTPKG
    if [[ $INSTPKG =~ ^(yes|y) ]] || [[ -z $INSTPKG ]]; then
        /bin/echo 'Installing the required packages'
        /usr/bin/aptitude install git perl apache2 libmojolicious-perl libinline-perl libinline-c-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libio-all-lwp-perl libyaml-tiny-perl libemail-sender-perl libusb-1.0-0 linux-headers-586 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc
    else
        /bin/echo 'Not installing the required packages'
    fi

    read -p 'Do you want to download and install the drivers of the LabJack U12 device? [Y/n]: ' INSTLJ
    if [[ $INSTLJ =~ (yes|y) ]] || [[ -z $INSTLJ ]]; then
        /bin/echo 'Downloading drivers'

        if [[ -d $PA/drivers ]]; then
            /bin/rm -rf $PA/drivers
        fi

        /bin/mkdir $PA/drivers
        /usr/bin/wget -P $PA/drivers http://labjack.com/sites/default/files/2013/10/ljacklm.zip
        /usr/bin/wget -P $PA/drivers https://github.com/labjack/exodriver/archive/master.zip

        cd $PA/drivers
        /usr/bin/unzip $PA/drivers/ljacklm.zip && /usr/bin/unzip $PA/drivers/master.zip

        cd $PA/drivers/exodriver-master
        /bin/sed -i '15i CFLAGS=-I/usr/src/linux-headers-3.16.0-4-common' $PA/drivers/exodriver-master/liblabjackusb/Makefile
        /bin/bash $PA/drivers/exodriver-master/install.sh

        cd $PA/drivers/ljacklm/libljacklm

        /bin/echo 'Compiling Drivers'

        /usr/bin/make clean
        /usr/bin/make install

        /bin/echo 'Copying Drivers to corresponding directories'

        /bin/cp $PA/drivers/ljacklm/libljacklm/{libljacklm.so.1.20.2,ljacklm.h} /usr/local/lib/.
        /bin/mv /usr/local/lib/libljacklm.so.1.20.2 /usr/local/lib/libljacklm.so
    else
        /bin/echo 'Not downloading and installing the LabJack drivers'
    fi

    read -p 'Generating BK User bk if a User named bk exists it will be deleted continue? [Y/n]: ' GENUSER
    if [[ $GENUSER =~ ^(no|n) ]]; then
        /bin/echo 'Not configuring BK User'
        /bin/echo 'Abording installation of BK'
        exit 0;
    fi
    if [[ `getent passwd bk` ]]; then
        /usr/sbin/deluser bk
    fi
    /usr/sbin/useradd bk
    /bin/echo 'Configuring Groups and Shell for the bk User'
    /usr/sbin/usermod -a -G adm bk
    /bin/sed -i 's|/bin/sh|/bin/false|g' /etc/passwd
    /bin/echo 'Setting up other required folders'

    /bin/rm -rf $PA/{database,log}

    /bin/echo 'Generating Log Files and Directories'
    /bin/mkdir $PA/{database,log}
    /usr/bin/touch $PA/log/{message,error}_log
    /usr/bin/touch $PA/log/{production,development}.log

    /bin/echo 'Stopping BK Services, this may take long'
    /bin/systemctl stop {bk,bkscanner}.service

    /bin/echo 'Setting up the database'
    /bin/echo 'AFTER DATABASE IS SET UP EXIT THE SQLITE3 CONSOLE WITH .exit TO CONTINUE THE SETUP'

    sqlite3 -init $PA/conf.d/DBConfig.sql $PA/database/BKDatabase.db

    /bin/echo ''
    /bin/echo ''

    read -p 'WARNING: webserver Apache2 will be stopped continue? [Y/n]' APACHECONT
    if [[ $APACHECONT =~ ^(no|n) ]]; then
        /bin/echo 'Not configuring BK with Apache2, you have to configure BK on your own'
        /bin/echo 'Abording installation of BK'
        exit 0
    fi
    /bin/systemctl stop apache2
    /bin/echo 'Initializing Apache Configuration Files'
    cd /etc/apache2
    /bin/rm -rf /etc/apache2/{apache2,ports}.conf
    /bin/cp $PA/Apache2_Config/{apache2,ports}.conf /etc/apache2/.
    a2dissite {000-default.conf,default-ssl.conf}
    a2dissite bk.conf
    /bin/rm -rf /etc/apache2/sites-available/bk*
    /bin/rm -rf /etc/apache2/sites-common/bk*
    
    ##  this section is for generating a self signed certificate and is not u/bin/sed but here just for your info/bin/rmation how to do this
    ##  
    ##      read -p 'Do you want to create a Self Signed SSL Certificate? [Y/n]: ' MAKESSC
    ##      /bin/mkdir -p /etc/apache2/certs/localcerts/bk/ssl.{crt,key}
    ##      /bin/rm -rf /etc/apache2/certs/localcerts/bk/ssl.{crt,key}/$HOSTNAME*
    ##      openssl req -new -x509 -days 365 -nodes -out /etc/apache2/certs/localcerts/bk/ssl.crt/$HOSTNAME.crt -keyout /etc/apache2/certs/localcerts/bk/ssl.key/$HOSTNAME.key
    ##      /bin/chmod 600 /etc/apache2/certs/localcerts/bk/ssl.{crt,key}/$HOSTNAME*

    /bin/mkdir -p /etc/apache2/certs/bk/ssl.{crt,key}
    /bin/echo ''
    /bin/echo ''
    /bin/echo 'Please place your certificates here: /etc/apache2/certs/bk/ssl.{crt,key}'
    /bin/echo "and name them: phd-bookshelf.{pem,key} or edit the Apache2 configuration files"
    /bin/echo ''
    /bin/echo ''
    a2enmod rewrite
    a2enmod ssl
    /bin/cp -a $PA/Apache2_Config/* /etc/apache2/sites-available/.
    /bin/rm -rf /etc/apache2/sites-available/{apache2,ports}.conf
    /bin/mv /etc/apache2/sites-available/sites-common /etc/apache2/.
    a2ensite bk.conf
    a2enmod proxy{_http,_wstunnel,}
    a2enmod {ldap,authnz_ldap}
    /bin/systemctl start apache2

    /bin/echo ''
    /bin/echo ''

    /bin/echo 'Copying Services, this may take long'
    /bin/systemctl disable bk{scanner,}.service
    /bin/rm -rf /etc/systemd/system/bk{scanner,}.service
    /bin/cp $PA/services/* /etc/systemd/system/.
    /bin/systemctl daemon-reload

    /bin/echo ''
    /bin/echo ''

    read -p 'Do you want to configure the BK Backend Service (WARNING: this will disable all GETTYs and will run BKBackend on TTY1) [Y/n]' $CONFBKB
    if [[ $CONFBKB =~ ^(Y|y) ]] || [[ -z $CONFBKB ]]; then
        if [[ -d /etc/systemd/system/getty.target.wants ]]; then
            cd /etc/systemd/system/getty.target.wants
            ls | xargs /bin/systemctl stop
            ls | xargs /bin/systemctl disable
        fi
        /bin/systemctl enable bkscanner.service
        /bin/systemctl start bkscanner.service
    else
        /bin/echo 'You have to configure BK Backend manually'
        /bin/echo 'Take a look at the BK Installation guide'
    fi

    /bin/echo 'Enabling BK Web Services'
    /bin/systemctl enable bk.service
    /bin/echo 'Starting BK Web Services'
    /bin/systemctl start bk.service

    /bin/echo ''
    /bin/echo ''

    /bin/echo 'Correcting Pe/bin/rmissions'
    /bin/chown bk $PA
    /bin/chgrp bk $PA
    /bin/chmod a-rwx $PA/{log,database}
    /bin/chmod a-rwx $PA/{log,database}/*
    /bin/chmod u+rwx $PA/{log,database}
    /bin/chmod u+rw $PA/{log,database}/*
    /bin/chmod g+rwx $PA/{log,database}
    /bin/chmod g+rw $PA/{log,database}/*

    /bin/chown bk $PA/{log,database}
    /bin/chown bk $PA/{log,database}/*

    /bin/chgrp bk $PA/{log,database}
    /bin/chgrp bk $PA/{log,database}/*

    /bin/echo ''
    /bin/echo ''
    /bin/echo 'PLEASE VERIFY that all Services are running'
    /bin/echo '/bin/systemctl status {apache2,bk,bkscanner}'
    /bin/echo ''
    /bin/echo ''

    /bin/echo '---------------------------------------------------------'
    /bin/echo 'Installation Complete'
    /bin/echo 'Thank you for choosing our software solutions'
    /bin/echo '---------------------------------------------------------'
else
    /bin/echo ''
    /bin/echo 'Installation aborted'
fi

/bin/echo ''
/bin/echo ''
