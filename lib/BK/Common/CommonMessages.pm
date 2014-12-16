#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package CommonMessages;

use Switch;

use BK::Common::Constants;
use BK::Common::DatabaseAccess;

sub new {
    my $class = shift;
    my $self = {
        '_' . Constants::THROWTIME => shift,
        '_' . Constants::MSGSTRING => shift
    };
    bless $self, $class;
    return $self;
}

sub GetMessageHash {
    my $self = shift;
    my $msg_hash = {
        Constants::THROWTIME => $self->{'_' . Constants::THROWTIME},
        Constants::MSGSTRING => $self->{'_' . Constants::MSGSTRING}
    };
    return $msg_hash;
}

sub ThrowMessage {
    my ($self, $msg_prio, $msg_type, $msg_string) = @_;

    switch ($msg_prio) {
        case Constants::ERROR {
            $CommonVariables::common_messages_collector->SetCommon(Constants::CMERROR, $msg_type, CommonMessages->new(time, $msg_string));
            $self->LogError($msg_prio, $msg_type, $msg_string);
            last;
        }
        case Constants::LOG {
            $CommonVariables::common_messages_collector->SetCommon(Constants::CMINFO, $msg_type, CommonMessages->new(time, $msg_string));
            $self->LogMessage($msg_prio, $msg_type, $msg_string);
            last;
        }
    }

    return 0;
}

sub CreateLogString {
    my ($owner_typ, $msg_prio, $msg_typ, $msg_string) = @_;
    return '[' . localtime . '][' . $owner_typ . '][' . $msg_prio . '][' . $msg_typ . '] ' . $msg_string . "\n";
}

sub LogError {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;

    if($self->{_owner_desc} eq Constants::DB) {
        $self->RollbackChanges();
    }
    $CommonVariables::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));

    return $self;
}

sub LogMessage {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;
    $CommonVariables::filehandle_log_message->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));
    return $self;
}

1;

__END__

=head1 BK::Common::CommonMessages

CommonMessages.pm

=head2 Description

Log Object, represents one Log Message
Is used as Parent Object of almost every other Object
Depends on the CommonMessagesCollector Object where it stores itself
Dont want to create such an Object without CommonMessagesCollector

=head2 Consturctor

_throwtime - STRING time when the message was thrown, is a Unix Timestamp
_msgstring - STRING message string

=head2 Setter

None

=head2 Getter

GetMessageHash() - Returns a Hash representation of the Log Object

=head2 Methods

ThrowMessage( [msg_prio - STRING], [msg_type - STRING], [msg_string - STRING] ) - Saves Message to itself, and itself to the CommonMessagesCollector Object, writes Message to Log File
LogError( [msg_prio - STRING], [msg_typ - STRING], [msg_string - STRING] ) - Saves Message to Error Log File
LogMessage( [msg_prio - STIRNG], [msg_typ - STRING], [msg_string - STRING] ) - Saves Message to Message Log File

=head2 Functions

CreateLogString( [owner_typ - STRING], [msg_prio - STRING], [msg_typ - STRING], [msg_string - STRING] ) - Returns a Log String suitable for Logging in Log Files

=head2 Synopsis

my $log_message = CommonMessages->new( [throwtime - STRING eg. `time`], [msgstring - STRING eg. testtest] );

my $object = Object->new();
$object->SUPER::ThrowMessage( [msg_prio - STRING eg. log], [msg_type - STRING eg. actionhandler], [msg_string - STRING eg. testtest] );
