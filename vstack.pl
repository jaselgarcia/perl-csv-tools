#!/usr/bin/env perl 

use strict; use warnings;
use Text::CSV;
use Getopt::Std;

# Script simply returns specified columns of each row in new-line delimited list.
# Currently only accepts stdin. Will refactor to make more robust in future.
# Can return only unique values per row with -u flag.

# Die without stdin
die "Need to parse from stdin.\n" if -t STDIN;

# Process command line flags
my %options;
&getopts('ud:', \%options);

my $delim = $options{"d"} || "\n";

# Rudimentary error checking on command line args.
my @requested_fields;
foreach my $arg (@ARGV) {
	die "Invalid argument: $arg\n" unless $arg =~ /^[1-9]\d*$/;
	push @requested_fields, $arg;
}

my $csv = Text::CSV-> new({binary => 1, keep_meta_info=>1});
my $line_no = 1;

while (<STDIN>) {
	chomp (my $line = $_);
	my ($err_code, $err_str, $err_pos) = $csv->error_diag() if !$csv->parse($line);
	$csv->parse($line) or die "Encountered error on line $line_no of STDIN:\t<$line>\n$err_code\t$err_str\t$err_pos\n";

	# Print all fields by default unless requested fields set. Very verbose.
	my @all_fields = $csv->fields();
	my @fields;
	if (@requested_fields) {
		foreach my $idx (@requested_fields) {
			die "Field $idx doesn't exist.\n" unless defined $all_fields[$idx - 1];
			$all_fields[$idx - 1] = "\"$all_fields[$idx - 1]\"" if $csv->is_quoted($idx - 1);
			push @fields, $all_fields[$idx - 1];
		}
	} else {
		for (my $i = 0; $i < @all_fields; $i++) {
			$all_fields[$i] = "\"$all_fields[$i]\"" if $csv->is_quoted($i);	
			push @fields, $all_fields[$i];
		}
	}	

	# Print unique fields per record if flag set. Need to make more elegant.
	for (my $i = 0; $i < @fields; $i++) {
		my $curr_field = $fields[$i];

		if (defined($options{"u"})) {
			my $match = 0;
			for (my $j = $#fields; $j > $i; $j--) {
				$match = 1 if $curr_field eq $fields[$j];
			}
			unless ($match) {
				print "$curr_field"; 
				print $i == $#fields  ? "\n" : "$delim";
			}
		} else {
			print "$curr_field";
			print $i == $#fields ? "\n" : "$delim";
		}
	}

	$line_no++;
}
