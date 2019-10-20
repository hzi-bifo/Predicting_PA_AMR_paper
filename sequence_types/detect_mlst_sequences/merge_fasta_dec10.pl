#!/usr/bin/perl -w
# merge_fasta.pl
# AUTHOR: Andreas Dötsch
# LAST REVISED: Jun 2011
#
# -s Merges multiple sequences of a single fasta file to a single sequence.
# -f Merges multiple fasta files to a single file.

use strict;
use Getopt::Std;

#init
our($opt_s, $opt_f, $opt_i, $opt_p);
my ($catsequence,$catfiles,$input,$separator,$outstring,$i,$sample,$myheader,$mysequence,$line);	#Skalars
my (@files,@parts); #Arrays

my $usage = "\n\nusage: $0 [-s -f -p] -i <input file(s)>  \n".
            " -s\t\t\tMerges multiple sequences of a single fasta file to a single sequence.\n".
	    " -f\t\t\tMerges multiple fasta files to a single file.\n".
            " -i <input files(s)>\tfilename or comma-separated list of filenames.\n".
	    " -p <separator>\t\tstring to separate two sequences from each other\n";

#get options
getopts('sfi:p:') or die $usage;
if ( (!defined($opt_s)) & (!defined($opt_f)) )	{die $usage}
if ( defined($opt_s) )				{$catsequence = 1}
if ( defined($opt_f) )				{$catfiles = 1}
if ( !defined($opt_i) )				{die $usage}
if ( !defined($opt_p) )				{$opt_p = ""}
$input 		= $opt_i;
$separator	= $opt_p;
$outstring	= "";

#parse filenames
@files = split(/,/,$input);

#loop all files
for($i=0;$i<@files;$i++){
	#parse sample name
	@parts	= split(/\//,$files[$i]);
	@parts	= split(/\./,$parts[@parts-1]);
	$sample	= $parts[0];

	#open file
	open(FILE,$files[$i])
	  or die("Error reading file $files[$i]: $!\n");

	#parse file
	if($catsequence){ # concatenate sequences
		$myheader 	= "";
		$mysequence	= "";
		while(defined($line = <FILE>)){
			chomp($line);
			#keep first header
			if((substr($line,0,1) eq ">")){
				if(!$myheader){ $myheader = ">$files[$i]" }
				next;
			}
			#append sequence
			$mysequence .= $line.$separator;
		}
		$outstring .= "$myheader\n$mysequence\n";
	} else { # keep original sequences
		while(defined($line = <FILE>)){ 
			$outstring .= $line;
		}
	}
	close(FILE);

	if(!$catfiles){
		# write single file output
		open(OUT,">$sample.merged.fasta")
		  or die("cannot open file $sample.merged.fasta: $!\n");
		
		print OUT $outstring;
		close(OUT);
		$outstring = "";
	} 
}
if($catfiles){
	#write merged file
	open(OUT,">all.merged.fasta")
	  or die("cannot open file all.merged.fasta: $!\n");
	print OUT $outstring;
	close(OUT);
}
