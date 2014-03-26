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
use JSON;

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
    my $msg_data = request->env->{'hippie.message'};
    my $recv_action = ActionHandler->new(undef, $msg_data);
    $recv_action->FromJSON();
    $recv_action->PrepareWebScoketData();
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->ToJSON();
    $topic->publish($data_to_send);
    $recv_action->DESTROY();
};

any => '/send_msg' => sub {
    $topic->publish({
            msg_data => params->{data_to_send}
        });
};

any ['get, post'] => '/:action' => sub {
    my $recv_action = ActionHandler->new(param('action'), param('msg_data'));
    $recv_action->FromJSON();
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->ToJSON();
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
