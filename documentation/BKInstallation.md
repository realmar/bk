# BuecherkastenBibliothek BK -- Installation Guide

## 1. Operating System
  1.  Debian
  2.  Install Debian Server as described in our RT Wiki

## 2. Apt Packages
  1.  aptitude install perl
  2.  aptitude install git
  3.  aptitude install libdancer-perl
  4.  aptitude install libmojolicious-perl
  5.  aptitude install libinline-perl
  6.  aptitude install unzip
  7.  aptitude install gcc

## 3. Install LabJack Drivers
  1.  mkdir /opt/drivers && cd /opt/drivers
  2.  Download Drivers
        -  wget http://labjack.com/sites/default/files/2013/10/ljacklm.zip
        -  https://github.com/labjack/exodriver/archive/master.zip
  3.  unzip ljacklm.zip && unzip master.zip
  4.  cd exodriver-master
  5.  ./install.sh
