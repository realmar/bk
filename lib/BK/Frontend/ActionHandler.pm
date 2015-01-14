#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

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
        _proc_ac    => 0
    };
    bless $self, $class;
    return $self;
}

sub DESTROY {
    my $self = shift;

    $self->{handle}->close() if $self->{handle};

    return 0;
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

sub GetAHAction {
    my $self = shift;
    return $self->{_action};
}

sub GetAHData {
    my $self = shift;
    return $self->{_data};
}

sub SetProcAC {
    my ($self, $proc_ac) = @_;
    $self->{_proc_ac} = $proc_ac if defined($proc_ac);
    return $self->{_proc_ac};
}

sub GetProcAC {
    my $self = shift;
    return $self->{_proc_ac};
}

sub ProcessAction {
    my $self = shift;

    $self->SetProcAC(0);

    switch ($self->{_action}) {
        case Constants::AHREFRESH {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHREFRESH, Constants::AHREFRESH);
            if($self->RefreshData()) {
                $self->SUPER::ThrowMessage(Constants::ERROR);
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRREFRESHDATA, MessagesTextConstants::AHERRREFRESHDATAMSG);
            }
            last;
        }
        case Constants::AHSAVEDATA {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, $self->{_data});
            $self->FromJSON();
            my $sav_data_response = $self->SaveData();
            if($sav_data_response eq Constants::INTERNALERROR) {
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRSAVEDATA, MessagesTextConstants::AHERRSAVEDATAMSG);
            }elsif($sav_data_response eq Constants::AHREFRESH) {
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRREFRESHDATA, MessagesTextConstants::AHERRREFRESHDATAMSG);
            }else{
                if(!$sav_data_response) {
                    $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSUCCSAVEDATA, MessagesTextConstants::AHSAVEDATANOCHANGESMSG);
                }else{
                    $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSUCCSAVEDATA, MessagesTextConstants::AHSAVEDATAMSG);
                }
            }
            last;
        }
        case Constants::AHOPENDOORS {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHOPENDOORS, $self->{_data});
            $self->FromJSON();
            my $sav_data_response = $self->MarkToOpenDoors();
            if($sav_data_response eq Constants::INTERNALERROR) {
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERROPENDOORS, MessagesTextConstants::AHERROPENDOORS);
            }elsif($sav_data_response eq Constants::AHREFRESH) {
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERROPENDOORS, MessagesTextConstants::AHERRREFRESHDATAMSG);
            }else{
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSUCCOPENDOORS, MessagesTextConstants::AHOPENDOORSMSG);
            }
            last;
        }
        case Constants::AHKEEPALIVE {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHKEEPALIVE, $self->{_action});
            $self->SetProcAC(1);
            last;
        }
        else {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHUNKNOWNACTION, $self->{_action});
            $self->SetProcAC(1);
            last;
        }
    }

    return 0;
}

sub RefreshData {
    my $self = shift;

    $self->{_data} = $self->GetAllEntries();
    if($self->{_data} eq Constants::INTERNALERROR) {
        return Constants::AHREFRESH;
    }

    return 0;
}

sub SaveData {
    my $self = shift;

    my $database_changed = 0;

    $CommonVariables::database_connection->BeginWork();

    for (my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        switch ($self->{_data}->[$i]) {
            case (Constants::AHNOTCHANGED) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDIDEN);
                last;
            }
            case ('') {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDDEL);
                if($CommonVariables::database_connection->UpdateEntryDatabase('Users', {'username' => 'null'}, {'doornumber' => $i}) eq Constants::INTERNALERROR) {
                    return Constants::INTERNALERROR;
                }
                $database_changed = 1;
                last;
            }
            else {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDNEW);
                if($CommonVariables::database_connection->UpdateEntryDatabase('Users', {'username' => $self->{_data}[$i]}, {'doornumber' => $i}) eq Constants::INTERNALERROR) {
                    return Constants::INTERNALERROR;
                }
                $database_changed = 1;
                last;
            }
        }
    }

    $CommonVariables::database_connection->CommitChanges();

    my $ah_refresh_data = $self->RefreshData();
    if(!$ah_refresh_data) {
        return $database_changed;
    }else{
        return $ah_refresh_data;
    }
}

sub MarkToOpenDoors {
    my $self = shift;

    my $database_changed = 0;

    $CommonVariables::database_connection->BeginWork();

    for (my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        switch ($self->{_data}->[$i]) {
            case (Constants::NOTOPENDOORNUM) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHOPENDOORS, MessagesTextConstants::AHNOTOPENDOORMSG);
                last;
            }
            case (Constants::DOOPENDOORNUM) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHOPENDOORS, MessagesTextConstants::AHDOOPENDOORMSG);
                if($CommonVariables::database_connection->UpdateEntryDatabase('Users', {'opendoor' => Constants::AHDOOPENDOOR}, {'doornumber' => $i}) eq Constants::INTERNALERROR) {
                    return Constants::INTERNALERROR;
                }
                $database_changed = 1;
                last;
            }
            else {
                $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHOPENDOORS, MessagesTextConstants::AHUNKNOWNACTION);
                last;
            }
        }
    }

    $CommonVariables::database_connection->CommitChanges();

    my $ah_refresh_data = $self->RefreshData();
    if(!$ah_refresh_data) {
        return $database_changed;
    }else{
        return $ah_refresh_data;
    }
}

sub GetAllEntries {
    my $self = shift;

    my %db_entries_hash;
    my @db_entries_array;
    my $db_entries = $CommonVariables::database_connection->ReadEntryDatabase('Users', {});
    if($db_entries eq Constants::INTERNALERROR) {
        return Constants::INTERNALERROR;
    }
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
        'all_errors' => $CommonVariables::common_messages_collector->GetAllCommons(Constants::CMERROR),
        'all_infos' => $CommonVariables::common_messages_collector->GetAllCommons(Constants::CMINFO)
    };
    $self->ToJSON();

    $CommonVariables::common_messages_collector->ResetAllStates();

    return $self->{_data};
}

1;

__END__

=head1 BK::Frontend::ActionHandler

ActionHandler.pm

=head2 Description

Processes the Requests from the Client

=head2 Constuctor

_owner_desc - STRING owner for logging
_action - STRING action to process
_data - STRING/ARRAY data which gets processed
_proc_ac - INT if there was an recognized or relevant Action

=head2 Setter

SetActionHandler( [action - STRING], [data - STRING/ARRAY] ) - Sets ActionHandler
SetAHAction( [action - STRING] ) - Sets action in ActionHandler
SetAHData( [data - STRING/ARRAY] ) - Sets data in ActionHandler
SetProcAC( [proc_ac - INT] ) - Sets proc_ac in ActionHandler

=head2 Getter

GetActionHandler() - Gets ActionHandler
GetAHAction() - Gets action in ActionHandler
GetAHData() - Gets data in ActionHandler
GetProcAC() - Gets proc_ac in ActionHandler

=head2 Methods

ProcessAction() - Processes Action takes inforamtions from itself from aciton and data
RefreshData() - Gets Database Entries and writes them do data
SaveData() - Writes data to Database
MarkToOpenDoors() - Marks Doors to be opened in the Database
GetAllEntries() - Gets Database Entires and Returns them
ToJSON() - Convert data to JSON
FromJSON() - Converts data from JSON
PrepareWebSocketData() - Prepares data which comes from a WebSocket connection
PrepareDataToSend() - Prepares data to send, normal and websockets

=head2 Synposis

my $recv_action = ActionHandler->new( [action - STRING eg. ahrefresh], [data - STRING/ARRAY eg. NULL] );
$recv_action->FromJSON();
$recv_action->PrepareWebSocketData();
$recv_action->ProcessAction();
my $data_to_end = $recv_action->PrepareDataToSend();
$recv_action->DESTROY();
