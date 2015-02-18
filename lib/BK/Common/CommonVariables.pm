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

use YAML::Tiny;

use Exporter 'import';
our @EXPORT = qw(
    $common_messages_collector
    $filehandle_log_message
    $filehandle_log_error
    $database_connection
    $app_environment
    $doors
    @emails
    init_variables
);

our $common_messages_collector;
our $filehandle_log_message;
our $filehandle_log_error;
our $database_connection;
our $app_environment;
our $doors;
our @emails;

sub init_variables {
    my ( $common_variables ) = @_;

    ##  common_variables = {
    ##      bk_path
    ##      config_file
    ##      doors
    ##      app_env
    ##  };

    my $config_file = YAML::Tiny->read($common_variables->{bk_path} . $common_variables->{config_file});

    $app_environment = $common_variables->{app_env};

    $common_messages_collector = CommonMessagesCollector->new();
    $filehandle_log_message = BKFileHandler->new('>>', $common_variables->{bk_path} . $config_file->[0]->{path}->{log}->{message});
    $filehandle_log_error = BKFileHandler->new('>>', $common_variables->{bk_path} . $config_file->[0]->{path}->{log}->{error});
    $database_connection = DatabaseAccess->new($config_file->[0]->{path}->{database}->{handler}, $common_variables->{bk_path} . $config_file->[0]->{path}->{database}->{file});
    @emails = @[ $config_file->[0]->{emails} ];
    $doors = Doors->new($common_variables->{doors});

    return 1;
}

return 1;
