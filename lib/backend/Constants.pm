#!/usr/bin/env perl

BEGIN {

    package Constants;

    use Exporter 'import';

    our @EXPORT = qw(
        DOORS
        DBERRCONN
        DBERRDISCONN
        DBERRREAD
        DBERRDELETE
        DBERRCOMMIT
        DBERRROLLBACK
        ERROR
        DB
    );

    ##  --
    ##  signal for the doors

    use constant DOORS => ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'];

    ##  --
    ##  db error exeptions

    use constant {
        DBERRCONN    => 'errconn',
        DBERRDISCONN => 'errdisconn',
        DBERRREAD       => 'errread',
        DBERRDELETE     => 'errdel',
        DBERRCOMMIT     => 'errcommit',
        DBERRROLLBACK   => 'errrollback'
    };

    ##  --
    ##  msg prio

    use constant {
        ERROR => 'err'
    };

    ##  --
    ##  owner typ

    use constant {
        DB => 'db'
    }

}

1;
