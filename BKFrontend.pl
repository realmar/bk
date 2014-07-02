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

use Dancer;
use Template;
use Fcntl qw(:flock SEEK_END);
use FileHandle;
use DBI;

our $common_messages_collector = CommonMessagesCollector->new();
our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');
our $database_connection = DatabaseAccess->new('SQLite', , 'database/BKDatabase.db');

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
