BK README
=========

What Is This?
-------------
BK stands for BuecherKasten, meaning bookshelf. It controls the physical doors connected to a processing unit (LabJack) by reading user input from a barcode scanner.  
It also provides a web interface to manage which user can open which door.  
The project is designed for the library of the physics department at ETH Zuerich 
but it can be expanded when necessary.

Installation
------------
The installation steps are described in the script `config/InitializeProgram.sh`.  
  -  Install the appropriate version of the `linux-headers` for your operating system.
  -  Look at the install script, which version of the `libjacklm.so` is compiled. You may need to adapt the version number so it can be renamed correctly.
  -  Run the install script as root and answer the questions.

Execution
---------
### Standalone
  1.  `perl BKScanner &`
  2.  `perl BK daemon -m production -l ws://0.0.0.0:8008 &`

### Services
  1.  `systemctl start bkscanner`
  2.  `systemctl start bk`
  3.  `systemctl start apache2`

Log Files
---------
  -  Both apps log to the same files `log/message_log` and `log/error_log`.
  -  `BK` also logs the Mojolicious messages to the `log/development.log` or `log/production.log`, depending on the mode.

Components
----------
  -  BK
  -  BKScanner
  -  SQLite Database
  -  JavaScript Client

### BK
This is the Mojolicious all-in-one app, meaning, it is the webserver, door opener and accesses the database.

There are different actions (routes) which BK can process. This information is taken from the URL. The response is in most cases just the content of the book boxes.

### BKScanner
It waits for user input from the barcode reader and transmits the username via HTTP request to BK on localhost.

### SQLite Database
Stores the information which door is assigned to which user.

### JavaScript Client
It has two connection modes: **AJAX** and **WebSockets**. The client starts with an AJAX connection and then tries to open a WebSocket. If this succeeds, it continues to use WebSockets as the preferred protocol. If WebSockets are no longer available it will fall back to AJAX.

#### Developer Note
You can manually force to use AJAX if you set the `ws_path` to an incorrect URL and then call `program_handler.InitializeConnTypeAJAX` in the console of your browser. To go back just set the `ws_path` to the previous correct URL and then wait until it makes a connection (this can take up to 1 min, because of the retry interval).

Services
--------
There are two services, based on `systemd` service files, the `bk.service` and `bkscanner.service` which run the corresponding scripts. They are configured to restart if they crash.

Webservers
----------
### Mojolicious
Is the actual webserver which delivers the data but listens only on localhost.

### Apache
Apache runs a proxy for the Mojolicious webserver and is responsible for the authentication via LDAP. The `ws_tunnel` module is required to proxy the WebSocket requests.

LabJack
-------
Hardware Name: LabJack U12  
Connection to Computer: USB  
Drivers: on LabJack Website  
Functionality: power is sent through the digital pins to the magnet on the door for a defined time to open the doors  
Programming Method 0: C  
Programming Method 1: ProfiLab

### Developer of the old system
Name: Stefan Meyer  
Tel.: +41 44 633 20 72  
E-Mail: stefan.meyer@phys.ethz.ch

Known issues
------------
  -  The call of `$self->{_db}->disconnect` generates an error. Therefore, as a temporary work-around, the `DatabaseAccess` destructor is commented out.
  -  WebSockets don't work with Safari, probably because Safari doesn't send the auth header with the wss protocol.

Developer Notes
---------------
## jBox
This project is using jBox for its popup in the browser to confirm things.
  -  https://github.com/StephanWagner/jBox
  -  http://stephanwagner.me/jBox

Author
------
Anastassios Martakos
