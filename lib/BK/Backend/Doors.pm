#!/usr/bin/env perl

package Doors;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;

sub new {
    $class = shift;
    $self = {
        _owner_desc => Constants::DOORS,
        _doors      => shift,
        _cm_id      => undef,
    };
    bless $self, $class;
    $self->{_cm_id} = $main::common_messages_collector->AddObject($self->SUPER::newcomsg());
    return $self;
}

sub SetDoors {
    my ($self, $doors) = @_;
    $self->{_doors} = $doors if defined($doors);
    return $self->{_doors};
}

sub GetCMID {
    my $self = shift;
    return $self->{_cm_id};
}

sub GetDoors {
    my $self = shift;
    return $self->{_doors};
}

sub OpenDoor {
    my ($self, $door, $username) = @_;

    print "Sending Signal to Door:\n\n";
    print "Number $door\n\n";


    my $doors_opened_err = &main::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::DOORSOUTPUT->[$door], Constants::HEXNULL);

    if($doors_opened_err > 0) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONOPENEND, MessagesTextConstants::DOORSERRORCODE . $doors_opened_err);
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOOROPENED, MessagesTextConstants::DOORSNUMBER . $door . MessagesTextConstants::DOORSUSERNAME . $username);
        sleep(Constants::DOORSSENDSIGNALTIME);
    }

    my $doors_closed_err = &main::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::HEXNULL, Constants::HEXNULL);

    if($doors_closed_err > 0) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONCLOSED, MessagesTextConstants::DOORSERRORCODE . $doors_closed_err);
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOORCLOSED, MessagesTextConstants::DOORSNUMBER . $door . MessagesTextConstants::DOORSUSERNAME . $username);
    }

    print "Stop Sending Signal to Door:\n\n";
    print "Number $door\n\n";


    return $doors_opened_err > 0 || $doors_closed_err > 0 ? undef : 2;
}

1;
