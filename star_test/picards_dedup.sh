#!/bin/bash

### Script to remove duplicates using picard 1.110 ###

IMAGE=/data/jonesse3/picard_1.110.simg
PICARD='java -Xmx???g -XX:ParallelGCThreads=5 -jar /opt/picard-tools-1.110/MarkDuplicates.jar'

#load singularity
module load singularity


for f in /data/jonesse3/*.sortedByCoord.out.bam
do
	if [ ! -f ${f%.*}_dedup.bam ]
	then
		singularity exec --bind /data/jonesse3 $IMAGE $PICARD \
      			I=$f \
      			O=${f%.*}_dedup.bam \
      			REMOVE_DUPLICATES=true \
      			METRICS_FILE=${f%.*}_metrics.txt 
	fi
done

