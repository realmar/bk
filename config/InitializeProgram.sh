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
##    Apache2_Config/bk.conf
##    Apache2_Config/bk-ssl.conf
##    Apache2_Config/bk_proxy.conf
##    Apache2_Config/bk-ssl_proxy.conf
##    Apache2_Config/bk_redirect_ssl.conf
##    Apache2_Config/bk_redirect_ssl_proxy.conf

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
        cp -a $PA/Apache2_Config $PA/backups/.
        cp -a $PA/services $PA/backups/.
    else
        echo 'Going back to restore point (Restore Backups)'
        rm -rf $PA/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl}
        rm -rf $PA/public/javascript/scripts/variables/VariablesDefinition.js
        rm -rf $PA/Apache2_Config
        rm -rf $PA/services
        cp $PA/backups/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl} $PA/.
        cp $PA/backups/VariablesDefinition.js $PA/public/javascript/scripts/variables/.
        cp -a $PA/backups/Apache2_Config $PA/.
        cp -a $PA/backups/services $PA/.
    fi
    echo ''

    sed -i "s|<BK_PATH>|$PA|g" $PA/{BKBackend.pl,BKFrontend.pl,BKFrontendWebSockets.pl}
    sed -i "s|<BK_PATH>|$PA|g" $PA/lib/BK/Common/CommonVariables.pm
    sed -i "s|<BK_PATH>|$PA|g" $PA/services/*

    echo ''

    read -p 'Do you want to configure BK within the Apache2 WebServer? [Y/n]: ' USEAPACHE
    if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
        read -p 'Do you want to use CGI + Proxy in combination [B], CGI alone [C] or a Proxy [P]? [B/c/p]: ' USEBEST
        read -p 'DO you want to set up SSL? [Y/n]: ' USESSL
    fi

    read -p 'Do you want to install the required packages? [Y/n]: ' INST2
    if [[ $INST2 =~ ^(yes|y) ]] || [[ -z $INST2 ]]; then
        echo 'Installing the required packages'
        aptitude install perl git libdancer-perl libmojolicious-perl libinline-perl libinline-c-perl libjson-perl libtemplate-perl libdbi-perl libdbd-sqlite3-perl libusb-1.0-0 linux-headers-586 libc6-dev libusb-1.0-0-dev sqlite3 make unzip gcc
        if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
            aptitude install apache2
        fi
        if [[ $USEBEST =~ (C|c) ]] || [[ $USEBEST =~ (B/b) ]] || [[ -z $USEBEST ]]; then
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

    echo 'Setting up other required folders'

    if [[ -d $PA/database ]]; then
        rm -rf $PA/database
    fi

    if [[ -d $PA/log ]]; then
        rm -rf $PA/log
    fi

    echo 'Generating Log Files and Directories'
    mkdir $PA/{database,log,logs}
    touch $PA/log/{message,error}_log
    touch $PA/log/{production,development}.log
    touch $PA/logs/{production,development}.log

    echo 'Stopping BK Services, this may take some time'
    systemctl stop bk{backend,frontend,frontendwebsockets}.service

    echo 'Setting up the database'
    echo 'AFTER DATABASE IS SET UP EXIT THE SQLITE3 CONSOLE WITH .exit TO CONTINUE THE SETUP'

    cd $PA/config
    bash CreateDatabase.sh

    echo ''
    echo ''

    read -p 'Enter the hostname of the BK - BuecherKasten server: ' HOSTNAME
    echo 'Applying: ' $HOSTNAME

    sed -i "s/<HOSTNAME>/$HOSTNAME/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js
    if [[ $USEBEST =~ (C|c) ]]; then
        sed -i "s/<HOSTNAME>/$HOSTNAME/g" $PA/services/*
    fi

    echo ''
    echo ''

    if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
        if [[ $USEBEST =~ ^(C|c) ]]; then
            WS_PORT=4443
        else
            WS_PORT=443
        fi
        AJAX_PORT=443
    else
        if [[ $USEBEST =~ ^(C|c) ]]; then
            WS_PORT=3003
        else
            WS_PORT=80
        fi
        AJAX_PORT=80
    fi

    if [[ $USEAPACHE =~ (N|n) ]]; then
        WS_PORT=3003;
        AJAX_PORT=80;
        sed -i 's/<WS_PROTOCOL>/ws/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
        sed -i 's/<AJAX_PROTOCOL>/http/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
        sed -i "s|<HOSTNAME>|$HOSTNAME|g" $PA/environments/*
        sed -i "s|<BK_AJAX_PORT>|$AJAX_PORT|g" $PA/environments/*
    fi

    echo "Your BK AJAX Server should be run on port (if using proxy the port of which Apache2 listens) $AJAX_PORT"
    echo "Your BK WebSocket Server should be run on port (if using proxy the of which Apache2 listens) $WS_PORT"
    echo "These values will be automatically set in the JavaScript"
    echo "You can manually change this by editing the public/javascript/scripts/variables/VariablesDefinition.js file and the corresponding Apache2 configuration files"

    echo ''
    echo ''

    echo 'Applying ' $AJAX_PORT
    echo 'Applying ' $WS_PORT

    sed -i "s/<AJAX_PORT>/$AJAX_PORT/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js
    sed -i "s/<WS_PORT>/$WS_PORT/g" $PA/public/javascript/scripts/variables/VariablesDefinition.js
    if [[ $USEAPACHE =~ (N|n) ]] || [[ $USEBEST =~ (C|c) ]]; then
        sed -i "s/<BK_WS_PORT>/$WS_PORT/g" $PA/services/*
    fi

    echo ''
    echo ''

    if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
        read -p 'WARNING: webserver Apache2 will be stopped continue? [Y/n]' APACHECONT
        if [[ $APACHECONT =~ ^(yes|y) ]] || [[ -z $APACHECONT ]]; then
            service apache2 stop
            echo 'Initializing Apache Configuration Files'
            cd /etc/apache2
            sed -i "s|<BK_PATH>|$PA|g" $PA/Apache2_Config/*
            sed -i "s|<BK_PATH>|$PA|g" $PA/Apache2_Config/sites-common/*
            if [[ $WS_PORT -ne 80 ]] && [[ $WS_PORT -ne 443 ]]; then
                echo "Listen $WS_PORT" >> $PA/Apache2_Config/ports.conf
            fi
            if [[ $AJAX_PORT -ne 80 ]] && [[ $AJAX_PORT -ne 443 ]]; then
                echo "Listen $AJAX_PORT" >> $PA/Apache2_Config/ports.conf
            fi
            rm -rf /etc/apache2/{apache2,ports}.conf
            cp $PA/Apache2_Config/{apache2,ports}.conf /etc/apache2/.
            a2dissite {000-default.conf,default-ssl.conf}
            a2dissite {bk,bk-ssl,bk_proxy,bk-ssl_proxy,bk_redirect_ssl,bk_redirect_ssl_proxy,bk_bk-cgi_ws-proxy,bk-ssl_bk-cgi_ws-proxy}.conf
            rm -rf /etc/apache2/sites-available/bk*
            rm -rf /etc/apache2/sites-common/bk*
            read -p 'Enter the contact creditals of the Serveradmin MUST BE AN E-MAIL ADDRESS: ' SERVERADMIN
            echo 'Applying: ' $SERVERADMIN
            sed -i "s/<SERVERADMIN>/$SERVERADMIN/g" $PA/Apache2_Config/*
            sed -i "s/<SERVERADMIN>/$SERVERADMIN/g" $PA/Apache2_Config/sites-common/*
            if [[ $USEBEST =~ (B|b) ]] || [[ $USEBEST =~ (P|p) ]] || [[ -z $USEBEST ]]; then
                if [[ $USEBEST =~ (P|p) ]]; then
                    read -p 'Enter the Port on which BK should run locally: ' BK_AJAX_PORT
                    echo 'Applying ' $BK_AJAX_PORT
                    sed -i "s/<BK_AJAX_PORT>/$BK_AJAX_PORT/g" $PA/Apache2_Config/*
                    sed -i "s/<BK_AJAX_PORT>/$BK_AJAX_PORT/g" $PA/Apache2_Config/sites-common/*
                fi
                read -p 'Enter the Port on which WebSocket BK should run locally: ' BK_WS_PORT
                echo 'Applying ' $BK_WS_PORT
                sed -i "s/<BK_WS_PORT>/$BK_WS_PORT/g" $PA/Apache2_Config/*
                sed -i "s/<BK_WS_PORT>/$BK_WS_PORT/g" $PA/Apache2_Config/sites-common/*
                sed -i "s/<BK_WS_PORT>/$BK_WS_PORT/g" $PA/services/*
                sed -i "s/<HOSTNAME>/localhost/g" $PA/services/*
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
                sed -i 's/<WS_PROTOCOL>/wss/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
                sed -i 's/<AJAX_PROTOCOL>/https/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
            else
                sed -i 's/<WS_PROTOCOL>/ws/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
                sed -i 's/<AJAX_PROTOCOL>/http/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
            fi
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
            if [[ $USEBEST =~ (B|b) ]] || [[ -z $USEBEST ]]; then
                if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
                    a2ensite bk_redirect_ssl.conf
                    a2ensite bk-ssl_bk-cgi_ws-proxy.conf
                else
                    a2ensite bk_bk-cgi_ws-proxy.conf
                fi
                a2enmod perl
                a2enmod proxy{_http,_wstunnel,}
                sed -i 's|<HOSTNAME>|localhost|g' $PA/environments/*
                sed -i "s|<BK_AJAX_PORT>|$BK_AJAX_PORT|g" $PA/environments/*
            elif [[ $USEBEST =~ (C|c) ]]; then
                if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
                    a2ensite bk_redirect_ssl.conf
                    a2ensite bk-ssl.conf
                else
                    a2ensite bk.conf
                fi
                a2enmod perl
                sed -i "s|<HOSTNAME>|$HOSTNAME|g" $PA/environments/*
                sed -i "s|<BK_AJAX_PORT>|$AJAX_PORT|g" $PA/environments/*
            elif [[ $USEBEST =~ (P|p) ]]; then
                if [[ $USESSL =~ ^(yes|y) ]] || [[ -z $USESSL ]]; then
                    a2ensite bk_redirect_ssl_proxy.conf
                    a2ensite bk-ssl_proxy.conf
                else
                    a2ensite bk_proxy.conf
                fi
                a2enmod proxy{_http,_wstunnel,}
                sed -i 's|<HOSTNAME>|localhost|g' $PA/environments/*
                sed -i "s|<BK_AJAX_PORT>|$BK_AJAX_PORT|g" $PA/environments/*
            fi
            a2enmod {ldap,authnz_ldap}
            service apache2 start
        else
            sed -i 's/<WS_PROTOCOL>/ws/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
            sed -i 's/<AJAX_PROTOCOL>/http/g' $PA/public/javascript/scripts/variables/VariablesDefinition.js
            echo 'Continue without Apache2 Configuration, you have to do this manually if you want to use these features'
        fi
    fi

    echo ''
    echo ''

    echo 'Copying Services, this may take long'
    systemctl disable bk{backend,frontend,frontendwebsockets}.service
    rm -rf /lib/systemd/system/bk*
    cp $PA/services/* /lib/systemd/system/.
    systemctl daemon-reload

    echo ''
    echo ''

    if [[ $USEAPACHE =~ ^(yes|y) ]] || [[ -z $USEAPACHE ]]; then
        if [[ $APACHECONT =~ ^(yes|y) ]] || [[ -z $APACHECONT ]]; then
            if [[ $USEBEST =~ (B|b) ]] || [[ $USEBEST =~ (P|p) ]] || [[ -z $USEBEST ]]; then
                echo 'Enabling BK Web Services'
                systemctl enable bkfrontendwebsockets.service
                echo 'Starting BK Web Services'
                systemctl start bkfrontendwebsockets.service
            fi
        fi
    fi

    read -p 'Do you want to configure the BK Backend Service (WARNING: this will disable all GETTYs and will run BKBackend on TTY1) [Y/n]' $CONFBKB
    if [[ $CONFBKB =~ ^(Y|y) ]] || [[ -z $CONFBKB ]]; then
        if [[ -d /etc/systemd/system/getty.target.wants ]]; then
            cd /etc/systemd/system/getty.target.wants
            ls | xargs systemctl stop
            ls | xargs systemctl disable
        fi
        systemctl enable bkbackend.service
        systemctl start bkbackend.service
    else
        echo 'You have to configure BK Backend manually'
        echo 'Take a look at the BK Installation guide'
    fi

    echo ''
    echo ''

    echo 'Correcting Permissions'
    chmod a+rwx $PA/{log,logs,database}
    chmod a+rwx $PA/{log,logs,database}/*

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
