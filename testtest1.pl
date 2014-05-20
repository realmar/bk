#!/usr/bin/env perl

use 5.010;

use Inline C => Config => MYEXTLIB => '/usr/local/lib/libljacklm.so';

##  use Inline C => Config => LIBS => '-L/usr/local/include/ljacklm.h -lljacklm';

##  use Inline C => Config => LIBS => '-lljacklm';

use Inline C => './source4.c';

##  Inline->bind(C => './source.c');

##  my $source_c;
##  
##  use File::Slurp;
##  
##  BEGIN {
##  	$source_c = read_file('source1.c');
##  }
##  
##  use Inline C => $source_c;

##  test($ARGV[0]);

test();

use strict;
use warnings;
