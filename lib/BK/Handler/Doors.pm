#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package Doors;

use 5.010;
use strict;
use warnings;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;
use BK::Handler::DatabaseAccess;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::DOORS,
        _doors      => shift
    };
    bless $self, $class;
    return $self;
}

sub OpenDoor {
    my ($self, $doors_arg, $username) = @_;

    my @doors = @{ $doors_arg };
    my $all_doors = 0;

    foreach my $door ( @doors ) {
        $all_doors = $all_doors | Constants::DOORSOUTPUT->[$door];
    }

    my $doors_opened_err = CommonVariables::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::DOORSOUTPUT->[$all_doors], Constants::HEXNULL);

    if($doors_opened_err > 0) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONOPENEND, MessagesTextConstants::DOORSERRORCODE . $doors_opened_err);
        return 0;
    }
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOOROPENED, MessagesTextConstants::DOORSNUMBER . join(', ', @doors) . MessagesTextConstants::DOORSUSERNAME . $username);
    sleep(Constants::DOORSSENDSIGNALTIME);

    my $doors_closed_err = CommonVariables::SetPins(Constants::HEXTWOBYTEONE, Constants::HEXNULL, Constants::HEXNULL, Constants::HEXNULL);

    if($doors_closed_err > 0) {
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DOORSEXEPTIONCLOSED, MessagesTextConstants::DOORSERRORCODE . $doors_closed_err);
        return 0;
    }
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DOORCLOSED, MessagesTextConstants::DOORSNUMBER . join(', ', @doors) . MessagesTextConstants::DOORSUSERNAME . $username);

    return 1;
}

1;

__END__

=head1 BK::Backend::Doors

Doors.pm

=head2 Description

Modul for controling the Pins on the LabJack basically open the Doors on the BuecherkastenBibliothek

=head2 Constuctor

_owner_desc - STRING owner for logging
_doors - ARRAY with all doors

=head2 Methods

OpenDoor( [door - INT], [username - STRING] ) - Sends signal to a specific pin on the LabJack defined as [door - INT], [username - STRING] is required only for logging purposes

=head2 Synopsis

my $doors = Doors->new( [doors - ARRAY] );
$doors->OpenDoors( [door - INT], [username - STRING] );
