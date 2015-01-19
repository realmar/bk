#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

use 5.010;
use strict;
use warnings;

use lib '<BK_PATH>/lib/';

use BK::Common::Constants;
use BK::Common::BKFileHandler;
use BK::Common::CommonMessagesCollector;
use BK::Common::CommonMessages;
use BK::Common::CommonVariables;
use BK::Handler::DatabaseAccess;
use BK::Handler::ActionHandler;
use BK::Handler::MessagesTextConstants;

use Mojolicious::Lite;
use Mojo::IOLoop;

CommonVariables::init_variables('<BK_PATH>/', 'log/message_log', 'log/error_log', 'database/BKDatabase.db', 'SQLite', Constants::DOORSOUTPUT, app->mode);

websocket '/ws' => sub {
    my $self = shift;

    Mojo::IOLoop->stream($self->tx->connection)->timeout(2000);

    $self->on(message => sub {
        my ($self, $msg_data) = @_;
        my $recv_action = ActionHandler->new(undef, $msg_data);
        $recv_action->FromJSON();
        $recv_action->PrepareWebSocketData();
        $recv_action->ProcessAction();
        $self->send($recv_action->PrepareDataToSend()) if !$recv_action->GetProcAC();
        $recv_action->DESTROY();
    });
};

any [qw(GET)] => '/' => sub {
    my $self = shift;
    $self->render('index');
};

any [qw(GET POST)] => '/:action' => sub {
    my $self = shift;
    my $action = $self->stash('action');
    my $msg_data= $self->param('msg_data');
    my $recv_action = ActionHandler->new($action, $msg_data);
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->PrepareDataToSend();
    $recv_action->DESTROY();
    $self->render(text => $data_to_send);
};

app->start;

__END__

=head1 NAME

BKFrontendWebSockets - CGI Script for BK Webfrontend over WS / WSS connections

=head1 SYNOPSIS

BKFrontentWebSockets.pl

=head1 DESCRIPTION

Sends Webfrontend to Client, saves Input over Webfrontend to Database, reads Database to display content to Webfrontend, works with WS and WSS protocols this are Protocols for the HTML 5 and upwards Websockets
Uses Perl Mojolicious

=head1 OPTIONS / FLAGS

None

=head1 USAGE

perl BKFrontendWebSockets.pl daemon -l http://*:3003/

=head1 FILES

./lib/Common/*
./lib/Frontend/*
./databases/*

=head1 SEE ALSO

Theres nothing else to reffer to
