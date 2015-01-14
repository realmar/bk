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

use Dancer;
use Template;

CommonVariables::init_variables('<BK_PATH>/', 'log/message_log', 'log/error_log', 'database/BKDatabase.db', 'SQLite', Constants::DOORSOUTPUT, config->{environment});

any ['get'] => '/' => sub {
    template 'index' => {};
};

any ['get', 'post'] => '/:action' => sub {
    my $recv_action = ActionHandler->new(param('action'), param('msg_data'));
    $recv_action->ProcessAction();
    my $data_to_send = $recv_action->PrepareDataToSend();
    $recv_action->DESTROY();
    return $data_to_send;
};

Dancer->dance;

__END__

=head1 NAME

BKFrontend - CGI Script for BK Webfrontend over HTTP / HTTPS connections

=head1 SYNOPSIS

BKFrontend.pl

=head1 DESCRIPTION

Sends Webfrontend to Client, saves Input over Webfrontend to Database, reads Database to display content to Webfrontend, works with HTTP and HTTPS protocols like Loading a Website or AJAX Requests
Uses Perl Dancer

=head1 OPTIONS / FLAGS

None

=head1 USAGE

perl BKFrontend.pl

=head1 FILES

./lib/Common/*
./lib/Frontend/*
./databases/*

=head1 SEE ALSO

Theres nothing else to reffer to
