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
    ##  signal for the doors

    use constant DOORSOUTPUT => ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'];

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
