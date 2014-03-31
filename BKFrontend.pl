#!/usr/bin/env perl

use 5.010;
use strict;

use Cwd qw(abs_path);
use File::Basename qw(dirname);

use lib dirname(abs_path($0)) . '/lib/common';
use lib dirname(abs_path($0)) . '/lib/frontend';

use Constants;
use MessagesTextConstants;
use BKFileHandler;
use CommonMessages;
use DatabaseAccess;
use ActionHandler;

use Dancer;
use Template;
use FileHandle;
use DBI;
use JSON;

set views => path(dirname(__FILE__), 'wwwcontent/templates');

our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');

any ['get'] => '/' => sub {
    template 'index' => {};
};

any ['get, post'] => '/:action' => sub {
    my $recv_action = ActionHandler->new(param('action'), param('msg_data'));
    $recv_action->FromJSON();
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->PrepareDataToSend();
    $recv_action->DESTROY();
    return $data_to_send;
};

Dancer->dance;
