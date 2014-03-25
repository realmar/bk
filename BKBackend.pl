#!/usr/bin/env perl

use 5.010;
use strict;

use lib 'lib/common/';
use lib 'lib/backend/';

use Constants;
use MessagesTextConstants;
use BKFileHandler;
use CommonMessages;
use Scanner;
use DatabaseAccess;
use Doors;

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

$database_connection->DESTROY();

$filehandle_log_message->CloseFileHandle();
$filehandle_log_error->CloseFileHandle();
