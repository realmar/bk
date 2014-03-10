#!/usr/bin/env perl

package Doors;

use parent -norequire, 'CommonMessages';

sub new {
    $class = shift;
    $self = {
        _owner_desc => 'doors',
        _doors => shift,
        _msg => undef
    };
    bless $self, $class;
    $self->{_msg} = $self->SUPER::newcomsg($self->{_owner_desc}, 0);
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
    my ($self, $door) = @_;
    print "Opening Door:\n\n";
    print "Number $door\n\n";
    return $self->{_doors};
}

1;
