#!/bin/bash

echo '-------------------------------------------------------------------------'
echo 'Welcome to BK - BuecherKasten'
echo 'Thank you for choosing our software solution'
echo ''
echo 'Author: Anastassios Martakos / ISG D-PHYS / ETH Zuerich Hoenggerberg'
echo '-------------------------------------------------------------------------'
echo ''
read -p 'Do you want to install BK - Buecherkasten? [Y/n]: ' INST
INST=${INST,,}
if [[ $INST =~ ^(yes|y) ]] || [[ -z $INST ]]; then
    echo ''
    read -p 'Enter BK Path (the Folder with all files) [/opt/BK]: ' PA
    if [[ -z $PA ]]; then
        PA=/opt/BK
    fi
    echo 'Applying to: ' $PA
    echo 'Installing required packages'

    aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-486 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc

    echo 'Downloading drivers'

    mkdir "$PA/drivers" && cd "$PA/drivers"
    wget http://labjack.com/sites/default/files/2013/10/ljacklm.zip

    unzip ljacklm.zip
    cd "$PA/drivers/ljacklm/libljacklm"

    echo 'Copiling Drivers'

    make clean
    make install

    echo 'Copying Drivers to correspondant directories'

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

    echo 'Installation Complete'
    echo 'Thank you for choosing our software solutions'
else
    echo ''
    echo 'Installation aborded'
fi

echo ''
echo ''
