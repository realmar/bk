#!/usr/bin/env perl

package DatabaseAccess;

use parent -norequire, 'CommonMessages';

use BK::Common::Constants;
use BK::Common::MessagesTextConstants;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => Constants::DB,
        _db => undef,
        _is_ext_locked => undef,
        _msg => undef
    };
    bless $self, $class;
    $self->SUPER::newcomsg();
    $self->ConnectToDatabase(shift, shift);
    return $self;
}

sub DESTROY {
    my $self = shift;

    $self->DisconnectFromDatabase();
    $self->{handle}->close() if $self->{handle};
}

sub SetIsExtLocked {
    my ($self, $value) = @_;
    $self->{_is_ext_locked} = $value;
    return $self->{_is_ext_locked};
}

sub GetIsExtLocked {
    $self = shift;
    return $self->{_is_ext_locked};
}

sub ConnectToDatabase {
    my ($self, $driver, $file) = @_;
    #  return undef if (!defined($driver) || $driver == '');
    $self->{_db} = DBI->connect('dbi:' . $driver . ':dbname=' . $file, '', '', {RaiseError => 1, AutoCommit => 0})
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCONN, MessagesTextConstants::DBERRCONNMSG . $DBI::Errstr);
    return $self->{_db};
}

sub DisconnectFromDatabase {
    my $self = shift;
    $self->{_db}->disconnect
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRDISCONN, MessagesTextConstants::DBERRDISCONNMSG . $DBI::Errstr);
    $self->{_db};
}

##  --
##  CreateEntryDatabase currenlty not in use

sub CreateEntryDatabase {
    my ($self, $table, $column) = @_;

    my $sql_query = 'INSERT INTO ' . $table . '(' . $column . ') VALUES(NULL)';

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCREATE, MessagesTextConstants::DBERRCREATEMSG . $DBI::Errstr);

    $self->{_db};
}

sub ReadEntryDatabase {
    my ($self, $table, $name_values) = @_;

    my %name_values = %{$name_values};

    my $sql_query = 'SELECT * FROM ' . $table;

    foreach my $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_values_key . '="' . $name_values{$name_values_key} . '"';
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constanst::ERROR, Constants::DBERRREAD, MessagesTextConstants::DBERRREADMSG . $DBI::Errstr);

    return $database_query;
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
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRUPDATE, MessagesTextConstants::DBERRUPDATEMSG . $DBI::Errstr);

    return $self->{_db};
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
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRDELETE, MessagesTextConstants::DBERRDELETEMSG . $DBI::Errstr);

    return $self->{_db};
}

sub CommitChanges {
    my $self = shift;
    $self->{_db}->commit()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRCOMMIT, MessagesTextConstants::DBERRCOMMITMSG . $DBI::Errstr);
    return $self->{_db};
}

sub RollbackChanges {
    my $self = shift;
    $self->{_db}->rollback()
        or $self->SUPER::ThrowMessage(Constants::ERROR, Constants::DBERRROLLBACK, MessagesTextConstants::DBERRROLLBACKMSG . $DBI::Errstr);
    return $self->{_db};
}

sub LockTables {
    my $self = shift;
    if($self->{_db}->do(Constants::DBLOCK)) {
        $self->{_is_ext_locked} = undef;
    }else{
        $self->{_is_ext_locked} = 2;
    }
    return $self->{_is_ext_locked};
}

sub UnlockTables {
    my $self = shift;
    if($self->{_db}->do(Constants::DBUNLOCK)) {
        $self->{_is_ext_locked} = undef;
    }else{
        $self->{_is_ext_locked} = 2;
    }
    return $self->{_is_ext_locked};
}

1;
