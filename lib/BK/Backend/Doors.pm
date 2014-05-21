#!/usr/bin/env perl

package Doors;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;

sub new {
    $class = shift;
    $self = {
        _owner_desc => Constants::DOORS,
        _doors => shift,
        _msg => undef
    };
    bless $self, $class;
    $self->SUPER::newcomsg();
    return $self;
}

sub SetDoors {
    my ($self, $doors) = @_;
    $self->{_doors} = $doors if defined($doors);
    return $self->{_doors};
}

sub GetDoors {
    my $self = shift;
    return $self->{_doors};
}

sub OpenDoor {
    my ($self, $door, $username) = @_;

    print "Sending Signal to Door:\n\n";
    print "Number $door\n\n";

    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOOROPENED, MessagesTextConstants::DOORSNUMBER . $door . MessagesTextConstants::DOORSUSERNAME . $username);

    &main::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::DOORSOUTPUT->[$door], Constants::HEXNULL);

    sleep(Constants::DOORSSENDSIGNALTIME);

    &main::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::HEXNULL, Constants::HEXNULL);

    print "Stop Sending Signal to Door:\n\n";
    print "Number $door\n\n";

    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOORCLOSED, MessagesTextConstants::DOORSNUMBER . $door . MessagesTextConstants::DOORSUSERNAME . $username);

    return $self->{_doors};
}

1;
