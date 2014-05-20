#!/usr/bin/env perl

BEGIN {

    package Constants;

    use Exporter 'import';

    our @EXPORT = qw(
        DOORSOUTPUT
        DBERRCONN
        DBERRDISCONN
        DBERRCREATE
        DBERRREAD
        DBERRUPDATE
        DBERRDELETE
        DBERRCOMMIT
        DBERRROLLBACK
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

    ##  --
    ##  db error exeptions

    use constant {
        DBERRCONN     => 'errconn',
        DBERRDISCONN  => 'errdisconn',
        DBERRCREATE   => 'errcreate',
        DBERRREAD     => 'errread',
        DBERRUPDATE   => 'errupdate',
        DBERRDELETE   => 'errdel',
        DBERRCOMMIT   => 'errcommit',
        DBERRROLLBACK => 'errrollback'
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
    ##  other variables

    use constant {
        DOORCOUNT => 11
    };

}

1;
