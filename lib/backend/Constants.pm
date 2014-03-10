#!/usr/bin/env perl

BEGIN {

    package Constants;

    use Exporter 'import';

    our @EXPORT = qw(
        DOORS
    );

    use constant DOORS => ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'];

}

1;
