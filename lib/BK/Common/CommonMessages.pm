#!/usr/bin/env perl

package CommonMessages;

use Switch;

use BK::Common::Constants;
use BK::Common::DatabaseAccess;

sub newcomsg {
    my $self = shift;
    my $err = {
        _owner_obj => $self,
    };
    bless $err, ref($self);
    $self->{'_' . Constants::CMERROR} = {};
    $self->{'_' . Constants::CMINFO} = {};
    return $err;
}

sub SetCommonCM {
    my ($self, $data_type, $msg_type, $msg_string) = @_;
    if(!defined($self->{'_' . $data_type}->{$msg_type})) {
        $self->{'_' . $data_type}->{$msg_type} = [];
    }
    push($self->{'_' . $data_type}->{$msg_type}, {Constants::THROWTIME => time(), Constants::MSGSTRING => $msg_string});
    return 0;
}

sub GetCommonCM {
    my ($self, $data_type, $msg_type) = @_;
    return $self->{'_' . $data_type}->{$msg_type};
}

sub GetCommonDataTypeCM {
    my ($self, $data_type) = @_;
    return $self->{'_' . $data_type};
}

sub ResetStates {
    my $self = shift;
    $self->{'_' . Constants::CMERROR} = {};
    $self->{'_' . Constants::CMINFO} = {};
    return 0;
}

sub ThrowMessage {
    my ($self, $msg_prio, $msg_type, $msg_string) = @_;

    switch ($msg_prio) {
        case Constants::ERROR {
            $self->SetCommonCM(Constants::CMERROR, $msg_type, $msg_string);
            $self->LogError($msg_prio, $msg_type, $msg_string);
            last;
        }
        case Constants::LOG {
            $self->SetCommonCM(Constants::CMINFO, $msg_type, $msg_string);
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
