#!/usr/bin/env perl

package CommonMessages;

use Switch;

sub newcomsg {
    my $self = shift;
    my $err = {
        _error_type => undef,
        _error_msg => undef,
        _err_count => undef
    };
    bless $err;
    $self->InitCoMSG();
    return $err;
}

sub SetErrorType {
    my ($self, $type) = @_;
    $self->{_msg}->{_error_type} = $type if defined($type);
    return $self->{_msg}->{_error_type};
}

sub SetErrorMSG {
    my ($self, $msg) = @_;
    $self->{_msg}->{_error_msg} = $msg if defined($msg);
    return $self->{_msg}->{_error_msg};
}

sub GetErrorType {
    my $self = shift;
    return $self->{_msg}->{_error_type};
}

sub GetErrorMSG {
    my $self = shift;
    return $self->{_msg}->{_error_msg};
}

sub InitCoMSG {
    my $self = shift;
    $self->{_msg}->{_error_count} = 0;
    return $self;
}

sub RaiseErrCount {
    my ($self, $raise_count) = @_;
    $self->{_msg}->{_err_count} += $raise_count;
    return $self->{_msg}->{_err_count};
}

sub ThrowMessage {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;

    switch ($msg_prio) {
        case Constants::ERROR {
            $self->SetErrorType($msg_type);
            $self->SetErrorMSG($msg_string);
            $self->LogError($msg_prio, $msg_typ, $msg_string);
            last;
        }
        case Constants::LOG {
            $self->LogMessage($msg_prio, $msg_typ, $msg_string);
            last;
        }
    }
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
    $self->RaiseErrCount(1);
    $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));
    return 1;
}

sub LogMessage {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;
    $main::filehandle_log_message->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));
    return 1;
}

1;
