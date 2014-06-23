#!/usr/bin/env perl

BEGIN {

    package Constants;

    use Exporter 'import';

    our @EXPORT = qw(
        HEXNULL
        HEXTWOBYTEONE
        DOORSOUTPUT
        DOORCOUNT
        DOORSSENDSIGNALTIME
        DOORSEXEPTIONOPENEND
        DOORSEXEPTIONCLOSED
        DOOROPENED
        DOORCLOSED
        DBRETRIES
        DBERRCONN
        DBERRDISCONN
        DBERRCREATE
        DBERRREAD
        DBERRUPDATE
        DBERRDELETE
        DBERRBEGINWORK
        DBERRCOMMIT
        DBERRROLLBACK
        DBCONN
        DBDISCONN
        DBCREATE
        DBREAD
        DBUPDATE
        DBDELETE
        DBBEGINWORK
        DBCOMMIT
        DBROLLBACK
        SCLOGGOTINPUT
        ERROR
        LOG
        DB
        DOORS
        SCANNER
        ACTIONHANDLER
        COMMONMESSAGESCOLLECTOR
        THROWTIME
        MSGSTRING
        AHREFRESH
        AHSAVEDATA
        AHSAVEDATAWRITE
        AHKEEPALIVE
        AHNOTCHANGED
        AHDATABASECHANGED
        AHERRSAVEDATA
        AHERRREFRESHDATA
        AHSUCCSAVEDATA
        AHUNKNOWNACTION
        CMERROR
        CMINFO
        INTERNALERROR
    );

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
        DOORSEXEPTIONOPENEND => 'doorsexeptionopenend',
        DOORSEXEPTIONCLOSED  => 'doorsexeptionclosed'
    };

    ##  --
    ##  doors types

    use constant {
        DOOROPENED => 'dooropened',
        DOORCLOSED => 'doorclosed'
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
        AHKEEPALIVE     => 'ahkeepalive'
    };

    ##  --
    ##  action handler change types

    use constant {
        AHNOTCHANGED => 'ahnotchanged',
        AHDATABASECHANGED => 'ahdbchanged'
    };

    ##  --
    ##  action handler errors

    use constant {
        AHERRSAVEDATA => 'aherrsavedata',
        AHERRREFRESHDATA => 'aherrrefreshdata'
    };

    ##  --
    ##  action handler messages

    use constant {
        AHSUCCSAVEDATA => 'ahsuccsavedata'
    };

    ##  --
    ##  common messages data types

    use constant {
        CMERROR => 'error',
        CMINFO => 'info'
    };

    ## --
    ##  other stuff

    use constant {
        INTERNALERROR => 'internalerror'
    };
}

1;
