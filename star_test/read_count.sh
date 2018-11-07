#!/bin/bash

### script that outputs the read count for bam files in directory ###

#load samtools version 0.1.19
module load samtools/0.1.19

#make file
touch reads.txt

#retrieve name and read counts of bam files and output to file
for f in *.bam
do
	echo -n $f ": " >> reads.txt; samtools view -c $f >> reads.txt;echo
done 
