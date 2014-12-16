#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package CommonVariables;

use BK::Common::CommonMessagesCollector;
use BK::Common::BKFileHandler;
use BK::Common::DatabaseAccess;

use Exporter 'import';
our @EXPORT = qw(
    $common_messages_collector
    $filehandle_log_message
    $filehandle_log_error
    $database_connection
    init_variables
);

our $common_messages_collector;
our $filehandle_log_message;
our $filehandle_log_error;
our $database_connection;

sub init_variables {
    my ($bk_path, $message_log_path, $error_log_path, $database_path, $database_handler) = @_;
    
    $common_messages_collector = CommonMessagesCollector->new();
    $filehandle_log_message = BKFileHandler->new('>>', $bk_path . $message_log_path);
    $filehandle_log_error = BKFileHandler->new('>>', $bk_path . $error_log_path);
    $database_connection = DatabaseAccess->new($database_handler, $bk_path . $database_path);
}

return 1;
