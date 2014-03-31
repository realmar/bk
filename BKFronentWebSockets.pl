#!/usr/bin/env perl

use 5.010;
use strict;

use Cwd qw(abs_path);
use File::Basename qw(dirname);

use lib dirname(abs_path($0)) . '/lib/common';
use lib dirname(abs_path($0)) . '/lib/frontent';

use Constants;
use MessagesTextConstants;
use BKFileHandler;
use CommonMessages;
use DatabaseAccess;
use ActionHandler;

use Mojolicious::Lite;
use FileHandle;
use DBI;
use JSON;
