#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package Scanner;

use 5.010;
use strict;
use warnings;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::SCANNER,
        _input      => undef
    };
    bless $self, $class;
    return $self;
}

sub GetInput {
    my $self = shift;

    $self->{_input} = <STDIN>;
    chomp($self->{_input});
    $self->{_input} = lc($self->{_input});

    $self->SUPER::ThrowMessage(Constants::LOG, Constants::SCLOGGOTINPUT, $self->{_input});

    return $self->{_input};
}

1;

__END__

=head1 BK::Backend::Scanner

Scanner.pm

=head2 Description

Scanner Object gets input from the STDIN and returns it, it is only an object for logging the STDIN

=head2 Consturctor

_owner_desc - STRING owner for logging
_input - STRING the last Input is saved there

=head2 Getter

None

=head2 Setter

None

=head2 Methods

GetInput() - Gets Input from the STDIN and returns it

=head2 Synopsis

my $scanner = Scanner->new();
my $input = $scanner->GetInput();
