#!/usr/bin/env perl

use 5.010;
use strict;

use lib '/opt/BK/lib/common';
use lib '/opt/BK/lib/frontend';

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
