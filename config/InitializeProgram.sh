#!/bin/bash

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

    sed -i "s|/opt/BK|$PA|g" $PA/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl}

    echo ''

    read -p 'Do you want to configure BK within the Apache2 WebServer? [Y/n]: ' USEAPACHE
    if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
        read -p 'Do you want to use CGI or a Proxy? [C/p]: ' USECGI
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

        cp $PA/drivers/ljacklm/libljacklm/{libljacklm.so.1.20.2,ljacklm.h} /usr/local/lib/
        mv /usr/local/lib/libljacklm.so.1.20.2 /usr/local/lib/libljacklm.so
    else
        echo 'Not downloading and installing the LabJack drivers'
    fi

    echo 'Setting up other required folders'

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
            a2dissite default{-ssl}
            sed -i "s/<BK_PATH>/$PA/g" $PA/Apache2_Config/*
            read -p 'Enter the contact creditals of the Serveradmin MUST BE AN E-MAIL ADDRESS: ' SERVERADMIN
            echo 'Applying: ' $SERVERADMIN
            sed -i "s/<SERVERADMIN>/$SERVERADMIN/g" $PA/Apache2_Config/*
            if [[ ! $USECGI =~ (C|c) ]] && [[ ! -z $USECGI ]]; then
                read -p 'Enter the Port on which BK should run locally DIFFERENT FROM THE BK PORT ENTERED ABOVE: ' BK_AJAX_PORT
                echo 'Applying ' $BK_AJAX_PORT
                sed -i "s/<BK_AJAX_PORT>/$BK_AJAX_PORT/g" $PA/Apache2_Config/*
            fi
            cp $PA/Apache2_Config/* /etc/apache2/sites-available/.
            if [[ $USECGI =~ (C|c) ]] || [[ -z $USECGI ]]; then
                a2ensite bk{-ssl}
                a2enmod perl
            else
                a2ensite bk{-ssl}_proxy
                a2enmod proxy{_http}
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
