#!/usr/bin/env perl

use strict; use warnings;
use Text::CSV;

# Simple script for substituting embedded new lines with first argument.
# Subsequent args can be any number of legitimate files.
# Return concatenated stream. Will implement error checking later.

my $csv = Text::CSV-> new({ binary => 1, keep_meta_info => 1 });

# Need simple error checking for number of arguments.
# If one, needs to be file; if more, first can be file or legitmate replacement string.
my $sub_chr = shift @ARGV;

# Potentially wrap script in loop in order to process multiple files.
my $file = shift @ARGV;
open my $fh, '<:encoding(utf8)', $file or die "$file: $!";

while (my $row = $csv->getline($fh)) {
	# Add translate and squashing multiple new lines
	foreach my $field (@$row) {
		print $field =~ m/.*[,].*/ ? "\"$field\"," : "$field,";
	}

	print "\n";
}
