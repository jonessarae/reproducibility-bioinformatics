#!/bin/bash

### Script to filter out reads with mapping quality <20 ###

#load samtools 0.1.19
module load samtools/0.1.19

#filter files that have already been deduplicated
for f in *dedup.bam
do
	if [ ! -f ${f%.*}_m20.bam ]
	then
		samtools view -b -q 20 $f > ${f%.*}_m20.bam
	fi
done
