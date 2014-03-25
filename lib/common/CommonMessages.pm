#!/usr/bin/env perl

package CommonMessages;

use Switch;

sub newcomsg {
    my $self = shift;
    my $err = {
        _owner_desc => shift,
        _err_count => shift
    };
    bless $err;
    return $err;
}

sub SetMsg {
    my ($self, $owner_desc, $err_count) = @_;
    $self->SetOwnerDesc($owner_desc) if !undef($owner_desc);
    $self->SetErrCount($err_count) if !undef($err_count);
    return $self->GetMsg();
}

sub GetMsg {
    my $self = shift;
    return {owner_desc => $self->GetOwnerDesc(), err_count => $self->GetErrCount};
}

sub SetOwnerDesc {
    my ($self, $owner_desc) = @_;
    $self->{_msg}->{_owner_desc} = $owner_desc if defined($owner_desc);
    return $self->{_msg}->{_owner_desc};
}

sub SetErrCount {
    my ($self, $err_count) = @_;
    $self->{_msg}->{_err_count} = $err_count if defined($err_count);
    return $self->{_msg}->{_err_count};
}

sub GetOwnerDesc {
    my $self = shift;
    return $self->{_msg}->{_owner_desc};
}

sub GetErrCount {
    my $self = shift;
    return $self->{_msg}->{_err_count};
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
    if($owner_typ == Constants::DB) {
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
