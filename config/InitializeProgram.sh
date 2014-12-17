#!/bin/bash

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Bash
##  Created For / At: ETH Zuerich Department Physics
#########################################################

##  Backup Files
##    BKBackend.pl
##    BKFrontend.pl
##    BKFrontendWebSockets.pl
##    public/javascript/scripts/variables/VariablesDefinition.js
##    Apache2_Config/bk
##    Apache2_Config/bk-ssl
##    Apache2_Config/bk_proxy
##    Apache2_Config/bk-ssl_proxy

echo '-------------------------------------------------------------------------'
echo 'Welcome to BK - BuecherKasten'
echo 'Thank you for choosing our software solution'
echo ''
echo 'Author: Anastassios Martakos / ISG D-PHYS / ETH Zuerich Hoenggerberg'
echo '-------------------------------------------------------------------------'
echo ''
read -p 'Do you want to install BK - Buecherkasten? [Y/n]: ' INST1
if [[ $INST1 =~ ^(yes|y) ]] || [[ -z $INST1 ]]; then
    echo ''
    read -p 'Enter BK Path (the Folder with all files) [/opt/BK]: ' PA
    if [[ -z $PA ]]; then
        PA=/opt/BK
    fi
    echo 'Applying to: ' $PA

    if [[ ! -d $PA/backups ]]; then
        echo 'Generating restore point (Making Backups)'
        mkdir $PA/backups
        cp $PA/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl} $PA/backups/.
        cp $PA/public/javascript/scripts/variables/VariablesDefinition.js $PA/backups/.
        cp $PA/Apache2_Config/{bk,bk-ssl,bk_proxy,bk-ssl_proxy,bk_redirect_ssl,bk_redirect_ssl_proxy} $PA/backups/.
    else
        echo 'Going back to restore point (Restore Backups)'
        rm -rf $PA/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl}
        rm -rf $PA/public/javascript/scripts/variables/VariablesDefinition.js
        rm -rf $PA/Apache2_Config/{bk,bk-ssl,bk_proxy,bk-ssl_proxy,bk_redirect_ssl,bk_redirect_ssl_proxy}
        cp $PA/backups/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl} $PA/.
        cp $PA/backups/VariablesDefinition.js $PA/public/javascript/scripts/variables/.
        cp $PA/backups/{bk,bk-ssl,bk_proxy,bk-ssl_proxy,bk_redirect_ssl,bk_redirect_ssl_proxy} $PA/Apache2_Config/.
    fi
    echo ''

    sed -i "s|/opt/BK|$PA|g" $PA/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl}

    echo ''

    read -p 'Do you want to configure BK within the Apache2 WebServer? [Y/n]: ' USEAPACHE
    if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
        read -p 'Do you want to use CGI or a Proxy? [C/p]: ' USECGI
        read -p 'DO you want to set up SSL? [Y/n]: ' USESSL
    fi

    read -p 'Do you want to install the required packages? [Y/n]: ' INST2
    if [[ $INST2 =~ ^(yes|y) ]] || [[ -z $INST2 ]]; then
        echo 'Installing the required packages'
        aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-486 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc
        if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
            aptitude install apache2
        fi
        if [[ $USECGI =~ (C|c) ]] || [[ -z $USECGI ]]; then
            aptitude install libapache2-mod-perl2 libplack-perl
        fi
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
        sed -i '15i CFLAGS=-I/usr/src/linux-headers-3.2.0-4-common' $PA/drivers/exodriver-master/liblabjackusb/Makefile
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

    echo 'Setting up other required folders'

    if [[ -d $PA/database ]]; then
        rm -rf $PA/database
    fi

    if [[ -d $PA/log ]]; then
        rm -rf $PA/log
    fi

    mkdir $PA/{database,log}
    touch $PA/log/{message,error}_log

    echo 'Setting up the database'

    cd $PA/config
    bash CreateDatabase.sh

    echo ''
    echo ''

    read -p 'Enter the hostname of the BK - BuecherKasten server: ' HOSTNAME
    echo 'Applying: ' $HOSTNAME

    sed -i "s/<HOSTNAME>/$HOSTNAME/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js

    echo ''
    echo ''

    read -p 'Enter the Port on which the BK - BuecherKasten Server should run: ' AJAX_PORT
    read -p 'Enter the Port on which the WebSocket BK - BuecherKasten Server should run: ' WS_PORT
    echo 'Applying BK Port: ' $AJAX_PORT
    echo 'Applying WS BK Port: ' $WS_PORT

    sed -i "s/<AJAX_PORT>/$AJAX_PORT/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js
    sed -i "s/<WS_PORT>/$WS_PORT/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js

    echo ''
    echo ''

    if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
        read -p 'WARNING: webserver Apache2 will be stopped continue? [Y/n]' APACHECONT
        if [[ $APACHECONT =~ ^(yes|y) ]] || [[ -z $APACHECONT ]]; then
            service apache2 stop
            echo 'Initializing Apache Configuration Files'
            cd /etc/apache2
            a2dissite default{-ssl,}
            a2dissite {bk,bk-ssl,bk_proxy,bk-ssl_proxy,bk_redirect_ssl,bk_redirect_ssl_proxy}
            rm -rf /etc/apache2/sites-available/bk*
            sed -i "s|<BK_PATH>|$PA|g" $PA/Apache2_Config/*
            read -p 'Enter the contact creditals of the Serveradmin MUST BE AN E-MAIL ADDRESS: ' SERVERADMIN
            echo 'Applying: ' $SERVERADMIN
            sed -i "s/<SERVERADMIN>/$SERVERADMIN/g" $PA/Apache2_Config/*
            if [[ ! $USECGI =~ (C|c) ]] && [[ ! -z $USECGI ]]; then
                read -p 'Enter the Port on which BK should run locally DIFFERENT FROM THE BK PORT ENTERED ABOVE: ' BK_AJAX_PORT
                echo 'Applying ' $BK_AJAX_PORT
                sed -i "s/<BK_AJAX_PORT>/$BK_AJAX_PORT/g" $PA/Apache2_Config/*
            fi
            if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
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
            fi
            cp $PA/Apache2_Config/* /etc/apache2/sites-available/.
            if [[ $USECGI =~ (C|c) ]] || [[ -z $USECGI ]]; then
                if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
                    a2ensite bk_redirect_ssl
                    a2ensite bk-ssl
                else
                    a2ensite bk
                fi
                a2enmod perl
            else
                if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
                    a2ensite bk_redirect_ssl_proxy
                    a2ensite bk-ssl_proxy
                else
                    a2ensite bk_proxy
                fi
                a2enmod proxy{_http,}
            fi
            echo 'Correcting Permissions'
            chmod a+rwx $PA/{log,database}
            chmod a+rwx $PA/{log,database}/*
            service apache2 start
        else
            echo 'Continue without Apache2 Configuration, you have to do this manually if you want to use these features'
        fi
    fi

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
