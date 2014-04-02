#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use Cwd qw(abs_path);
use File::Basename qw(dirname);

use lib dirname(abs_path($0)) . '/lib/';

use BK::Common::Constants;
use BK::Common::MessagesTextConstants;
use BK::Common::BKFileHandler;
use BK::Common::CommonMessages;
use BK::Common::DatabaseAccess;
use BK::Backend::Doors;
use BK::Backend::Scanner;

use FileHandle;
use DBI;

our $filehandle_log_message = BKFileHandler->new('>>', 'log/message_log');
our $filehandle_log_error = BKFileHandler->new('>>', 'log/error_log');
my $database_connection = DatabaseAccess->new('SQLite', 'database/BKDatabase.db');
my $doors = Doors->new(Constants::DOORSOUTPUT);
my $scanner = Scanner->new();

while(2) {
    my $input_barc = $scanner->GetInput();

    my $database_entries = $database_connection->ReadEntryDatabase('users', {'username' => $input_barc});

    while(my $database_entries_row = $database_entries->fetchrow_hashref) {
        $doors->OpenDoor($database_entries_row->{doornumber});
        $database_connection->UpdateEntryDatabase('users', {'username' => ''}, {'username' => $input_barc});
        $database_connection->CommitChanges();

        ##  Send E-Mail
        ##  To Correspondant Person
    }
}

$filehandle_log_message->CloseFileHandle();
$filehandle_log_error->CloseFileHandle();
