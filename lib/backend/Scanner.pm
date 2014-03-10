#!/usr/bin/env perl

package Scanner;

use parent -norequire, 'CommonMessages';

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => 'scanner',
        _input => undef,
        _msg => undef
    };
    bless $self, $class;
    $self->{_msg} = $self->SUPER::newcomsg($self->{_owner_desc}, 0);
    return $self;
}

sub GetInput {
    my $self = shift;
    $self->{_input} = <STDIN>;
    chomp($self->{_input});

    $self->SUPER::ThrowMessage($self->{_owner_desc}, Constants::LOG, Constants::SCLOGGOTINPUT, $self->{_input});

    return $self->{_input};
}

1;
