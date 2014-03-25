#!/usr/bin/env perl

package ActionHandler;

use parent -norequire, 'CommonMessages';

use Switch;

sub new {
    my $class = shift;
    my $self = {
        _owner_desc => 'actionhandler',
        _action     => shift,
        _data       => shift,
        _msg        => undef
    };
    bless $self, $class;
    return $self;
}

sub SetAction {
    my ($self, $action, $data) = @_;
    if(defined($action) && defined($data)) {
        $self->{_action} = $action;
        $self->{_data}   = $data;
    }
    return $self;
}

sub GetAction {
    my $self = shift;
    return {
        'action' => $self->{_action},
        'data'   => $self->{_data}
    };
}

sub ProcessAction {
    my $self = shift;
    switch ($self->{_action}) {
        case Constants::AHREFRESH {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHREFRESH, Constants::AHREFRESH);
            $self->RefreshData();
            last;
        }
        case Constants::AHSAVEDATA {
            $self->SUPER::ThrowMessage(Constants::LOG, Constants::AHSAVEDATA, $self->{_data});
            $self->SaveData();
            last;
        }
        else {
            $self->SUPER::ThrowMessage(Constants::ERROR, Constants::AHUNKNOWNACTION, $self->{_action});
            last;
        }
    }

    return $self;
}

sub RefreshData {
}

sub SaveData {
}

1;
