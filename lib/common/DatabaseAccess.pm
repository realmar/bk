#!/usr/bin/env perl

package DatabaseAccess;

sub new {
    my $class = shift;
    my $self = {
        _db => ConnectToDatabase(shift, shift)
    };
    bless $self, $class;
    return $self;
}

sub ConnectToDatabase {
    my ($self, $driver, $file) = @_;
    return undef if !defined($driver) || $driver == '';
    $self->{_db} = DBI->connect('dbi:' . $driver . ':dbname=' . $file, '', '');
    return $self->{_db};
}

sub DisconnectFromDatabase {
    my $self = shift;
    $self->{_db}->disconnect;
    return 1;
}

sub ReadEntryDatabase {
    my ($self, $table, $name_values);

    my %name_values = %{$name_values};

    my $sql_query = 'SELECT * FROM ' . $table;

    foreach $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_values_key . '=' . $name_values{$name_values_key};
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute();

    return $database_query;
}

sub DeleteEntryDatabase {
    my ($self, $table, $name_values);

    my %name_values = %{$name_values};

    my $sql_query = 'DELETE FROM ' . $table;

    foreach $name_values_key (keys(%name_values)) {
        $sql_query .= ' WHERE ' . $name_valuesx_key . '=' . $name_values{$name_values_key};
    }

    my $database_query = $self->{_db}->prepare($sql_query);
    $database_query->execute();

    return 1;
}

1;
