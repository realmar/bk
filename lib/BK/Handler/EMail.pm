#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package DatabaseAccess;

use 5.010;
use strict;
use warnings;

use Email::Sender::Simple;
use Email::Simple;
use Email::Simple::Creator;

use parent -norequire, 'CommonMessages';

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::EMAIL,
        _emails_to => shift,
        _email_from => shift
    };
    bless $self, $class;
    return $self;
}

sub SendEMail {
    my ( $self,  $user, $door) = @_;

    my $email_to = join(', ', $self->{_emails_to});

    my $email = Email::Simple->create(
        header => [
            To => $email_to,
            From => $self->{_email_from},
            Subject => 'The user' . $user .  'took his/her book from book box ' . $door
        ],
        body => 'The user' . $user .  'took his/her book from book box ' . $door

    );

    Email::Sender::Simple->send($email);
}

1;

__END__

=head1 BK::Handler::EMail

EMail.pm

=head2 Description

Sends E-Mails to predefined recipients

=head2 Constructor

_owner_desc - STRING owner for logging
_emails_to - recipients, is an array
_email_from - sender

=head2 Setter

None

=head2 Getter

None

=head2 Methods

SendEMail() - sends an e-amil

=head2 Synposis

my $email_handler = EMail->new( [ to - receipients is an array ], [ from - STRING represents the sender ] );
$email_handler->SendEMail( [ user - STRING ], [ door - STRING ] );
