#!/bin/bash

### Script to make genome indices and run 1st pass mapping using STAR version 2.4.0g1 ###

export TMPDIR=/lscratch/$SLURM_JOB_ID
export FASTA=/data/jonesse3/ucsc.hg19.fasta
export GTF=/data/jonesse3/gencode.v19.annotation.gtf
export READS="/data/jonesse3/SRR2989969_1.fastq /data/jonesse3/SRR2989969_2.fastq"
export STAR=/data/jonesse3/star2.4.0g1.simg

#load singularity
module load singularity

#make directory to hold genome indices
mkdir $TMPDIR/GenomeForPass1

#go to directory
cd $TMPDIR/GenomeForPass1

#make genome indices for 1st pass
singularity exec --bind /data/jonesse3,$TMPDIR $STAR STAR \
      --runThreadN $SLURM_CPUS_PER_TASK \
      --runMode genomeGenerate \
      --genomeDir $TMPDIR/GenomeForPass1 \
      --genomeFastaFiles $FASTA \
      --sjdbGTFfile $GTF \
      --sjdbOverhang 49 

cd ..

#make directory to hold files from 1st pass
mkdir $TMPDIR/Pass1

#go to directory
cd $TMPDIR/Pass1

#run 1st pass
singularity exec --bind /data/jonesse3,$TMPDIR $STAR STAR \
      --runThreadN $SLURM_CPUS_PER_TASK \
      --genomeDir $TMPDIR/GenomeForPass1 \
      --readFilesIn $READS \
      --outSAMattributes All \
      --genomeLoad NoSharedMemory \
      --outFileNamePrefix 2.4.0g1_49_

#copy files to my directory
mkdir -p /data/jonesse3/logs/2.4.0g1_49/1stpass
cp *Log.final.out *Log.out /data/jonesse3/logs/2.4.0g1_49/1stpass
cp *sam /data/jonesse3
cp *out.tab /data/jonesse3
