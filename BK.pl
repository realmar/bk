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

CommonVariables::init_variables({
        'bk_path'          => '<BK_PATH>/',
        'message_log_path' => 'log/message_log',
        'error_log_path'   =>'log/error_log',
        'database_path'    => 'database/BKDatabase.db',
        'database_handler' => 'SQLite',
        'doors'            => Constants::DOORSOUTPUT,
        'app_env'          => app->mode
});

websocket '/ws' => sub {
    my $self = shift;

    Mojo::IOLoop->stream($self->tx->connection)->timeout(2000);

    $self->on(message => sub {
        my ($self, $msg_data) = @_;
        my $recv_action = ActionHandler->new(undef, $msg_data);
        $recv_action->FromJSON();
        $recv_action->PrepareWebSocketData();
        $recv_action->ProcessAction();
        if($recv_action->GetAHAction() ne Constants::AHUSERINPUT) {
            $self->send($recv_action->PrepareDataToSend()) if !$recv_action->GetProcAC();
        }else{
            $self->send(MessagesTextConstants::STATUS200);
        }
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
    if($recv_action->GetAHAction() ne Constants::AHUSERINPUT) {
        my $data_to_send = $recv_action->PrepareDataToSend();
        $self->render(text => $data_to_send);
    }else{
        $self->render(text => MessagesTextConstants::STATUS200);
    }
    $recv_action->DESTROY();
};

app->start;

$CommonVariables::filehandle_log_message->CloseFileHandle();
$CommonVariables::filehandle_log_error->CloseFileHandle();

__END__

=head1 NAME

BKFrontendWebSockets - CGI Script for BK all in one Handler

=head1 SYNOPSIS

BK.pl

=head1 DESCRIPTION

All in one Handler is a Webserver and opens Doors
Uses Perl Mojolicious

=head1 OPTIONS / FLAGS

None

=head1 USAGE

perl BK.pl daemon -l http://0.0.0.0:3004/

=head1 FILES

./lib/Common/*
./lib/Frontend/*
./databases/*

=head1 SEE ALSO

Theres nothing else to reffer to
