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

use lib '/opt/BK/lib/';

use BK::Common::Constants;
use BK::Common::MessagesTextConstants;
use BK::Common::BKFileHandler;
use BK::Common::CommonMessagesCollector;
use BK::Common::CommonMessages;
use BK::Common::DatabaseAccess;
use BK::Frontend::ActionHandler;

use Mojolicious::Lite;
use Mojo::IOLoop;
use Fcntl qw(:flock SEEK_END);
use FileHandle;
use DBI;
use JSON;

our $common_messages_collector = CommonMessagesCollector->new();
our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');
our $database_connection = DatabaseAccess->new('SQLite', 'database/BKDatabase.db');

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
