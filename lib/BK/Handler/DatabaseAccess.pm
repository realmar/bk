#!/usr/bin/env perl

#########################################################
##  Project Name:     BuecherkastenBibliothek BK
##  Author:           Anastassios Martakos
##  Language:         English / Perl
##  Created For / At: ETH Zuerich Department Physics
#########################################################

package DatabaseAccess;

use 5.010;
use strict;
use warnings;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;
use BK::Handler::MessagesTextConstants;
use BK::Common::CommonMessagesCollector;

use DBI;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::DB,
        _db         => undef
    };
    bless $self, $class;
    $self->ConnectToDatabase(shift, shift);
    return $self;
}

sub DESTROY {
    my $self = shift;

    $self->DisconnectFromDatabase();
    $self->{handle}->close() if $self->{handle};

    return 0;
}

sub ConnectToDatabase {
    my ($self, $driver, $file) = @_;
    #  return undef if (!defined($driver) || $driver == '');
    $self->{_db} = DBI->connect('dbi:' . $driver . ':dbname=' . $file, '', '', {PrintError => 1, RaiseError => 1, AutoCommit => 1})
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCONN, MessagesTextConstants::DBERRCONNMSG . $self->{_db}->errstr);
    $self->{_db}->{HandleError} = sub{ return 0; };
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBCONN, MessagesTextConstants::DBCONNMSG);
    return $self->{_db};
}

sub DisconnectFromDatabase {
    my $self = shift;
    $self->{_db}->disconnect
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRDISCONN, MessagesTextConstants::DBERRDISCONNMSG . $self->{_db}->errstr);
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBDISCONN, MessagesTextConstants::DBDISCONNMSG);
    $self->{_db};
    return 0;
}

##  --
##  CreateEntryDatabase currenlty not in use

sub CreateEntryDatabase {
    my ($self, $table, $column) = @_;

    my $sql_query = 'INSERT INTO ' . $table . '(' . $column . ') VALUES(NULL)';

    my $database_query = $self->{_db}->prepare($sql_query);
    if(!$database_query->execute()) {
        for(0..Constants::DBRETRIES) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCREATE, MessagesTextConstants::DBERRCREATEMSG . $self->{_db}->errstr);
            sleep(Constanst::DBRETRIESTIME);
            if($database_query->execute()) {
                $self->SUPER::ThrowMessage(Constanst::LOG, Constanst::DBCREATE, $sql_query);
                return 0;
            }
        }
    }else{
        $self->SUPER::ThrowMessage(Constanst::LOG, Constanst::DBCREATE, $sql_query);
        return 0;
    }

    $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCREATE, MessagesTextConstants::DBERRCREATEMSG . $self->{_db}->errstr);

    return Constants::INTERNALERROR;
}

sub ReadEntryDatabase {
    my ($self, $table, $name_values) = @_;

    my %name_values = %{$name_values};

    my $sql_query = 'SELECT * FROM ' . $table;

    foreach my $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_values_key . '="' . $name_values{$name_values_key} . '"';
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    if(!$database_query->execute()) {
        db_retries : for(0..Constants::DBRETRIES) {
            $self->SUPER::ThrowMessage(Constanst::ERROR, Constants::DBERRREAD, MessagesTextConstants::DBERRREADMSG . $self->{_db}->errstr);
            sleep(Constanst::DBRETRIESTIME);
            if($database_query->execute()) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBREAD, $sql_query);
                return $database_query;
            }
        }
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBREAD, $sql_query);
        return $database_query;
    }

    $self->SUPER::ThrowMessage(Constanst::ERROR, Constants::DBERRREAD, MessagesTextConstants::DBERRREADMSG . $self->{_db}->errstr);

    return Constants::INTERNALERROR;
}

sub UpdateEntryDatabase {
    my ($self, $table, $set_values, $name_values) = @_;

    my %set_values_hash = %{$set_values};
    my %name_values_hash = %{$name_values};

    my $sql_query = 'UPDATE ' . $table;

    my $first_set_entry = 2;

    foreach my $set_values_key (keys(%set_values_hash)) {
        if(defined($first_set_entry)) {
            if($set_values_hash{$set_values_key} ne 'null') {
                $sql_query .= ' SET ' . $set_values_key . '="' . $set_values_hash{$set_values_key} . '"';
            }else{
                $sql_query .= ' SET ' . $set_values_key . '=' . $set_values_hash{$set_values_key};
            }
            $first_set_entry = undef;
        }else{
            if($set_values_hash{$set_values_key} ne 'null') {
                $sql_query .= ', ' . $set_values_key . '="' . $set_values_hash{$set_values_key} . '"';
            }else{
                $sql_query .= ', ' . $set_values_key . '=' . $set_values_hash{$set_values_key};
            }
        }
    }

    foreach my $name_values_key (keys(%name_values_hash)) {
        $sql_query .= ' WHERE ' . $name_values_key . '=' . $name_values_hash{$name_values_key};
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    if(!$database_query->execute()) {
        db_retries : for(0..Constants::DBRETRIES) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRUPDATE, MessagesTextConstants::DBERRUPDATEMSG . $self->{_db}->errstr);
            sleep(Constanst::DBRETRIESTIME);
            if($database_query->execute()) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBUPDATE, $sql_query);
                return 0;
            }
        }
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBUPDATE, $sql_query);
        return 0;
    }

    $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRUPDATE, MessagesTextConstants::DBERRUPDATEMSG . $self->{_db}->errstr);

    return Constants::INTERNALERROR;
}

##  --
##  DeleteEntryDatabase currenlty not in use

sub DeleteEntryDatabase {
    my ($self, $table, $name_values) = @_;

    my %name_values = %{$name_values};

    my $sql_query = 'DELETE FROM ' . $table;

    foreach $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_values_key . '="' . $name_values{$name_values_key} . '"';
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    if(!$database_query->execute()) {
        db_retries : for(0..Constants::DBRETRIES) {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRDELETE, MessagesTextConstants::DBERRDELETEMSG . $self->{_db}->errstr);
            sleep(Constanst::DBRETRIESTIME);
            if($database_query->execute()) {
                $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBDELETE, $sql_query);
                return 0;
            }
        }
    }else{
        $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBDELETE, $sql_query);
        return 0;
    }

    $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRDELETE, MessagesTextConstants::DBERRDELETEMSG . $self->{_db}->errstr);

    return Constants::INTERNALERROR;
}

sub BeginWork {
    my $self = shift;
    $self->{_db}->begin_work()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRBEGINWORK, Constants::DBERRBEGINWORKMSG . $self->{_db}->errstr);
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBBEGINWORK, MessagesTextConstants::DBBEGINWORKMSG);
    return $self->{_db};
}

sub CommitChanges {
    my $self = shift;
    $self->{_db}->commit()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCOMMIT, MessagesTextConstants::DBERRCOMMITMSG . $self->{_db}->errstr);
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBCOMMIT, MessagesTextConstants::DBCOMMITMSG);
    return $self->{_db};
}

sub RollbackChanges {
    my $self = shift;
    $self->{_db}->rollback()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRROLLBACK, MessagesTextConstants::DBERRROLLBACKMSG . $self->{_db}->errstr);
    $self->SUPER::ThrowMessage(Constants::LOG, Constants::DBROLLBACK, MessagesTextConstants::DBROLLBACKMSG);
    return $self->{_db};
}

1;

__END__

=head1 BK::Common::DatabaseAccess

DatabaseAccess.pm

=head2 Description

Handles all Database Accesses
Works with DBI and DBD

=head2 Constructor

_owner_desc - STRING owner for logging
_db - DBI Database Handler

=head2 Setter

ConnectToDatabase( [driver - STRING], [file - STRING] ) - Connect to a SQLite Database
DisconnectFromDatabase() - Disconnect from a SQLite Database

=head2 Getter

None

=head2 Methods

CreateEntryDatabase( [table - STRING], [column - STRING] ) - Creates a new NULL Entry in the Database
ReadEntryDatabase( [table - STRING], [name_values - HASH] ) - Returns the result of the Database Query, name_values is WHERE key=value in SQL Query
UpdateEntryDatabase( [table - STRING], [set_values - HASH], [name_values - HASH] ) - Update Database with the given arguments, set_values is SET key=value, name_values is WHERE key=value in SQL Query
DeleteEntryDatabase( [table - STRING], [name_values - HASH] ) - Deletes an Entry in the Database, name_values is WHERE key=value
BeginWork() - Starts a Transaction in the Database
CommitChanges() - Stops / Commits a Transaction in the Database
RollbackChanges() - Undo changes in the current Transaction

=head2 Synposis

my $database_connection = DatabaseAccess->new( [driver - STRING eg. SQLite], [file - STRING eg. database.db] );
$database_connection->CreateEntryDatabase( [table - STRING eg. Users], [column - STRING eg. username] );
$database_connection->ReadEntryDatabase( [table - STRING eg. Users], [name_values - HASH eg. { username => 'testtest' }] );
$database_connection->UpdateEntryDatabase( [table - STRING eg. Users], [set_values - HASH eg. { username => 'testtest' }], [name_values - HASH eg. { doornumber => 4 }] );
$database_connection->DeleteEntryDatabase( [table - STRING eg. Users], [name_values - HASH eg. { username => 'testtest' }] );
$database_connection->BeginWork();
$database_connection->CommitChanges();
$database_connection->RollbackChanges();
$database_connection->DisconnectFromDatabase();
