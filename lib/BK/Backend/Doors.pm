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
    my ($self, $door) = @_;
    print "Opening Door:\n\n";
    print "Number $door\n\n";
    return $self->{_doors};
}

1;
