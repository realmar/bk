#!/usr/bin/env perl

package ScannerMessages;

sub ScannerLogInput {
    my ($self, $owner_typ, $msg_prio, $log_typ, $log_string) = @_;

    $main::filehandle_log_message->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $log_typ, $log_string));
}

1;
