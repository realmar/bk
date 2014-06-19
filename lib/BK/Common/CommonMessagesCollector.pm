#!/usr/bin/env perl

package CommonMessagesCollector;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::COMMONMESSAGESCOLLECTOR,
        _common_messages => [],
        _logging_facilities => {
            Constants::CMERROR => [
                Constants::DBERRCONN,
                Constants::DBERRDISCONN,
                Constants::DBERRCREATE,
                Constants::DBERRREAD,
                Constants::DBERRUPDATE,
                Constants::DBERRDELETE,
                Constants::DBERRBEGINWORK,
                Constants::DBERRCOMMIT,
                Constants::AHERRREFRESHDATA,
                Constants::AHERRSAVEDATA
            ],
            Constants::CMINFO => [
                Constants::DBCONN,
                Constants::DBDISCONN,
                Constants::DBCREATE,
                Constants::DBREAD,
                Constants::DBUPDATE,
                Constants::DBDELETE,
                Constants::DBBEGINWORK,
                Constants::DBCOMMIT,
                Constants::AHSAVEDATAWRITE,
                Constants::AHSUCCSAVEDATA
            ]
        },
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
    return 0;
}

sub GetObject {
    my ($self, $id) = @_;
    return $self->{_common_messages}[$id];
}

sub GetAllErrors {
    my $self = shift;
    my @all_errors = ();
    for(my $i = 0; $i < scalar(@{ $self->{_common_messages} }); $i++) {
        push(@all_errors, $self->GetCommon($i, Constants::CMERROR));
    }
    return @all_errors;
}

sub GetAllInfos {
    my $self = shift;
    my @all_infos = ();
    for(my $i = 0; $i < scalar(@{ $self->{_common_messages} }); $i++) {
        push(@all_infos, $self->GetCommon($i, Constants::CMINFO));
    }
    return @all_infos;
}

sub GetCommon {
    my ($self, $id, $data_type) = @_;
    my %all_common = ();
    foreach my $key (keys(%{ $self->{_common_messages}->[$id]->{_owner_obj}->SUPER::GetCommonDataTypeCM($data_type) })) {
        foreach my $logging_facility (@{ $self->{_logging_facilities}->{$data_type} }) {
            if($key eq $logging_facility) {
                $all_common{$key} = $self->{_common_messages}->[$id]->{_owner_obj}->SUPER::GetCommonCM($data_type, $key);
            }
        }
    }
    return %all_common;
}

sub ResetAllStates {
    my $self = shift;
    for (my $i = 0; $i < scalar(@{ $self->{_common_messages} }); $i++) {
        $self->{_common_messages}->[$i]->{_owner_obj}->SUPER::ResetStates();
    }
    return 0;
}

1;
