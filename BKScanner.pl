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
use BK::Scanner::Scanner;

use LWP::Simple;

CommonVariables::init_variables({
        'bk_path'          => '<BK_PATH>/',
        'message_log_path' => 'log/message_log',
        'error_log_path'   => 'log/error_log',
        'database_path'    => undef,
        'database_handler' => undef,
        'doors'            => undef,
        'app_env'          => Constants::APPENVPRODUCTION
});

my $scanner = Scanner->new();

while(1) {
    my $input_barc = $scanner->GetInput();

    if($input_barc ne '') {
        my $request = 'http://localhost:<BK_LOCAL_PORT>/' . Constants::AHUSERINPUT . '?msg_data=[{ "' . Constants::OPENDOOR . '" : ' . Constants::TRUE . ', "user" : "' . $input_barc . '" }]';
        get($request);
    }
}

&CommonVariables::filehandle_log_message->CloseFileHandle();
&CommonVariables::filehandle_log_error->CloseFileHandle();

__END__

=head1 NAME

BK - Reads STDIN and sends an HTTP Request to BK

=head1 SYNOPSIS

BK.pl

=head1 DESCRIPTION

Reads STDIN and sends an HTTP Request to BK

=head1 OPTIONS / FLAGS

None

=head1 USAGE

perl BKBackend.pl

=head1 FILES

./lib/Common/*
./lib/Backend/*
./databases/*

=head1 SEE ALSO

Theres nothing else to reffer to
