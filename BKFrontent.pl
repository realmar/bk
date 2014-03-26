#!/usr/bin/env perl

use 5.010;
use strict;

use lib 'lib/common';
use lib 'lib/frontend';

use Constants;
use MessagesTextConstants;
use BKFileHandler;
use CommonMessages;
use DatabaseAccess;
use DBMessages;
use ActionHandler;

use Dancer;
use Template;
use AnyMQ;
use Plack::Builder;
use FileHandle;
use DBI;

set views => path(dirname(__FILE__), 'wwwcontent/templates');

our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');

my $bus = AnyMQ->new();
my $topic = $bus->topic('BK');

any ['get'] => '/' => sub {
    template 'index' => {};
};

any ['get'] => '/new_listener' => sub {
    request->env->{'hippie.listener'}->subscribe($topic);
};

any ['get'] => '/message' => sub {
};

any => '/send_msg' => sub {
};

any ['get'] => '/:action' => sub {
    my $recv_action = ActionHandler->new(param('action'), []);
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->PrepareDataJQuery();
    $recv_action->DESTROY();
    return $data_to_send;
};

any ['post'] => '/:action' => sub {
    my $recv_action = ActionHandler->new(param('action'), [
            param('bookbox0'),
            param('bookbox1'),
            param('bookbox2'),
            param('bookbox3'),
            param('bookbox4'),
            param('bookbox5'),
            param('bookbox6'),
            param('bookbox7'),
            param('bookbox8'),
            param('bookbox9'),
            param('bookbox10')
        ]);
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->PrepareDataJQuery();
    $recv_action->DESTROY();
    return $data_to_send;
};

builder {
    mount '/' => Dancer->dance;
    mount '/_hippie' => builder {
        enable '+Web::Hippie';
        enable '+Web::Hippie::Pipe', bus => $bus;
        Dancer->dance;
    };
};
