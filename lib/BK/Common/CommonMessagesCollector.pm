#!/usr/bin/env perl

package CommonMessagesCollector;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::COMMONMESSAGESCOLLECTOR,
        _common_messages => {},
        _logging_facilities => {
            Constants::CMERROR => {
                Constants::DBERRCONN        => 1,
                Constants::DBERRDISCONN     => 1,
                Constants::DBERRCREATE      => 1,
                Constants::DBERRREAD        => 1,
                Constants::DBERRUPDATE      => 1,
                Constants::DBERRDELETE      => 1,
                Constants::DBERRBEGINWORK   => 1,
                Constants::DBERRCOMMIT      => 1,
                Constants::AHERRREFRESHDATA => 1,
                Constants::AHERRSAVEDATA    => 1

            },
            Constants::CMINFO => {
                ##  Constants::DBCONN          => 1,
                ##  Constants::DBDISCONN       => 1,
                ##  Constants::DBCREATE        => 1,
                ##  Constants::DBREAD          => 1,
                ##  Constants::DBUPDATE        => 1,
                ##  Constants::DBDELETE        => 1,
                ##  Constants::DBBEGINWORK     => 1,
                ##  Constants::DBCOMMIT        => 1,
                ##  Constants::AHSAVEDATAWRITE => 1,
                Constants::AHSUCCSAVEDATA      => 1

            }
        }
    };
    bless $self, $class;
    return $self;
}

sub SetCommon {
    my ($self, $data_type, $msg_type, $msg_obj) = @_;
    $self->{_common_messages}->{$msg_type}->{$data_type} = [] if !defined($self->{_common_messages}->{$msg_type}->{$data_type});
    push($self->{_common_messages}->{$msg_type}->{$data_type}, $msg_obj);
    return 0;
}

sub GetAllCommons {
    my ($self, $data_type) = @_;
    my $all_commons = {};
    my @msg_types = keys(%{ $self->{_common_messages} });
    foreach my $msg_type (@msg_types) {
        if(defined($self->{_logging_facilities}->{$data_type}->{$msg_type})) {
            $all_commons->{$msg_type} = $self->GetCommon($data_type, $msg_type);
        }
    }
    return $all_commons;
}

sub GetCommon {
    my ($self, $data_type, $msg_type) = @_;
    my $all_common = [];
    foreach my $msg_obj (@{ $self->{_common_messages}->{$msg_type}->{$data_type} }) {
        push(@{ $all_common }, $msg_obj->SUPER::GetMessageHash());
    }
    return $all_common;
}

sub ResetAllStates {
    my $self = shift;
    $self->{_common_messages} = {};
    return 0;
}

1;
