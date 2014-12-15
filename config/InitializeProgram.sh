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

    read -p 'Do you want to install the required packages? [Y/n]: ' INST2
    if [[ $INST2 =~ ^(yes|y) ]] || [[ -z $INST2 ]]; then
        echo 'Installing the required packages'
        aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-486 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc
    else
        echo 'Not installing the required packages'
    fi

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

    echo 'Setting up other required folders'

    mkdir $PA/{database,log}

    echo 'Setting up the database'

    cd $PA/database
    bash CreateDatabase.sh

    echo ''
    echo ''

    read -p 'Enter the hostname of the BK - BuecherKasten server: ' HOSTNAME
    echo 'Applying: ' $HOSTNAME

    sed -i "s/<HOSTNAME>/$HOSTNAME/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js

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
