#!/usr/bin/env perl

package ScannerMessages;

sub ScannerLogInput {
    my ($self, $log_typ, $log_string) = @_;

    print('[' . localtime . '][' . $log_typ . '] got input: ' . $log_string);
    print("\nTESTPURPOSES THIS GOES TO AN LOG FILE\n");
}

1;
