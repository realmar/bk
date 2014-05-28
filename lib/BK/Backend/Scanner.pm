#!/usr/bin/env perl

package Scanner;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::SCANNER,
        _input      => undef,
        _cm_id      => undef,
    };
    bless $self, $class;
    $main::common_messages_collector->AddObject($self->{_cm_id} = $main::common_messages_collector->GetNextID(), $self->SUPER::newcomsg());
    return $self;
}

sub GetCMID {
    my $self = shift;
    return $self->{_cm_id};
}

sub GetInput {
    my $self = shift;

    $self->{_input} = <STDIN>;
    chomp($self->{_input});

    $self->SUPER::ThrowMessage(Constants::LOG, Constants::SCLOGGOTINPUT, $self->{_input});

    return $self->{_input};
}

1;
