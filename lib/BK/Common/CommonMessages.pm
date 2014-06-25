#!/usr/bin/env perl

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
            $main::common_messages_collector->SetCommon(Constants::CMERROR, $msg_type, CommonMessages->new(time, $msg_string));
            $self->LogError($msg_prio, $msg_type, $msg_string);
            last;
        }
        case Constants::LOG {
            $main::common_messages_collector->SetCommon(Constants::CMINFO, $msg_type, CommonMessages->new(time, $msg_string));
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
    $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));

    return $self;
}

sub LogMessage {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;
    $main::filehandle_log_message->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));
    return $self;
}

1;
