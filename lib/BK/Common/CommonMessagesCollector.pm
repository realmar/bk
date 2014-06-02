#!/usr/bin/env perl

package CommonMessagesCollector;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::COMMONMESSAGESCOLLECTOR,
        _common_messages => [],
        _id_count => 0
    };
    bless $self, $class;
    return $self;
}

sub AddObject {
    my ($self, $obj) = @_;
    push($self->{_common_messages}, $obj);
    $self->{_id_count}++;
    return $self->{_id_count} - 1;
}

sub RemoveObject {
    my ($self, $id) = @_;
    delete($self->{_common_messages}[$id]);
    return;
}

sub GetObject {
    my ($self, $id) = @_;
    return $self->{_common_messages}[$id];
}

sub GetAllErrors {
    my $self = shift;
    my @all_errors = [];
    for(my $i = 0; $i < scalar(@{ $self->{_common_messages} }); $i++) {
        push(@all_errors, $self->GetCommon($i, Constants::CMERROR));
    }
    return @all_errors;
}

sub GetAllInfos {
    my $self = shift;
    my @all_infos = [];
    for(my $i = 0; $i < scalar(@{ $self->{_common_messages} }); $i++) {
        push(@all_infos, $self->GetCommon($i, Constants::CMINFO));
    }
    return @all_infos;
}

sub GetCommon {
    my ($self, $id, $data_type) = @_;
    my %all_common = (
        "$data_type" . "_type" => $self->{_common_messages}->[$id]->{_owner_obj}->SUPER::GetCommonType($data_type),
        "$data_type" . "_msg" => $self->{_common_messages}->[$id]->{_owner_obj}->SUPER::GetCommonMSG($data_type)
    );
    return %all_common;
}

1;
