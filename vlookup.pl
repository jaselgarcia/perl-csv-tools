#!/usr/bin/env perl

use strict; use warnings;
use open qw( :std :encoding(utf-8) );
use Text::CSV;
use Getopt::Std;

my (	%options,
	$FS,
	$lookup_hash,
	$return_idx,
	@search_fields
);

sub usage {
	die "Usage: $0 [-d <delimiter>] [lmo] <file: lookup array> <int: field to return> <int: search criteria fields>\n";
}

# Die without stdin
die "Need to parse from stdin.\n" if -t STDIN;

# Process command line flags
&getopts('F:mlor', \%options);
$FS = $options{"F"} || ",";

# Rudimentary error checking
if ( scalar @ARGV < 3 || ! -f $ARGV[0] || $ARGV[1] !~ /^[1-9]\d*$/) {
	usage;
}

chomp (my $file = shift(@ARGV));
$return_idx = shift(@ARGV) - 1;
my $csv = Text::CSV->new ({
		binary		=> 1, 
		keep_meta_info	=> 1,
		sep		=> $FS
	});

# Read lookup file into hash
open(my $fh, '<:encoding(utf8)', $file) or die "Could not read '$file': $!\n";
while (my $line = $csv->getline($fh)) {
	my $key = shift @{$line};
	$lookup_hash->{$key} = $line;
	my $die = sprintf "Field %s doesn't exist on line %s of %s.\n", $return_idx + 1, $., $file;
	die "$die" unless exists $lookup_hash->{$key}[$return_idx];
}

foreach my $arg (@ARGV) {
	die "Invalid argument: $arg\n" unless $arg =~ /^[1-9]\d*$/;
	push @search_fields, $arg - 1;
}

# die scalar keys %{$lookup_hash};


while (<stdin>) {
	chomp(my $line = $_);

	my %values;
	my @freq;
	my $return;
	
	# Standard error checking, reused from vstack. Can probably be improved
	my ($err_code, $err_str, $err_pos) = $csv->error_diag() if !$csv->parse($line);
	$csv->parse($line) or die "Encountered error on line $. of STDIN:\t<$line>\n$err_code\t$err_str\t$err_pos\n";
	
	my @all_fields = $csv->fields();

	# Populate values with each value field
	for (my $i = 0; $i < scalar @search_fields; $i++) {
		my $search_field = $search_fields[$i];
		$values{$search_field} = $all_fields[$search_field] unless $all_fields[$search_field] eq "";
	}

	# Regex branching logic should be refactored
	foreach my $value (values %values) {
		if (defined $options{"r"}) { 
			foreach my $regex (keys %{$lookup_hash}) {
				if ($value =~ m/$regex/) {
					$return = $lookup_hash->{$regex}->[$return_idx] // undef;
					
					push @freq, $return if defined $return;
					warn "\t$regex <- $value\n";
				}
			}
		} else {

			$return = $lookup_hash->{$value}->[$return_idx] // undef;
			
			push @freq, $return if defined $return;
			warn "\t$value -> $return\n" if defined $return;
		}
	}

	# return max value
	if (defined $options{"m"}) {
		@freq = sort {$b <=> $a} @freq;
		$return = shift @freq unless $#freq < 0;
	}

	next if (defined $options{"o"} && ! defined $return);

	printf("%s%s\n", 
		defined $options{"l"} ? "$. " : "", 
		defined $return ? $return : 0);
}
