#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package CommonVariables;

use 5.010;
use strict;
use warnings;

use Inline C => Config => MYEXTLIB => '/usr/local/lib/libljacklm.so';
use Inline C => '<BK_PATH>/lib/BK/Handler/SourceC/DoorsInterface.c';

use BK::Common::CommonMessagesCollector;
use BK::Common::BKFileHandler;
use BK::Handler::DatabaseAccess;
use BK::Handler::Doors;

use Exporter 'import';
our @EXPORT = qw(
    $common_messages_collector
    $filehandle_log_message
    $filehandle_log_error
    $database_connection
    $app_environment
    $doors
    init_variables
);

our $common_messages_collector;
our $filehandle_log_message;
our $filehandle_log_error;
our $database_connection;
our $app_environment;
our $doors;

sub init_variables {
    my ($bk_path, $message_log_path, $error_log_path, $database_path, $database_handler, $doors_arg, $app_env) = @_;
    
    $app_environment = $app_env;

    $common_messages_collector = CommonMessagesCollector->new();
    if (defined($message_log_path)) { $filehandle_log_message = BKFileHandler->new('>>', $bk_path . $message_log_path); }
    if (defined($error_log_path)) { $filehandle_log_error = BKFileHandler->new('>>', $bk_path . $error_log_path); }
    if (defined($database_handler) && defined($database_path)) { $database_connection = DatabaseAccess->new($database_handler, $bk_path . $database_path); }
    if (defined($doors_arg)) { $doors = Doors->new($doors_arg); }

    return 0;
}

return 1;
