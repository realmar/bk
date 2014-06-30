#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package BKFileHandler;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::BKFILEHANDLER,
        _filehandle => undef
    };
    bless $self, $class;
    $self->OpenFileHandle(shift, shift);
    return $self;
}

sub OpenFileHandle {
    my ($self, $mode, $file) = @_;

    $self->{_filehandle} = FileHandle->new;
    $self->{_filehandle}->open($mode . ' ' . $file);

    return $self->{_filehandle};
}

sub CloseFileHandle {
    my $self = shift;
    $self->{_filehandle}->close;
    return $self->{_filehandle};
}

sub WriteToFile {
    my ($self, $msg) = @_;

    print {$self->{_filehandle}} ($msg);
    autoflush {$self->{_filehandle}} 1;

    return $self->{_filehandle};
}

1;

__END__

=head1 BK::Common::BKFileHandler

BKFileHandler.pm

=head2 Description

FileHandler Object which handles all access to Files, designed for logging, write in log files

=head2 Constructor

_owner_desc - STRING owner for logging
_filehandle - HANDLE FileHandle

=head2 Setter

OpenFileHandle( [mode - STRING], [file - STRING] ) - Open a FileHandle on a specific File with a specific mode
CloseFileHandle() - Close a FileHandle

=head2 Getter

None

=head2 Methods

WriteToFile( [msg - STRING] ) - writes the [msg - STRING] to the open File

=head2 Synopsis

my $filehandle = BKFileHandler->new( [mode - STRING eg. >>], [file - STRING] );
$filehandle->WriteToFile( [msg - String] );
$filehandle->CloseFileHandle();
