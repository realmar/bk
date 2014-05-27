#!/usr/bin/env perl

BEGIN {

    package Constants;

    use Exporter 'import';

    our @EXPORT = qw(
        HEXNULL
        HEXTWOBYTEONE
        DOORSOUTPUT
        DOORSSENDSIGNALTIME
        DOORSEXEPTIONOPENEND
        DOORSEXEPTIONCLOSED
        DOOROPENED
        DOORCLOSED
        DBERRCONN
        DBERRDISCONN
        DBERRCREATE
        DBERRREAD
        DBERRUPDATE
        DBERRDELETE
        DBERRCOMMIT
        DBERRROLLBACK
        DBERRHANDLEERROR
        DBCONN
        DBDISCONN
        DBCREATE
        DBREAD
        DBUPDATE
        DBDELETE
        DBCOMMIT
        DBROLLBACK
        SCLOGGOTINPUT
        ERROR
        LOG
        DB
        DOORS
        SCANNER
        ACTIONHANDLER
        AHREFRESH
        AHSAVEDATA
        AHKEEPALIVE
        AHNOTCHANGED
        AHUNKNOWNACTION
        DOORCOUNT
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

    use constant {
        DOORSSENDSIGNALTIME => 2
    };

    ##  --
    ##  doors exceptions

    use constant {
        DOORSEXEPTIONOPENEND => 'doorsexeptionopenend',
        DOORSEXEPTIONCLOSED => 'doorsexeptionclosed'
    };

    ##  --
    ##  doors types

    use constant {
        DOOROPENED => 'dooropened',
        DOORCLOSED => 'doorclosed'
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
        DBERRCOMMIT      => 'dberrcommit',
        DBERRROLLBACK    => 'dberrrollback',
        DBERRHANDLEERROR => 'dberrhandleerror'
    };

    ##  --
    ##  db messages

    use constant {
        DBCONN => 'dbconn',
        DBDISCONN => 'dbdisconn',
        DBCREATE => 'dbcreate',
        DBREAD => 'dbread',
        DBUPDATE => 'dbupdate',
        DBDELETE => 'dbdel',
        DBCOMMIT => 'dbcommit',
        DBROLLBACK => 'dbrollback'
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
        BKFILEHANDLER => 'bkfilehandler',
        DB            => 'db',
        DOORS         => 'doors',
        SCANNER       => 'scanner',
        ACTIONHANDLER => 'actionhandler'
    };

    ##  --
    ##  action handler types

    use constant {
        AHREFRESH   => 'ahrefresh',
        AHSAVEDATA  => 'ahsavedata',
        AHKEEPALIVE => 'ahkeepalive'
    };

    ##  --
    ##  action handler change types

    use constant {
        AHNOTCHANGED => 'ahnotchanged'
    };

    ##  --
    ##  other variables

    use constant {
        DOORCOUNT => 11
    };

}

1;
