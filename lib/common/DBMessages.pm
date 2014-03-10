#!/usr/bin/env perl

package DBMessages;

use Switch;

sub DBError {
    my ($self, $err_typ, $error_string) = @_;

    $self->RollbackChanges();
    $self->RaiseErrCount(1);

    switch ($err_typ) {
        case Constants::DBERRCONN {
            print("Failed to Connect to Database:\n");
            last;
        }
        case Constants::DBERRDISCONN{
            print("Failed to Disconnect to Database:\n");
            last;
        }
        case Constants::DBERRREAD {
            print("Failed to Read from Database:\n");
            last;
        }
        case Constants::DBERRDELETE {
            print("Failed to Delete Entries in Database:\n");
            last;
        }
        case Constants::DBERRCOMMIT {
            print("Failed to Commit Changes in Database:\n");
            last;
        }
        case Constants::DBERRROLLBACK {
            print("Failed to Rollback Changes in Database:\n");
            last;
        }
        case default {
            print("Unknown Error:\n");
            last;
        }
    }

    print($error_string . "\n");

    return 2;
}

1;
