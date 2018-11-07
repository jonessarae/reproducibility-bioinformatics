#!/bin/bash

###Script to make splice junctions database file, generate new genome indices, and run 2nd pass using STAR version 2.4.0g1###

export TMPDIR=/lscratch/$SLURM_JOB_ID
export FASTA=/data/jonesse3/ucsc.hg19.fasta
export GTF=/data/jonesse3/gencode.v19.annotation.gtf
export TMPDIR=/lscratch/$SLURM_JOB_ID
export READS="/data/jonesse3/SRR2989969_1.fastq /data/jonesse3/SRR2989969_2.fastq"
export STAR=/data/jonesse3/star2.4.0g1.simg

#load singularity
module load singularity

#make directory for genome indices for Pass 2
mkdir $TMPDIR/GenomeForPass2

#go to directory
cd #TMPDIR/GenomeForPass2

#edit SJ.out.tab file to get SJ.out.tab.Pass1.sjdb, filters out non-canonical junctions
awk 'BEGIN {OFS="\t"; strChar[0]="."; strChar[1]="+"; strChar[2]="-";} {if($5>0){print $1,$2,$3,strChar[$4]}}' /data/jonesse3/*SJ.out.tab > SJ.out.tab.Pass1_49.sjdb
#remove lines starting with chrm
sed '/^chrm/d' SJ.out.tab.Pass1.sjdb > SJ.out.tab.Pass1_49.sjdb

#generate genome indices from the 1st pass
singularity exec --bind /data/jonesse3,$TMPDIR $STAR STAR \
      --runThreadN $SLURM_CPUS_PER_TASK \
      --runMode genomeGenerate \
      --genomeDir $TMPDIR/GenomeForPass2 \
      --genomeFastaFiles $FASTA \
      --sjdbFileChrStartEnd SJ.out.tab.Pass1_49.sjdb \
      --sjdbOverhang 49 

cd ..

#make directory for Pass 2 files
mkdir $TMPDIR/Pass2

#go to directory
cd $TMPDIR/Pass2

#run 2nd pass
singularity exec --bind /data/jonesse3,$TMPDIR $STAR STAR \
      --runThreadN $SLURM_CPUS_PER_TASK \
      --genomeDir $TMPDIR/GenomeForPass2 \
      --readFilesIn $READS \
      --outFileNamePrefix 2.4.0g1_49_ \
      --genomeLoad NoSharedMemory \
      --outSAMtype BAM SortedByCoordinate

#copy bam and log files to my directory
cp *bam /data/jonesse3
mkdir -p /data/jonesse3/logs/2.4.0g1_49/2ndpass
cp *Log.out *Log.final.out /data/jonesse3/logs/2.4.0g1_49/2ndpass
