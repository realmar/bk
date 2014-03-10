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
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRCONN, $DBI::Errstr);
    return $self->{_db};
}

sub DisconnectFromDatabase {
    my $self = shift;
    $self->{_db}->disconnect
        or $self->SUPER::ThrowMessage(Constants::DB, Constants::ERROR, Constants::DBERRDISCONN, $DBI::Errstr);
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
        or $self->SUPER::ThrowMessage(Constants::DB, Constanst::ERROR, Constants::DBERRREAD, $DBI::Errstr);

    return $database_query;
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
