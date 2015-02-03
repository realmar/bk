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
use Inline C => '/opt/BK/lib/BK/Handler/SourceC/DoorsInterface.c';

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
    my ( $common_variables ) = @_;

    ##  common_variables = {
    ##      bk_path
    ##      message_log_path
    ##      error_log_path
    ##      database_handler
    ##      database_path
    ##      doors
    ##      app_env
    ##  };

    $app_environment = $common_variables->{app_env};

    $common_messages_collector = CommonMessagesCollector->new();
    if (defined($common_variables->{message_log_path})) { $filehandle_log_message = BKFileHandler->new('>>', $common_variables->{bk_path} . $common_variables->{message_log_path}); }
    if (defined($common_variables->{error_log_path})) { $filehandle_log_error = BKFileHandler->new('>>', $common_variables->{bk_path} . $common_variables->{error_log_path}); }
    if (defined($common_variables->{database_handler}) && defined($common_variables->{database_path})) { $database_connection = DatabaseAccess->new($common_variables->{database_handler}, $common_variables->{bk_path} . $common_variables->{database_path}); }
    if (defined($common_variables->{doors})) { $doors = Doors->new($common_variables->{doors}); }

    return 1;
}

return 1;
