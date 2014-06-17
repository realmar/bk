#!/usr/bin/env perl

package DatabaseAccess;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;
use BK::Common::MessagesTextConstants;
use BK::Common::CommonMessagesCollector;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::DB,
        _db         => undef,
        _cm_id      => undef,
    };
    bless $self, $class;
    $self->{_cm_id} = $main::common_messages_collector->AddObject($self->SUPER::newcomsg());
    $self->ConnectToDatabase(shift, shift);
    return $self;
}

sub DESTROY {
    my $self = shift;

    $self->DisconnectFromDatabase();
    $self->{handle}->close() if $self->{handle};

    $main::common_messages_collector->RemoveMessageData($self->getCMID());

    return 0;
}

sub GetCMID {
    my $self = shift;
    return $self->{_cm_id};
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
        return 0;
    }
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
        return $database_query;
    }

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
        return 0;
    }

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
        return 0;
    }
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
