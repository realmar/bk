#!/usr/bin/env perl

package CommonMessages;

use Switch;

use BK::Common::Constants;
use BK::Common::DatabaseAccess;

sub newcomsg {
    my $self = shift;
    my $err = {
        _owner_obj                          => $self,
        "_" . Constants::CMERROR . "_type"  => '',
        "_" . Constants::CMERROR . "_msg"   => '',
        "_" . Constants::CMINFO . "_type"   => '',
        "_" . Constants::CMINFO . "_msg"    => '',
        "_" . Constants::CMERROR . "_count" => 0,
        "_" . Constants::CMINFO . "_count"  => 0
    };
    bless $err;
    return $err;
}

sub SetCommonType {
    my ($self, $data_type, $type) = @_;
    $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_type"} = $type if defined($type);
    return $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_type"};
}

sub SetCommonMSG {
    my ($self, $data_type, $msg) = @_;
    $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_msg"} = $msg if defined($msg);
    return $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_msg"};
}

sub GetCommonType {
    my ($self, $data_type) = @_;
    return $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_type"};
}

sub GetCommonMSG {
    my ($self, $data_type) = @_;
    return $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_msg"};
}

sub InitCoMSG {
    my $self = shift;
    $main::common_messages_collector->GetObject($self->GetCMID())->{_error_type} = '';
    $main::common_messages_collector->GetObject($self->GetCMID())->{_error_msg} = '';
    $main::common_messages_collector->GetObject($self->GetCMID())->{_msg_type} = '';
    $main::common_messages_collector->GetObject($self->GetCMID())->{_msg_msg} = '';
    $main::common_messages_collector->GetObject($self->GetCMID())->{_error_count} = 0;
    $main::common_messages_collector->GetObject($self->GetCMID())->{_info_count} = 0;
    return;
}

sub RaiseCommonCount {
    my ($self, $data_type, $raise_count) = @_;
    $main::common_messages_collector->GetObject($self->GetCMID())->{"_" . $data_type . "_count"} += $raise_count;
    return;
}

sub ThrowMessage {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;

    switch ($msg_prio) {
        case Constants::ERROR {
            $self->SetErrorType($msg_type);
            $self->SetErrorMSG($msg_string);
            $self->LogError($msg_prio, $msg_typ, $msg_string);
            last;
        }
        case Constants::LOG {
            $self->LogMessage($msg_prio, $msg_typ, $msg_string);
            last;
        }
    }

    return $self->{_msg};
}

sub CreateLogString {
    my ($owner_typ, $msg_prio, $msg_typ, $msg_string) = @_;
    return '[' . localtime . '][' . $owner_typ . '][' . $msg_prio . '][' . $msg_typ . '] ' . $msg_string . "\n";
}

sub LogError {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;

    if($self->{_owner_desc} eq Constants::DB) {
        $self->RollbackChanges();
    }
    $self->RaiseErrCount(1);
    $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));

    return $self;
}

sub LogMessage {
    my ($self, $msg_prio, $msg_typ, $msg_string) = @_;
    $main::filehandle_log_message->WriteToFile(CommonMessages::CreateLogString($self->{_owner_desc}, $msg_prio, $msg_typ, $msg_string));
    return $self;
}

1;
