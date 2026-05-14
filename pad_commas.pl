#!/usr/bin/env perl

use strict; use warnings;
use open qw( :std :encoding(utf-8) );
use Text::CSV;
use Getopt::Std;

# Perl implementation of the pad_commas awk prototype.
# Requires two passes, first to find max number of fields
# then pad any lines that fall short with delims.

my (
	%options,
	$FS,
	$max,
	$input
);

# Die without stdin
die "Need to parse from stdin.\n" if -t STDIN;

# Process command line flags
&getopts('F:', \%options);
$FS = $options{"F"} || ",";

$max = 0;
my $csv = Text::CSV-> new({
		binary 		=> 1, 
		keep_meta_info	=> 1,
		sep_char 	=> $FS
	});

# Read input into array of arrays
while (<STDIN>) {
	chomp $_;

	my ($err_code, $err_str, $err_pos) = $csv->error_diag() if !$csv->parse($_);
	$csv->parse($_) or die "Encountered error on line $. of STDIN\n<$_>\n$err_code\n$err_str\n$err_pos\n";

	my @record = $csv->fields();

	for (my $i = 0; $i < scalar @record; $i++) {
		$record[$i] = "\"$record[$i]\"" if $csv->is_quoted($i);	
	}
	
	push @{$input}, \@record;
}

foreach my $record (@{$input}) {
	my $NF = scalar @{$record};
	$max = $NF > $max ? $NF : $max;
}

foreach my $record (@{$input}) {
	my $NF = scalar @{$record};

	printf "%s", join $FS, @{$record};
	for (my $i = 0; $i < $max - $NF; $i++) {
		print $FS;
	}
	
	print "\n";
}
