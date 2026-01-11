#!/usr/bin/env perl

use strict; use warnings;
use open qw( :std :encoding(utf-8) );
use Text::CSV;

# Simple script for substituting embedded new lines with first argument.
# Subsequent args can be any number of legitimate files.
# Return concatenated stream. Very simple error checking currently.

my $csv = Text::CSV-> new({ binary => 1, keep_meta_info => 1 });
my $sep = $csv->sep;
my $sub;

# Simple error checking. Can implement 'usage' subroutine.
if (@ARGV > 1) {
	$sub = shift @ARGV unless (-f $ARGV[0]);
}

$sub = " " unless (defined($sub));

while (my $file = shift @ARGV) {
	open my $fh, '<:encoding(utf8)', $file or warn "$file: $!";

	while (my $row = $csv->getline($fh)) {
		for (my $i = 0; $i < scalar (@$row); $i++) {
			my $field = $row->[$i];
			$field =~ s/[\n\r]+/$sub/g;
			$field =~ s/"/''/g;
			print $field =~ m/.*$sep+.*/ ? "\"$field\"" : "$field";
			print $sep unless $i == scalar(@$row) - 1; 
		}

		print "\n";
	}
}
