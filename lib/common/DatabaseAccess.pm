#!/usr/bin/env perl

package DatabaseAccess;

use parent -norequire, 'CommonMessages';

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => 'dbaccess',
        _db => undef,
        _msg => undef
    };
    bless $self, $class;
    $self->{_msg} = $self->SUPER::newcomsg($self->{_owner_desc}, 0);
    $self->ConnectToDatabase(shift, shift);
    return $self;
}

sub ConnectToDatabase {
    my ($self, $driver, $file) = @_;
    #  return undef if (!defined($driver) || $driver == '');
    $self->{_db} = DBI->connect('dbi:' . $driver . ':dbname=' . $file, '', '', {RaiseError => 1, AutoCommit => 0})
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRCONN, MessagesTextConstants::DBERRCONNMSG . $DBI::Errstr);
    return $self->{_db};
}

sub DisconnectFromDatabase {
    my $self = shift;
    $self->{_db}->disconnect
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRDISCONN, MessagesTextConstants::DBERRDISCONNMSG . $DBI::Errstr);
    return 1;
}

sub CreateEntryDatabase {
    my ($self, $table, $column) = @_;

    my $sql_query = 'INSERT INTO ' . $table . '(' . $column . ') VALUES(NULL)';

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute()
        or $self_>SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Cosntants::DBERRCREATE, MessagesTextConstants::DBERRCREATEMSG . $DBI::Errstr);

    return 1;
}

sub ReadEntryDatabase {
    my ($self, $table, $name_values) = @_;

    my %name_values = %{$name_values};

    my $sql_query = 'SELECT * FROM ' . $table;

    foreach $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_values_key . '="' . $name_values{$name_values_key} . '"';
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constants::DB, Constanst::ERROR, Constants::DBERRREAD, MessagesTextConstants::DBERRREADMSG . $DBI::Errstr);

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
            $sql_query .= 'SET ' . $set_values_key . '=' . $set_values_hash{$set_values_key};
            $first_set_entry = undef;
        }else{
            $sql_query .= ', ' . $set_values_key . '=' . $set_values_hash{$set_values_key};
        }
    }

    foreach my $name_values_key (keys(%name_values_hash)) {
        $sql_query .= 'WHERE ' . $name_values_key . '=' . $name_values_hash{$name_values_key};
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRUPDATE, $DBI::Errstr);

    return 1;
}

sub DeleteEntryDatabase {
    my ($self, $table, $name_values) = @_;

    my %name_values = %{$name_values};

    my $sql_query = 'DELETE FROM ' . $table;

    foreach $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_values_key . '="' . $name_values{$name_values_key} . '"';
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute()
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRDELETE, $DBI::Errstr);

    return 1;
}

sub CommitChanges {
    my $self = shift;
    $self->{_db}->commit()
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRCOMMIT, $DBI::Errstr);
    return $self->{_db};
}

sub RollbackChanges {
    my $self = shift;
    $self->{_db}->rollback()
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRROLLBACK, $DBI::Errstr);
    return $self->{_db};
}

1;
