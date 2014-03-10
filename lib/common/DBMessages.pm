#!/usr/bin/env perl

package DBMessages;

use Switch;

sub DBError {
    my ($self, $owner_typ, $msg_prio, $err_typ, $error_string) = @_;

    $self->RollbackChanges();
    $self->RaiseErrCount(1);

    switch ($err_typ) {
        case Constants::DBERRCONN {
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Failed to Connect to Database: ' . $error_string));
            last;
        }
        case Constants::DBERRDISCONN{
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Failed to Disconnect from Database: ' . $error_string));
            last;
        }
        case Constants::DBERRREAD {
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Failed to Read from Database: ' . $error_string));
            last;
        }
        case Constants::DBERRDELETE {
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Failed to Delete Entries from Database: ' . $error_string));
            last;
        }
        case Constants::DBERRCOMMIT {
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Failed to Commit Changes to Database: ' . $error_string));
            last;
        }
        case Constants::DBERRROLLBACK {
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Failed to Rollback Changes to Database: ' . $error_string));
            last;
        }
        case default {
            $main::filehandle_log_error->WriteToFile(CommonMessages::CreateLogString($owner_typ, $msg_prio, $err_typ, 'Unknown Error: ' . $error_string));
            last;
        }
    }

    return 2;
}

1;
