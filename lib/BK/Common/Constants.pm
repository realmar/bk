#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

BEGIN {

    package Constants;

    use 5.010;
    use strict;
    use warnings;

    use Exporter 'import';

    our @EXPORT = qw(
        TRUE                     ##  Booleaon for 1
        FALSE                    ##  Boolean for 0
        HEXNULL                  ##  represent 0 in hex 0x0
        HEXTWOBYTEONE            ##  represent two byte in hex 0xFFFF (byte 0 := 0000000 ;; byte 1 := 00000000)
        DOORSOUTPUT              ##  ARRAY with door number to pin port mapping (eg. 0 => 0x1 ;; 1 => 0x2)
        DOORCOUNT                ##  Number of doors
        DOORSSENDSIGNALTIME      ##  Time in Seconds how long a Pin will ouput a Signal
        DOORSEXEPTIONOPENEND     ##  Logging facility for Error at door open (update Pin)
        DOORSEXEPTIONCLOSED      ##  Logging facility for Error at door close(update Pin)
        DOORSEXEPTIONCHECKDOORS  ##  Logging facility for Error at Check Doors, Database Error
        DOOROPENED               ##  Logging facility for Message (success) at door open (update Pin)
        DOORCLOSED               ##  Logging facility for Message (success) at door close (update Pin)
        AHDOOPENDOOR             ##  Database Entry for Opening a Door
        AHNOTOPENDOOR            ##  Database Entry for not Opening a Door
        DOORSUSER                ##  Username for Oppening a Door when invoked by Frontend
        OPENDOOR                 ##  Hash key of value wheter the door should be open or not
        DBRETRIES                ##  Time a sql execute is executed bevor an cannot access db error is thrown (look at ./lib/BK/Common/DatabaseAccess.db)
        DBRETRIESTIME            ##  Time to wait until a retrie if a sql execuation is not successfull
        DBERRCONN                ##  Logging facility for Error at Database Connect
        DBERRDISCONN             ##  Logging facility for Error at Database Disconnect
        DBERRCREATE              ##  Logging facility for Error at Database Create
        DBERRREAD                ##  Logging facility for Error at Database Read
        DBERRUPDATE              ##  Logging facility for Error at Database Update
        DBERRDELETE              ##  Logging facility for Error at Database Delete
        DBERRBEGINWORK           ##  Logging facility for Error at Database Begin Work (start Transaction)
        DBERRCOMMIT              ##  Logging facility for Error at Database Commit (stop Transaction / execute Transaction / make Changes permanent)
        DBERRROLLBACK            ##  Logging facility for Error at Database Rollback (undo changes made in the current open Transaction)
        DBCONN                   ##  Logging facility for Message (success) at Database Connect
        DBDISCONN                ##  Logging facility for Message (success) at Database Disconnect
        DBCREATE                 ##  Logging facility for Message (success) at Database Create
        DBREAD                   ##  Logging facility for Message (success) at Database Read
        DBUPDATE                 ##  Logging facility for Message (success) at Database Update
        DBDELETE                 ##  Logging facility for Message (success) at Database Delete
        DBBEGINWORK              ##  Logging facility for Message (success) at Database Begin Work (start Transaction)
        DBCOMMIT                 ##  Logging facility for Message (success) at Database Commit (stop Transaction / execute Transaction / make changes permanent)
        DBROLLBACK               ##  Logging facility for Message (success) at Database Rollback (undo changed made in the current open Transaction)
        SCLOGGOTINPUT            ##  Logging facility for Message (take note) at got input in BKBackend from STDIN (Scanner Object, look at ./lib/BK/Backend/Scanner.pm)
        ERROR                    ##  Logging Type for Error
        LOG                      ##  Logging Type for Log
        DB                       ##  Owner Description for database
        DOORS                    ##  Owner Description for doors
        SCANNER                  ##  Owner Description for scanner
        ACTIONHANDLER            ##  Owner Description for actionhandler
        COMMONMESSAGESCOLLECTOR  ##  Owner Description for commonmessagescollector
        THROWTIME                ##  Time a message (Log or Error) is thrown, key value for the log object CommonMessages
        MSGSTRING                ##  Message String (Log or Error), key value for log object CommonMessages
        AHREFRESH                ##  ActionHandler (AH) facility for Sending all Database Entries to the Client
        AHSAVEDATA               ##  ActionHandler (AH) facility for Save Data from the Input (Client) to the Database
        AHSAVEDATAWRITE          ##  Logging facility for Message (take note) at ActionHandler what happens with the Database (SQL Code)
        AHKEEPALIVE              ##  ActionHandler (AH) facility for Keep Alive requests for the WebSockets
        AHOPENDOORS              ##  ActionHandler (AH) facility for Opening a Doors
        AHUSERINPUT              ##  ActionHandler (AH) facility for getting User Input from the Scanner
        AHNOTCHANGED             ##  Logging facility for Message (take note) at ActionHandler if the Database has not changed
        AHDATABASECHANGED        ##  Logging facility for Message (take note) at ActionHandler if the Database has changed
        AHERRSAVEDATA            ##  Logging facility for Error at ActionHandler Save Data to Database, Database error
        AHERRREFRESHDATA         ##  Logging facility for Error at ActionHandler Refresh Data to Client, failed to access Database, Database error
        AHERROPENDOORS           ##  Logging facility for Error at ActionHandler Opening a Door
        AHERRUSERINPUT           ##  Logging facility for Error at ActionHandler User Input
        AHSUCCSAVEDATA           ##  Logging facility for Message (success) at ActionHandler Save Data Logging facility for JavaScript Messages
        AHSUCCOPENDOORS          ##  Logging facility for Message (success) at ActionHandler Oppening Doors Lagging facility for JavaScript Messages
        AHUNKNOWNACTION          ##  Logging facility for Error at ActionHandler Unknown Action from Client
        CMERROR                  ##  CommonMessages Logging Typ Error
        CMINFO                   ##  CommonMessages Logging Typ Info
        INTERNALERROR            ##  Return Value if an Action is not successfull Internal Error
        APPENVPRODUCTION         ##  APP Environment Production
        APPENVDEVELOPMENT        ##  APP Environment Development
        );

    ##  --
    ##  booleans
    
    use constant {
        TRUE  => 1,
        FALSE => 0
    };

    ##  --
    ##  hex numbers

    use constant {
        HEXNULL       => 0x0,
        HEXTWOBYTEONE => 0xFFFF
    };

    ##  --
    ##  signal for the doors

    use constant DOORSOUTPUT => [
        0x1,  ##  D0
        0x2,  ##  D1
        0x4,  ##  D2
        0x8,  ##  D3
        0x10,  ##  D4
        0x20,  ##  D5
        0x40,  ##  D6
        0x80,  ##  D7
        0x100,  ##  D8
        0x200,  ##  D9
        0x400,  ##  D10
        0xffff  ##  all pins
    ];

    ##  --
    ##  doors settings

    use constant {
        DOORCOUNT           => 11,
        DOORSSENDSIGNALTIME => 2
    };

    ##  --
    ##  doors exceptions

    use constant {
        DOORSEXEPTIONOPENEND    => 'doorsexeptionopenend',
        DOORSEXEPTIONCLOSED     => 'doorsexeptionclosed',
        DOORSEXEPTIONCHECKDOORS => 'doorsexeptioncheckdoors'
    };

    ##  --
    ##  doors types

    use constant {
        DOOROPENED => 'dooropened',
        DOORCLOSED => 'doorclosed',
        DOOPENDOORNUM      => 1,
        NOTOPENDOORNUM     => 0
    };

    ##  --
    ##  doors users

    use constant {
        DOORSUSER => 'frontend'
    };

    ##  --
    ##  open doors

    use constant {
        OPENDOOR => 'opendoor'
    };

    ##  --
    ##  db settings

    use constant {
        DBRETRIES     => 100,
        DBRETRIESTIME => 0.1
    };

    ##  --
    ##  db error exeptions

    use constant {
        DBERRCONN        => 'dberrconn',
        DBERRDISCONN     => 'dberrdisconn',
        DBERRCREATE      => 'dberrcreate',
        DBERRREAD        => 'dberrread',
        DBERRUPDATE      => 'dberrupdate',
        DBERRDELETE      => 'dberrdel',
        DBERRBEGINWORK   => 'dberrbeginwork',
        DBERRCOMMIT      => 'dberrcommit',
        DBERRROLLBACK    => 'dberrrollback',
    };

    ##  --
    ##  db messages

    use constant {
        DBCONN      => 'dbconn',
        DBDISCONN   => 'dbdisconn',
        DBCREATE    => 'dbcreate',
        DBREAD      => 'dbread',
        DBUPDATE    => 'dbupdate',
        DBDELETE    => 'dbdel',
        DBBEGINWORK => 'dbbeginwork',
        DBCOMMIT    => 'dbcommit',
        DBROLLBACK  => 'dbrollback'
    };

    ##  --
    ##  action handler exceptions

    use constant {
        AHUNKNOWNACTION => 'ahunknownaction'
    };

    ##  --
    ##  scanner log messages

    use constant {
        SCLOGGOTINPUT => 'gotinput'
    };

    ##  --
    ##  msg prio

    use constant {
        ERROR => 'err',
        LOG   => 'log'
    };

    ##  --
    ##  owner typ

    use constant {
        BKFILEHANDLER           => 'bkfilehandler',
        DB                      => 'db',
        DOORS                   => 'doors',
        SCANNER                 => 'scanner',
        ACTIONHANDLER           => 'actionhandler',
        COMMONMESSAGESCOLLECTOR => 'commonmessagescollector'
    };

    ##  --
    ##  common messages hash elements

    use constant {
        THROWTIME => 'throw_time',
        MSGSTRING => 'msg_string'
    };

    ##  --
    ##  action handler types

    use constant {
        AHREFRESH       => 'ahrefresh',
        AHSAVEDATA      => 'ahsavedata',
        AHSAVEDATAWRITE => 'ahsavedatawrite',
        AHKEEPALIVE     => 'ahkeepalive',
        AHOPENDOORS     => 'ahopendoors',
        AHUSERINPUT     => 'ahuserinput'
    };

    ##  --
    ##  action handler change types

    use constant {
        AHNOTCHANGED      => 'ahnotchanged',
        AHDATABASECHANGED => 'ahdbchanged',
    };

    ##  --
    ##  action handler errors

    use constant {
        AHERRSAVEDATA    => 'aherrsavedata',
        AHERRREFRESHDATA => 'aherrrefreshdata',
        AHERROPENDOORS   => 'aherropendoors',
        AHERRUSERINPUT   => 'aherruserinput'
    };

    ##  --
    ##  action handler messages

    use constant {
        AHSUCCSAVEDATA  => 'ahsuccsavedata',
        AHSUCCOPENDOORS => 'ahsuccopendoors'
    };

    ##  --
    ##  common messages data types

    use constant {
        CMERROR => 'error',
        CMINFO => 'info'
    };

    ##  --
    ##  app

    use constant {
        APPENVPRODUCTION => 'production',
        APPENVDEVELOPMENT => 'development'
    };

    ##  --
    ##  other stuff

    use constant {
        INTERNALERROR => 'internalerror'
    };
}

1;
