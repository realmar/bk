#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use lib '/opt/BK/lib/';

use BK::Common::Constants;
use BK::Common::MessagesTextConstants;
use BK::Common::BKFileHandler;
use BK::Common::CommonMessages;
use BK::Common::DatabaseAccess;
use BK::Frontend::ActionHandler;

use Dancer;
use Template;
use FileHandle;
use DBI;

our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');

any ['get'] => '/' => sub {
    template 'index' => {};
};

any ['get', 'post'] => '/:action' => sub {
    my $recv_action = ActionHandler->new(param('action'), param('msg_data'));
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->PrepareDataToSend();
    return $data_to_send;
};

Dancer->dance;
