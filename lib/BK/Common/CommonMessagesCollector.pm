#!/usr/bin/env perl

package CommonMessagesCollector;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::COMMONMESSAGESCOLLECTOR,
        _common_messages => []
    };
    bless $self, $class;
    return $self;
}

sub GetNextID {
    my $self = shift;
    my @cm_temp = $self->{_common_messages};
    return $#cm_temp + 1;
}

sub AddObject {
    my ($self, $id, $obj) = @_;
    $self->{_common_messages}->[$id] = $obj;
    return;
}

sub RemoveObject {
    my ($self, $id) = @_;
    delete($self->{_common_messages}->[$id]);
    return;
}

sub GetObject {
    my ($self, $id) = @_;
    return $self->{_common_messages}->[$id];
}

sub GetAllErrors {
    my $self = shift;
    my @all_errors = [];
    for(my $i = 0; $i < scalar($self->{_common_messages}) + 1; $i++) {
        push(@all_errors, $self->GetCommon($i, Constants::CMERROR));
    }
    return @all_errors;
}

sub GetAllInfos {
    my $self = shift;
    my @all_infos = [];
    for(my $i = 0; $i < scalar($self->{_common_messages}) + 1; $i++) {
        push(@all_infos, $self->GetCommon($i, Constants::CMINFO));
    }
    return @all_infos;
}

sub GetCommon {
    my $self = shift;
    my ($self, $id, $data_type) = @_;
    my %all_common = {
        "$data_type" . "_type" => $self->{_common_messages}->[$id]->SUPER::GetCommonType($data_type),
        "$data_type" . "_msg" => $self->{_common_messages}->[$id]->SUPER::GetCommonMSG($data_type)
    };
    return %all_common;
}

1;
