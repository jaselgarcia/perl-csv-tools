#!/usr/bin/env perl

use strict; use warnings;
use Text::CSV;

# Script simply returns specified columns of each row in new-line delimited list.
# Currently only accepts single file and list of rows to stack.
# Will refactor to make more robust in future.
# Row numbers are currently 0-based.

my $csv = Text::CSV-> new({binary => 1});
my $file = shift(@ARGV);

open my $fh, "<:encoding(utf8)", $file or die "$file: $!";

while (my $row = $csv->getline ($fh)) {
	foreach my $arg (@ARGV) {
		print "$row->[$arg]\n";
	}
}
