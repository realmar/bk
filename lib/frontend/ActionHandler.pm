#!/usr/bin/env perl

package ActionHandler;

use parent -norequire, 'CommonMessages';

use Switch;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => 'actionhandler',
        _action     => shift,
        _data       => shift,
        _db_conn    => undef,
        _msg        => undef
    };
    bless $self, $class;
    $self->SUPER::newcomsg();
    return $self;
}

sub DESTROY {
    my $self = shift;

    $self->{_db_conn}->DisconnectFromDatabase();
    $self->{handle}->close() if $self->{handle};
}

sub SetActionHandler {
    my ($self, $action, $data) = @_;
    if(defined($action) && defined($data)) {
        $self->{_action} = $action;
        $self->{_data}   = $data;
    }
    return $self;
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

sub ProcessAction {
    my $self = shift;
    $self->{_db_conn} = DatabaseAccess->new('SQLite', 'database/BKDatabase.db');
    switch ($self->{_action}) {
        case Constants::AHREFRESH {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHREFRESH, Constants::AHREFRESH);
            $self->RefreshData();
            last;
        }
        case Constants::AHSAVEDATA {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, $self->{_data});
            $self->SaveData();
            last;
        }
        else {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHUNKNOWNACTION, $self->{_action});
            last;
        }
    }

    return $self;
}

sub RefreshData {
    my $self = shift;
    $self->{_data} = $self->GetAllEntries();
    return 1;
}

sub SaveData {
    my $self = shift;
    my @db_data = $self->GetAllEntries();
    for (my $i = 0; $i < scalar($self->{_data}); $i++) {
        switch ($self->{_data}->[$i]) {
            case $db_data[$i] {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, MessagesTextConstants::AHSDIDEN);
                last;
            }
            case '' {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, MessagesTextConstants::AHSDDEL);
                $self->{_db_conn}->UpdateEntryDatabase('users', {'username' => ''}, {'doornumber' => $i});
                last;
            }
            else {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, MessagesTextConstants::AHSDNEW);
                $self->{_db_conn}->UpdateEntryDatabase('user', {'username' => $self->{_data}[$i]}, {'doornumber' => $i});
                last;
            }
        }
    }
    $self->RefreshData();
    return 1;
}

sub GetAllEntries {
    my $self = shift;
    my %db_entries_hash = {};
    my @db_entries_array = [];
    my $db_entries = $self->{_db_conn}->ReadEntryDatabase('users', {});
    while (my $db_entries_row = $db_entries->fetchrow_hashref) {
        $db_entries_hash{$db_entries_row->{doornumber}} = $db_entries_row->{username};
    }
    foreach my $entry_pos (sort(keys($db_entries_hash))) {
        push(@db_entries_array, $db_entries_hash{$entry_pos});
    }

    return @db_entries_array;
}

sub ToJSON {
    my $self = shift;
    $self->{_data} = to_json($self->{_data});
    return $self->{_data};
}

sub FromJSON {
    my $self = shift;
    $self->{_data} = from_json($self->{_data});
    return $self->{_data};
}

sub PrepareWebSocketData {
    my $self = shift;
    $self->{_action} = $self->{_data}->{'action'};
    $self->{_data} = $self->{_data}->{'msg_data'};
    return 1;
}

sub CollectAllErrors {
    my $self = shift;
    return [
        {
            'error_type' => $self->SUPER::GetErrorType(),
            'error_msg' => $self->SUPER::GetErrorMSG()
        },
        {
            'error_type' => $self->{_db_conn}->SUPER::GetErrorType(),
            'error_msg' => $self->{_db_conn}->SUPER::GetErrorMSG()
        }
    ];
}

sub PrepareDataToSend {
    my $self = shift;
    $self->{_data} = {
        'msg_data' => $self->{_data},
        'all_errors' => $self->CollectAllError()
    };
    $self->ToJSON();
    return $self->{_data};
}

1;
