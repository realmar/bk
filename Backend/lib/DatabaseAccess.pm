#!/usr/bin/env perl

sub new {
    my $class = shift;
    my $self = {
        _db => shift
    };
    bless $self, $class;
    return $self;
}

sub ConnectToDatabase {
    my ($self) = @_;

    return $self->{_db};
}

sub DisconnectFromDatabase {
    my $self = shift;
    $self->{_db}->disconnect;
    return 1;
}

sub ReadEntryDatabase {
    my ($self, $table, $nameValues);

    my %nameValues = %{$nameValues};

    my $SQLQuery = 'SELECT * FROM ' . $table . ' WHERE ' . keys(%nameValues)[0] . '=' . $nameValues[0];

    my $databaseQuery = $self->{_db}->prepare($SQLQuery);
    $databaseQuery->execute();

    return $databaseQuery;
}

sub DeleteEntryDatabase {
    my ($self, $table, $nameValues);

    my %nameValues = %{$nameValues};

    my $SQLQuery = 'DELETE FROM ' . $table . ' WHERE ' . keys(%nameValues)[0] . '=' . $nameValues[0];

    my $databaseQuery = $self->{_db}->prepare($SQLQuery);
    $databaseQuery->execute();

    return 1;
}

1;
