#!/usr/bin/perl

use warnings;
use strict;

my $options;   # A string for all of the '-' options
my $verbosity; # How much information should we output?
my $log = "";  # A string for a log of the rolls made
my $mode = "add";
my $total = 0;

sub parseargs {
    foreach my $arg (@ARGV) {
        $options = $options . $arg if $arg =~ /^-[A-CE-Za-ce-z]/;
        # Not capturing options starting with 'd' or 'D' because of the
        # possibility of "minus-dee-six" input
    }
}

sub roll {
    # Return value.
    my @list = {};

    my $numdice = $_[0];
    my $numsides = $_[1];
    
    # Append the die roll, in XdY notation, to the log.
    $log = $log . $numdice . "d" . $numsides . "=";

    if ($numdice == 0 || $numsides == 0) {
        return @list;
    }

    # Roll the dice. For every die rolled, update the log.
    for my $i (1..$numdice) {
        my $roll = 1 + int rand $numsides;
        $list[$i] = $roll;
    }


    for my $roll (@list) {
        $log = $log . $roll . "+"; 
        if ($mode eq "subtract") {
            $total += $list[$i] * -1;
        } else {
            $total += $list[$i];
        }
    }

    # Strip any trailing '+' signs, append the sum of the roll to the log,
    # and end with a newline. 
    $log =~ s/(.*)\+$/$1=$total\n/;

    return @list;
}

parseargs();
roll($ARGV[0], $ARGV[1]);

print $log . "\n";
