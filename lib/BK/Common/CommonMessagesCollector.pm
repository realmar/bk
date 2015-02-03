#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package CommonMessagesCollector;

use 5.010;
use strict;
use warnings;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::COMMONMESSAGESCOLLECTOR,
        _common_messages => {},
        _logging_facilities => {
            Constants::CMERROR => {
                Constants::DBERRCONN        => 1,
                Constants::DBERRDISCONN     => 1,
                Constants::DBERRCREATE      => 1,
                Constants::DBERRREAD        => 1,
                Constants::DBERRUPDATE      => 1,
                Constants::DBERRDELETE      => 1,
                Constants::DBERRBEGINWORK   => 1,
                Constants::DBERRCOMMIT      => 1,
                Constants::AHERRREFRESHDATA => 1,
                Constants::AHERRSAVEDATA    => 1,
                Constants::AHERROPENDOORS   => 1,
                Constants::AHERRUSERINPUT   => 1

            },
            Constants::CMINFO => {
                ##  Constants::DBCONN          => 1,
                ##  Constants::DBDISCONN       => 1,
                ##  Constants::DBCREATE        => 1,
                ##  Constants::DBREAD          => 1,
                ##  Constants::DBUPDATE        => 1,
                ##  Constants::DBDELETE        => 1,
                ##  Constants::DBBEGINWORK     => 1,
                ##  Constants::DBCOMMIT        => 1,
                ##  Constants::AHSAVEDATAWRITE => 1,
                Constants::AHSUCCSAVEDATA      => 1,
                Constants::AHSUCCOPENDOORS     => 1
            }
        }
    };
    bless $self, $class;
    return $self;
}

sub SetCommon {
    my ($self, $data_type, $msg_type, $msg_obj) = @_;
    $self->{_common_messages}->{$msg_type}->{$data_type} ||= [];
    push( @{ $self->{_common_messages}->{$msg_type}->{$data_type} }, $msg_obj);
    return 0;
}

sub GetAllCommons {
    my ($self, $data_type) = @_;
    my $all_commons = {};
    my @msg_types = keys(%{ $self->{_common_messages} });
    foreach my $msg_type (@msg_types) {
        if(defined($self->{_logging_facilities}->{$data_type}->{$msg_type})) {
            $all_commons->{$msg_type} = $self->GetCommon($data_type, $msg_type);
        }
    }
    return $all_commons;
}

sub GetCommon {
    my ($self, $data_type, $msg_type) = @_;
    my $all_common = [];
    foreach my $msg_obj (@{ $self->{_common_messages}->{$msg_type}->{$data_type} }) {
        push(@{ $all_common }, $msg_obj->SUPER::GetMessageHash());
    }
    return $all_common;
}

sub ResetAllStates {
    my $self = shift;
    $self->{_common_messages} = {};
    return 0;
}

1;

__END__

=head1 BK::Common::CommonMessagesCollector

CommonMessagesCollector.pm

=head2 Description

Log Message Collector, holds all Log Objects in an Hash log_facilities -> common_messages_facilities -> Log Object

=head2 Constructor

_owner_desc - STRING owner for logging
_common_messages - HASH holds all Log Objects
_logging_facilities - HASH holds all  Logging Facilities which should get logged to the Client common_messages_facilities -> logging_facilities

=head2 Setter

SetCommon( [data_type - STRING], [msg_type - STRING], [msg_obj - COMMONMESSAGES] ) - Adds an Log Object to the _common_messages

=head2 Getter

GetAllCommons( [data_type - STRING] ) - Returns an HASH with all Log Object of a data_type
GetCommon( [data_type - STRING], [msg_type - STRING] ) - Returns an ARRAY with all Log Object of a msg_type of a data_type

=head2 Methods

ResetAllStates() - Deletes all Log Objects

=head2 Synopsis

my $common_messages_collector = CommonMessagesCollector->new();
$common_messages_collector->SetCommon( [data_type - STRING eg. info], [msg_type - STRING, eg. actionhandler], [msg_obj - COMMONMESSAGES eg. CommonMessages->new(time, 'testtest')] );
my $all_common_messages = $common_messages_collector->GetAllCommons( [data_type - STRING eg. info] );
$common_messages_collector->ResetAllStates();
