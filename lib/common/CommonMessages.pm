#!/usr/bin/env perl

package CommonMessages;

use parent -norequire, 'DBMessages', 'ScannerMessages';

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
    my ($self, $owner_typ, $msg_prio, $msg_typ, $msg_string) = @_;

    switch ($msg_prio) {
        case Constants::ERROR {
            switch ($owner_typ) {
                case Constants::DB {
                    $self->SUPER::DBError($msg_typ, $msg_string);
                    last;
                }
            }
            last;
        }
        case Constants::LOG {
            switch ($owner_typ) {
                case Constants::SCANNER {
                    $self->SUPER::ScannerLogInput($msg_typ, $msg_string);
                    last;
                }
            }
            last;
        }
    }
}

1;
