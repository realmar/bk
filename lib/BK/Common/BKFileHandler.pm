#!/usr/bin/env perl

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
