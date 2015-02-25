#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package ActionHandler;

use 5.010;
use strict;
use warnings;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;
use BK::Common::CommonMessagesCollector;
use BK::Common::CommonVariables;
use BK::Handler::DatabaseAccess;

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

    return 1;
}

sub GetAHAction {
    my $self = shift;
    return $self->{_action};
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

    if($self->{_action} eq Constants::AHREFRESH) {
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHREFRESH, Constants::AHREFRESH);
        if($self->RefreshData() eq Constants::AHREFRESH) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRREFRESHDATA, MessagesTextConstants::AHERRREFRESHDATAMSG);
        }
    }elsif($self->{_action} eq Constants::AHSAVEDATA) {
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
    }elsif($self->{_action} eq Constants::AHOPENDOORS) {
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHOPENDOORS, $self->{_data});
        $self->FromJSON();
        my $sav_data_response = $self->RequestOpenDoors();
        if($sav_data_response eq Constants::INTERNALERROR) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRSAVEDATA, MessagesTextConstants::AHERRSAVEDATAMSG);
        }elsif($sav_data_response eq Constants::AHERROPENDOORS) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERROPENDOORS, MessagesTextConstants::AHERROPENDOORSMSG);
        }elsif($sav_data_response eq Constants::AHREFRESH) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRREFRESHDATA, MessagesTextConstants::AHERRREFRESHDATAMSG);
        }else{
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSUCCOPENDOORS, MessagesTextConstants::AHOPENDOORSMSG);
        }
    }elsif($self->{_action} eq Constants::AHUSERINPUT) {
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHUSERINPUT, $self->{_data});
        $self->FromJSON();
        my $sav_data_response = $self->RequestOpenDoors();
        if($sav_data_response eq Constants::INTERNALERROR) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRSAVEDATA, MessagesTextConstants::AHERRSAVEDATAMSG);
        }elsif($sav_data_response eq Constants::AHERROPENDOORS) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRUSERINPUT, MessagesTextConstants::AHERRUSERINPUTMSG);
        }elsif($sav_data_response eq Constants::AHREFRESH) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHERRREFRESHDATA, MessagesTextConstants::AHERRREFRESHDATAMSG);
        }
    }elsif($self->{_action} eq Constants::AHKEEPALIVE) {
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHKEEPALIVE, $self->{_action});
        $self->SetProcAC(1);
    }else{
        $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHUNKNOWNACTION, $self->{_action});
        $self->SetProcAC(1);
        last;
    }

    return 1;
}

sub RefreshData {
    my $self = shift;

    $self->{_data} = $self->GetAllEntries();
    if($self->{_data} eq Constants::INTERNALERROR) {
        return Constants::AHREFRESH;
    }

    return 1;
}

sub SaveData {
    my $self = shift;

    my $database_changed = 0;

    for(my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        $self->{_data}->[$i] = lc($self->{_data}->[$i]);
    }


    $CommonVariables::database_connection->BeginWork();

    for (my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        if($self->{_data}->[$i] eq Constants::AHNOTCHANGED) {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDIDEN);
        }elsif($self->{_data}->[$i] eq '') {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDDEL);
            if(!$CommonVariables::database_connection->UpdateEntryDatabase('Users', {'username' => 'null'}, {'doornumber' => $i})) {
                return Constants::INTERNALERROR;
            }
            $database_changed = 1;
        }else{
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATAWRITE, MessagesTextConstants::AHSDNEW);
            if(!$CommonVariables::database_connection->UpdateEntryDatabase('Users', {'username' => $self->{_data}[$i]}, {'doornumber' => $i})) {
                return Constants::INTERNALERROR;
            }
            $database_changed = 1;
        }
    }

    $CommonVariables::database_connection->CommitChanges();

    my $ah_refresh_data = $self->RefreshData();
    if($ah_refresh_data eq Constants::AHREFRESH) {
        return $ah_refresh_data;
    }else{
        return $database_changed;
    }
}

sub RequestOpenDoors {
    my $self = shift;

    my $database_changed = 0;
    my $open_all_doors = 1;

    my %users = {};

    for(my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        if($self->{_data}[$i]->{Constants::OPENDOOR} == Constants::FALSE) {
            $open_all_doors = 0;
        }
        $users{$self->{_data}[$i]->{user}} = 0;
    }

    if($open_all_doors && scalar(@{$self->{_data}}) != Constants::DOORCOUNT) {
        $open_all_doors = 0;
    }

    my $opened_all_doors = 0;
    my $doors_open;

    for(my $i = 0; $i < scalar(@{$self->{_data}}); $i++) {
        if($self->{_data}[$i]->{Constants::OPENDOOR} == Constants::TRUE) {
            if($self->{_data}[$i]->{user} ne Constants::DOORSUSER) {
                if(!$users{$self->{_data}[$i]->{user}}) {
                    my @fetched_doors = [];
                    my $database_entries = $CommonVariables::database_connection->ReadEntryDatabase('Users', {'username' => $self->{_data}[$i]->{user}});
                    while(my $database_entries_row = $database_entries->fetchrow_hashref) {
                        push(@fetched_doors, $database_entries_row->{doornumber});
                    }
                    $doors_open = $CommonVariables::doors->OpenDoor(@fetched_doors, $self->{_data}[$i]->{user});
                    if($doors_open) {
                        ##  $CommonVariables::database_connection->BeginWork();
                        ##  if(!$CommonVariables::database_connection->UpdateEntryDatabase('Users', {'username' => 'null'}, {'doornumber' => $database_entries_row->{doornumber}})) {
                        ##      $database_changed = Constants::INTERNALERROR;
                        ##  }
                        ##  $CommonVariables::database_connection->CommitChanges();
                        $CommonVariables::email_handler->SendEMail($self->{_data}[$i]->{user}, @fetched_doors);
                    }else{
                        $database_changed = Constants::AHERROPENDOORS;
                    }
                    $users{$self->{_data}[$i]->{user}} = 1;
                    $doors_open = undef;
                }
            }else{
                if($open_all_doors) {
                    if(!$opened_all_doors) {
                        $opened_all_doors = 1;
                        $doors_open = $CommonVariables::doors->OpenDoor(Constants::DOORCOUNT, $self->{_data}[$i]->{user});
                        if(!$doors_open) {
                            $database_changed = Constants::AHERROPENDOORS;
                        }
                    }
                }else{
                    $doors_open = $CommonVariables::doors->OpenDoor($i, $self->{_data}[$i]->{user});
                    if(!$doors_open) {
                        $database_changed = Constants::AHERROPENDOORS;
                    }
                }
                $doors_open = undef;
            }
        }
    }

    my $ah_refresh_data = $self->RefreshData();
    if($ah_refresh_data eq Constants::AHREFRESH) {
        return $ah_refresh_data;
    }else{
        return $database_changed;
    }
}

sub GetAllEntries {
    my $self = shift;

    my %db_entries_hash;
    my @db_entries_array;
    my $db_entries = $CommonVariables::database_connection->ReadEntryDatabase('Users', {});
    if(!$db_entries) {
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

=head1 BK::Handler::ActionHandler

ActionHandler.pm

=head2 Description

Processes the Requests from the Client

=head2 Constuctor

_owner_desc - STRING owner for logging
_action - STRING action to process
_data - STRING/ARRAY data which gets processed
_proc_ac - INT if there was an recognized or relevant Action

=head2 Setter

SetProcAC( [proc_ac - INT] ) - Sets proc_ac in ActionHandler

=head2 Getter

GetAHAction() - Gets action in ActionHandler
GetProcAC() - Gets proc_ac in ActionHandler

=head2 Methods

ProcessAction() - Processes Action takes inforamtions from itself from aciton and data
RefreshData() - Gets Database Entries and writes them do data
SaveData() - Writes data to Database
RequestOpenDoors() - Opens Doors
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
