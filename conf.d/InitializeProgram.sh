#!/bin/bash

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Bash
##  Created For / At: ETH Zuerich Department Physics
#########################################################

echo '-------------------------------------------------------------------------'
echo 'Welcome to BK - BuecherKasten'
echo 'Thank you for choosing our software solution'
echo ''
echo 'Author: Anastassios Martakos / ISG D-PHYS / ETH Zuerich Hoenggerberg'
echo '-------------------------------------------------------------------------'
echo ''
read -p 'Do you want to install BK - Buecherkasten? [Y/n]: ' INSTBK
if [[ $INSTBK =~ ^(yes|y) ]] || [[ -z $INSTBK ]]; then
    echo ''
    read -p 'Enter the Path where BK is located (BK and BKScanner) [/opt/BK]: ' PA
    if [[ -z $PA ]]; then
        PA=/opt/BK
    fi

    read -p 'Do you want to install the required packages? [Y/n]: ' INSTPKG
    if [[ $INSTPKG =~ ^(yes|y) ]] || [[ -z $INSTPKG ]]; then
        echo 'Installing the required packages'
        aptitude install git perl apache2 libmojolicious-perl libinline-perl libinline-c-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libio-all-lwp-perl libyaml-tiny-perl libemail-sender-perl libusb-1.0-0 linux-headers-586 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc
    else
        echo 'Not installing the required packages'
    fi

    read -p 'Do you want to download and install the drivers of the LabJack U12 device? [Y/n]: ' INSTLJ
    if [[ $INSTLJ =~ (yes|y) ]] || [[ -z $INSTLJ ]]; then
        echo 'Downloading drivers'

        if [[ -d $PA/drivers ]]; then
            rm -rf $PA/drivers
        fi

        mkdir $PA/drivers
        wget -P $PA/drivers http://labjack.com/sites/default/files/2013/10/ljacklm.zip
        wget -P $PA/drivers https://github.com/labjack/exodriver/archive/master.zip

        cd $PA/drivers
        unzip $PA/drivers/ljacklm.zip && unzip $PA/drivers/master.zip

        cd $PA/drivers/exodriver-master
        sed -i '15i CFLAGS=-I/usr/src/linux-headers-3.16.0-4-common' $PA/drivers/exodriver-master/liblabjackusb/Makefile
        bash $PA/drivers/exodriver-master/install.sh

        cd $PA/drivers/ljacklm/libljacklm

        echo 'Compiling Drivers'

        make clean
        make install

        echo 'Copying Drivers to corresponding directories'

        cp $PA/drivers/ljacklm/libljacklm/{libljacklm.so.1.20.2,ljacklm.h} /usr/local/lib/.
        mv /usr/local/lib/libljacklm.so.1.20.2 /usr/local/lib/libljacklm.so
    else
        echo 'Not downloading and installing the LabJack drivers'
    fi

    read -p 'Generating BK User bk if a User named bk exists it will be deleted continue? [Y/n]: ' GENUSER
    if [[ $GENUSER =~ ^(no|n) ]]; then
        echo 'Not configuring BK User'
        echo 'Abording installation of BK'
        exit 0;
    fi
    if [[ `getent passwd bk` ]]; then
        deluser bk
    fi
    useradd bk
    echo 'Configuring Groups for the bk User'
    usermod -a -G adm bk
    echo 'Setting up other required folders'

    rm -rf $PA/{database,log}

    echo 'Generating Log Files and Directories'
    mkdir $PA/{database,log}
    touch $PA/log/{message,error}_log
    touch $PA/log/{production,development}.log

    echo 'Stopping BK Services, this may take long'
    systemctl stop {bk,bkscanner}.service

    echo 'Setting up the database'
    echo 'AFTER DATABASE IS SET UP EXIT THE SQLITE3 CONSOLE WITH .exit TO CONTINUE THE SETUP'

    sqlite3 -init $PA/config/DBConfig.sql $PA/database/BKDatabase.db

    echo ''
    echo ''

    read -p 'WARNING: webserver Apache2 will be stopped continue? [Y/n]' APACHECONT
    if [[ $APACHECONT =~ ^(no|n) ]]; then
        echo 'Not configuring BK with Apache2, you have to configure BK on your own'
        echo 'Abording installation of BK'
        exit 0
    fi
    service apache2 stop
    echo 'Initializing Apache Configuration Files'
    cd /etc/apache2
    rm -rf /etc/apache2/{apache2,ports}.conf
    cp $PA/Apache2_Config/{apache2,ports}.conf /etc/apache2/.
    a2dissite {000-default.conf,default-ssl.conf}
    a2dissite bk.conf
    rm -rf /etc/apache2/sites-available/bk*
    rm -rf /etc/apache2/sites-common/bk*
    
    ##  this section is for generating a self signed certificate and is not used but here just for your information how to do this
    ##  
    ##      read -p 'Do you want to create a Self Signed SSL Certificate? [Y/n]: ' MAKESSC
    ##      mkdir -p /etc/apache2/certs/localcerts/bk/ssl.{crt,key}
    ##      rm -rf /etc/apache2/certs/localcerts/bk/ssl.{crt,key}/$HOSTNAME*
    ##      openssl req -new -x509 -days 365 -nodes -out /etc/apache2/certs/localcerts/bk/ssl.crt/$HOSTNAME.crt -keyout /etc/apache2/certs/localcerts/bk/ssl.key/$HOSTNAME.key
    ##      chmod 600 /etc/apache2/certs/localcerts/bk/ssl.{crt,key}/$HOSTNAME*

    mkdir -p /etc/apache2/certs/bk/ssl.{crt,key}
    echo ''
    echo ''
    echo 'Please place your certificates here: /etc/apache2/certs/bk/ssl.{crt,key}'
    echo "and name them: phd-bookshelf.{pem,key} or edit the Apache2 configuration files"
    echo ''
    echo ''
    a2enmod rewrite
    a2enmod ssl
    cp -a $PA/Apache2_Config/* /etc/apache2/sites-available/.
    rm -rf /etc/apache2/sites-available/{apache2,ports}.conf
    mv /etc/apache2/sites-available/sites-common /etc/apache2/.
    a2ensite bk.conf
    a2enmod proxy{_http,_wstunnel,}
    a2enmod {ldap,authnz_ldap}
    service apache2 start

    echo ''
    echo ''

    echo 'Copying Services, this may take long'
    systemctl disable bk{scanner,}.service
    rm -rf /etc/systemd/system/bk{scanner,}.service
    cp $PA/services/* /etc/systemd/system/.
    systemctl daemon-reload

    echo ''
    echo ''

    read -p 'Do you want to configure the BK Backend Service (WARNING: this will disable all GETTYs and will run BKBackend on TTY1) [Y/n]' $CONFBKB
    if [[ $CONFBKB =~ ^(Y|y) ]] || [[ -z $CONFBKB ]]; then
        if [[ -d /etc/systemd/system/getty.target.wants ]]; then
            cd /etc/systemd/system/getty.target.wants
            ls | xargs systemctl stop
            ls | xargs systemctl disable
        fi
        systemctl enable bkscanner.service
        systemctl start bkscanner.service
    else
        echo 'You have to configure BK Backend manually'
        echo 'Take a look at the BK Installation guide'
    fi

    echo 'Enabling BK Web Services'
    systemctl enable bk.service
    echo 'Starting BK Web Services'
    systemctl start bk.service

    echo ''
    echo ''

    echo 'Correcting Permissions'
    chown bk $PA
    chgrp bk $PA
    chmod a-rwx $PA/{log,database}
    chmod a-rwx $PA/{log,database}/*
    chmod u+rwx $PA/{log,database}
    chmod u+rw $PA/{log,database}/*
    chmod g+rwx $PA/{log,database}
    chmod g+rw $PA/{log,database}/*

    chown bk $PA/{log,database}
    chown bk $PA/{log,database}/*

    chgrp bk $PA/{log,database}
    chgrp bk $PA/{log,database}/*

    echo ''
    echo ''
    echo 'PLEASE VERIFY that all Services are running'
    echo 'systemctl status {apache2,bk,bkscanner}'
    echo ''
    echo ''

    echo '---------------------------------------------------------'
    echo 'Installation Complete'
    echo 'Thank you for choosing our software solutions'
    echo '---------------------------------------------------------'
else
    echo ''
    echo 'Installation aborted'
fi

echo ''
echo ''
