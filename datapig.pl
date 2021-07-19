#!/usr/bin/perl -w

# datapig
# parses `nm` output to list largest data/bss symbols, in spirit of old Apple-internal tool
# author: Matt Jacobson

use strict;

my %addrs = ();
my %types = ();
my $last_addr = 0;
my $last_name = "???";
my %sizes = ();

while (<>) {
	if (/^([0-9A-Fa-f]+) ([A-Za-z]) (.*)$/) {
		my $addr = hex($1);
		my $type = $2;
		my $name = $3;

		$addrs{$name} = $addr;
		$types{$name} = $type;
	}
}

foreach my $name (sort { $addrs{$a} <=> $addrs{$b} } keys %addrs) {
	my $addr = $addrs{$name};

	if ($last_addr != 0) {
		$sizes{$last_name} = $addr - $last_addr;
	}

	$last_addr = $addr;
	$last_name = $name;

	# printf("%8x %s\n", $addr, $name);
}

foreach my $name (sort { $sizes{$b} <=> $sizes{$a} } keys %sizes) {
	my $type = $types{$name};

	if ($type eq "d" || $type eq "D" || $type eq "b" || $type eq "B") {
		printf("%8x %s\n", $sizes{$name}, $name);
	}
}