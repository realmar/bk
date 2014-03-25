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
        DB      => 'db',
        DOORS   => 'doors',
        SCANNER => 'scanner'
    }

}

1;
