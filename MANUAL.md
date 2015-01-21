# BK MANUAL

Author:
Anastassios Martakos

To Deploy please read the README.md

## Components
  -  BK
  -  BKScanner
  -  SQLite Database

### BK
This is the al in one frontend meaning, it is the webserver, door opener and reads / writes to the database

### BKScanner
Only get the user input from the barcode reader and makes an http request to localhost to the BK

### SQLite Database
Stores the informations which door is to which user assigned

## Services
There are two services (based on systemd service files) the **bk.service** and the **bkscanner.service** which runs the appropriate script, as the name of these services tells. They are configured that they will restart if they break down.

## Webserver
### Apache2
Apache2 runs a proxy on the Mojolicious Webserver

### Mojolicious
Is the actual webserver which delivers the data, runs only on localhost (recommeded by init script)
