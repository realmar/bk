#!/bin/bash

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Bash
##  Created For / At: ETH Zuerich Department Physics
#########################################################

##  Backup Files
##    BKScanner.pl
##    BK.pl
##    public/javascript/scripts/variables/VariablesDefinition.js
##    Apache2_Config/apache2.conf
##    Apache2_Config/ports.conf
##    Apache2_Config/bk-ssl_proxy.conf
##    Apache2_Config/bk_redirect_ssl_proxy.conf
##    services/bkscanner.service
##    services/bk.service

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
    read -p 'Enter BK Path (the Folder with all files) [/opt/BK]: ' PA
    if [[ -z $PA ]]; then
        PA=/opt/BK
    fi
    echo 'Applying to: ' $PA

    if [[ ! -d $PA/backups ]]; then
        echo 'Generating restore point (Making Backups)'
        mkdir $PA/backups
        cp $PA/{BKScanner.pl,BK.pl} $PA/backups/.
        cp $PA/public/javascript/scripts/variables/VariablesDefinition.js $PA/backups/.
        cp -a $PA/Apache2_Config $PA/backups/.
        cp -a $PA/services $PA/backups/.
    else
        echo 'Going back to restore point (Restore Backups)'
        rm -rf $PA/{BKScanner.pl,BK.pl}
        rm -rf $PA/public/javascript/scripts/variables/VariablesDefinition.js
        rm -rf $PA/Apache2_Config
        rm -rf $PA/services
        cp $PA/backups/{BKScanner.pl,BK.pl} $PA/.
        cp $PA/backups/VariablesDefinition.js $PA/public/javascript/scripts/variables/.
        cp -a $PA/backups/Apache2_Config $PA/.
        cp -a $PA/backups/services $PA/.
    fi
    echo ''

    sed -i "s|<BK_PATH>|$PA|g" $PA/{BKScanner.pl,BK.pl}
    sed -i "s|<BK_PATH>|$PA|g" $PA/lib/BK/Common/CommonVariables.pm
    sed -i "s|<BK_PATH>|$PA|g" $PA/services/*

    echo ''

    read -p 'Do you want to install the required packages? [Y/n]: ' INSTPKG
    if [[ $INSTPKG =~ ^(yes|y) ]] || [[ -z $INSTPKG ]]; then
        echo 'Installing the required packages'
        aptitude install git perl apache2 libmojolicious-perl libinline-perl libinline-c-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libio-all-lwp-perl libusb-1.0-0 linux-headers-586 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc
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

    rm -rf $PA/{database,log,logs}

    echo 'Generating Log Files and Directories'
    mkdir $PA/{database,log,logs,_Inline}
    touch $PA/log/{message,error}_log
    touch $PA/log/{production,development}.log
    touch $PA/logs/{production,development}.log

    echo 'Stopping BK Services, this may take long'
    systemctl stop {bk,bkscanner}.service

    echo 'Setting up the database'
    echo 'AFTER DATABASE IS SET UP EXIT THE SQLITE3 CONSOLE WITH .exit TO CONTINUE THE SETUP'

    cd $PA/config
    bash CreateDatabase.sh

    echo ''
    echo ''

    read -p 'Enter the hostname of the BK - BuecherKasten server: ' HOSTNAME
    echo 'Applying: ' $HOSTNAME

    sed -i "s/<HOSTNAME>/$HOSTNAME/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js

    echo ''
    echo ''

    BK_PORT=443

    echo "The BK Server should be run on port $BK_PORT"
    echo "These values will be automatically set in the JavaScript"
    echo "You can manually change this by editing the public/javascript/scripts/variables/VariablesDefinition.js file and the corresponding Apache2 configuration files"

    echo ''
    echo ''

    echo 'Applying ' $BK_PORT

    sed -i "s/<BK_PORT>/$BK_PORT/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js

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
    sed -i "s|<BK_PATH>|$PA|g" $PA/Apache2_Config/*
    sed -i "s|<BK_PATH>|$PA|g" $PA/Apache2_Config/sites-common/*
    rm -rf /etc/apache2/{apache2,ports}.conf
    cp $PA/Apache2_Config/{apache2,ports}.conf /etc/apache2/.
    a2dissite {000-default.conf,default-ssl.conf}
    a2dissite {bk-ssl_proxy,bk_redirect_ssl_proxy}.conf
    rm -rf /etc/apache2/sites-available/bk*
    rm -rf /etc/apache2/sites-common/bk*
    read -p 'Enter the contact creditals of the Serveradmin MUST BE AN E-MAIL ADDRESS: ' SERVERADMIN
    echo 'Applying: ' $SERVERADMIN
    sed -i "s/<SERVERADMIN>/$SERVERADMIN/g" $PA/Apache2_Config/*
    sed -i "s/<SERVERADMIN>/$SERVERADMIN/g" $PA/Apache2_Config/sites-common/*
    read -p 'Enter the Port on which BK should run locally: ' BK_LOCAL_PORT
    echo 'Applying ' $BK_LOCAL_PORT
    sed -i "s|<BK_LOCAL_PORT>|$BK_LOCAL_PORT|g" $PA/Apache2_Config/*
    sed -i "s|<BK_LOCAL_PORT>|$BK_LOCAL_PORT|g" $PA/Apache2_Config/sites-common/*
    sed -i "s|<BK_LOCAL_PORT>|$BK_LOCAL_PORT|g" $PA/services/*
    sed -i "s|<BK_LOCAL_PORT>|$BK_LOCAL_PORT|g" $PA/BKScanner.pl
    sed -i "s|<HOSTNAME>|localhost|g" $PA/services/*
    read -p 'Do you want to create a Self Signed SSL Certificate? [Y/n]: ' MAKESSC
    if [[ $MAKESSC =~ ^(yes|y) ]] || [[ -z $MAKESSC ]]; then
        echo 'Creating SSL Self-Signed Certificates'
        rm -rf /etc/ssl/localcerts/apache2/bk*
        openssl req -new -x509 -days 365 -nodes -out /etc/ssl/localcerts/apache2/bk_certificate.pem -keyout /etc/ssl/localcerts/apache2/bk_certificate.key
        chmod 600 /etc/ssl/localcerts/apache2/bk*
    else
        echo ''
        echo ''
        echo 'Please place your certificates here: /etc/ssl/localcerts/apache2/'
        echo 'and name them: bk_certificate.{pem,key} or edit the Apache2 configuration files'
        echo ''
        echo ''
    fi
    a2enmod rewrite
    a2enmod ssl
    sed -i 's/<WS_PROTOCOL>/wss/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
    sed -i 's/<AJAX_PROTOCOL>/https/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
    echo 'Configuring LDAP Users and Groups'
    read -p 'Enter the a User to grant Access to BK N := no more users [<USERNAME>/n]' LDAPUSER
    while [[ ! $LDAPUSER =~ (N|n) ]] && [[ ! -z $LDAPUSER ]]; do
        echo "Require ldap-user $LDAPUSER" >> $PA/Apache2_Config/sites-common/bk_ldap_users_groups.conf
        read -p 'Enter the a User to grant Access to BK N := no more users [<USERNAME>/n]' LDAPUSER
    done
    read -p 'Enter the group to grant Access to BK N := no more groups [<GROUPNAME>/n]' LDAPGROUP
    while [[ ! $LDAPGROUP =~ (N|n) ]] && [[ ! -z $LDAPGROUP ]]; do
        echo "Require ldap-group cn=$LDAPGROUP,ou1=Group,ou=Physik Departement,o=ethz,c=ch" >> $PA/Apache2_Config/sites-common/bk_ldap_users_groups.conf
        read -p 'Enter the group to grant Access to BK N := no more groups [<GROUPNAME>/n]' LDAPGROUP
    done
    cp -a $PA/Apache2_Config/* /etc/apache2/sites-available/.
    rm -rf /etc/apache2/sites-available/{apache2,ports}.conf
    mv /etc/apache2/sites-available/sites-common /etc/apache2/.
    a2ensite bk_redirect_ssl_proxy.conf
    a2ensite bk-ssl_proxy.conf
    a2enmod proxy{_http,_wstunnel,}
    a2enmod {ldap,authnz_ldap}
    service apache2 start

    echo ''
    echo ''

    echo 'Copying Services, this may take long'
    systemctl disable bk{scanner,}.service
    rm -rf /lib/systemd/system/bk{scanner,}.service
    cp $PA/services/* /lib/systemd/system/.
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
    chmod a-rwx $PA/{log,logs,database,_Inline}
    chmod a-rwx $PA/{log,logs,database,_Inline}/*
    chmod u+rwx $PA/{log,logs,database,_Inline}
    chmod u+rw $PA/{log,logs,database,_Inline}/*
    chmod g+rwx $PA/{log,logs,database,_Inline}
    chmod g+rw $PA/{log,logs,database,_Inline}/*

    chown bk $PA/{log,logs,database,_Inline}
    chown bk $PA/{log,logs,database,_Inline}/*

    chgrp bk $PA/{log,logs,database,_Inline}
    chgrp bk $PA/{log,logs,database,_Inline}/*

    echo ''
    echo ''
    echo 'PLEASE VERIFY that all Services are running'
    echo 'systemctl status {bk,bkscanner}'
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
