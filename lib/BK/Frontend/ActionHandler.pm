#!/usr/bin/env perl

package ActionHandler;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;
use BK::Common::CommonMessagesCollector;
use BK::Common::DatabaseAccess;

use Switch;
use JSON;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::ACTIONHANDLER,
        _action     => shift,
        _data       => shift,
        _cm_id      => undef,
    };
    bless $self, $class;
    $self->{_cm_id} = $main::common_messages_collector->AddObject($self->SUPER::newcomsg());
    return $self;
}

sub DESTROY {
    my $self = shift;

    $self->{handle}->close() if $self->{handle};
    $main::common_messages_collector->RemoveObject($self->GetCMID());

    return;
}

sub SetActionHandler {
    my ($self, $action, $data) = @_;

    if(defined($action) && defined($data)) {
        $self->{_action} = $action;
        $self->{_data}   = $data;
    }

    return $self;
}

sub GetCMID {
    my $self = shift;
    return $self->{_cm_id};
}

sub GetActionHandler {
    my $self = shift;
    return {
        'action' => $self->{_action},
        'data'   => $self->{_data}
    };
}

sub SetAHAction {
    my ($self, $action) = @_;
    $self->{_action} = $action if defined($action);
    return $self->{_action};
}

sub SetAHData {
    my ($self, $data) = @_;
    $self->{_data} = $data if defined($data);
    return $self->{_data};
}

sub GetSHAction {
    my $self = shift;
    return $self->{_action};
}

sub GetAHData {
    my $self = shift;
    return $self->{_data};
}

sub GetProcAC {
    my $self = shift;
    return $self->{_proc_ac};
}

sub ProcessAction {
    my $self = shift;

    switch ($self->{_action}) {
        case Constants::AHREFRESH {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHREFRESH, Constants::AHREFRESH);
            $self->RefreshData();
            last;
        }
        case Constants::AHSAVEDATA {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, $self->{_data});
            $self->FromJSON();
            $self->SaveData();
            last;
        }
        case Constants::AHKEEPALIVE {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHKEEPALIVE, $self->{_action});
            return 1;
        }
        else {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHUNKNOWNACTION, $self->{_action});
            return 1;
        }
    }

    return;
}

sub RefreshData {
    my $self = shift;

    $self->GetAllEntries();
    $self->{_data} = $self->GetAllEntries();

    return 1;
}

sub SaveData {
    my $self = shift;

    $main::database_connection->BeginWork();

    for (my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        switch ($self->{_data}->[$i]) {
            case (Constants::AHNOTCHANGED) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDIDEN);
                last;
            }
            case ('') {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDDEL);
                $main::database_connection->UpdateEntryDatabase('Users', {'username' => 'null'}, {'doornumber' => $i});
                last;
            }
            else {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDNEW);
                $main::database_connection->UpdateEntryDatabase('Users', {'username' => $self->{_data}[$i]}, {'doornumber' => $i});
                last;
            }
        }
    }

    $main::database_connection->CommitChanges();

    $self->RefreshData();

    return $self;
}

sub GetAllEntries {
    my $self = shift;

    my %db_entries_hash;
    my @db_entries_array;
    my $db_entries = $main::database_connection->ReadEntryDatabase('Users', {});
    while (my $db_entries_row = $db_entries->fetchrow_hashref) {
        $db_entries_hash{$db_entries_row->{doornumber}} = $db_entries_row->{username};
    }
    foreach my $entry_pos (sort(keys(%db_entries_hash))) {
        $db_entries_array[$entry_pos] = $db_entries_hash{$entry_pos};
    }
    $db_entries_array[Constants::DOORCOUNT] = undef if undef($db_entries_array[Constants::DOORCOUNT]);

    return \@db_entries_array;
}

sub ToJSON {
    my $self = shift;
    $self->{_data} = to_json($self->{_data});
    return $self->{_data};
}

sub FromJSON {
    my $self = shift;
    if(ref($self->{_data}) eq 'ARRAY' || ref($self->{_data}) eq 'HASH') {
        return $self->{_data};
    }
    $self->{_data} = from_json($self->{_data});
    return $self->{_data};
}

sub PrepareWebSocketData {
    my $self = shift;

    $self->{_action} = $self->{_data}->{'action'};
    $self->{_data} = $self->{_data}->{'msg_data'};

    return $self;
}

sub PrepareDataToSend {
    my $self = shift;

    $self->{_data} = {
        'msg_data' => $self->{_data},
        'all_errors' => $main::common_messages_collector->GetAllErrors(),
        'all_infos' => $main::common_messages_collector->GetAllInfos()
    };
    $self->ToJSON();

    $main::common_messages_collector->ResetAllStates();

    return $self->{_data};
}

1;
