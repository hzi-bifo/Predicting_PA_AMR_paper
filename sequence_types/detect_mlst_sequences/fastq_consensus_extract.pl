#!/usr/bin/perl -w
# fastq_consensus_extract.pl
# AUTHOR: Andreas Dötsch
# LAST REVISED: Feb 2012
# 

## extracts sequences from fastq/fasta consensus file

use strict;
use Getopt::Std;

#variables

my $usage = "\n\nusage: $0 <fastq file>\n".
            "Extracts sequences from fastq/fasta consensus file.\n\n".
	    "-r\tdefinition file for regions to be retrieved (mandatory)\n".
	    "-c\tconcatenate output to a single fasta file (default: multifasta)\n".
	    "-p\tprefix for output gene names (e.g. strain or clone)\n";
our($opt_r,$opt_c,$opt_p);
getopts('r:cp:') or die $usage;
if (!defined($opt_r) ) { die $usage }
if (!defined($opt_c) ) { $opt_c = 0 }
if (!defined($opt_p) ) { $opt_p = "" }

if (($#ARGV + 1) < 1) { die $usage }

my $input_file		= $ARGV[$#ARGV];	# FASTQ file
my $extract_region	= $opt_r;		# region(s) for extraction
my $catoutput		= $opt_c;		# concatenate sequence output
my $prefix		= $opt_p;		# prefix for output gene names

# variables
my (@parts,@name,@start,@end,@strand);
my ($line,$i,$consensus,$tmpseq);

### read region file
open(REGION,$extract_region)
	or die "Error reading region file $extract_region: $!\n";

$i = 0;
while(defined($line = <REGION>)){
	# parse lines
	@parts	= split(/\t/,$line);
	if($parts[0] eq ""){next}

	$i++;
	$name[$i]	= $parts[0];
	$start[$i]	= $parts[1];
	$end[$i]	= $parts[2];
	$strand[$i]	= $parts[3];
}

close(REGION);

### read fastq/fasta file
open(INPUT,$input_file)
	or die "Error reading fastq file $input_file: $!\n";

$consensus = "";
while(defined($line = <INPUT>)){
	#skip header line
	if((substr($line,0,1) eq '@') || (substr($line,0,1) eq '>')){ next }

	#ignore quality data
	if(substr($line,0,1) eq '+') { last }
	
	chomp($line);

	#append sequence
	$consensus .= $line;
}
print STDERR "Found consensus sequence of ".length($consensus)." bp.\n";
close(INPUT);

### retrieve regions
if($catoutput){
	print ">$prefix:";
	for($i = 1; $i < @name;$i++){
		print "$name[$i]|";
	}
	print "\n";
	for($i = 1; $i < @name;$i++){
		$tmpseq = substr($consensus,$start[$i]-1,$end[$i]-$start[$i]+1);
		if($strand[$i] eq "-"){	$tmpseq = revcomp($tmpseq) }
		print $tmpseq."NNNNNANANANNNNN";
	}
	print "\n";
} else {
	for($i = 1; $i < @name;$i++){
		print ">$prefix:$name[$i]\n";
		$tmpseq = substr($consensus,$start[$i]-1,$end[$i]-$start[$i]+1);
		if($strand[$i] eq "-"){	$tmpseq = revcomp($tmpseq) }
		print "$tmpseq\n";
	}
}

sub revcomp {
  my $seq = $_[0];
  my $revcomp = reverse($seq);

  $revcomp =~ tr/ACGTacgt/TGCAtgca/;

  return $revcomp;
}
