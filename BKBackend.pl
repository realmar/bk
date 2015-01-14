#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

use 5.010;

use Cwd qw(abs_path);
use File::Basename qw(dirname);

use Inline C => Config => MYEXTLIB => '/usr/local/lib/libljacklm.so';
use Inline C => dirname(abs_path($0)) . '/lib/BK/Backend/SourceC/DoorsInterface.c';

use strict;
use warnings;

use lib dirname(abs_path($0)) . '/lib/';

use BK::Common::Constants;
use BK::Common::MessagesTextConstants;
use BK::Common::BKFileHandler;
use BK::Common::CommonMessagesCollector;
use BK::Common::CommonMessages;
use BK::Common::DatabaseAccess;
use BK::Common::CommonVariables;
use BK::Backend::Doors;
use BK::Backend::Scanner;

use threads;
use threads::shared;

CommonVariables::init_variables('/opt/BK/', 'log/message_log', 'log/error_log', 'database/BKDatabase.db', 'SQLite', Constants::APPENVPRODUCTION);

my $doors = Doors->new(Constants::DOORSOUTPUT);
my $scanner = Scanner->new();

share($doors);

my $check_doors_thread = threads->create(\&CheckDoorsThread);

while(1) {
    my $input_barc = $scanner->GetInput();

    if($input_barc ne '') {
        my $database_entries = $CommonVariables::database_connection->ReadEntryDatabase('Users', {'username' => $input_barc});

        while(my $database_entries_row = $database_entries->fetchrow_hashref) {
            my $doors_open = $doors->OpenDoor($database_entries_row->{doornumber}, $input_barc);
            if(defined($doors_open)) {
                $CommonVariables::database_connection->BeginWork();
                $CommonVariables::database_connection->UpdateEntryDatabase('Users', {'username' => 'null'}, {'doornumber' => $database_entries_row->{doornumber}});
                $CommonVariables::database_connection->CommitChanges();
            }

            ##  Send E-Mail
            ##  To Correspondant Person
        }
    }
}

$CommonVariables::database_connection->DisconnectFromDatabase();

$CommonVariables::filehandle_log_message->CloseFileHandle();
$CommonVariables::filehandle_log_error->CloseFileHandle();

$check_doors_thread->kill('SIGKILL')->join();

sub CheckDoorsThread {
    while(1) {
        $doors->CheckDoors();
    }
}

__END__

=head1 NAME

BKBackend - Reads STDIN and does Comparing operations for the BuecherkastenBibliothek

=head1 SYNOPSIS

BKBackend.pl

=head1 DESCRIPTION

Reads STDIN line per line and compares input with database username fields, if one field matches, sets this filed to NULL and opens the correspondant door saved in relation to the username in the database

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
