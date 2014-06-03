#!/usr/bin/env perl

package BKFileHandler;

use parent -norequire, 'CommonMessages';

use BK::Common::CommonMessagesCollector;
use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::BKFILEHANDLER,
        _filehandle => undef,
        _cm_id      => undef,
    };
    bless $self, $class;
    $self->{_cm_id} = $main::common_messages_collector->AddObject($self->SUPER::newcomsg());
    $self->OpenFileHandle(shift, shift);
    return $self;
}

sub DESTORY {
    my $self = shift;
    $main::common_messages_collector->RemoveObject($self->GetCMID());
    return;
}

sub GetCMID {
    my $self = shift;
    return $self->{_cm_id};
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
